import 'package:flutter/material.dart';

/// Palet placeholder — SATU titik penggantian color scheme final dari user.
///
/// Fakta tertunda #1 (docs/grilling/bagian-01-fondasi.md): color scheme final
/// belum ditentukan. Bila sudah ada, cukup ganti nilai di sini — semua layar
/// wajib mengambil warna dari `Theme.of(context)`, dilarang hardcode.
abstract final class AppPalette {
  /// Warna benih placeholder (ungu); akan ditukar dengan palet final.
  static const Color seed = Color(0xFF7C4DFF);
}

abstract final class AppTheme {
  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppPalette.seed,
      brightness: brightness,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
      ),
    );
  }
}
