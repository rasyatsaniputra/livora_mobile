import 'package:flutter_test/flutter_test.dart';
import 'package:livora_mobile/core/network/api_client.dart';
import 'package:livora_mobile/core/network/api_exception.dart';
import 'package:livora_mobile/features/catalog/data/bookmark_repository.dart';

import '../../support/catalog_fixtures.dart';
import '../../support/fake_http_adapter.dart';

/// Test kontrak data bookmark (tiket 08) di atas seam HTTP:
/// `GET /users/bookmarks` untuk daftar tersimpan dan
/// `POST /events/:id/bookmark` untuk toggle simpan/hapus.
void main() {
  group('BookmarkRepository — GET /users/bookmarks', () {
    test('memetakan event tersimpan beserta harga mulai', () async {
      final adapter = FakeHttpAdapter(
        200,
        bookmarksResponse([
          bookmarkEventJson(minPrice: '350000'),
          bookmarkEventJson(id: 2, name: 'Tulus: Tur 2026', posterUrl: null),
        ]),
      );
      final repository = BookmarkRepository(
        client: ApiClient(adapter: adapter),
      );

      final events = await repository.fetchBookmarks();

      expect(events, hasLength(2));
      final first = events.first;
      expect(first.id, '1');
      expect(first.name, 'Soundtix Fest 2026: The Grand Stage');
      expect(first.venue, 'Gelora Bung Karno Stadium, Jakarta');
      expect(first.startsAt, DateTime.parse('2026-12-30T19:00:00.000Z'));
      // Numeric Postgres bisa datang sebagai string; UI butuh angka.
      expect(first.minPrice, 350000);
      expect(events.last.name, 'Tulus: Tur 2026');
      expect(Uri.parse(adapter.lastRequestUrl!).path, '/users/bookmarks');
    });

    test('data bukan array dilaporkan sebagai kesalahan server', () async {
      final adapter = FakeHttpAdapter(200, {
        'success': true,
        'data': {'bukan': 'array'},
      });
      final repository = BookmarkRepository(
        client: ApiClient(adapter: adapter),
      );

      await expectLater(
        repository.fetchBookmarks(),
        throwsA(
          isA<ApiException>().having(
            (e) => e.kind,
            'kind',
            ApiExceptionKind.server,
          ),
        ),
      );
    });
  });

  group('BookmarkRepository — POST /events/:id/bookmark', () {
    test('mengirim toggle dan mengembalikan status dari server', () async {
      final adapter = FakeHttpAdapter(200, bookmarkToggleResponse(true));
      final repository = BookmarkRepository(
        client: ApiClient(adapter: adapter),
      );

      final bookmarked = await repository.toggleBookmark('7');

      expect(bookmarked, isTrue);
      expect(adapter.requests.single.method, 'POST');
      expect(Uri.parse(adapter.lastRequestUrl!).path, '/events/7/bookmark');
    });

    test(
      'status toggle menyimpang dilaporkan sebagai kesalahan server',
      () async {
        final adapter = FakeHttpAdapter(200, {
          'success': true,
          'data': {'bookmarked': 'ya'},
        });
        final repository = BookmarkRepository(
          client: ApiClient(adapter: adapter),
        );

        await expectLater(
          repository.toggleBookmark('1'),
          throwsA(
            isA<ApiException>().having(
              (e) => e.kind,
              'kind',
              ApiExceptionKind.server,
            ),
          ),
        );
      },
    );
  });
}
