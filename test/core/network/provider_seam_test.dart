import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:livora_mobile/core/network/api_client.dart';
import 'package:livora_mobile/core/network/providers.dart';

import '../../support/fake_http_adapter.dart';
import '../../support/memory_token_store.dart';

void main() {
  group('Pola test modul-modul berikutnya: override provider + adapter palsu',
      () {
    test('apiClientProvider bisa dioverride dengan ApiClient ber-adapter palsu',
        () async {
      final adapter = FakeHttpAdapter(200, {'status': 'ok'});
      final store = MemoryTokenStore(accessToken: 'access-lama');

      final container = ProviderContainer(
        overrides: [
          apiClientProvider.overrideWithValue(
            ApiClient(adapter: adapter, tokenStore: store),
          ),
        ],
      );
      addTearDown(container.dispose);

      final data = await container.read(apiClientProvider).get<Map<String, dynamic>>(
            '/health/',
          );

      expect(data['status'], 'ok');
      expect(adapter.lastRequestAuthorization, 'Bearer access-lama');
    });
  });
}
