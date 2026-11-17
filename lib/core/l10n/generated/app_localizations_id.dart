// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Afterglow';

  @override
  String get navCatalog => 'Katalog';

  @override
  String get navTickets => 'Tiket';

  @override
  String get navHistory => 'Riwayat';

  @override
  String get placeholderComingSoon =>
      'Modul ini akan hadir setelah fondasi dan modul sebelumnya selesai.';

  @override
  String get healthCheckTitle => 'Cek koneksi backend';

  @override
  String get healthCheckDescription =>
      'Menguji konektivitas ke Soundtix API dari emulator.';

  @override
  String get healthCheckRun => 'Cek /health/';

  @override
  String get healthCheckRunning => 'Memeriksa…';

  @override
  String get healthCheckSuccess => 'Backend terjangkau ✓';

  @override
  String get errorNetwork =>
      'Server tidak terjangkau. Pastikan backend berjalan.';

  @override
  String get errorTimeout => 'Koneksi habis waktu. Silakan coba lagi.';

  @override
  String get errorServer => 'Server sedang bermasalah. Coba lagi nanti.';

  @override
  String get errorRequest => 'Terjadi kesalahan. Silakan coba lagi.';

  @override
  String get changeLanguage => 'Ganti bahasa';
}
