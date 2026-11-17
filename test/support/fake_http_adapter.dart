import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// Satu respons terjadwal pada [FakeHttpAdapter.queue].
class FakeResponse {
  FakeResponse(this.statusCode, this.body);

  final int statusCode;
  final Object body;
}

/// Satu permintaan yang benar-benar masuk ke adapter — dipakai untuk
/// menguji perilaku request dari luar (URL, header, body).
class RecordedRequest {
  RecordedRequest(
    this.method,
    this.url,
    this.headers,
    Object? rawBody,
  ) : body = rawBody is String ? jsonDecode(rawBody) : rawBody;

  final String method;
  final String url;
  final Map<String, dynamic> headers;

  /// Body request yang sudah ter-parse dari JSON (bila ada).
  final Object? body;
}

/// Adapter palsu di seam HTTP (HttpClientAdapter dio) — dipakai bersama oleh
/// semua test agar alur berjalan tanpa backend hidup (pola pertama yang akan
/// diikuti modul-modul berikutnya; lihat spec, bagian Testing Decisions).
class FakeHttpAdapter implements HttpClientAdapter {
  FakeHttpAdapter(this.statusCode, this.body, {this.gate})
    : _queue = null;

  /// Adapter dengan antrean respons: setiap request mengambil satu
  /// respons berurutan; setelah habis, respons terakhir dipakai ulang.
  /// Dipakai untuk mengemulasi alur 401 → refresh → retry (tiket 02).
  FakeHttpAdapter.queue(List<FakeResponse> responses, {this.gate})
    : _queue = List.of(responses),
      statusCode = responses.first.statusCode,
      body = responses.first.body;

  final int statusCode;
  final Object body;
  final List<FakeResponse>? _queue;
  var _queueIndex = 0;

  /// URL permintaan terakhir yang masuk ke adapter (baseUrl + path) —
  /// dipakai untuk menguji perilaku request dari luar.
  String? lastRequestUrl;

  /// Header `Authorization` dari permintaan terakhir — dipakai untuk
  /// menguji perilaku interseptor Bearer dari luar (tiket 02).
  String? get lastRequestAuthorization {
    final header = lastRequestHeaders?['Authorization'];
    return header == null ? null : (header as String);
  }

  Map<String, dynamic>? lastRequestHeaders;

  /// Semua permintaan yang masuk, berurutan — dipakai mis. untuk
  /// membuktikan refresh dipanggil tepat sekali (single-flight).
  final List<RecordedRequest> requests = [];

  /// Bila diisi, respons baru dikirim setelah completer dilengkapi —
  /// dipakai untuk mengamati kondisi loading.
  Completer<void>? gate;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequestUrl = options.uri.toString();
    lastRequestHeaders = options.headers;
    requests.add(
      RecordedRequest(options.method, options.uri.toString(), options.headers, options.data),
    );

    if (statusCode < 0) {
      // Status negatif dipakai untuk meniru server mati (koneksi ditolak).
      throw DioException.connectionError(
        requestOptions: options,
        reason: 'connection refused (emulasi server mati)',
      );
    }
    if (gate != null) {
      await gate!.future;
    }

    FakeResponse current;
    final queue = _queue;
    if (queue == null) {
      current = FakeResponse(statusCode, body);
    } else {
      if (_queueIndex >= queue.length) _queueIndex = queue.length - 1;
      current = queue[_queueIndex++];
    }
    return ResponseBody.fromString(
      jsonEncode(current.body),
      current.statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }
}
