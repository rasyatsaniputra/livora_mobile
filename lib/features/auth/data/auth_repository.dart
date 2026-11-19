import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/token_store.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/providers.dart';
import 'auth_tokens.dart';

/// Sesi OTP yang sedang berjalan. Dua alur memakai endpoint yang sama:
/// registrasi mengirim nama lengkap, login pengguna lama cukup email
/// (API Soundtix passwordless — lihat `docs/soundtix-api-*.json`).
sealed class OtpChallenge {
  const OtpChallenge({required this.email});

  /// Email penerima kode sekaligus identitas sesi yang diverifikasi.
  final String email;
}

/// Pendaftaran akun baru: email + nama lengkap.
final class RegistrationOtpChallenge extends OtpChallenge {
  const RegistrationOtpChallenge({
    required super.email,
    required this.username,
  });

  final String username;
}

/// Login pengguna yang sudah terdaftar: cukup email.
final class LoginOtpChallenge extends OtpChallenge {
  const LoginOtpChallenge({required super.email});
}

/// Kontrak data modul auth (tiket 03–04): permintaan & verifikasi OTP untuk
/// registrasi maupun login, sesuai kontrak Soundtix
/// (`POST /auth/request-otp` & `POST /auth/verify-otp` — API tidak memiliki
/// field password, lihat docs/soundtix-api-*.json).
///
/// Semua request lewat [ApiClient] (satu-satunya seam HTTP) sehingga test
/// cukup menukar adapternya dengan respons contoh. Error dilempar sebagai
/// `ApiException` dari ApiClient — tidak ada tipe dio yang bocor ke UI.
class AuthRepository {
  AuthRepository({required this.client, required this.tokenStore});

  final ApiClient client;
  final TokenStore tokenStore;

  /// Meminta OTP untuk [challenge]: registrasi mengirim email + nama,
  /// login hanya email. 200 berarti kode terkirim.
  ///
  /// Dipakai tiga kali dalam alur: submit form register, submit form login,
  /// dan "kirim ulang OTP" di layar verifikasi.
  Future<void> requestOtp(OtpChallenge challenge) async {
    await client.post<dynamic>(
      '/auth/request-otp',
      body: _requestBody(challenge),
    );
  }

  /// Verifikasi OTP. Respons memuat [AuthTokens] (access & refresh — lihat
  /// panduan autentikasi di OpenAPI) yang langsung disimpan ke [TokenStore],
  /// sehingga user berada dalam kondisi login dengan sesi aktif.
  Future<void> verifyOtp(
    OtpChallenge challenge, {
    required String otp,
  }) async {
    final Object? data = await client.post<Object?>(
      '/auth/verify-otp',
      body: {..._requestBody(challenge), 'otp': otp},
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

  /// Body permintaan OTP per alur — nama hanya untuk pendaftaran.
  Map<String, Object?> _requestBody(OtpChallenge challenge) =>
      switch (challenge) {
        RegistrationOtpChallenge(:final email, :final username) => {
          'email': email,
          'username': username,
        },
        LoginOtpChallenge(:final email) => {'email': email},
      };
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
