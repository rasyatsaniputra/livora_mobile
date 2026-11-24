import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:livora_mobile/core/l10n/generated/app_localizations.dart';
import 'package:livora_mobile/core/network/api_client.dart';
import 'package:livora_mobile/core/network/providers.dart';
import 'package:livora_mobile/features/catalog/presentation/catalog_screen.dart';

import '../../support/catalog_fixtures.dart';
import '../../support/fake_http_adapter.dart';
import '../../support/memory_token_store.dart';
import '../../support/test_app.dart';

/// Alur tab katalog (tiket 06) lewat router + seam HTTP nyata: daftar event
/// berposter, statistik, pencarian, filter, serta state loading/error/kosong.
void main() {
  MemoryTokenStore signedInStore() =>
      MemoryTokenStore(accessToken: 'access-1', refreshToken: 'refresh-1');

  testWidgets('menampilkan event berposter, venue, dan statistik platform', (
    tester,
  ) async {
    final adapter = FakeHttpAdapter.queue([
      FakeResponse(
        200,
        catalogEventsResponse([catalogEventJson(posterUrl: null)]),
      ),
      FakeResponse(200, catalogStatsResponse()),
    ]);

    await pumpAfterglowApp(
      tester,
      adapter: adapter,
      tokenStore: signedInStore(),
      location: '/catalog',
    );

    expect(find.text('Soundtix Fest 2026: The Grand Stage'), findsOneWidget);
    expect(find.text('Gelora Bung Karno Stadium, Jakarta'), findsOneWidget);
    expect(find.text('Statistik platform'), findsOneWidget);
    expect(find.text('Event aktif'), findsOneWidget);
    expect(find.text('12'), findsOneWidget);
    expect(find.text('3.450'), findsOneWidget);
    // Poster kosong memakai placeholder, bukan kotak rusak.
    expect(find.byIcon(Icons.music_note), findsOneWidget);
  });

  testWidgets('pencarian kata kunci mengirim q dan mengganti hasil', (
    tester,
  ) async {
    final adapter = FakeHttpAdapter.queue([
      FakeResponse(
        200,
        catalogEventsResponse([catalogEventJson(posterUrl: null)]),
      ),
      FakeResponse(200, catalogStatsResponse()),
      FakeResponse(
        200,
        catalogEventsResponse([
          catalogEventJson(id: 2, name: 'Tulus: Tur 2026', posterUrl: null),
        ]),
      ),
    ]);

    await pumpAfterglowApp(
      tester,
      adapter: adapter,
      tokenStore: signedInStore(),
      location: '/catalog',
    );

    await tester.enterText(
      find.byKey(const Key('catalogSearchField')),
      'Tulus',
    );
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    expect(find.text('Tulus: Tur 2026'), findsOneWidget);
    expect(find.text('Soundtix Fest 2026: The Grand Stage'), findsNothing);
    expect(find.text('Statistik platform'), findsOneWidget);

    final searchRequest = adapter.requests.last;
    expect(Uri.parse(searchRequest.url).queryParameters['q'], 'Tulus');
  });

  testWidgets('filter kota, genre, dan urutan diterapkan ke permintaan', (
    tester,
  ) async {
    final adapter = FakeHttpAdapter.queue([
      FakeResponse(
        200,
        catalogEventsResponse([catalogEventJson(posterUrl: null)]),
      ),
      FakeResponse(200, catalogStatsResponse()),
      FakeResponse(200, catalogEventsResponse([])),
    ]);

    await pumpAfterglowApp(
      tester,
      adapter: adapter,
      tokenStore: signedInStore(),
      location: '/catalog',
    );

    await tester.tap(find.byKey(const Key('catalogFilterButton')));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('catalogCityField')),
      'Bandung',
    );
    await tester.enterText(find.byKey(const Key('catalogGenreField')), 'Pop');
    await tester.tap(find.byKey(const Key('catalogSortField')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Terbaru').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('catalogApplyFiltersButton')));
    await tester.pumpAndSettle();

    expect(find.text('Belum ada konser'), findsOneWidget);
    // Statistik tetap tampil walau hasil filter kosong.
    expect(find.text('Statistik platform'), findsOneWidget);

    final params = Uri.parse(adapter.requests.last.url).queryParameters;
    expect(params['city'], 'Bandung');
    expect(params['genre'], 'Pop');
    expect(params['sort'], 'terbaru');
  });

  testWidgets('hasil kosong menampilkan empty state dan tombol reset', (
    tester,
  ) async {
    final adapter = FakeHttpAdapter.queue([
      FakeResponse(200, catalogEventsResponse([])),
      FakeResponse(200, catalogStatsResponse()),
    ]);

    await pumpAfterglowApp(
      tester,
      adapter: adapter,
      tokenStore: signedInStore(),
      location: '/catalog',
    );

    expect(find.text('Belum ada konser'), findsOneWidget);
    expect(find.text('Statistik platform'), findsOneWidget);
    expect(find.byKey(const Key('catalogEmptyResetButton')), findsNothing);
  });

  testWidgets('server tidak terjangkau: pesan jelas + tombol coba lagi', (
    tester,
  ) async {
    await pumpAfterglowApp(
      tester,
      adapter: FakeHttpAdapter(-1, <String, Object?>{}),
      tokenStore: signedInStore(),
      location: '/catalog',
    );

    expect(
      find.text('Server tidak terjangkau. Pastikan backend berjalan.'),
      findsOneWidget,
    );
    expect(find.byKey(const Key('catalogRetryButton')), findsOneWidget);
  });

  testWidgets('loading tampil selama permintaan pertama berjalan', (
    tester,
  ) async {
    final adapter = FakeHttpAdapter(
      200,
      catalogEventsResponse([catalogEventJson(posterUrl: null)]),
    )..gate = Completer<void>();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          apiClientProvider.overrideWithValue(ApiClient(adapter: adapter)),
        ],
        child: MaterialApp(
          locale: const Locale('id'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const CatalogScreen(),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    adapter.gate!.complete();
    await tester.pumpAndSettle();

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Soundtix Fest 2026: The Grand Stage'), findsOneWidget);
  });
}
