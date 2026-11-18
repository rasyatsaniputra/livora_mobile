import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/generated/app_localizations.dart';
import '../router/app_routes.dart';

/// Splash screen dengan branding Afterglow (story 39).
///
/// Branding masih placeholder (wordmark teks + ikon generik) sesuai keputusan
/// bagian 01 — Fakta tertunda #2: logo final dari user, tinggal mengganti
/// bagian visual di sini, struktur route tidak berubah.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const _splashDuration = Duration(milliseconds: 1200);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(_splashDuration, () {
      if (mounted) context.go(AppRoutes.catalog);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = AppLocalizations.of(context)!.appTitle;

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
