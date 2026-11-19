import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fake_http_adapter.dart';
import '../../support/memory_token_store.dart';
import '../../support/test_app.dart';

/// Alur login + verifikasi OTP + sesi persist (tiket 04) — diuji dari luar
/// lewat seam HTTP (adapter palsu + override provider) dan router nyata,
/// mengikuti pola yang dibentuk tiket 02–03.
void main() {
  /// Membuka aplikasi dari splash (lokasi awal '/') lalu menunggu durasi
  /// splash selesai agar redirect pembuka benar-benar ter-exercise.
  Future<void> pumpAppFromSplash(
    WidgetTester tester, {
    required FakeHttpAdapter adapter,
    required MemoryTokenStore store,
  }) async {
    await pumpAfterglowApp(tester, adapter: adapter, tokenStore: store);
    await tester.pump(const Duration(milliseconds: 1200));
    await tester.pumpAndSettle();
  }

  /// Login penuh dari layar /login sampai sesi tersimpan & Katalog tampil.
  Future<void> loginThroughUi(
    WidgetTester tester, {
    required FakeHttpAdapter adapter,
    required MemoryTokenStore store,
  }) async {
    await pumpAfterglowApp(
      tester,
      adapter: adapter,
      tokenStore: store,
      location: '/login',
    );

    await tester.enterText(find.byType(TextFormField), 'buyer@soundtix.id');
    await tester.tap(find.widgetWithText(FilledButton, 'Masuk'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '123456');
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Verifikasi'));
    await tester.pumpAndSettle();
  }

  group('Pembuka aplikasi (sesi persist)', () {
    testWidgets('tanpa sesi: splash membuka layar login', (tester) async {
      final store = MemoryTokenStore();

      await pumpAppFromSplash(
        tester,
        adapter: FakeHttpAdapter(200, {}),
        store: store,
      );

      expect(find.widgetWithText(FilledButton, 'Masuk'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Katalog'), findsNothing);
    });

    testWidgets('sesi tersimpan: aplikasi dibuka langsung ke Katalog',
        (tester) async {
      final store = MemoryTokenStore(
        accessToken: 'access-tersimpan',
        refreshToken: 'refresh-tersimpan',
      );

      await pumpAppFromSplash(
        tester,
        adapter: FakeHttpAdapter(200, {}),
        store: store,
      );

      expect(find.text('Katalog'), findsWidgets);
      expect(find.widgetWithText(FilledButton, 'Masuk'), findsNothing);
    });

    testWidgets('login lalu aplikasi dibuka ulang: sesi tetap aktif',
        (tester) async {
      final adapter = FakeHttpAdapter.queue([
        FakeResponse(200, {'message': 'OTP dikirim'}),
        FakeResponse(200, {
          'access_token': 'access-1',
          'refresh_token': 'refresh-1',
        }),
      ]);
      final store = MemoryTokenStore();

      await loginThroughUi(tester, adapter: adapter, store: store);
      expect(find.text('Katalog'), findsWidgets);

      // "Buka ulang aplikasi": container + router baru, storage yang sama.
      await pumpAppFromSplash(
        tester,
        adapter: FakeHttpAdapter(200, {}),
        store: store,
      );

      expect(find.text('Katalog'), findsWidgets);
      expect(find.widgetWithText(FilledButton, 'Masuk'), findsNothing);
    });
  });

  group('Login (layar /login)', () {
    testWidgets('email tidak valid: pesan field tampil, tidak ada request',
        (tester) async {
      final adapter = FakeHttpAdapter(200, {});

      await pumpAfterglowApp(
        tester,
        adapter: adapter,
        tokenStore: MemoryTokenStore(),
        location: '/login',
      );

      await tester.enterText(find.byType(TextFormField), 'bukan-email');
      await tester.tap(find.widgetWithText(FilledButton, 'Masuk'));
      await tester.pump();

      expect(find.text('Format email tidak valid.'), findsOneWidget);
      expect(adapter.requests, isEmpty);
    });

    testWidgets(
        'login sukses: minta OTP (email saja) lalu verifikasi menyimpan sesi',
        (tester) async {
      final adapter = FakeHttpAdapter.queue([
        FakeResponse(200, {'message': 'OTP dikirim'}),
        FakeResponse(200, {
          'access_token': 'access-1',
          'refresh_token': 'refresh-1',
        }),
      ]);
      final store = MemoryTokenStore();

      await pumpAfterglowApp(
        tester,
        adapter: adapter,
        tokenStore: store,
        location: '/login',
      );

      await tester.enterText(find.byType(TextFormField), 'buyer@soundtix.id');
      await tester.tap(find.widgetWithText(FilledButton, 'Masuk'));
      await tester.pumpAndSettle();

      // Layar verifikasi OTP menampilkan email tujuan.
      expect(find.text('Verifikasi OTP'), findsOneWidget);
      expect(find.textContaining('buyer@soundtix.id'), findsOneWidget);

      // Permintaan login hanya membawa email — bukan username.
      expect(adapter.requests, hasLength(1));
      expect(
        adapter.requests.single.url.endsWith('/auth/request-otp'),
        isTrue,
      );
      expect(adapter.requests.single.body, {'email': 'buyer@soundtix.id'});

      await tester.enterText(find.byType(TextField), '123456');
      await tester.pump();
      await tester.tap(find.widgetWithText(FilledButton, 'Verifikasi'));
      await tester.pumpAndSettle();

      // Sesi aktif: pasangan token tersimpan dan home (Katalog) terbuka.
      expect(store.accessToken, 'access-1');
      expect(store.refreshToken, 'refresh-1');
      expect(find.text('Katalog'), findsWidgets);

      expect(adapter.requests, hasLength(2));
      expect(
        adapter.requests.last.url.endsWith('/auth/verify-otp'),
        isTrue,
      );
      expect(adapter.requests.last.body, {
        'email': 'buyer@soundtix.id',
        'otp': '123456',
      });
    });

    testWidgets('OTP login salah: pesan jelas, sesi tidak terbentuk',
        (tester) async {
      final adapter = FakeHttpAdapter.queue([
        FakeResponse(200, {'message': 'OTP dikirim'}),
        FakeResponse(401, {'detail': 'OTP salah'}),
      ]);
      final store = MemoryTokenStore();

      await pumpAfterglowApp(
        tester,
        adapter: adapter,
        tokenStore: store,
        location: '/login',
      );

      await tester.enterText(find.byType(TextFormField), 'buyer@soundtix.id');
      await tester.tap(find.widgetWithText(FilledButton, 'Masuk'));
      await tester.pumpAndSettle();

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

    testWidgets('tautan pendaftaran membuka form register', (tester) async {
      await pumpAfterglowApp(
        tester,
        adapter: FakeHttpAdapter(200, {}),
        tokenStore: MemoryTokenStore(),
        location: '/login',
      );

      await tester.tap(find.text('Daftar'));
      await tester.pumpAndSettle();

      expect(find.text('Daftar Akun'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Daftar'), findsOneWidget);
    });
  });

  group('Sesi nyata + auto-refresh', () {
    testWidgets(
        'restart dengan access token kedaluwarsa: sesi pulih lewat refresh',
        (tester) async {
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
        FakeResponse(200, {'status': 'ok'}),
      ]);

      // Sesi tersimpan membuka home; access token lama baru terbukti
      // kedaluwarsa saat request pertama setelah restart.
      await pumpAppFromSplash(tester, adapter: adapter, store: store);
      expect(find.text('Katalog'), findsWidgets);

      await tester.tap(find.text('Cek /health/'));
      await tester.pumpAndSettle();

      expect(find.text('Backend terjangkau ✓'), findsOneWidget);
      expect(store.accessToken, 'access-baru');
      expect(store.refreshToken, 'refresh-2');
      expect(
        adapter.requests.where((r) => r.url.endsWith('/auth/refresh')),
        hasLength(1),
      );
    });

    testWidgets(
        'request sesudah login memakai Bearer; 401 → refresh → retry tanpa '
        'interupsi user', (tester) async {
      final adapter = FakeHttpAdapter.queue([
        FakeResponse(200, {'message': 'OTP dikirim'}),
        FakeResponse(200, {
          'access_token': 'access-1',
          'refresh_token': 'refresh-1',
        }),
        FakeResponse(401, {'detail': 'token kedaluwarsa'}),
        FakeResponse(200, {
          'access_token': 'access-2',
          'refresh_token': 'refresh-2',
        }),
        FakeResponse(200, {'status': 'ok'}),
      ]);
      final store = MemoryTokenStore();

      await pumpAfterglowApp(
        tester,
        adapter: adapter,
        tokenStore: store,
        location: '/login',
      );

      await tester.enterText(find.byType(TextFormField), 'buyer@soundtix.id');
      await tester.tap(find.widgetWithText(FilledButton, 'Masuk'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), '123456');
      await tester.pump();
      await tester.tap(find.widgetWithText(FilledButton, 'Verifikasi'));
      await tester.pumpAndSettle();

      // Request berikutnya (lewat UI katalog) memakai access token hasil login
      // dan pulih otomatis saat server membalas 401: refresh → retry.
      await tester.tap(find.text('Cek /health/'));
      await tester.pumpAndSettle();

      expect(find.text('Backend terjangkau ✓'), findsOneWidget);
      expect(adapter.requests.last.headers['Authorization'], 'Bearer access-2');

      // Refresh dipanggil sekali dengan refresh token sesi login.
      final refreshCalls = adapter.requests
          .where((r) => r.url.endsWith('/auth/refresh'))
          .toList();
      expect(refreshCalls, hasLength(1));
      expect(
        (refreshCalls.single.body as Map)['refresh_token'],
        'refresh-1',
      );

      // Token baru menggantikan sesi lama.
      expect(store.accessToken, 'access-2');
      expect(store.refreshToken, 'refresh-2');
    });
  });
}
