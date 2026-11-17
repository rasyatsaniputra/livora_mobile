import 'package:dio/dio.dart';

import '../auth/token_store.dart';
import '../config/app_config.dart';
import 'api_exception.dart';
import 'bearer_interceptor.dart';

/// Pembungkus dio — ini satu-satunya seam untuk test (lihat spec, bagian
/// Testing Decisions): `HttpClientAdapter` dio bisa ditukar dengan adapter
/// palsu sehingga repository/provider/widget ikut ter-exercise tanpa backend.
///
/// Tugas ApiClient:
/// 1. pegang satu instance dio dengan base URL dari [AppConfig];
/// 2. memetakan `DioException` menjadi `ApiException` (story 40);
/// 3. menyediakan method get/post/patch/delete yang nyaman dipakai modul.
///
/// Bila [tokenStore] diisi, interseptor Bearer + auto-refresh (tiket 02)
/// dipasang pada dio yang sama — sehingga seluruh trafik, termasuk
/// panggilan refresh, tetap lewat satu boundary ini.
class ApiClient {
  ApiClient({HttpClientAdapter? adapter, TokenStore? tokenStore})
    : dio = Dio(
        BaseOptions(
          baseUrl: AppConfig.baseUrl,
          // Timeout diberi nilai agar pesan error "koneksi habis waktu"
          // benar-benar bisa terjadi (story 40), bukan menggantung selamanya.
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ),
      ) {
    if (adapter != null) {
      dio.httpClientAdapter = adapter;
    }
    if (tokenStore != null) {
      dio.interceptors.add(BearerInterceptor(dio, tokenStore));
    }
  }

  /// Instance dio yang dipakai. Sengaja publik: modul-modul memanggil lewat
  /// sini, dan test menukar adapter pada instance yang sama.
  final Dio dio;

  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  }) =>
      _send(() => dio.get<T>(path, queryParameters: query, options: _opts(headers)));

  Future<T> post<T>(
    String path, {
    Object? body,
    Map<String, dynamic>? headers,
  }) =>
      _send(() => dio.post<T>(path, data: body, options: _opts(headers)));

  Future<T> patch<T>(
    String path, {
    Object? body,
    Map<String, dynamic>? headers,
  }) =>
      _send(() => dio.patch<T>(path, data: body, options: _opts(headers)));

  Future<T> delete<T>(
    String path, {
    Object? body,
    Map<String, dynamic>? headers,
  }) =>
      _send(() => dio.delete<T>(path, data: body, options: _opts(headers)));

  Options _opts(Map<String, dynamic>? headers) =>
      headers == null ? Options() : Options(headers: headers);

  /// Menjalankan permintaan dan menerjemahkan `DioException` menjadi
  /// `ApiException` agar lapisan di atasnya tidak melihat tipe dio.
  Future<T> _send<T>(Future<Response<T>> Function() request) async {
    try {
      final response = await request();
      return response.data as T;
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  ApiException _fromDio(DioException e) {
    final status = e.response?.statusCode;
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      return ApiException(ApiExceptionKind.network, cause: e);
    }
    if (e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return ApiException(ApiExceptionKind.timeout, cause: e);
    }
    if (status != null && status >= 500) {
      return ApiException(ApiExceptionKind.server, statusCode: status, cause: e);
    }
    return ApiException(ApiExceptionKind.request, statusCode: status, cause: e);
  }
}
