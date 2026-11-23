import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../data/catalog_event.dart';

/// Ringkasan statistik publik Soundtix (`GET /events/stats`) di atas daftar:
/// event aktif, tiket terjual, promotor terverifikasi, dan jumlah kota.
class CatalogStatsCard extends StatelessWidget {
  const CatalogStatsCard({required this.stats, super.key});

  final CatalogStats stats;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final number = NumberFormat.decimalPattern(l10n.localeName);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.insights_outlined,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.catalogStatsTitle,
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _StatTile(
                  icon: Icons.event_available_outlined,
                  value: number.format(stats.activeEvents),
                  label: l10n.catalogStatEvents,
                ),
                _StatTile(
                  icon: Icons.confirmation_number_outlined,
                  value: number.format(stats.ticketsSold),
                  label: l10n.catalogStatTickets,
                ),
                _StatTile(
                  icon: Icons.verified_outlined,
                  value: number.format(stats.verifiedOrganizers),
                  label: l10n.catalogStatOrganizers,
                ),
                _StatTile(
                  icon: Icons.location_city_outlined,
                  value: number.format(stats.cities),
                  label: l10n.catalogStatCities,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 140,
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: theme.colorScheme.primaryContainer,
            child: Icon(
              icon,
              size: 18,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
