import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/catalog_fixtures.dart';
import '../../support/fake_http_adapter.dart';
import '../../support/memory_token_store.dart';
import '../../support/test_app.dart';

/// Alur bookmark (tiket 08) lewat router + seam HTTP: daftar tersimpan,
/// penghapusan dari daftar, toggle dari detail, dan konsistensi status antara
/// kedua layar.
void main() {
  MemoryTokenStore signedInStore() =>
      MemoryTokenStore(accessToken: 'access-1', refreshToken: 'refresh-1');

  testWidgets('daftar bookmark menampilkan event tersimpan lalu menghapusnya', (
    tester,
  ) async {
    final adapter = FakeHttpAdapter.queue([
      FakeResponse(
        200,
        catalogEventsResponse([catalogEventJson(posterUrl: null)]),
      ),
      FakeResponse(
        200,
        bookmarksResponse([bookmarkEventJson(posterUrl: null)]),
      ),
      FakeResponse(200, catalogStatsResponse()),
      FakeResponse(200, bookmarkToggleResponse(false)),
    ]);

    await pumpAfterglowApp(
      tester,
      adapter: adapter,
      tokenStore: signedInStore(),
      location: '/catalog/bookmarks',
    );

    expect(find.text('Event tersimpan'), findsOneWidget);
    expect(find.text('Soundtix Fest 2026: The Grand Stage'), findsOneWidget);
    expect(find.text('Gelora Bung Karno Stadium, Jakarta'), findsOneWidget);

    await tester.tap(find.byKey(const Key('bookmarkRemove-1')));
    await tester.pumpAndSettle();

    expect(find.text('Soundtix Fest 2026: The Grand Stage'), findsNothing);
    expect(find.text('Belum ada event tersimpan'), findsOneWidget);
    expect(find.text('Event dihapus dari bookmark.'), findsOneWidget);

    final removeRequest = adapter.requests.last;
    expect(removeRequest.method, 'POST');
    expect(Uri.parse(removeRequest.url).path, '/events/1/bookmark');
  });

  testWidgets('toggle hapus di detail langsung menghapus dari daftar', (
    tester,
  ) async {
    final adapter = FakeHttpAdapter.queue([
      FakeResponse(
        200,
        catalogEventsResponse([catalogEventJson(posterUrl: null)]),
      ),
      FakeResponse(
        200,
        bookmarksResponse([bookmarkEventJson(posterUrl: null)]),
      ),
      FakeResponse(200, catalogStatsResponse()),
      FakeResponse(
        200,
        eventDetailResponse(eventDetailJson(posterUrl: null, bookmarked: true)),
      ),
      FakeResponse(200, organizerResponse()),
      FakeResponse(200, bookmarkToggleResponse(false)),
    ]);

    await pumpAfterglowApp(
      tester,
      adapter: adapter,
      tokenStore: signedInStore(),
      location: '/catalog/bookmarks',
    );

    await tester.tap(find.text('Soundtix Fest 2026: The Grand Stage'));
    await tester.pumpAndSettle();

    // Detail memakai status server (tersimpan) dan menampilkan ikon penuh.
    expect(find.byIcon(Icons.bookmark), findsOneWidget);

    await tester.tap(find.byKey(const Key('eventDetailBookmarkButton')));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.bookmark_border), findsOneWidget);
    expect(find.text('Event dihapus dari bookmark.'), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(find.text('Soundtix Fest 2026: The Grand Stage'), findsNothing);
    expect(find.text('Belum ada event tersimpan'), findsOneWidget);
    // Tidak ada muat ulang daftar setelah toggle: baris hilang lewat status
    // bersama.
    expect(
      adapter.requests.where(
        (r) => Uri.parse(r.url).path == '/users/bookmarks',
      ),
      hasLength(1),
    );
    expect(adapter.requests.last.method, 'POST');
    expect(Uri.parse(adapter.requests.last.url).path, '/events/1/bookmark');
  });

  testWidgets('simpan dari detail muncul di daftar lewat ikon katalog', (
    tester,
  ) async {
    final adapter = FakeHttpAdapter.queue([
      FakeResponse(
        200,
        catalogEventsResponse([catalogEventJson(posterUrl: null)]),
      ),
      FakeResponse(200, catalogStatsResponse()),
      FakeResponse(200, eventDetailResponse(eventDetailJson(posterUrl: null))),
      FakeResponse(200, organizerResponse()),
      FakeResponse(200, bookmarkToggleResponse(true)),
      FakeResponse(
        200,
        bookmarksResponse([bookmarkEventJson(posterUrl: null)]),
      ),
    ]);

    await pumpAfterglowApp(
      tester,
      adapter: adapter,
      tokenStore: signedInStore(),
      location: '/catalog',
    );

    await tester.tap(find.text('Soundtix Fest 2026: The Grand Stage'));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.bookmark_border), findsOneWidget);
    await tester.tap(find.byKey(const Key('eventDetailBookmarkButton')));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.bookmark), findsOneWidget);
    expect(find.text('Event disimpan ke bookmark.'), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('catalogBookmarksButton')));
    await tester.pumpAndSettle();

    expect(find.text('Event tersimpan'), findsOneWidget);
    expect(find.text('Soundtix Fest 2026: The Grand Stage'), findsOneWidget);
    expect(Uri.parse(adapter.requests.last.url).path, '/users/bookmarks');
  });

  testWidgets('gagal memuat daftar: pesan jelas dan tombol coba lagi', (
    tester,
  ) async {
    final adapter = FakeHttpAdapter.queue([
      FakeResponse(
        200,
        catalogEventsResponse([catalogEventJson(posterUrl: null)]),
      ),
      FakeResponse(500, {'success': false}),
      FakeResponse(200, catalogStatsResponse()),
      FakeResponse(200, bookmarksResponse([])),
    ]);

    await pumpAfterglowApp(
      tester,
      adapter: adapter,
      tokenStore: signedInStore(),
      location: '/catalog/bookmarks',
    );

    expect(
      find.text('Server sedang bermasalah. Coba lagi nanti.'),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const Key('bookmarksRetryButton')));
    await tester.pumpAndSettle();

    expect(find.text('Belum ada event tersimpan'), findsOneWidget);
  });
}
