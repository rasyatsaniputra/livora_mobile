import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/l10n/locale_provider.dart';
import 'health_check_card.dart';

/// Tab Katalog — placeholder sampai modul katalog (tiket 03) dikerjakan.
/// Menampung smoke test fondasi: kartu cek koneksi ke backend.
class CatalogScreen extends ConsumerWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navCatalog),
        actions: const [_LanguageToggle()],
      ),
      body: ListView(
        children: const [
          HealthCheckCard(),
        ],
      ),
    );
  }
}

/// Toggle bahasa manual: Indonesia default, English opsional (R3 bagian 01).
class _LanguageToggle extends ConsumerWidget {
  const _LanguageToggle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = ref.watch(localeControllerProvider);

    return PopupMenuButton<String>(
      tooltip: l10n.changeLanguage,
      icon: const Icon(Icons.language),
      initialValue: locale.languageCode,
      onSelected: (code) =>
          ref.read(localeControllerProvider.notifier).setLocale(Locale(code)),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'id',
          child: Text(l10n.languageIndonesian),
        ),
        PopupMenuItem(
          value: 'en',
          child: Text(l10n.languageEnglish),
        ),
      ],
    );
  }
}
