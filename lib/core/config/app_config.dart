/// Konfigurasi aplikasi di SATU titik.
///
/// Fakta tertunda: URL publik backend bila nanti di-deploy — cukup ubah
/// [baseUrl] di sini, tidak ada perubahan kode lain.
abstract final class AppConfig {
  /// Base URL backend Soundtix.
  ///
  /// `10.0.2.2` adalah alias localhost dari Android emulator.
  /// Port mengikuti backend Bun (default 3000); sesuaikan bila berbeda.
  static const String baseUrl = 'http://10.0.2.2:3000';
}
