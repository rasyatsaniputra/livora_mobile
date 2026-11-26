import 'api_exception.dart';

/// Isi `data` dari envelope Soundtix `{success, message, data}`.
///
/// Bentuk respons yang menyimpang dilaporkan sebagai kesalahan server agar
/// layar menampilkan pesan, bukan crash saat parsing.
Object? envelopeData(Object? response) {
  if (response is! Map<String, Object?>) {
    throw ApiException(ApiExceptionKind.server);
  }
  return response['data'];
}

/// Sama seperti [envelopeData], tetapi `data` wajib berupa objek JSON.
Map<String, Object?> envelopeDataMap(Object? response) {
  final data = envelopeData(response);
  if (data is! Map<String, Object?>) {
    throw ApiException(ApiExceptionKind.server);
  }
  return data;
}
