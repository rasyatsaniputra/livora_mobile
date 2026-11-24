import 'package:flutter_test/flutter_test.dart';
import 'package:livora_mobile/core/network/api_client.dart';
import 'package:livora_mobile/core/network/api_exception.dart';
import 'package:livora_mobile/features/catalog/data/catalog_filters.dart';
import 'package:livora_mobile/features/catalog/data/catalog_repository.dart';

import '../../support/catalog_fixtures.dart';
import '../../support/fake_http_adapter.dart';

/// Test kontrak data katalog (tiket 06) di atas seam HTTP (adapter palsu).
/// Kontrak mengikuti Soundtix: `GET /events` (envelope berisi array event)
/// dan `GET /events/stats` (envelope berisi metrik agregat).
void main() {
  group('CatalogRepository — GET /events', () {
    test('memetakan event + mengirim kata kunci, filter, dan urutan', () async {
      final adapter = FakeHttpAdapter(
        200,
        catalogEventsResponse([catalogEventJson(minPrice: '350000')]),
      );
      final repository = CatalogRepository(client: ApiClient(adapter: adapter));

      final events = await repository.fetchEvents(
        query: 'Tulus',
        city: 'Jakarta',
        genre: 'Electronic',
        sort: CatalogSort.cheapest,
      );

      expect(events, hasLength(1));
      final event = events.single;
      expect(event.name, 'Soundtix Fest 2026: The Grand Stage');
      expect(event.venue, 'Gelora Bung Karno Stadium, Jakarta');
      expect(event.genre, 'Electronic');
      expect(event.posterUrl, '/uploads/fest.png');
      expect(event.startsAt, DateTime.parse('2026-12-30T19:00:00.000Z'));
      // Numeric Postgres bisa datang sebagai string; UI butuh angka.
      expect(event.minPrice, 350000);

      final uri = Uri.parse(adapter.lastRequestUrl!);
      expect(uri.path, '/events');
      expect(uri.queryParameters, {
        'q': 'Tulus',
        'city': 'Jakarta',
        'genre': 'Electronic',
        'sort': 'termurah',
        'limit': '50',
      });
    });

    test('pencarian kosong tidak mengirim parameter filter kosong', () async {
      final adapter = FakeHttpAdapter(
        200,
        catalogEventsResponse([catalogEventJson()]),
      );
      final repository = CatalogRepository(client: ApiClient(adapter: adapter));

      await repository.fetchEvents();

      final uri = Uri.parse(adapter.lastRequestUrl!);
      expect(uri.queryParameters, {'sort': 'terdekat', 'limit': '50'});
    });

    test(
      'respons tanpa array data dilaporkan sebagai kesalahan server',
      () async {
        final adapter = FakeHttpAdapter(200, {
          'success': true,
          'data': {'bukan': 'array'},
        });
        final repository = CatalogRepository(
          client: ApiClient(adapter: adapter),
        );

        await expectLater(
          repository.fetchEvents(),
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

  group('CatalogRepository — GET /events/stats', () {
    test('memetakan statistik publik platform', () async {
      final adapter = FakeHttpAdapter(200, catalogStatsResponse());
      final repository = CatalogRepository(client: ApiClient(adapter: adapter));

      final stats = await repository.fetchStats();

      expect(stats.activeEvents, 12);
      expect(stats.ticketsSold, 3450);
      expect(stats.verifiedOrganizers, 4);
      expect(stats.cities, 7);
      expect(Uri.parse(adapter.lastRequestUrl!).path, '/events/stats');
    });

    test(
      'statistik berbentuk menyimpang dilaporkan sebagai kesalahan server',
      () async {
        final adapter = FakeHttpAdapter(200, {
          'success': true,
          'data': 'bukan objek',
        });
        final repository = CatalogRepository(
          client: ApiClient(adapter: adapter),
        );

        await expectLater(
          repository.fetchStats(),
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
