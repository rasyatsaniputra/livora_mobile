import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Bahasa aktif aplikasi: Indonesia default, English via toggle manual
/// (keputusan R3 bagian 01 — "ikut locale sistem" ditolak).
///
/// Saat ini disimpan di memori (ikuti sesi); penyimpanan permanen bisa
/// ditambahkan tanpa mengubah pemakai karena UI hanya membaca provider ini.
class LocaleController extends Notifier<Locale> {
  @override
  Locale build() => const Locale('id');

  void setLocale(Locale locale) => state = locale;
}

final localeControllerProvider =
    NotifierProvider<LocaleController, Locale>(LocaleController.new);
