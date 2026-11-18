import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_tokens.freezed.dart';
part 'auth_tokens.g.dart';

/// Pasangan token sesi hasil verifikasi OTP (dokumentasi OpenAPI:
/// access_token JWT berlaku 15 menit, refresh_token 7 hari).
///
/// Model codegen (freezed + json_serializable) mengikuti keputusan spec:
/// parsing JSON memakai codegen, model dibuat per modul saat dikerjakan.
@freezed
abstract class AuthTokens with _$AuthTokens {
  const factory AuthTokens({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') required String refreshToken,
  }) = _AuthTokens;

  factory AuthTokens.fromJson(Map<String, Object?> json) =>
      _$AuthTokensFromJson(json);
}
