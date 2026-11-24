import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:livora_mobile/core/auth/token_store.dart';
import 'package:livora_mobile/core/router/app_router.dart';
import 'package:livora_mobile/features/auth/data/auth_repository.dart';

import '../../support/catalog_fixtures.dart';
import '../../support/fake_http_adapter.dart';
import '../../support/memory_token_store.dart';
import '../../support/test_app.dart';

/// Alur register + verifikasi OTP (tiket 03) — diuji dari luar lewat
/// seam HTTP (adapter palsu + override provider) dan router nyata,
/// mengikuti pola test yang dibentuk tiket 02.
void main() {
  group('Form register (layar /register)', () {
    testWidgets('input tidak valid: pesan field tampil, tidak ada request',
        (tester) async {
      final adapter = FakeHttpAdapter(200, {});

      await pumpAfterglowApp(tester, adapter: adapter, location: '/register');

      await tester.tap(find.widgetWithText(FilledButton, 'Daftar'));
      await tester.pump();

      expect(find.text('Nama minimal 3 karakter.'), findsOneWidget);
      expect(find.text('Format email tidak valid.'), findsOneWidget);
      // Tidak ada trafik HTTP untuk input yang tidak lolos validasi.
      expect(adapter.requests, isEmpty);
    });

    testWidgets('register sukses: meminta OTP lalu layar verifikasi tampil',
        (tester) async {
      final adapter = FakeHttpAdapter(200, {'message': 'OTP dikirim'});

      await pumpAfterglowApp(tester, adapter: adapter, location: '/register');

      await tester.enterText(find.byType(TextFormField).at(0), 'Budi Santoso');
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'baru@soundtix.id',
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Daftar'));
      await tester.pumpAndSettle();

      // Layar berpindah ke verifikasi OTP dengan menyebut email tujuan.
      expect(find.text('Verifikasi OTP'), findsOneWidget);
      expect(find.textContaining('baru@soundtix.id'), findsOneWidget);

      // Tepat satu request pendaftaran dengan isi yang benar.
      expect(adapter.requests, hasLength(1));
      expect(
        adapter.requests.single.url.endsWith('/auth/request-otp'),
        isTrue,
      );
      expect(adapter.requests.single.body, {
        'email': 'baru@soundtix.id',
        'username': 'Budi Santoso',
      });
    });

    testWidgets('email sudah terdaftar (409): pesan jelas, tetap di form',
        (tester) async {
      final adapter = FakeHttpAdapter(409, {'detail': 'email sudah terdaftar'});

      await pumpAfterglowApp(tester, adapter: adapter, location: '/register');

      await tester.enterText(find.byType(TextFormField).at(0), 'Budi Santoso');
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'buyer@soundtix.id',
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Daftar'));
      await tester.pumpAndSettle();

      expect(
        find.text('Email sudah terdaftar. Gunakan email lain.'),
        findsOneWidget,
      );
      // Tidak berpindah ke layar verifikasi.
      expect(find.text('Verifikasi OTP'), findsNothing);
    });
  });

  group('Layar verifikasi OTP (/register/verify)', () {    testWidgets('verifikasi sukses: token tersimpan dan sampai ke Katalog',
        (tester) async {
      final adapter = FakeHttpAdapter.queue([
        FakeResponse(200, {
          'access_token': 'access-1',
          'refresh_token': 'refresh-1',
        }),
        FakeResponse(
          200,
          catalogEventsResponse([catalogEventJson(posterUrl: null)]),
        ),
        FakeResponse(200, catalogStatsResponse()),
      ]);
      final store = MemoryTokenStore();

      await pumpAfterglowApp(
        tester,
        adapter: adapter,
        tokenStore: store,
        location: '/register/verify',
        extra: const RegistrationOtpChallenge(
          email: 'baru@soundtix.id',
          username: 'Budi Santoso',
        ),
      );

      await tester.enterText(find.byType(TextField), '123456');
      // Frame untuk mengaktifkan tombol (6 digit terisi).
      await tester.pump();
      await tester.tap(find.widgetWithText(FilledButton, 'Verifikasi'));
      await tester.pumpAndSettle();

      // Kondisi terdaftar & terverifikasi: pasangan token tersimpan.
      expect(store.accessToken, 'access-1');
      expect(store.refreshToken, 'refresh-1');

      // Berpindah ke home (Katalog) dan event pertama dimuat.
      expect(find.text('Katalog'), findsWidgets);
      expect(find.text('Soundtix Fest 2026: The Grand Stage'), findsOneWidget);

      // Tepat satu request verifikasi dengan isi yang benar.
      final verifyCalls = adapter.requests
          .where((r) => r.url.endsWith('/auth/verify-otp'))
          .toList();
      expect(verifyCalls, hasLength(1));
      expect(verifyCalls.single.body, {
        'email': 'baru@soundtix.id',
        'otp': '123456',
        'username': 'Budi Santoso',
      });
    });

    testWidgets('OTP salah/kedaluwarsa: pesan jelas, tidak ada sesi terbentuk',
        (tester) async {
      final adapter = FakeHttpAdapter(401, {'detail': 'OTP salah'});
      final store = MemoryTokenStore();

      await pumpAfterglowApp(
        tester,
        adapter: adapter,
        tokenStore: store,
        location: '/register/verify',
        extra: const RegistrationOtpChallenge(
          email: 'baru@soundtix.id',
          username: 'Budi Santoso',
        ),
      );

      await tester.enterText(find.byType(TextField), '000000');
      await tester.pump();
      await tester.tap(find.widgetWithText(FilledButton, 'Verifikasi'));
      await tester.pumpAndSettle();

      expect(
        find.text('Kode OTP salah atau kedaluwarsa. Coba lagi.'),
        findsOneWidget,
      );
      // Tetap di layar verifikasi, tanpa sesi terbentuk.
      expect(find.text('Verifikasi OTP'), findsOneWidget);
      expect(store.accessToken, isNull);
      expect(store.refreshToken, isNull);
    });

    testWidgets('kirim ulang OTP: meminta ulang kode dan konfirmasi tampil',
        (tester) async {
      final adapter = FakeHttpAdapter(200, {'message': 'OTP dikirim'});

      await pumpAfterglowApp(
        tester,
        adapter: adapter,
        location: '/register/verify',
        extra: const RegistrationOtpChallenge(
          email: 'baru@soundtix.id',
          username: 'Budi Santoso',
        ),
      );

      await tester.tap(find.text('Kirim ulang OTP'));
      await tester.pumpAndSettle();

      expect(adapter.requests, hasLength(1));
      expect(
        adapter.requests.single.url.endsWith('/auth/request-otp'),
        isTrue,
      );
      expect(adapter.requests.single.body, {
        'email': 'baru@soundtix.id',
        'username': 'Budi Santoso',
      });
      expect(
        find.text('Kode OTP dikirim ulang ke baru@soundtix.id.'),
        findsOneWidget,
      );
    });

    testWidgets('kirim ulang gagal: pesan kesalahan umum, bukan "kode salah"',
        (tester) async {
      // Endpoint menolak permintaan kirim ulang (bukan kode yang dinilai).
      final adapter = FakeHttpAdapter(401, {'detail': 'unauthorized'});

      await pumpAfterglowApp(
        tester,
        adapter: adapter,
        location: '/register/verify',
        extra: const RegistrationOtpChallenge(
          email: 'baru@soundtix.id',
          username: 'Budi Santoso',
        ),
      );

      await tester.tap(find.text('Kirim ulang OTP'));
      await tester.pumpAndSettle();

      expect(find.text('Terjadi kesalahan. Silakan coba lagi.'), findsOneWidget);
      // Tidak menuduh kode salah — tidak ada kode yang dikirim.
      expect(
        find.text('Kode OTP salah atau kedaluwarsa. Coba lagi.'),
        findsNothing,
      );
    });

    testWidgets('percobaan sebelumnya tidak membawa error basi ke layar baru',
        (tester) async {
      final adapter = FakeHttpAdapter(401, {'detail': 'OTP salah'});
      final container = await pumpAfterglowApp(
        tester,
        adapter: adapter,
        location: '/register/verify',
        extra: const RegistrationOtpChallenge(
          email: 'baru@soundtix.id',
          username: 'Budi Santoso',
        ),
      );

      // Percobaan pertama gagal → pesan tampil.
      await tester.enterText(find.byType(TextField), '000000');
      await tester.pump();
      await tester.tap(find.widgetWithText(FilledButton, 'Verifikasi'));
      await tester.pumpAndSettle();
      expect(
        find.text('Kode OTP salah atau kedaluwarsa. Coba lagi.'),
        findsOneWidget,
      );

      // Kembali ke register, lalu buka layar verifikasi lagi.
      final router = container.read(appRouterProvider);
      router.go('/register');
      await tester.pumpAndSettle();
      router.go(
        '/register/verify',
        extra: const RegistrationOtpChallenge(
          email: 'baru@soundtix.id',
          username: 'Budi Santoso',
        ),
      );
      await tester.pumpAndSettle();

      // Layar baru bersih: belum ada kesalahan yang ditampilkan.
      expect(
        find.text('Kode OTP salah atau kedaluwarsa. Coba lagi.'),
        findsNothing,
      );
    });

    testWidgets('gagal menyimpan sesi: pesan error tampil, tidak menggantung',
        (tester) async {
      final adapter = FakeHttpAdapter(200, {
        'access_token': 'access-1',
        'refresh_token': 'refresh-1',
      });

      await pumpAfterglowApp(
        tester,
        adapter: adapter,
        tokenStore: _ThrowingTokenStore(),
        location: '/register/verify',
        extra: const RegistrationOtpChallenge(
          email: 'baru@soundtix.id',
          username: 'Budi Santoso',
        ),
      );

      await tester.enterText(find.byType(TextField), '123456');
      await tester.pump();
      await tester.tap(find.widgetWithText(FilledButton, 'Verifikasi'));
      await tester.pumpAndSettle();

      expect(find.text('Terjadi kesalahan. Silakan coba lagi.'), findsOneWidget);
      // Tombol kembali aktif — layar tidak tertahan di "Memverifikasi…".
      expect(find.text('Memverifikasi…'), findsNothing);
    });
  });
}

/// Token store yang selalu gagal menyimpan (mis. secure storage bermasalah).
class _ThrowingTokenStore implements TokenStore {
  @override
  Future<String?> readAccessToken() async => null;

  @override
  Future<String?> readRefreshToken() async => null;

  @override
  Future<void> save({
    required String accessToken,
    required String refreshToken,
  }) async =>
      throw Exception('secure storage gagal');

  @override
  Future<void> clear() async {}
}
