import 'package:flutter_test/flutter_test.dart';
import 'package:livora_mobile/core/network/api_client.dart';
import 'package:livora_mobile/core/network/api_exception.dart';
import 'package:livora_mobile/features/catalog/data/event_detail_repository.dart';

import '../../support/catalog_fixtures.dart';
import '../../support/fake_http_adapter.dart';

/// Test kontrak data detail event (tiket 07) di atas seam HTTP:
/// `GET /events/:id` untuk detail + kategori tiket, dan `GET /organizers/:id`
/// untuk profil publik penyelenggara.
void main() {
  group('EventDetailRepository — GET /events/:id', () {
    test('memetakan detail event beserta kategori tiket', () async {
      final adapter = FakeHttpAdapter(200, eventDetailResponse());
      final repository = EventDetailRepository(
        client: ApiClient(adapter: adapter),
      );

      final event = await repository.fetchEventDetail('1');

      expect(event.name, 'Soundtix Fest 2026: The Grand Stage');
      expect(
        event.description,
        'Konser musik akbar persembahan siswa UKK Kelas 12.',
      );
      expect(event.artist, 'Sheila on 7, Tulus, Hindia');
      expect(event.venue, 'Gelora Bung Karno Stadium, Jakarta');
      expect(event.city, 'Jakarta');
      expect(event.startsAt, DateTime.parse('2026-12-30T19:00:00.000Z'));
      expect(event.endsAt, DateTime.parse('2026-12-31T01:30:00.000Z'));
      expect(event.organizerId, '1');
      expect(event.organizationName, 'Soundtix Live');
      expect(event.availableQuota, 1465);
      expect(event.soldOut, isFalse);

      expect(event.categories, hasLength(2));
      final vip = event.categories.first;
      expect(vip.name, 'VIP Front Row');
      expect(vip.price, 1500000);
      expect(vip.quotaAvailable, 480);
      expect(vip.maxPerTransaction, 2);
      // Numeric Postgres bisa datang sebagai string; UI butuh angka.
      final regular = event.categories.last;
      expect(regular.price, 350000);

      expect(Uri.parse(adapter.lastRequestUrl!).path, '/events/1');
    });

    test('data bukan objek dilaporkan sebagai kesalahan server', () async {
      final adapter = FakeHttpAdapter(200, {
        'success': true,
        'data': 'bukan objek',
      });
      final repository = EventDetailRepository(
        client: ApiClient(adapter: adapter),
      );

      await expectLater(
        repository.fetchEventDetail('1'),
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

  group('EventDetailRepository — GET /organizers/:id', () {
    test('memetakan profil publik organizer', () async {
      final adapter = FakeHttpAdapter(200, organizerResponse());
      final repository = EventDetailRepository(
        client: ApiClient(adapter: adapter),
      );

      final organizer = await repository.fetchOrganizer('1');

      expect(organizer.id, '1');
      expect(organizer.name, 'Soundtix Live Official');
      expect(organizer.verificationStatus, 'verified');
      expect(Uri.parse(adapter.lastRequestUrl!).path, '/organizers/1');
    });

    test(
      'data organizer bukan objek dilaporkan sebagai kesalahan server',
      () async {
        final adapter = FakeHttpAdapter(200, {
          'success': true,
          'data': ['bukan', 'objek'],
        });
        final repository = EventDetailRepository(
          client: ApiClient(adapter: adapter),
        );

        await expectLater(
          repository.fetchOrganizer('1'),
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
