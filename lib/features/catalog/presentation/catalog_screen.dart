import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/l10n/locale_provider.dart';
import '../../../core/router/app_routes.dart';
import 'health_check_card.dart';

/// Tab Katalog — placeholder sampai modul katalog (tiket 06) dikerjakan.
/// Menampung smoke test fondasi: kartu cek koneksi ke backend.
class CatalogScreen extends ConsumerWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navCatalog),
        actions: const [_RegisterEntry(), _LanguageToggle()],
      ),
      body: ListView(
        children: const [
          HealthCheckCard(),
        ],
      ),
    );
  }
}

/// Pintu masuk sementara ke alur pendaftaran (tiket 03) sampai layar login
/// penuh dibuat di tiket 04 — saat itu tombol ini diganti alur auth sesi.
class _RegisterEntry extends StatelessWidget {
  const _RegisterEntry();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return IconButton(
      tooltip: l10n.registerEntryTooltip,
      icon: const Icon(Icons.person_add_alt_1),
      onPressed: () => context.push(AppRoutes.register),
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
