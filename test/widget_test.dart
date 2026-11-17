import 'package:dio/dio.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:livora_mobile/core/l10n/generated/app_localizations.dart';
import 'package:livora_mobile/core/network/api_client.dart';
import 'package:livora_mobile/core/network/providers.dart';
import 'package:livora_mobile/features/catalog/presentation/health_check_card.dart';

import 'support/fake_http_adapter.dart';

Future<void> _pumpCard(WidgetTester tester, HttpClientAdapter adapter) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        apiClientProvider.overrideWithValue(ApiClient(adapter: adapter)),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('id'),
        home: const Scaffold(body: Center(child: HealthCheckCard())),
      ),
    ),
  );
}

void main() {
  testWidgets(
      'smoke test fondasi: backend 200 → kartu menunjukkan berhasil',
      (tester) async {
    await _pumpCard(tester, FakeHttpAdapter(200, {'status': 'ok'}));

    expect(find.text('Cek /health/'), findsOneWidget);
    await tester.tap(find.text('Cek /health/'));
    await tester.pumpAndSettle();

    expect(find.text('Backend terjangkau ✓'), findsOneWidget);
  });

  testWidgets(
      'smoke test fondasi: server mati → pesan error jelas (story 40)',
      (tester) async {
    await _pumpCard(tester, FakeHttpAdapter(-1, <String, Object?>{}));

    await tester.tap(find.text('Cek /health/'));
    await tester.pumpAndSettle();

    expect(find.text('Server tidak terjangkau. Pastikan backend berjalan.'),
        findsOneWidget);
  });

  testWidgets(
      'smoke test fondasi: saat memeriksa, tombol mati + indikator muncul (story 41)',
      (tester) async {
    final adapter = FakeHttpAdapter(200, {'status': 'ok'})..gate = Completer<void>();
    await _pumpCard(tester, adapter);

    await tester.tap(find.text('Cek /health/'));
    await tester.pump();

    expect(find.text('Memeriksa…'), findsWidgets);

    // Selesaikan permintaan agar tidak ada timer dio yang menggantung.
    adapter.gate!.complete();
    await tester.pumpAndSettle();
    expect(find.text('Backend terjangkau ✓'), findsOneWidget);
  });
}
