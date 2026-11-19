import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/otp_verification_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/catalog/presentation/catalog_screen.dart';
import '../l10n/generated/app_localizations.dart';
import '../presentation/placeholder_screen.dart';
import '../presentation/splash_screen.dart';
import 'app_routes.dart';

/// Routing declarative (go_router) dengan shell untuk bottom navigation
/// (keputusan R1 bagian 01). Alur dalam (login → checkout → bayar → e-tiket)
/// ditambahkan per modul.
///
/// Tab saat ini sengaja 3 (Katalog/Tiket/Riwayat); layar auth masuk di
/// tiket 03–04 dan payment di tiket 05.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      // Alur auth di luar shell bottom-nav (tiket 03–04). Login dan
      // registrasi berbagi layar verifikasi OTP; alurnya dibedakan oleh
      // OtpChallenge yang dibawa sebagai `extra`.
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.loginVerify,
        builder: (context, state) => const OtpVerificationScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.registerVerify,
        builder: (context, state) => const OtpVerificationScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => _ShellScaffold(shell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.catalog,
              builder: (context, state) => const CatalogScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.tickets,
              builder: (context, state) {
                final l10n = AppLocalizations.of(context)!;
                return PlaceholderScreen(title: l10n.navTickets);
              },
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.history,
              builder: (context, state) {
                final l10n = AppLocalizations.of(context)!;
                return PlaceholderScreen(title: l10n.navHistory);
              },
            ),
          ]),
        ],
      ),
    ],
  );
});

class _ShellScaffold extends StatelessWidget {
  const _ShellScaffold({required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.event_outlined),
            selectedIcon: const Icon(Icons.event),
            label: l10n.navCatalog,
          ),
          NavigationDestination(
            icon: const Icon(Icons.confirmation_number_outlined),
            selectedIcon: const Icon(Icons.confirmation_number),
            label: l10n.navTickets,
          ),
          NavigationDestination(
            icon: const Icon(Icons.history_outlined),
            selectedIcon: const Icon(Icons.history),
            label: l10n.navHistory,
          ),
        ],
        onDestinationSelected: (index) => shell.goBranch(
          index,
          initialLocation: index == shell.currentIndex,
        ),
      ),
    );
  }
}
