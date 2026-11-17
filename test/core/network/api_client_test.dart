import 'package:flutter_test/flutter_test.dart';
import 'package:livora_mobile/core/config/app_config.dart';
import 'package:livora_mobile/core/network/api_client.dart';
import 'package:livora_mobile/core/network/api_exception.dart';

import '../../support/fake_http_adapter.dart';

void main() {
  group('ApiClient (seam: HttpClientAdapter dio)', () {
    test('GET /health/ mengembalikan body JSON yang sudah ter-parse', () async {
      final client = ApiClient(
        adapter: FakeHttpAdapter(200, {'status': 'ok'}),
      );

      final data = await client.get<Map<String, dynamic>>('/health/');

      expect(data['status'], 'ok');
    });

    test('request dikirim ke base URL konfigurasi + path yang diminta',
        () async {
      final adapter = FakeHttpAdapter(200, {'ok': true});
      final client = ApiClient(adapter: adapter);

      await client.get<void>('/health/');

      // Menguji perilaku dari luar: URL penuh yang benar-benar diminta.
      expect(adapter.lastRequestUrl, '${AppConfig.baseUrl}/health/');
    });

    test('status >= 500 dilempar sebagai ApiException.server', () async {
      final client = ApiClient(
        adapter: FakeHttpAdapter(503, {'error': 'unavailable'}),
      );

      await expectLater(
        client.get<void>('/health/'),
        throwsA(isA<ApiException>().having(
          (e) => e.kind,
          'kind',
          ApiExceptionKind.server,
        )),
      );
    });

    test('server tidak bisa dihubungi dilempar sebagai ApiException.network',
        () async {
      final client = ApiClient(
        adapter: FakeHttpAdapter(-1, <String, Object?>{}),
      );

      await expectLater(
        client.get<void>('/health/'),
        throwsA(isA<ApiException>().having(
          (e) => e.kind,
          'kind',
          ApiExceptionKind.network,
        )),
      );
    });
  });
}
