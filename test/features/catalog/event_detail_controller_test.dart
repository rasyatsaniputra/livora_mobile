import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:livora_mobile/core/network/api_client.dart';
import 'package:livora_mobile/core/network/api_exception.dart';
import 'package:livora_mobile/core/network/providers.dart';
import 'package:livora_mobile/features/catalog/presentation/event_detail_controller.dart';

import '../../support/catalog_fixtures.dart';
import '../../support/fake_http_adapter.dart';

/// Test provider detail event lewat seam HTTP: detail + organizer diambil
/// dari backend, dengan organizer sebagai data pelengkap.
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

  test('memuat detail event lalu organizer ke state siap tampil', () async {
    final adapter = FakeHttpAdapter.queue([
      FakeResponse(200, eventDetailResponse()),
      FakeResponse(200, organizerResponse()),
    ]);
    final container = containerFor(adapter);
    final provider = eventDetailControllerProvider('1');
    final controller = container.read(provider.notifier);

    final loading = controller.load();
    expect(container.read(provider), isA<EventDetailLoading>());
    await loading;

    final state = container.read(provider);
    expect(state, isA<EventDetailReady>());
    final ready = state as EventDetailReady;
    expect(ready.detail.name, 'Soundtix Fest 2026: The Grand Stage');
    expect(ready.detail.categories, hasLength(2));
    expect(ready.organizer?.name, 'Soundtix Live Official');
    expect(adapter.requests.map((r) => Uri.parse(r.url).path).toList(), [
      '/events/1',
      '/organizers/1',
    ]);
  });

  test('organizer gagal dimuat tidak menggagalkan detail event', () async {
    final adapter = FakeHttpAdapter.queue([
      FakeResponse(200, eventDetailResponse()),
      FakeResponse(404, {'success': false, 'message': 'Promotor tidak ada'}),
    ]);
    final container = containerFor(adapter);
    final controller = container.read(
      eventDetailControllerProvider('1').notifier,
    );

    await controller.load();

    final state = container.read(eventDetailControllerProvider('1'));
    expect(state, isA<EventDetailReady>());
    final ready = state as EventDetailReady;
    expect(ready.detail.name, 'Soundtix Fest 2026: The Grand Stage');
    expect(ready.organizer, isNull);
  });

  test('server tidak terjangkau: state gagal dengan pesan jaringan', () async {
    final container = containerFor(FakeHttpAdapter(-1, <String, Object?>{}));
    final provider = eventDetailControllerProvider('1');
    final controller = container.read(provider.notifier);

    await controller.load();

    final state = container.read(provider);
    expect(state, isA<EventDetailFailed>());
    expect((state as EventDetailFailed).kind, ApiExceptionKind.network);
  });

  test('coba lagi setelah gagal memuat ulang detail', () async {
    final adapter = FakeHttpAdapter.queue([
      FakeResponse(500, {'success': false}),
      FakeResponse(200, eventDetailResponse()),
      FakeResponse(200, organizerResponse()),
    ]);
    final container = containerFor(adapter);
    final provider = eventDetailControllerProvider('1');
    final controller = container.read(provider.notifier);

    await controller.load();
    expect(container.read(provider), isA<EventDetailFailed>());

    await controller.retry();

    expect(container.read(provider), isA<EventDetailReady>());
    expect(adapter.requests, hasLength(3));
  });
}
