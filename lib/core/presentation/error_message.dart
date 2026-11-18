import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../network/api_exception.dart';

/// Pesan l10n untuk [ApiExceptionKind] — satu titik pemetaan agar pesan
/// jaringan/timeout/server/request konsisten di seluruh layar.
String apiErrorText(ApiExceptionKind kind, AppLocalizations l10n) =>
    switch (kind) {
      ApiExceptionKind.network => l10n.errorNetwork,
      ApiExceptionKind.timeout => l10n.errorTimeout,
      ApiExceptionKind.server => l10n.errorServer,
      ApiExceptionKind.request => l10n.errorRequest,
    };

/// Baris pesan error seragam (ikon + teks berwarna error) untuk form.
class ErrorMessage extends StatelessWidget {
  const ErrorMessage(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(Icons.error_outline, size: 18, color: theme.colorScheme.error),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            message,
            style: TextStyle(color: theme.colorScheme.error),
          ),
        ),
      ],
    );
  }
}
