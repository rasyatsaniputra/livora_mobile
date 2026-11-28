import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/presentation/error_message.dart';
import '../../../core/router/app_routes.dart';
import '../data/catalog_event.dart';
import 'bookmark_list_controller.dart';
import 'catalog_event_card.dart';

/// Halaman daftar bookmark (tiket 08): event tersimpan ditampilkan dengan
/// kartu yang sama seperti katalog, dengan aksi hapus per baris. Status
/// simpan/hapus dibagi dengan halaman detail lewat
/// `bookmarkStoreProvider`.
class BookmarkListScreen extends ConsumerStatefulWidget {
  const BookmarkListScreen({super.key});

  @override
  ConsumerState<BookmarkListScreen> createState() => _BookmarkListScreenState();
}

class _BookmarkListScreenState extends ConsumerState<BookmarkListScreen> {
  final _removing = <String>{};

  @override
  void initState() {
    super.initState();
    // Muat setelah frame pertama — Riverpod melarang mengubah provider di
    // initState.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(bookmarkListControllerProvider.notifier).load();
    });
  }

  Future<void> _remove(String eventId) async {
    setState(() => _removing.add(eventId));
    final kind = await ref
        .read(bookmarkListControllerProvider.notifier)
        .remove(eventId);
    if (!mounted) return;
    setState(() => _removing.remove(eventId));

    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          kind == null ? l10n.bookmarkRemoved : apiErrorText(kind, l10n),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(bookmarkListControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.bookmarksTitle)),
      body: switch (state) {
        BookmarkListLoading() => const Center(
          child: CircularProgressIndicator(),
        ),
        BookmarkListFailed(:final kind) => _BookmarkErrorView(
          kind: kind,
          onRetry: () =>
              ref.read(bookmarkListControllerProvider.notifier).load(),
        ),
        BookmarkListReady(:final events) =>
          events.isEmpty
              ? _BookmarkEmptyView(
                  onExplore: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go(AppRoutes.catalog);
                    }
                  },
                )
              : _BookmarkList(
                  events: events,
                  removing: _removing,
                  onRemove: _remove,
                ),
      },
    );
  }
}

class _BookmarkList extends StatelessWidget {
  const _BookmarkList({
    required this.events,
    required this.removing,
    required this.onRemove,
  });

  final List<CatalogEvent> events;
  final Set<String> removing;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: events.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final event = events[index];
        final id = event.id;
        final isRemoving = id != null && removing.contains(id);

        return CatalogEventCard(
          event: event,
          action: IconButton(
            key: Key('bookmarkRemove-${id ?? index}'),
            tooltip: l10n.bookmarksRemove,
            visualDensity: VisualDensity.compact,
            onPressed: id == null || isRemoving ? null : () => onRemove(id),
            icon: isRemoving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.bookmark_remove_outlined),
          ),
        );
      },
    );
  }
}

class _BookmarkEmptyView extends StatelessWidget {
  const _BookmarkEmptyView({required this.onExplore});

  final VoidCallback onExplore;

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
              Icons.bookmark_border,
              size: 48,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.bookmarksEmptyTitle,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              l10n.bookmarksEmptyBody,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              key: const Key('bookmarksExploreButton'),
              onPressed: onExplore,
              child: Text(l10n.bookmarksExplore),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookmarkErrorView extends StatelessWidget {
  const _BookmarkErrorView({required this.kind, required this.onRetry});

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
              key: const Key('bookmarksRetryButton'),
              onPressed: onRetry,
              child: Text(l10n.bookmarksRetry),
            ),
          ],
        ),
      ),
    );
  }
}
