import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:livora_mobile/core/auth/session_controller.dart';
import 'package:livora_mobile/core/network/api_client.dart';
import 'package:livora_mobile/core/network/api_exception.dart';
import 'package:livora_mobile/core/network/providers.dart';
import 'package:livora_mobile/features/catalog/presentation/bookmark_list_controller.dart';
import 'package:livora_mobile/features/catalog/presentation/bookmark_store.dart';
import 'package:livora_mobile/features/catalog/presentation/event_detail_controller.dart';

import '../../support/catalog_fixtures.dart';
import '../../support/fake_http_adapter.dart';
import '../../support/memory_token_store.dart';

/// Test state bookmark (tiket 08) lewat seam HTTP: status dari detail,
/// toggle, daftar tersimpan, dan penghapusan berbagi satu sumber status agar
/// detail dan daftar tetap konsisten.
void main() {
  ProviderContainer containerFor(FakeHttpAdapter adapter) {
    final container = ProviderContainer(
      overrides: [
        tokenStoreProvider.overrideWithValue(
          MemoryTokenStore(accessToken: 'access-1'),
        ),
        apiClientProvider.overrideWithValue(ApiClient(adapter: adapter)),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('EventDetailController — status bookmark', () {
    test('memuat detail menyinkronkan status bookmark dari server', () async {
      final adapter = FakeHttpAdapter.queue([
        FakeResponse(
          200,
          eventDetailResponse(eventDetailJson(bookmarked: true)),
        ),
        FakeResponse(200, organizerResponse()),
      ]);
      final container = containerFor(adapter);

      await container.read(eventDetailControllerProvider('1').notifier).load();

      expect(container.read(bookmarkStoreProvider)['1'], isTrue);
    });

    test('toggle dari detail memperbarui status bersama', () async {
      final adapter = FakeHttpAdapter.queue([
        FakeResponse(
          200,
          eventDetailResponse(eventDetailJson(bookmarked: true)),
        ),
        FakeResponse(200, organizerResponse()),
        FakeResponse(200, bookmarkToggleResponse(false)),
      ]);
      final container = containerFor(adapter);
      final controller = container.read(
        eventDetailControllerProvider('1').notifier,
      );
      await controller.load();

      final kind = await controller.toggleBookmark();

      expect(kind, isNull);
      expect(container.read(bookmarkStoreProvider)['1'], isFalse);
      final toggleRequest = adapter.requests.last;
      expect(toggleRequest.method, 'POST');
      expect(Uri.parse(toggleRequest.url).path, '/events/1/bookmark');
    });

    test(
      'toggle gagal mempertahankan status dan melaporkan jenis error',
      () async {
        final adapter = FakeHttpAdapter.queue([
          FakeResponse(
            200,
            eventDetailResponse(eventDetailJson(bookmarked: true)),
          ),
          FakeResponse(200, organizerResponse()),
          FakeResponse(500, {'success': false}),
        ]);
        final container = containerFor(adapter);
        final controller = container.read(
          eventDetailControllerProvider('1').notifier,
        );
        await controller.load();

        final kind = await controller.toggleBookmark();

        expect(kind, ApiExceptionKind.server);
        expect(container.read(bookmarkStoreProvider)['1'], isTrue);
      },
    );
  });

  group('BookmarkListController', () {
    test('memuat daftar bookmark dan menandai status tersimpan', () async {
      final adapter = FakeHttpAdapter(
        200,
        bookmarksResponse([bookmarkEventJson()]),
      );
      final container = containerFor(adapter);
      final controller = container.read(
        bookmarkListControllerProvider.notifier,
      );

      final loading = controller.load();
      expect(
        container.read(bookmarkListControllerProvider),
        isA<BookmarkListLoading>(),
      );
      await loading;

      final state = container.read(bookmarkListControllerProvider);
      expect(state, isA<BookmarkListReady>());
      final ready = state as BookmarkListReady;
      expect(ready.events.single.name, 'Soundtix Fest 2026: The Grand Stage');
      expect(container.read(bookmarkStoreProvider)['1'], isTrue);
      expect(Uri.parse(adapter.lastRequestUrl!).path, '/users/bookmarks');
    });

    test('daftar kosong menjadi state siap tanpa event', () async {
      final adapter = FakeHttpAdapter(200, bookmarksResponse([]));
      final container = containerFor(adapter);

      await container.read(bookmarkListControllerProvider.notifier).load();

      final state = container.read(bookmarkListControllerProvider);
      expect(state, isA<BookmarkListReady>());
      expect((state as BookmarkListReady).events, isEmpty);
    });

    test('server gagal memuat daftar menjadi state gagal', () async {
      final container = containerFor(FakeHttpAdapter(-1, <String, Object?>{}));

      await container.read(bookmarkListControllerProvider.notifier).load();

      final state = container.read(bookmarkListControllerProvider);
      expect(state, isA<BookmarkListFailed>());
      expect((state as BookmarkListFailed).kind, ApiExceptionKind.network);
    });

    test('hapus dari daftar memanggil toggle lalu membuang event', () async {
      final adapter = FakeHttpAdapter.queue([
        FakeResponse(200, bookmarksResponse([bookmarkEventJson()])),
        FakeResponse(200, bookmarkToggleResponse(false)),
      ]);
      final container = containerFor(adapter);
      final controller = container.read(
        bookmarkListControllerProvider.notifier,
      );
      await controller.load();

      final kind = await controller.remove('1');

      expect(kind, isNull);
      final state = container.read(bookmarkListControllerProvider);
      expect(state, isA<BookmarkListReady>());
      expect((state as BookmarkListReady).events, isEmpty);
      expect(container.read(bookmarkStoreProvider)['1'], isFalse);
      expect(adapter.requests.last.method, 'POST');
      expect(Uri.parse(adapter.requests.last.url).path, '/events/1/bookmark');
    });

    test('hapus gagal mempertahankan event dan melaporkan error', () async {
      final adapter = FakeHttpAdapter.queue([
        FakeResponse(200, bookmarksResponse([bookmarkEventJson()])),
        FakeResponse(500, {'success': false}),
      ]);
      final container = containerFor(adapter);
      final controller = container.read(
        bookmarkListControllerProvider.notifier,
      );
      await controller.load();

      final kind = await controller.remove('1');

      expect(kind, ApiExceptionKind.server);
      final state = container.read(bookmarkListControllerProvider);
      expect((state as BookmarkListReady).events, hasLength(1));
      expect(container.read(bookmarkStoreProvider)['1'], isTrue);
    });

    test(
      'status bookmark berubah di detail langsung tercermin di daftar',
      () async {
        final adapter = FakeHttpAdapter(
          200,
          bookmarksResponse([bookmarkEventJson()]),
        );
        final container = containerFor(adapter);
        await container.read(bookmarkListControllerProvider.notifier).load();

        container.read(bookmarkStoreProvider.notifier).seed('1', false);
        await Future<void>.delayed(Duration.zero);

        final state = container.read(bookmarkListControllerProvider);
        expect((state as BookmarkListReady).events, isEmpty);
      },
    );

    test('hapus baris basi tetap berakhir tanpa bookmark', () async {
      final adapter = FakeHttpAdapter.queue([
        FakeResponse(200, bookmarksResponse([bookmarkEventJson()])),
        // Server ternyata sudah tidak menyimpan event ini: toggle pertama
        // justru menyimpan, toggle kedua menghapus.
        FakeResponse(200, bookmarkToggleResponse(true)),
        FakeResponse(200, bookmarkToggleResponse(false)),
      ]);
      final container = containerFor(adapter);
      final controller = container.read(
        bookmarkListControllerProvider.notifier,
      );
      await controller.load();

      final kind = await controller.remove('1');

      expect(kind, isNull);
      final state = container.read(bookmarkListControllerProvider);
      expect((state as BookmarkListReady).events, isEmpty);
      expect(container.read(bookmarkStoreProvider)['1'], isFalse);
      expect(adapter.requests.where((r) => r.method == 'POST'), hasLength(2));
    });

    test('sesi berakhir mengosongkan daftar dan status bookmark', () async {
      final adapter = FakeHttpAdapter(
        200,
        bookmarksResponse([bookmarkEventJson()]),
      );
      final container = containerFor(adapter);
      await container.read(bookmarkListControllerProvider.notifier).load();
      expect(container.read(bookmarkStoreProvider)['1'], isTrue);

      await container.read(sessionControllerProvider.notifier).markSignedOut();
      await Future<void>.delayed(Duration.zero);

      expect(
        container.read(bookmarkListControllerProvider),
        isA<BookmarkListLoading>(),
      );
      expect(container.read(bookmarkStoreProvider), isEmpty);
    });
  });
}
