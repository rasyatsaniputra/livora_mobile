import 'package:flutter_test/flutter_test.dart';
import 'package:livora_mobile/core/network/api_client.dart';
import 'package:livora_mobile/core/network/api_exception.dart';
import 'package:livora_mobile/features/auth/data/auth_repository.dart';

import '../../support/fake_http_adapter.dart';
import '../../support/memory_token_store.dart';

/// Test kontrak data modul auth di atas seam HTTP (adapter palsu, tiket 02) —
/// tanpa jaringan sungguhan. Kontrak mengikuti OpenAPI Soundtix:
/// `POST /auth/request-otp` dan `POST /auth/verify-otp`.
void main() {
  const draft = (email: 'baru@soundtix.id', username: 'Budi Santoso');

  group('AuthRepository (seam: adapter palsu)', () {
    test(
      'registrasi meminta OTP: POST /auth/request-otp dengan email & nama',
      () async {
        final adapter = FakeHttpAdapter(200, {'message': 'OTP dikirim'});
        final repository = AuthRepository(
          client: ApiClient(adapter: adapter),
          tokenStore: MemoryTokenStore(),
        );

        await repository.requestRegistrationOtp(draft);

        final calls = adapter.requests
            .where((r) => r.url.endsWith('/auth/request-otp'))
            .toList();
        expect(calls, hasLength(1));
        expect(calls.single.method, 'POST');
        expect(calls.single.body, {
          'email': 'baru@soundtix.id',
          'username': 'Budi Santoso',
        });
      },
    );

    test(
      'verifikasi sukses: POST /auth/verify-otp dengan email+otp+nama, '
      'pasangan token tersimpan (terdaftar & terverifikasi)',
      () async {
        final adapter = FakeHttpAdapter(200, {
          'access_token': 'access-1',
          'refresh_token': 'refresh-1',
        });
        final store = MemoryTokenStore();
        final repository = AuthRepository(
          client: ApiClient(adapter: adapter),
          tokenStore: store,
        );

        await repository.verifyRegistration(draft, otp: '123456');

        final calls = adapter.requests
            .where((r) => r.url.endsWith('/auth/verify-otp'))
            .toList();
        expect(calls, hasLength(1));
        expect(calls.single.method, 'POST');
        expect(calls.single.body, {
          'email': 'baru@soundtix.id',
          'otp': '123456',
          'username': 'Budi Santoso',
        });
        expect(store.accessToken, 'access-1');
        expect(store.refreshToken, 'refresh-1');
      },
    );

    test('verifikasi gagal (401 OTP salah): token tidak tersimpan', () async {
      final adapter = FakeHttpAdapter(401, {'detail': 'OTP salah'});
      final store = MemoryTokenStore();
      final repository = AuthRepository(
        client: ApiClient(adapter: adapter),
        tokenStore: store,
      );

      await expectLater(
        repository.verifyRegistration(draft, otp: '000000'),
        throwsA(
          isA<ApiException>()
              .having((e) => e.kind, 'kind', ApiExceptionKind.request)
              .having((e) => e.statusCode, 'statusCode', 401),
        ),
      );
      expect(store.accessToken, isNull);
      expect(store.refreshToken, isNull);
    });

    test('respons 200 tanpa token: dilaporkan sebagai kesalahan server',
        () async {
      final adapter = FakeHttpAdapter(200, {'unexpected': 'bentuk'});
      final store = MemoryTokenStore();
      final repository = AuthRepository(
        client: ApiClient(adapter: adapter),
        tokenStore: store,
      );

      await expectLater(
        repository.verifyRegistration(draft, otp: '123456'),
        throwsA(
          isA<ApiException>().having((e) => e.kind, 'kind', ApiExceptionKind.server),
        ),
      );
      expect(store.accessToken, isNull);
      expect(store.refreshToken, isNull);
    });
  });
}
