/// Konfigurasi aplikasi di SATU titik.
///
/// Fakta tertunda: URL publik backend bila nanti di-deploy — cukup ubah
/// [baseUrl] di sini, tidak ada perubahan kode lain.
abstract final class AppConfig {
  /// Base URL backend Soundtix.
  ///
  /// Default `http://10.0.2.2:3000`: alias localhost dari Android emulator.
  /// Port mengikuti backend Bun (default 3000); sesuaikan bila berbeda.
  ///
  /// Untuk perangkat fisik, base URL bisa diganti TANPA mengedit kode, lewat
  /// `--dart-define` saat menjalankan aplikasi, contoh:
  ///
  /// ```
  /// flutter run --dart-define=SOUNDTIX_BASE_URL=http://192.168.1.10:3000
  /// ```
  ///
  /// Saat backend nanti di-deploy (Fakta tertunda #3), cukup ubah default di
  /// sini — tidak ada perubahan kode lain.
  static const String baseUrl = String.fromEnvironment(
    'SOUNDTIX_BASE_URL',
    defaultValue: 'http://10.0.2.2:3000',
  );

  /// URL absolut untuk aset yang dikirim backend sebagai path relatif
  /// (poster event: `/uploads/...`). URL absolut dibiarkan apa adanya.
  static String mediaUrl(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }
    final base = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    return path.startsWith('/') ? '$base$path' : '$base/$path';
  }
}
