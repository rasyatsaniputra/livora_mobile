import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:livora_mobile/core/network/api_client.dart';
import 'package:livora_mobile/core/network/api_exception.dart';
import 'package:livora_mobile/core/network/providers.dart';
import 'package:livora_mobile/features/catalog/data/catalog_filters.dart';
import 'package:livora_mobile/features/catalog/presentation/catalog_controller.dart';

import '../../support/catalog_fixtures.dart';
import '../../support/fake_http_adapter.dart';

/// Test provider katalog lewat seam HTTP: repository, provider Riverpod, dan
/// pemetaan state ikut ter-exercise tanpa backend hidup.
void main() {
  ProviderContainer containerFor(FakeHttpAdapter adapter) {
    final container = ProviderContainer(
      overrides: [
        apiClientProvider.overrideWithValue(ApiClient(adapter: adapter)),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('memuat daftar event lalu statistik ke state siap tampil', () async {
    final adapter = FakeHttpAdapter.queue([
      FakeResponse(200, catalogEventsResponse([catalogEventJson()])),
      FakeResponse(200, catalogStatsResponse()),
    ]);
    final container = containerFor(adapter);
    final controller = container.read(catalogControllerProvider.notifier);

    final loading = controller.load();
    expect(container.read(catalogControllerProvider), isA<CatalogLoading>());
    await loading;

    final state = container.read(catalogControllerProvider);
    expect(state, isA<CatalogReady>());
    final ready = state as CatalogReady;
    expect(ready.events.single.name, 'Soundtix Fest 2026: The Grand Stage');
    expect(ready.events.single.venue, 'Gelora Bung Karno Stadium, Jakarta');
    expect(ready.stats?.activeEvents, 12);
    expect(ready.stats?.ticketsSold, 3450);
    expect(adapter.requests.map((r) => Uri.parse(r.url).path).toList(), [
      '/events',
      '/events/stats',
    ]);
  });

  test('pencarian mengirim kata kunci dan mempertahankan statistik', () async {
    final adapter = FakeHttpAdapter.queue([
      FakeResponse(200, catalogEventsResponse([catalogEventJson()])),
      FakeResponse(200, catalogStatsResponse()),
      FakeResponse(
        200,
        catalogEventsResponse([
          catalogEventJson(id: 2, name: 'Tulus: Tur 2026'),
        ]),
      ),
    ]);
    final container = containerFor(adapter);
    final controller = container.read(catalogControllerProvider.notifier);
    await controller.load();

    await controller.search('Tulus');

    final ready = container.read(catalogControllerProvider) as CatalogReady;
    expect(ready.filters.query, 'Tulus');
    expect(ready.events.single.name, 'Tulus: Tur 2026');
    // Statistik tidak diambil ulang hanya karena kata kunci berubah.
    expect(ready.stats?.activeEvents, 12);

    final searchRequest = adapter.requests.last;
    expect(Uri.parse(searchRequest.url).queryParameters['q'], 'Tulus');
    expect(
      adapter.requests.where((r) => r.url.contains('/events/stats')),
      hasLength(1),
    );
  });

  test('filter kota, genre, dan urutan diteruskan ke API', () async {
    final adapter = FakeHttpAdapter.queue([
      FakeResponse(200, catalogEventsResponse([catalogEventJson()])),
      FakeResponse(200, catalogStatsResponse()),
      FakeResponse(200, catalogEventsResponse([])),
    ]);
    final container = containerFor(adapter);
    final controller = container.read(catalogControllerProvider.notifier);
    await controller.load();

    await controller.setFilters(
      city: 'Bandung',
      genre: 'Pop',
      sort: CatalogSort.newest,
    );

    final state = container.read(catalogControllerProvider) as CatalogReady;
    expect(state.filters.city, 'Bandung');
    expect(state.filters.genre, 'Pop');
    expect(state.filters.sort, CatalogSort.newest);
    expect(state.events, isEmpty);

    final params = Uri.parse(adapter.requests.last.url).queryParameters;
    expect(params['city'], 'Bandung');
    expect(params['genre'], 'Pop');
    expect(params['sort'], 'terbaru');
  });

  test('server tidak terjangkau: state gagal dengan pesan jaringan', () async {
    final container = containerFor(FakeHttpAdapter(-1, <String, Object?>{}));
    final controller = container.read(catalogControllerProvider.notifier);

    await controller.load();

    final state = container.read(catalogControllerProvider);
    expect(state, isA<CatalogFailed>());
    expect((state as CatalogFailed).kind, ApiExceptionKind.network);
  });

  test('statistik gagal dimuat tidak menggagalkan daftar event', () async {
    final adapter = FakeHttpAdapter.queue([
      FakeResponse(200, catalogEventsResponse([catalogEventJson()])),
      FakeResponse(500, {'detail': 'stats down'}),
    ]);
    final container = containerFor(adapter);
    final controller = container.read(catalogControllerProvider.notifier);

    await controller.load();

    final state = container.read(catalogControllerProvider);
    expect(state, isA<CatalogReady>());
    final ready = state as CatalogReady;
    expect(ready.events, hasLength(1));
    expect(ready.stats, isNull);
  });
}
