import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/token_store.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/providers.dart';
import 'auth_tokens.dart';

/// Data pendaftaran passwordless: email + nama lengkap. Dikemas sebagai satu
/// tipe karena selalu berjalan bersama (form → minta OTP → verifikasi OTP).
typedef RegisterDraft = ({String email, String username});

/// Kontrak data modul auth (tiket 03): pendaftaran passwordless via OTP,
/// sesuai kontrak Soundtix (`POST /auth/request-otp` & `POST /auth/verify-otp`
/// — API tidak memiliki field password, lihat docs/soundtix-api-*.json).
///
/// Semua request lewat [ApiClient] (satu-satunya seam HTTP) sehingga test
/// cukup menukar adapternya dengan respons contoh. Error dilempar sebagai
/// `ApiException` dari ApiClient — tidak ada tipe dio yang bocor ke UI.
class AuthRepository {
  AuthRepository({required this.client, required this.tokenStore});

  final ApiClient client;
  final TokenStore tokenStore;

  /// Meminta OTP pendaftaran: akun baru dibuat di backend dan kode OTP
  /// dikirim ke email. Body respons tidak dipakai — 200 berarti terkirim.
  ///
  /// Dipakai dua kali dalam alur: saat submit form register dan saat
  /// "kirim ulang OTP" di layar verifikasi.
  Future<void> requestRegistrationOtp(RegisterDraft draft) async {
    await client.post<dynamic>(
      '/auth/request-otp',
      body: {'email': draft.email, 'username': draft.username},
    );
  }

  /// Verifikasi OTP pendaftaran. Respons memuat [AuthTokens] (access &
  /// refresh — lihat panduan autentikasi di OpenAPI) yang langsung disimpan
  /// ke [TokenStore] — user berada dalam kondisi terdaftar & terverifikasi.
  Future<void> verifyRegistration(
    RegisterDraft draft, {
    required String otp,
  }) async {
    final Object? data = await client.post<Object?>(
      '/auth/verify-otp',
      body: {'email': draft.email, 'otp': otp, 'username': draft.username},
    );
    if (data is! Map<String, Object?>) {
      // Respons 200 tanpa objek JSON berarti backend menyimpang dari
      // kontrak — dilaporkan sebagai kesalahan server, bukan crash parse.
      throw ApiException(ApiExceptionKind.server);
    }
    final AuthTokens tokens;
    try {
      tokens = AuthTokens.fromJson(data);
    } on TypeError {
      // Objek JSON tanpa access_token/refresh_token: bentuk respons
      // menyimpang dari kontrak (OpenAPI tidak merinci skemanya).
      throw ApiException(ApiExceptionKind.server);
    }
    await tokenStore.save(
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
    );
  }
}

/// Satu repository auth untuk seluruh aplikasi. Test modul auth tidak
/// meng-override provider ini — cukup override [apiClientProvider] (adapter
/// palsu) dan [tokenStoreProvider] (memori), sesuai pola tiket 02.
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(
    client: ref.watch(apiClientProvider),
    tokenStore: ref.watch(tokenStoreProvider),
  ),
);
