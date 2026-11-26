import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:livora_mobile/core/l10n/generated/app_localizations.dart';
import 'package:livora_mobile/core/network/api_client.dart';
import 'package:livora_mobile/core/network/providers.dart';
import 'package:livora_mobile/features/catalog/presentation/event_detail_screen.dart';

import '../../support/catalog_fixtures.dart';
import '../../support/fake_http_adapter.dart';
import '../../support/memory_token_store.dart';
import '../../support/test_app.dart';

/// Alur halaman detail event (tiket 07) lewat seam HTTP: detail lengkap,
/// kategori tiket read-only, profil organizer, tombol lanjut, serta state
/// loading/error. Navigasi diuji lewat router penuh dari tab katalog.
void main() {
  Future<void> pumpDetail(
    WidgetTester tester,
    FakeHttpAdapter adapter, {
    String eventId = '1',
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          apiClientProvider.overrideWithValue(ApiClient(adapter: adapter)),
        ],
        child: MaterialApp(
          locale: const Locale('id'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: EventDetailScreen(eventId: eventId),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> scrollTo(WidgetTester tester, Finder finder) =>
      tester.scrollUntilVisible(
        finder,
        200,
        scrollable: find.byType(Scrollable).first,
      );

  testWidgets('menampilkan detail lengkap, kategori tiket, dan organizer', (
    tester,
  ) async {
    final adapter = FakeHttpAdapter.queue([
      FakeResponse(200, eventDetailResponse(eventDetailJson(posterUrl: null))),
      FakeResponse(200, organizerResponse()),
    ]);

    await pumpDetail(tester, adapter);

    expect(find.byKey(const Key('eventDetailPoster')), findsOneWidget);
    expect(find.text('Soundtix Fest 2026: The Grand Stage'), findsOneWidget);

    // Tanggal mulai–selesai tampil dalam bahasa Indonesia.
    await scrollTo(tester, find.textContaining('Desember 2026'));
    expect(find.textContaining('Desember 2026'), findsOneWidget);

    await scrollTo(tester, find.text('Gelora Bung Karno Stadium, Jakarta'));
    expect(find.text('Gelora Bung Karno Stadium, Jakarta'), findsOneWidget);
    await scrollTo(tester, find.text('Sheila on 7, Tulus, Hindia'));
    expect(find.text('Sheila on 7, Tulus, Hindia'), findsOneWidget);
    await scrollTo(
      tester,
      find.text('Konser musik akbar persembahan siswa UKK Kelas 12.'),
    );
    expect(
      find.text('Konser musik akbar persembahan siswa UKK Kelas 12.'),
      findsOneWidget,
    );

    expect(find.text('Kategori tiket'), findsOneWidget);
    await scrollTo(tester, find.text('VIP Front Row'));
    expect(find.text('Rp 1.500.000'), findsOneWidget);
    expect(find.text('480 tiket tersisa'), findsOneWidget);
    await scrollTo(tester, find.text('Regular'));
    expect(find.text('Rp 350.000'), findsOneWidget);
    expect(find.text('985 tiket tersisa'), findsOneWidget);

    // Nama dari GET /organizers/:id, bukan field organization_name event.
    await scrollTo(tester, find.text('Soundtix Live Official'));
    expect(find.text('Penyelenggara'), findsOneWidget);
    expect(find.text('Soundtix Live Official'), findsOneWidget);
    expect(find.text('Promotor terverifikasi'), findsOneWidget);

    expect(find.byKey(const Key('eventDetailContinueButton')), findsOneWidget);
    expect(adapter.requests.map((r) => Uri.parse(r.url).path).toList(), [
      '/events/1',
      '/organizers/1',
    ]);
  });

  testWidgets('kategori tanpa kuota tersisa ditandai habis', (tester) async {
    final adapter = FakeHttpAdapter.queue([
      FakeResponse(
        200,
        eventDetailResponse(
          eventDetailJson(
            posterUrl: null,
            categories: [
              ticketCategoryJson(name: 'Regular', quotaAvailable: 0),
            ],
          ),
        ),
      ),
      FakeResponse(200, organizerResponse()),
    ]);

    await pumpDetail(tester, adapter);
    await scrollTo(tester, find.text('Regular'));

    expect(find.text('Regular'), findsOneWidget);
    expect(find.text('Habis'), findsOneWidget);
    expect(find.textContaining('tiket tersisa'), findsNothing);
  });

  testWidgets('menekan kartu katalog membuka detail event', (tester) async {
    final adapter = FakeHttpAdapter.queue([
      FakeResponse(
        200,
        catalogEventsResponse([catalogEventJson(posterUrl: null)]),
      ),
      FakeResponse(200, catalogStatsResponse()),
      FakeResponse(200, eventDetailResponse(eventDetailJson(posterUrl: null))),
      FakeResponse(200, organizerResponse()),
    ]);

    await pumpAfterglowApp(
      tester,
      adapter: adapter,
      tokenStore: MemoryTokenStore(
        accessToken: 'access-1',
        refreshToken: 'refresh-1',
      ),
      location: '/catalog',
    );

    await tester.tap(find.text('Soundtix Fest 2026: The Grand Stage'));
    await tester.pumpAndSettle();

    await scrollTo(
      tester,
      find.text('Konser musik akbar persembahan siswa UKK Kelas 12.'),
    );
    expect(
      find.text('Konser musik akbar persembahan siswa UKK Kelas 12.'),
      findsOneWidget,
    );
    expect(adapter.requests.map((r) => Uri.parse(r.url).path).toList(), [
      '/events',
      '/events/stats',
      '/events/1',
      '/organizers/1',
    ]);
  });

  testWidgets('tombol lanjut membuka layar pemesanan', (tester) async {
    final adapter = FakeHttpAdapter.queue([
      FakeResponse(
        200,
        catalogEventsResponse([catalogEventJson(posterUrl: null)]),
      ),
      FakeResponse(200, catalogStatsResponse()),
      FakeResponse(200, eventDetailResponse(eventDetailJson(posterUrl: null))),
      FakeResponse(200, organizerResponse()),
    ]);

    await pumpAfterglowApp(
      tester,
      adapter: adapter,
      tokenStore: MemoryTokenStore(
        accessToken: 'access-1',
        refreshToken: 'refresh-1',
      ),
      location: '/catalog',
    );

    await tester.tap(find.text('Soundtix Fest 2026: The Grand Stage'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('eventDetailContinueButton')));
    await tester.pumpAndSettle();

    expect(find.text('Pemesanan'), findsOneWidget);
  });

  testWidgets('loading tampil selama detail dimuat', (tester) async {
    final adapter = FakeHttpAdapter.queue([
      FakeResponse(200, eventDetailResponse(eventDetailJson(posterUrl: null))),
      FakeResponse(200, organizerResponse()),
    ])..gate = Completer<void>();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          apiClientProvider.overrideWithValue(ApiClient(adapter: adapter)),
        ],
        child: MaterialApp(
          locale: const Locale('id'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const EventDetailScreen(eventId: '1'),
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

  testWidgets('server tidak terjangkau: pesan jelas + tombol coba lagi', (
    tester,
  ) async {
    await pumpDetail(tester, FakeHttpAdapter(-1, <String, Object?>{}));

    expect(
      find.text('Server tidak terjangkau. Pastikan backend berjalan.'),
      findsOneWidget,
    );
    expect(find.byKey(const Key('eventDetailRetryButton')), findsOneWidget);
  });
}
