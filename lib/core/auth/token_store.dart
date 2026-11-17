/// Penyimpanan access & refresh token (tiket 02: secure storage).
///
/// Sebagai interface supaya test dapat menukarnya dengan penyimpanan
/// di memori (pola "override provider + adapter palsu"); di aplikasi
/// nyata dipakai [SecureTokenStore] berbasis flutter_secure_storage —
/// token disimpan terenkripsi, bukan di shared_preferences.
abstract interface class TokenStore {
  /// Access token yang sedang aktif, atau null bila belum login.
  Future<String?> readAccessToken();

  /// Refresh token yang sedang aktif, atau null bila belum login.
  Future<String?> readRefreshToken();

  /// Menyimpan pasangan token (hasil login atau hasil refresh).
  Future<void> save({
    required String accessToken,
    required String refreshToken,
  });

  /// Menghapus semua token (logout atau refresh gagal).
  Future<void> clear();
}
