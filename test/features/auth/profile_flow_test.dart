import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fake_http_adapter.dart';
import '../../support/memory_token_store.dart';
import '../../support/test_app.dart';

/// Alur profil & logout (tiket 05) — diuji dari luar lewat seam HTTP
/// (adapter palsu + override provider) dan router nyata, mengikuti pola
/// tiket 02–04. Profil memakai kontrak `GET/PATCH /users/me` dan logout
/// `POST /auth/logout` (OpenAPI Soundtix).
void main() {
  Map<String, Object?> profileJson({
    String username = 'Budi Santoso',
    String phone = '08123456789',
  }) => {
    'id': 'user-1',
    'email': 'buyer@soundtix.id',
    'username': username,
    'no_hp': phone,
    'role': 'customer',
  };

  MemoryTokenStore signedInStore() =>
      MemoryTokenStore(accessToken: 'access-1', refreshToken: 'refresh-1');

  group('Profil (layar /profile)', () {
    testWidgets('menampilkan nama & email dari GET /users/me', (tester) async {
      final adapter = FakeHttpAdapter(200, profileJson());

      await pumpAfterglowApp(
        tester,
        adapter: adapter,
        tokenStore: signedInStore(),
        location: '/profile',
      );

      expect(find.text('Budi Santoso'), findsOneWidget);
      expect(find.text('buyer@soundtix.id'), findsOneWidget);
      expect(find.text('08123456789'), findsOneWidget);

      final profileCalls = adapter.requests
          .where((r) => r.url.endsWith('/users/me'))
          .toList();
      expect(profileCalls, hasLength(1));
      expect(profileCalls.single.method, 'GET');
      // Request profil otomatis memakai Bearer sesi (tiket 02/04).
      expect(profileCalls.single.headers['Authorization'], 'Bearer access-1');
    });

    testWidgets(
      'edit profil: PATCH tersimpan ke server lalu tampil setelah muat ulang',
      (tester) async {
        final updatedJson = profileJson(
          username: 'Budi Baru',
          phone: '081298765432',
        );
        final adapter = FakeHttpAdapter.queue([
          FakeResponse(200, profileJson()),
          FakeResponse(200, {}),
          FakeResponse(200, updatedJson),
        ]);
        final store = signedInStore();

        await pumpAfterglowApp(
          tester,
          adapter: adapter,
          tokenStore: store,
          location: '/profile',
        );

        await tester.tap(find.text('Edit profil'));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byKey(const Key('profileNameField')),
          'Budi Baru',
        );
        await tester.enterText(
          find.byKey(const Key('profilePhoneField')),
          '081298765432',
        );
        await tester.tap(find.widgetWithText(FilledButton, 'Simpan'));
        await tester.pumpAndSettle();

        final patchCalls = adapter.requests
            .where((r) => r.method == 'PATCH')
            .toList();
        expect(patchCalls, hasLength(1));
        expect(patchCalls.single.url.endsWith('/users/me'), isTrue);
        expect(patchCalls.single.body, {
          'username': 'Budi Baru',
          'no_hp': '081298765432',
        });

        // Setelah simpan, data server (hasil GET ulang) yang ditampilkan.
        expect(find.text('Budi Baru'), findsOneWidget);
        expect(find.text('081298765432'), findsOneWidget);

        // "Muat ulang aplikasi": sesi yang sama, server sudah menyimpan
        // perubahan — profil yang tampil adalah data terbaru.
        await pumpAfterglowApp(
          tester,
          adapter: FakeHttpAdapter(200, updatedJson),
          tokenStore: store,
          location: '/profile',
        );

        expect(find.text('Budi Baru'), findsOneWidget);
        expect(find.text('081298765432'), findsOneWidget);
        expect(find.text('Budi Santoso'), findsNothing);
      },
    );

    testWidgets('simpan gagal: pesan jelas, data lama tetap tampil', (
      tester,
    ) async {
      final adapter = FakeHttpAdapter.queue([
        FakeResponse(200, profileJson()),
        FakeResponse(500, {'detail': 'gagal menyimpan'}),
      ]);

      await pumpAfterglowApp(
        tester,
        adapter: adapter,
        tokenStore: signedInStore(),
        location: '/profile',
      );

      await tester.tap(find.text('Edit profil'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('profileNameField')),
        'Budi Baru',
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Simpan'));
      await tester.pumpAndSettle();

      expect(
        find.text('Server sedang bermasalah. Coba lagi nanti.'),
        findsOneWidget,
      );
      // Tetap di mode edit agar user bisa memperbaiki/mencoba lagi.
      expect(find.widgetWithText(FilledButton, 'Simpan'), findsOneWidget);
    });

    testWidgets('nama terlalu pendek: validasi tampil, tidak ada PATCH', (
      tester,
    ) async {
      final adapter = FakeHttpAdapter(200, profileJson());

      await pumpAfterglowApp(
        tester,
        adapter: adapter,
        tokenStore: signedInStore(),
        location: '/profile',
      );

      await tester.tap(find.text('Edit profil'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('profileNameField')), 'Bu');
      await tester.tap(find.widgetWithText(FilledButton, 'Simpan'));
      await tester.pump();

      expect(find.text('Nama minimal 3 karakter.'), findsOneWidget);
      expect(adapter.requests.where((r) => r.method == 'PATCH'), isEmpty);
    });

    testWidgets('nama melebihi 50 karakter: validasi tampil, tidak ada PATCH', (
      tester,
    ) async {
      final adapter = FakeHttpAdapter(200, profileJson());

      await pumpAfterglowApp(
        tester,
        adapter: adapter,
        tokenStore: signedInStore(),
        location: '/profile',
      );

      await tester.tap(find.text('Edit profil'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('profileNameField')),
        'N' * 51,
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Simpan'));
      await tester.pump();

      expect(find.text('Nama maksimal 50 karakter.'), findsOneWidget);
      expect(adapter.requests.where((r) => r.method == 'PATCH'), isEmpty);
    });

    testWidgets('nomor HP dikosongkan: PATCH mengirim no_hp null', (
      tester,
    ) async {
      final withoutPhone = {...profileJson(), 'no_hp': null};
      final adapter = FakeHttpAdapter.queue([
        FakeResponse(200, profileJson()),
        FakeResponse(200, {}),
        FakeResponse(200, withoutPhone),
      ]);

      await pumpAfterglowApp(
        tester,
        adapter: adapter,
        tokenStore: signedInStore(),
        location: '/profile',
      );

      await tester.tap(find.text('Edit profil'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('profilePhoneField')), '');
      await tester.tap(find.widgetWithText(FilledButton, 'Simpan'));
      await tester.pumpAndSettle();

      final patchCalls = adapter.requests
          .where((r) => r.method == 'PATCH')
          .toList();
      expect(patchCalls, hasLength(1));
      expect(patchCalls.single.body, {
        'username': 'Budi Santoso',
        'no_hp': null,
      });
      expect(find.text('Belum diisi'), findsOneWidget);
    });
  });

  group('Logout', () {
    testWidgets(
      'logout mencabut sesi di server, membersihkan token, kembali ke login',
      (tester) async {
        final adapter = FakeHttpAdapter.queue([
          FakeResponse(200, profileJson()),
          FakeResponse(200, {'message': 'logout'}),
        ]);
        final store = signedInStore();

        await pumpAfterglowApp(
          tester,
          adapter: adapter,
          tokenStore: store,
          location: '/profile',
        );

        await tester.ensureVisible(find.widgetWithText(FilledButton, 'Keluar'));
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(FilledButton, 'Keluar'));
        await tester.pumpAndSettle();

        final logoutCalls = adapter.requests
            .where((r) => r.url.endsWith('/auth/logout'))
            .toList();
        expect(logoutCalls, hasLength(1));
        expect(logoutCalls.single.method, 'POST');
        expect(logoutCalls.single.body, {'refresh_token': 'refresh-1'});

        expect(store.accessToken, isNull);
        expect(store.refreshToken, isNull);
        expect(find.widgetWithText(FilledButton, 'Masuk'), findsOneWidget);
        expect(find.text('Katalog'), findsNothing);
      },
    );

    testWidgets('logout saat server mati: sesi lokal tetap dibersihkan', (
      tester,
    ) async {
      final adapter = FakeHttpAdapter.queue([
        FakeResponse(200, profileJson()),
        FakeResponse(-1, {}),
      ]);
      final store = signedInStore();

      await pumpAfterglowApp(
        tester,
        adapter: adapter,
        tokenStore: store,
        location: '/profile',
      );

      await tester.ensureVisible(find.widgetWithText(FilledButton, 'Keluar'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Keluar'));
      await tester.pumpAndSettle();

      expect(store.accessToken, isNull);
      expect(store.refreshToken, isNull);
      expect(find.widgetWithText(FilledButton, 'Masuk'), findsOneWidget);
    });
  });
}
