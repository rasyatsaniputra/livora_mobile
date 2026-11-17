import 'package:flutter/material.dart';

import '../../../core/l10n/generated/app_localizations.dart';

/// Tab Riwayat — placeholder sampai modul riwayat (tiket 07) dikerjakan.
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navHistory)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            l10n.placeholderComingSoon,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
