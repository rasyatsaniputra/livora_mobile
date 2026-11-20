import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/providers.dart';
import 'user_profile.dart';

/// Kontrak data profil customer (tiket 05): baca & ubah identitas lewat
/// `GET/PATCH /users/me` (OpenAPI Soundtix — PATCH hanya menerima
/// `username` dan `no_hp`; email tidak dapat diubah).
///
/// Semua request lewat [ApiClient] sehingga test cukup menukar adapter HTTP.
class ProfileRepository {
  ProfileRepository({required this.client});

  final ApiClient client;

  /// Profil pengguna yang sedang login.
  Future<UserProfile> fetchProfile() async =>
      _parse(await client.get<Object?>('/users/me'));

  /// Menyimpan perubahan profil, lalu membaca ulang dari server supaya yang
  /// ditampilkan adalah data kanonis (respons PATCH tidak dirinci OpenAPI).
  Future<UserProfile> updateProfile({
    required String username,
    String? noHp,
  }) async {
    await client.patch<dynamic>(
      '/users/me',
      body: {
        'username': username,
        // Selalu kirim no_hp (null bila dikosongkan) supaya user benar-benar
        // dapat menghapus nomor HP-nya — bukan hanya mengubahnya.
        'no_hp': noHp,
      },
    );
    return fetchProfile();
  }

  /// Respons profil wajib berupa objek JSON; bentuk lain dilaporkan sebagai
  /// kesalahan server, bukan crash parse.
  UserProfile _parse(Object? data) {
    if (data is! Map<String, Object?>) {
      throw ApiException(ApiExceptionKind.server);
    }
    try {
      return UserProfile.fromJson(data);
    } on TypeError {
      throw ApiException(ApiExceptionKind.server);
    }
  }
}

/// Satu repository profil untuk seluruh aplikasi; test meng-override
/// [apiClientProvider] (adapter palsu) seperti modul sebelumnya.
final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepository(client: ref.watch(apiClientProvider)),
);
