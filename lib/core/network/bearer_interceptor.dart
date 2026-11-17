import 'dart:async';

import 'package:dio/dio.dart';

import '../auth/token_store.dart';

/// Interceptor Bearer + auto-refresh (tiket 02).
///
/// - [onRequest]: memasang header `Authorization: Bearer <access token>`
///   dari [TokenStore] pada setiap request yang tidak menandai dirinya
///   bebas-auth (`skip_auth`), mis. request refresh itu sendiri.
/// - [onError]: saat request kena 401, token di-refresh lewat
///   `POST /auth/refresh` lalu request asli di-retry sekali. Refresh
///   berjalan tunggal (single-flight): 401 yang datang bersamaan menunggu
///   refresh yang sama. Bila refresh gagal, token dibuang dan 401 asli
///   diteruskan ke lapisan atas.
///
/// Interceptor ini memakai [Dio] yang sama dengan request asli, sehingga
/// panggilan refresh juga lewat seam HTTP dan bisa diemulasi adapter palsu.
class BearerInterceptor extends Interceptor {
  BearerInterceptor(this._dio, this._tokenStore, {this.refreshPath = '/auth/refresh'});

  final Dio _dio;
  final TokenStore _tokenStore;
  final String refreshPath;

  Completer<({String accessToken, String refreshToken})>? _refreshInFlight;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra[_kSkipAuth] != true) {
      final token = await _tokenStore.readAccessToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    if (options.extra[_kSkipAuth] == true || options.extra[_kRetried] == true) {
      return handler.next(err);
    }
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    final oldAccess = _bearerTokenOf(options);
    final currentAccess = await _tokenStore.readAccessToken();

    // Token sudah diganti oleh refresh lain (mis. 401 konkuren yang
    // keburu selesai) — langsung retry dengan token yang sekarang.
    if (currentAccess != null && currentAccess != oldAccess) {
      return _retry(options, handler);
    }

    final refreshToken = await _tokenStore.readRefreshToken();
    if (refreshToken == null) {
      return handler.next(err);
    }

    try {
      final tokens = await _refreshSingleFlight(refreshToken);
      await _tokenStore.save(
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
      );
    } on DioException {
      await _tokenStore.clear();
      return handler.next(err);
    }
    return _retry(options, handler);
  }

  /// Retry request yang gagal 401 sekali; penanda [_kRetried] mencegah
  /// loop tak berujung bila retry pun kembali 401.
  Future<void> _retry(
    RequestOptions options,
    ErrorInterceptorHandler handler,
  ) async {
    final retried = options
      ..extra[_kRetried] = true
      ..headers.remove('Authorization');
    try {
      final response = await _dio.fetch<dynamic>(retried);
      return handler.resolve(response);
    } on DioException catch (e) {
      return handler.next(e);
    }
  }

  /// Refresh tunggal: bila sudah ada refresh berjalan, ikut menunggu
  /// hasilnya; bila tidak, mulai refresh baru dan bagikan hasilnya.
  Future<({String accessToken, String refreshToken})> _refreshSingleFlight(
    String refreshToken,
  ) {
    final inFlight = _refreshInFlight;
    if (inFlight != null) return inFlight.future;

    final completer = Completer<({String accessToken, String refreshToken})>();
    _refreshInFlight = completer;
    // Selesaikan completer lalu kosongkan referensinya segera supaya
    // refresh berikutnya (mis. sesi benar-benar kedaluwarsa lagi) memulai
    // refresh baru, bukan menunggu completer usang yang sudah selesai.
    _performRefresh(refreshToken).then(
      (tokens) {
        if (identical(_refreshInFlight, completer)) _refreshInFlight = null;
        completer.complete(tokens);
      },
      onError: (Object error, StackTrace stackTrace) {
        if (identical(_refreshInFlight, completer)) _refreshInFlight = null;
        completer.completeError(error, stackTrace);
      },
    );
    return completer.future;
  }

  Future<({String accessToken, String refreshToken})> _performRefresh(
    String refreshToken,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      refreshPath,
      data: {'refresh_token': refreshToken},
      options: Options(extra: {_kSkipAuth: true}),
    );
    final body = response.data;
    final access = body?['access_token'] as String?;
    final refresh = body?['refresh_token'] as String? ?? refreshToken;
    if (access == null) {
      throw DioException(
        requestOptions: RequestOptions(path: refreshPath),
        message: 'respons refresh tidak berisi access_token',
      );
    }
    return (accessToken: access, refreshToken: refresh);
  }

  /// Token yang tercantum di header request yang gagal — dipakai untuk
  /// membedakan "401 dengan token usang" dari "401 dengan token terbaru".
  String? _bearerTokenOf(RequestOptions options) {
    final header = options.headers['Authorization'];
    if (header is String && header.startsWith('Bearer ')) {
      return header.substring('Bearer '.length);
    }
    return null;
  }
}

const _kSkipAuth = 'skip_auth';
const _kRetried = 'auth_retried';
