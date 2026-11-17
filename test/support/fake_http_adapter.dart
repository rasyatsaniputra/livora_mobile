import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// Adapter palsu di seam HTTP (HttpClientAdapter dio) — dipakai bersama oleh
/// semua test agar alur berjalan tanpa backend hidup (pola pertama yang akan
/// diikuti modul-modul berikutnya; lihat spec, bagian Testing Decisions).
class FakeHttpAdapter implements HttpClientAdapter {
  FakeHttpAdapter(this.statusCode, this.body);

  final int statusCode;
  final Object body;

  /// URL permintaan terakhir yang masuk ke adapter (baseUrl + path) —
  /// dipakai untuk menguji perilaku request dari luar.
  String? lastRequestUrl;

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
    return ResponseBody.fromString(
      jsonEncode(body),
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }
}
