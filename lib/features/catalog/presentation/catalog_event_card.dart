import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/presentation/currency_format.dart';
import '../../../core/router/app_routes.dart';
import '../data/catalog_event.dart';
import 'event_poster.dart';
import 'sold_out_badge.dart';

/// Kartu event katalog: poster, nama, tanggal, venue, genre, dan harga mulai
/// dari. Ketuk kartu membuka halaman detail event (tiket 07).
class CatalogEventCard extends StatelessWidget {
  const CatalogEventCard({required this.event, super.key});

  final CatalogEvent event;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final startsAt = event.startsAt;
    final dateText = startsAt == null
        ? l10n.catalogDateTba
        : DateFormat.yMMMd(l10n.localeName).add_Hm().format(startsAt.toLocal());
    final venue = event.venue.trim().isEmpty
        ? l10n.catalogVenueUnknown
        : event.venue;
    final price = event.minPrice > 0
        ? l10n.catalogPriceFrom(formatRupiah(event.minPrice))
        : l10n.catalogPriceUnavailable;
    final genre = event.genre?.trim();

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: event.id == null
            ? null
            : () => context.push(AppRoutes.eventDetailPath(event.id!)),
        child: SizedBox(
          height: 168,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 112,
                child: EventPoster(posterUrl: event.posterUrl),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              event.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (event.soldOut) ...[
                            const SizedBox(width: 8),
                            SoldOutBadge(label: l10n.catalogSoldOut),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      _InfoRow(
                        icon: Icons.calendar_today_outlined,
                        text: dateText,
                      ),
                      const SizedBox(height: 4),
                      _InfoRow(icon: Icons.place_outlined, text: venue),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              price,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (genre != null && genre.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            _GenreChip(label: genre),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 14, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

class _GenreChip extends StatelessWidget {
  const _GenreChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSecondaryContainer,
        ),
      ),
    );
  }
}
