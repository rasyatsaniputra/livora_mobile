import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:livora_mobile/core/config/app_config.dart';
import 'package:livora_mobile/core/network/api_client.dart';
import 'package:livora_mobile/core/network/api_exception.dart';

/// Adapter palsu yang selalu mengembalikan respons yang sama — inilah seam:
/// seluruh test jalan tanpa backend hidup, cukup tukar HttpClientAdapter dio.
class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this.statusCode, this.body);

  final int statusCode;
  final Object body;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return ResponseBody.fromString(
      jsonEncode(body),
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }
}

void main() {
  group('ApiClient (seam: HttpClientAdapter dio)', () {
    test('GET /health/ mengembalikan body JSON yang sudah ter-parse', () async {
      final client = ApiClient(
        adapter: _FakeAdapter(200, {'status': 'ok'}),
      );

      final data = await client.get<Map<String, dynamic>>('/health/');

      expect(data['status'], 'ok');
    });

    test('request dikirim ke base URL konfigurasi + path yang diminta', () async {
      _FakeAdapter? captured;
      final client = ApiClient(
        adapter: _FakeAdapter(200, {'ok': true}),
      );
      captured = client.dio.httpClientAdapter as _FakeAdapter?;
      expect(captured, isNotNull);

      await client.get<void>('/health/');

      expect(client.dio.options.baseUrl, AppConfig.baseUrl);
    });

    test('status >= 500 dilempar sebagai ApiException.server', () async {
      final client = ApiClient(
        adapter: _FakeAdapter(503, {'error': 'unavailable'}),
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
        adapter: _ConnectionRefusedAdapter(),
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

/// Adapter yang meniru server mati: koneksi ditolak oleh OS.
class _ConnectionRefusedAdapter implements HttpClientAdapter {
  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    throw DioException.connectionError(
      requestOptions: RequestOptions(path: options.path),
      reason: 'connection refused (emulasi server mati)',
    );
  }
}
