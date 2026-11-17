import 'package:flutter/material.dart';

import '../../../core/l10n/generated/app_localizations.dart';

/// Tab Tiket — placeholder sampai modul e-tiket (tiket 06) dikerjakan.
class TicketsScreen extends StatelessWidget {
  const TicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navTickets)),
      body: _ComingSoon(text: l10n.placeholderComingSoon),
    );
  }
}

class _ComingSoon extends StatelessWidget {
  const _ComingSoon({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.hourglass_empty,
                size: 40, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(height: 12),
            Text(
              text,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
