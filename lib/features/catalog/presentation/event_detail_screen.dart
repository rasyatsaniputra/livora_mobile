import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/presentation/currency_format.dart';
import '../../../core/presentation/error_message.dart';
import '../../../core/router/app_routes.dart';
import '../data/event_detail.dart';
import 'bookmark_store.dart';
import 'event_detail_controller.dart';
import 'event_poster.dart';
import 'sold_out_badge.dart';

/// Halaman detail event (tiket 07): poster besar, deskripsi, tanggal, venue,
/// daftar kategori tiket read-only (harga & kuota tersisa), profil organizer,
/// dan tombol lanjut ke pemesanan.
class EventDetailScreen extends ConsumerStatefulWidget {
  const EventDetailScreen({required this.eventId, super.key});

  final String eventId;

  @override
  ConsumerState<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends ConsumerState<EventDetailScreen> {
  var _bookmarkBusy = false;

  @override
  void initState() {
    super.initState();
    // Muat setelah frame pertama: Riverpod melarang mengubah provider di
    // initState, dan halaman ini dibuka dengan id dari path.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(eventDetailControllerProvider(widget.eventId).notifier).load();
    });
  }

  Future<void> _toggleBookmark() async {
    setState(() => _bookmarkBusy = true);
    final kind = await ref
        .read(eventDetailControllerProvider(widget.eventId).notifier)
        .toggleBookmark();
    if (!mounted) return;
    setState(() => _bookmarkBusy = false);

    final l10n = AppLocalizations.of(context)!;
    final eventId = ref
        .read(eventDetailControllerProvider(widget.eventId).notifier)
        .bookmarkEventId;
    final bookmarked = ref.read(bookmarkStoreProvider)[eventId] ?? false;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          kind != null
              ? apiErrorText(kind, l10n)
              : bookmarked
              ? l10n.bookmarkSaved
              : l10n.bookmarkRemoved,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = eventDetailControllerProvider(widget.eventId);
    final state = ref.watch(provider);
    final bookmarkEventId = state is EventDetailReady
        ? (state.detail.id ?? widget.eventId)
        : widget.eventId;
    final bookmarked =
        ref.watch(bookmarkStoreProvider)[bookmarkEventId] ??
        (state is EventDetailReady ? state.detail.bookmarked : false);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.eventDetailTitle),
        actions: [
          if (state is EventDetailReady)
            IconButton(
              key: const Key('eventDetailBookmarkButton'),
              tooltip: bookmarked
                  ? l10n.eventDetailBookmarkRemove
                  : l10n.eventDetailBookmarkSave,
              onPressed: _bookmarkBusy ? null : _toggleBookmark,
              icon: Icon(bookmarked ? Icons.bookmark : Icons.bookmark_border),
            ),
        ],
      ),
      body: switch (state) {
        EventDetailLoading() => const Center(
          child: CircularProgressIndicator(),
        ),
        EventDetailFailed(:final kind) => _DetailErrorView(
          kind: kind,
          onRetry: () => ref.read(provider.notifier).retry(),
        ),
        EventDetailReady(:final detail, :final organizer) => _DetailBody(
          detail: detail,
          organizer: organizer,
          onContinue: () =>
              context.push(AppRoutes.checkoutPath(detail.id ?? widget.eventId)),
        ),
      },
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({
    required this.detail,
    required this.organizer,
    required this.onContinue,
  });

  final EventDetail detail;
  final OrganizerProfile? organizer;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final description = detail.description.trim();
    final artist = detail.artist.trim();

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  key: const Key('eventDetailPoster'),
                  aspectRatio: 16 / 9,
                  child: EventPoster(posterUrl: detail.posterUrl, iconSize: 56),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      detail.name,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (detail.soldOut) ...[
                    const SizedBox(width: 12),
                    SoldOutBadge(label: l10n.catalogSoldOut),
                  ],
                ],
              ),
              const SizedBox(height: 16),
              _InfoRow(
                icon: Icons.calendar_today_outlined,
                label: l10n.eventDetailDate,
                value: _dateText(l10n),
              ),
              const SizedBox(height: 10),
              _InfoRow(
                icon: Icons.place_outlined,
                label: l10n.eventDetailVenue,
                value: _venueText(l10n),
              ),
              if (artist.isNotEmpty) ...[
                const SizedBox(height: 10),
                _InfoRow(
                  icon: Icons.mic_none_outlined,
                  label: l10n.eventDetailArtist,
                  value: artist,
                ),
              ],
              const SizedBox(height: 24),
              _SectionTitle(title: l10n.eventDetailAbout),
              const SizedBox(height: 8),
              Text(
                description.isEmpty ? l10n.eventDetailAboutEmpty : description,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              _SectionTitle(title: l10n.eventDetailCategories),
              const SizedBox(height: 8),
              if (detail.categories.isEmpty)
                Text(
                  l10n.eventDetailCategoriesEmpty,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                )
              else
                for (final category in detail.categories)
                  _CategoryCard(category: category),
              const SizedBox(height: 24),
              _SectionTitle(title: l10n.eventDetailOrganizer),
              const SizedBox(height: 8),
              _OrganizerCard(detail: detail, organizer: organizer),
            ],
          ),
        ),
        SafeArea(
          top: false,
          minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton(
              key: const Key('eventDetailContinueButton'),
              onPressed: onContinue,
              child: Text(l10n.eventDetailContinue),
            ),
          ),
        ),
      ],
    );
  }

  String _dateText(AppLocalizations l10n) {
    final start = detail.startsAt?.toLocal();
    if (start == null) return l10n.catalogDateTba;
    final dateFormat = DateFormat.yMMMMd(l10n.localeName).add_Hm();
    final end = detail.endsAt?.toLocal();
    if (end == null) return dateFormat.format(start);
    final endFormat = DateFormat.Hm(l10n.localeName);
    return l10n.eventDetailDateRange(
      dateFormat.format(start),
      endFormat.format(end),
    );
  }

  String _venueText(AppLocalizations l10n) {
    final venue = detail.venue.trim();
    final city = detail.city?.trim() ?? '';
    final base = venue.isEmpty ? l10n.catalogVenueUnknown : venue;
    if (city.isEmpty || base.toLowerCase().contains(city.toLowerCase())) {
      return base;
    }
    return l10n.eventDetailVenueCity(base, city);
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(value, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.category});

  final TicketCategory category;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final available = category.quotaAvailable > 0 ? category.quotaAvailable : 0;
    final remaining = available <= 0
        ? l10n.eventDetailCategorySoldOut
        : l10n.eventDetailRemaining(available);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  remaining,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: available <= 0
                        ? theme.colorScheme.error
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            formatRupiah(category.price),
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrganizerCard extends StatelessWidget {
  const _OrganizerCard({required this.detail, required this.organizer});

  final EventDetail detail;
  final OrganizerProfile? organizer;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final organizerName = organizer?.name.trim() ?? '';
    final fallbackName = detail.organizationName?.trim() ?? '';
    final name = organizerName.isNotEmpty
        ? organizerName
        : fallbackName.isNotEmpty
        ? fallbackName
        : l10n.eventDetailOrganizerUnknown;
    final verified = organizer?.verificationStatus == 'verified';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: theme.colorScheme.primaryContainer,
            foregroundColor: theme.colorScheme.onPrimaryContainer,
            child: const Icon(Icons.apartment_outlined),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (verified) ...[
                  const SizedBox(height: 2),
                  Text(
                    l10n.eventDetailOrganizerVerified,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (verified)
            Icon(Icons.verified, color: theme.colorScheme.primary, size: 20),
        ],
      ),
    );
  }
}

class _DetailErrorView extends StatelessWidget {
  const _DetailErrorView({required this.kind, required this.onRetry});

  final ApiExceptionKind kind;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 48,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 12),
            ErrorMessage(apiErrorText(kind, l10n)),
            const SizedBox(height: 16),
            FilledButton(
              key: const Key('eventDetailRetryButton'),
              onPressed: onRetry,
              child: Text(l10n.eventDetailRetry),
            ),
          ],
        ),
      ),
    );
  }
}
