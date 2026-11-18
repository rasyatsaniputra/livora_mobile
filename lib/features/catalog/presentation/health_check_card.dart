import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/presentation/error_message.dart';
import 'health_check_controller.dart';

/// Smoke test fondasi (story 40 & 41): satu kartu yang memanggil endpoint
/// health Soundtix untuk memastikan konektivitas dari emulator.
///
/// Saat modul katalog (tiket 03) dikerjakan, kartu ini akan diganti konten
/// katalog yang sebenarnya.
class HealthCheckCard extends ConsumerWidget {
  const HealthCheckCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(healthCheckControllerProvider);
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.healthCheckTitle,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              l10n.healthCheckDescription,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 12),
            _StatusLine(state: state),
            const SizedBox(height: 12),
            FilledButton(
              // Loading dilarang ganda-klik (story 41): indikator dulu, akses berikutnya diblok.
              onPressed: state is HealthLoading
                  ? null
                  : () => ref.read(healthCheckControllerProvider.notifier).check(),
              child: Text(state is HealthLoading
                  ? l10n.healthCheckRunning
                  : l10n.healthCheckRun),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusLine extends StatelessWidget {
  const _StatusLine({required this.state});

  final HealthCheckState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    final (IconData icon, String? text, Color color) = switch (state) {
      HealthIdle() => (
          Icons.circle_outlined,
          null,
          theme.colorScheme.onSurfaceVariant,
        ),
      HealthLoading() => (
          Icons.autorenew,
          l10n.healthCheckRunning,
          theme.colorScheme.onSurfaceVariant,
        ),
      HealthSuccess() => (
          Icons.check_circle,
          l10n.healthCheckSuccess,
          theme.colorScheme.primary,
        ),
      HealthFailure(:final kind) => (
          Icons.error,
          apiErrorText(kind, l10n),
          theme.colorScheme.error,
        ),
    };

    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: text == null
              ? const SizedBox.shrink()
              : Text(text, style: TextStyle(color: color)),
        ),
      ],
    );
  }
}
