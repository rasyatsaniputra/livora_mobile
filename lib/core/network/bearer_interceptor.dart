import 'dart:async';

import 'package:dio/dio.dart';

import '../auth/token_store.dart';

/// Interceptor Bearer + auto-refresh (tiket 02).
///
/// - [onRequest]: memasang header `Authorization: Bearer <access token>`
///   dari [TokenStore] pada setiap request yang tidak menandai dirinya
///   bebas-auth (`skip_auth`), mis. request refresh itu sendiri.
/// - [onError]: saat request BER-Bearer kena 401, access token dianggap
///   kedaluwarsa: token di-refresh lewat `POST /auth/refresh` lalu request
///   asli di-retry sekali. 401 pada request tanpa Bearer (mis. login salah
///   kredensial) diteruskan apa adanya — bukan alasan untuk refresh.
///   Refresh berjalan tunggal (single-flight): 401 yang datang bersamaan
///   menunggu refresh yang sama. Bila refresh gagal — karena alasan apa
///   pun — token dibuang dan 401 asli diteruskan ke lapisan atas.
///
/// Interceptor ini memakai [Dio] yang sama dengan request asli, sehingga
/// panggilan refresh juga lewat seam HTTP dan bisa diemulasi adapter palsu.
class BearerInterceptor extends Interceptor {
  BearerInterceptor(this._dio, this._tokenStore);

  static const _refreshPath = '/auth/refresh';

  final Dio _dio;
  final TokenStore _tokenStore;

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

    // Hanya request yang memang membawa Bearer yang dianggap mengalami
    // access token kedaluwarsa; sisanya (mis. login ditolak) diteruskan.
    final oldAccess = _bearerTokenOf(options);
    if (oldAccess == null) {
      return handler.next(err);
    }

    // Token sudah diganti oleh refresh lain (mis. 401 konkuren yang
    // keburu selesai) — langsung retry dengan token yang sekarang.
    final currentAccess = await _tokenStore.readAccessToken();
    if (currentAccess != null && currentAccess != oldAccess) {
      return _retry(options, handler);
    }

    final refreshToken = await _tokenStore.readRefreshToken();
    if (refreshToken == null) {
      return handler.next(err);
    }

    try {
      await _refreshSingleFlight(refreshToken);
    } on Object {
      // Gagal refresh karena alasan apa pun berarti sesi tidak bisa
      // diselamatkan: buang token dan teruskan 401 asli ke lapisan atas.
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
  /// Penyimpanan token baru juga bagian dari siklus ini supaya tidak ada
  /// celah "completer selesai tapi token belum tersimpan" yang bisa
  /// memicu refresh kedua oleh 401 yang datang di tengahnya.
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
    _refreshAndSave(refreshToken).then(
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

  Future<({String accessToken, String refreshToken})> _refreshAndSave(
    String refreshToken,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      _refreshPath,
      data: {'refresh_token': refreshToken},
      options: Options(extra: {_kSkipAuth: true}),
    );
    final body = response.data;
    final access = body?['access_token'] as String?;
    final refresh = body?['refresh_token'] as String? ?? refreshToken;
    if (access == null) {
      throw DioException(
        requestOptions: RequestOptions(path: _refreshPath),
        message: 'respons refresh tidak berisi access_token',
      );
    }
    await _tokenStore.save(accessToken: access, refreshToken: refresh);
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
