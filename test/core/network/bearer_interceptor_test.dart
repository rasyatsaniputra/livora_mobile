import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:livora_mobile/core/network/api_client.dart';
import 'package:livora_mobile/core/network/api_exception.dart';
import 'package:livora_mobile/core/network/providers.dart';

import '../../support/fake_http_adapter.dart';
import '../../support/memory_token_store.dart';

/// Pola test untuk semua modul (tiket 02): ApiClient dibangun di ATAS
/// adapter palsu (seam HTTP) + token store di memori, lalu dipasang lewat
/// override provider Riverpod — tidak ada jaringan sungguhan.
ApiClient _client(MemoryTokenStore store, FakeHttpAdapter adapter) =>
    ApiClient(adapter: adapter, tokenStore: store);

void main() {
  group('BearerInterceptor (seam: ApiClient + adapter palsu)', () {
    test('access token yang tersimpan terpasang sebagai header Authorization',
        () async {
      final store = MemoryTokenStore(
        accessToken: 'access-lama',
        refreshToken: 'refresh-lama',
      );
      final adapter = FakeHttpAdapter(200, {'status': 'ok'});
      final client = _client(store, adapter);

      await client.get<Map<String, dynamic>>('/health/');

      expect(adapter.lastRequestAuthorization, 'Bearer access-lama');
    });

    test('tanpa token tersimpan, request berjalan tanpa header Authorization',
        () async {
      final store = MemoryTokenStore();
      final adapter = FakeHttpAdapter(200, {'status': 'ok'});
      final client = _client(store, adapter);

      await client.get<Map<String, dynamic>>('/health/');

      expect(adapter.lastRequestAuthorization, isNull);
    });

    // Test pembuktian utama tiket 02, memakai pola "override provider +
    // adapter palsu" yang akan diikuti semua modul berikutnya.
    test(
        'pola override provider: 401 → refresh → retry sukses, '
        'token baru tersimpan', () async {
      final store = MemoryTokenStore(
        accessToken: 'access-usang',
        refreshToken: 'refresh-1',
      );
      final adapter = FakeHttpAdapter.queue([
        FakeResponse(401, {'detail': 'token kedaluwarsa'}),
        FakeResponse(200, {
          'access_token': 'access-baru',
          'refresh_token': 'refresh-2',
        }),
        FakeResponse(200, {'data': 'rahasia'}),
      ]);

      final container = ProviderContainer(
        overrides: [
          apiClientProvider.overrideWithValue(_client(store, adapter)),
        ],
      );
      addTearDown(container.dispose);

      final data =
          await container.read(apiClientProvider).get<Map<String, dynamic>>(
                '/catalog/events',
              );

      // Retry memakai access token baru dan berhasil.
      expect(data['data'], 'rahasia');
      expect(adapter.lastRequestAuthorization, 'Bearer access-baru');

      // Refresh dipanggil tepat sekali dengan refresh token yang tersimpan.
      final refreshCalls = adapter.requests
          .where((r) => r.url.endsWith('/auth/refresh'))
          .toList();
      expect(refreshCalls, hasLength(1));
      expect(refreshCalls.single.method, 'POST');
      expect(
        (refreshCalls.single.body as Map)['refresh_token'],
        'refresh-1',
      );

      // Pasangan token baru ikut tersimpan.
      expect(store.accessToken, 'access-baru');
      expect(store.refreshToken, 'refresh-2');
    });

    test('refresh gagal → 401 asli muncul sebagai ApiException dan token dibuang',
        () async {
      final store = MemoryTokenStore(
        accessToken: 'access-usang',
        refreshToken: 'refresh-kadaluarsa',
      );
      final adapter = FakeHttpAdapter.queue([
        FakeResponse(401, {'detail': 'token kedaluwarsa'}),
        FakeResponse(401, {'detail': 'refresh token tidak valid'}),
      ]);
      final client = _client(store, adapter);

      await expectLater(
        client.get<Map<String, dynamic>>('/catalog/events'),
        throwsA(
          isA<ApiException>()
              .having((e) => e.kind, 'kind', ApiExceptionKind.request)
              .having((e) => e.statusCode, 'statusCode', 401),
        ),
      );

      // Tidak ada retry: hanya request asli + satu percobaan refresh.
      expect(adapter.requests, hasLength(2));
      // Token dibuang — user dianggap belum login.
      expect(store.accessToken, isNull);
      expect(store.refreshToken, isNull);
    });

    test('tanpa refresh token tersimpan, 401 langsung diteruskan tanpa refresh',
        () async {
      final store = MemoryTokenStore(accessToken: 'access-usang');
      final adapter = FakeHttpAdapter(401, {'detail': 'token kedaluwarsa'});
      final client = _client(store, adapter);

      await expectLater(
        client.get<Map<String, dynamic>>('/catalog/events'),
        throwsA(
          isA<ApiException>()
              .having((e) => e.kind, 'kind', ApiExceptionKind.request)
              .having((e) => e.statusCode, 'statusCode', 401),
        ),
      );

      // Tidak ada panggilan /auth/refresh.
      expect(
        adapter.requests.where((r) => r.url.endsWith('/auth/refresh')),
        isEmpty,
      );
    });

    test('401 pada request tanpa Bearer (mis. login ditolak) tidak memicu refresh',
        () async {
      // Sesi kosong: request berjalan tanpa header Authorization.
      final store = MemoryTokenStore();
      final adapter = FakeHttpAdapter.queue([
        FakeResponse(401, {'detail': 'OTP salah'}),
      ]);
      final client = _client(store, adapter);

      await expectLater(
        client.post<Map<String, dynamic>>(
          '/auth/verify-otp',
          body: {'email': 'buyer@soundtix.id', 'otp': '000000'},
        ),
        throwsA(
          isA<ApiException>()
              .having((e) => e.kind, 'kind', ApiExceptionKind.request)
              .having((e) => e.statusCode, 'statusCode', 401),
        ),
      );

      // Hanya request asli — 401 bukan karena token kedaluwarsa.
      expect(adapter.requests, hasLength(1));
      expect(
        adapter.requests.where((r) => r.url.endsWith('/auth/refresh')),
        isEmpty,
      );
      // Token tidak tersentuh.
      expect(store.accessToken, isNull);
      expect(store.refreshToken, isNull);
    });

    test('dua 401 bersamaan → refresh hanya sekali, keduanya retry sukses',
        () async {
      final store = MemoryTokenStore(
        accessToken: 'access-usang',
        refreshToken: 'refresh-1',
      );
      final adapter = FakeHttpAdapter.queue([
        FakeResponse(401, {'detail': 'token kedaluwarsa'}),
        FakeResponse(401, {'detail': 'token kedaluwarsa'}),
        FakeResponse(200, {
          'access_token': 'access-baru',
          'refresh_token': 'refresh-2',
        }),
        FakeResponse(200, {'data': 'rahasia'}),
        FakeResponse(200, {'data': 'rahasia'}),
      ]);
      final client = _client(store, adapter);

      final results = await Future.wait([
        client.get<Map<String, dynamic>>('/catalog/events'),
        client.get<Map<String, dynamic>>('/orders/active'),
      ]);

      expect(results[0]['data'], 'rahasia');
      expect(results[1]['data'], 'rahasia');

      // Refresh tunggal: hanya satu panggilan /auth/refresh.
      final refreshCalls = adapter.requests
          .where((r) => r.url.endsWith('/auth/refresh'))
          .toList();
      expect(refreshCalls, hasLength(1));
      expect(store.accessToken, 'access-baru');
      expect(store.refreshToken, 'refresh-2');
    });
  });
}
