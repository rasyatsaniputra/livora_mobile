import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:livora_mobile/core/auth/token_store.dart';
import 'package:livora_mobile/core/l10n/generated/app_localizations.dart';
import 'package:livora_mobile/core/l10n/locale_provider.dart';
import 'package:livora_mobile/core/network/api_client.dart';
import 'package:livora_mobile/core/network/providers.dart';
import 'package:livora_mobile/core/router/app_router.dart';

import 'fake_http_adapter.dart';
import 'memory_token_store.dart';

/// Menyiapkan aplikasi penuh (router nyata + i18n) di atas provider yang
/// dioverride dengan adapter palsu + token store memori — pola seam HTTP
/// (tiket 02): repository, provider, dan widget ikut ter-exercise tanpa
/// backend hidup.
///
/// [location] (mis. `/register`) dibuka segera setelah pump pertama agar
/// test tidak menunggu splash screen; [extra] meneruskan argumen route.
/// Bahasa dikunci ke bahasa template (Indonesia) supaya assertion teks
/// menantang teks yang benar-benar tampil.
Future<ProviderContainer> pumpAfterglowApp(
  WidgetTester tester, {
  required FakeHttpAdapter adapter,
  TokenStore? tokenStore,
  String location = '/',
  Object? extra,
}) async {
  // Token store selalu ada dan dipakai dua-duanya (provider & ApiClient),
  // supaya wiring test konsisten dengan produksi (interseptor Bearer aktif).
  final store = tokenStore ?? MemoryTokenStore();

  final container = ProviderContainer(
    overrides: [
      tokenStoreProvider.overrideWithValue(store),
      apiClientProvider.overrideWithValue(
        ApiClient(adapter: adapter, tokenStore: store),
      ),
    ],
  );
  addTearDown(container.dispose);

  final router = container.read(appRouterProvider);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        routerConfig: router,
        locale: container.read(localeControllerProvider),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    ),
  );
  await tester.pump();
  if (location != '/') {
    router.go(location, extra: extra);
    await tester.pumpAndSettle();
  }
  return container;
}
