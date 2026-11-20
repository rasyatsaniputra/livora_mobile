import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

/// Profil customer yang sedang login (kontrak `GET/PATCH /users/me`).
///
/// OpenAPI hanya menyebut identitas (ID, email, username, role) dan
/// `no_hp` untuk kontak e-tiket; field yang tidak dipakai UI dibuat
/// nullable agar respons backend yang lebih ramping tetap terbaca.
@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    @JsonKey(fromJson: _idFromJson) String? id,
    required String email,

    /// Nama tampilan akun — kontrak API Soundtix menyebutnya `username`.
    required String username,
    @JsonKey(name: 'no_hp') String? noHp,
    String? role,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, Object?> json) =>
      _$UserProfileFromJson(json);
}

/// ID bisa dikirim sebagai string UUID maupun angka; UI hanya butuh
/// representasi teks, jadi keduanya dinormalkan.
String? _idFromJson(Object? value) => value?.toString();
