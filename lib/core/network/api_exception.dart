/// Error dari lapisan HTTP, dipetakan dari DioException agar lapisan UI
/// tidak pernah melihat tipe dio secara langsung.
///
/// UI menerjemahkan [kind] ke pesan via key l10n (dilarang literal string).
enum ApiExceptionKind {
  /// Tidak bisa terhubung (server mati / URL salah) — story 40.
  network,

  /// Koneksi habis waktu — story 40.
  timeout,

  /// Kesalahan di sisi server (status >= 500).
  server,

  /// Permintaan ditolak atau tidak valid (4xx).
  request,
}

final class ApiException implements Exception {
  ApiException(this.kind, {this.statusCode, this.cause});

  final ApiExceptionKind kind;

  /// Status code HTTP bila ada (null untuk network/timeout).
  final int? statusCode;

  /// Error asli untuk keperluan debug, bukan untuk ditampilkan ke user.
  final Object? cause;

  @override
  String toString() =>
      'ApiException(kind: $kind, statusCode: $statusCode, cause: $cause)';
}
