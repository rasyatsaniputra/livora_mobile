import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../auth/session_controller.dart';
import '../l10n/generated/app_localizations.dart';
import '../router/app_routes.dart';

/// Splash screen dengan branding Afterglow (story 39) sekaligus pintu masuk
/// sesi (tiket 04): setelah durasi branding, aplikasi membuka home bila ada
/// sesi tersimpan atau layar login bila belum.
///
/// Branding masih placeholder (wordmark teks + ikon generik) sesuai keputusan
/// bagian 01 — Fakta tertunda #2: logo final dari user, tinggal mengganti
/// bagian visual di sini, struktur route tidak berubah.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  static const _splashDuration = Duration(milliseconds: 1200);
  Timer? _timer;
  var _minimumDurationElapsed = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer(_splashDuration, () {
      if (!mounted) return;
      _minimumDurationElapsed = true;
      _openNextScreen();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Navigasi hanya setelah dua syarat terpenuhi: durasi branding selesai
  /// dan pembacaan token dari secure storage selesai.
  void _openNextScreen() {
    if (!_minimumDurationElapsed || !mounted) return;
    final session = ref.read(sessionControllerProvider);
    final signedIn = session.value;
    if (signedIn == null) return; // pembacaan sesi belum selesai
    context.go(signedIn ? AppRoutes.catalog : AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = AppLocalizations.of(context)!.appTitle;

    // Sesi bisa selesai dibaca sebelum timer splash habis; dengarkan agar
    // redirect terjadi begitu kedua syarat terpenuhi.
    ref.listen<AsyncValue<bool>>(sessionControllerProvider, (previous, next) {
      _openNextScreen();
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wb_twilight,
                size: 64, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
