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
  String get navProfile => 'Profil';

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

  @override
  String get languageIndonesian => 'Bahasa Indonesia';

  @override
  String get languageEnglish => 'English';

  @override
  String get loginTitle => 'Masuk';

  @override
  String get loginSubtitle =>
      'Masuk dengan email — kode verifikasi akan dikirim ke email kamu.';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginEmailInvalid => 'Format email tidak valid.';

  @override
  String get loginSubmit => 'Masuk';

  @override
  String get loginSubmitting => 'Mengirim kode…';

  @override
  String get loginRegisterPrompt => 'Belum punya akun?';

  @override
  String get loginRegisterAction => 'Daftar';

  @override
  String get registerTitle => 'Daftar Akun';

  @override
  String get registerSubtitle =>
      'Buat akun Afterglow — kode verifikasi akan dikirim ke email kamu.';

  @override
  String get registerNameLabel => 'Nama lengkap';

  @override
  String get registerEmailLabel => 'Email';

  @override
  String get registerNameInvalid => 'Nama minimal 3 karakter.';

  @override
  String get registerEmailInvalid => 'Format email tidak valid.';

  @override
  String get registerSubmit => 'Daftar';

  @override
  String get registerSubmitting => 'Mendaftarkan…';

  @override
  String get errorEmailRegistered =>
      'Email sudah terdaftar. Gunakan email lain.';

  @override
  String get otpTitle => 'Verifikasi OTP';

  @override
  String otpSentTo(String email) {
    return 'Masukkan 6 kode OTP yang dikirim ke $email.';
  }

  @override
  String get otpFieldLabel => 'Kode OTP';

  @override
  String get otpVerify => 'Verifikasi';

  @override
  String get otpVerifying => 'Memverifikasi…';

  @override
  String get otpResend => 'Kirim ulang OTP';

  @override
  String get otpResending => 'Mengirim ulang…';

  @override
  String otpResent(String email) {
    return 'Kode OTP dikirim ulang ke $email.';
  }

  @override
  String get otpWrongCode => 'Kode OTP salah atau kedaluwarsa. Coba lagi.';

  @override
  String get otpTooManyAttempts =>
      'Terlalu banyak percobaan kode. Minta kode baru lalu coba lagi.';

  @override
  String get otpMissingDraft =>
      'Sesi verifikasi tidak ditemukan. Ulangi dari halaman masuk atau daftar.';

  @override
  String get profileNameLabel => 'Nama lengkap';

  @override
  String get profileEmailLabel => 'Email';

  @override
  String get profilePhoneLabel => 'Nomor HP';

  @override
  String get profilePhoneEmpty => 'Belum diisi';

  @override
  String get profileNameInvalid => 'Nama minimal 3 karakter.';

  @override
  String get profileNameTooLong => 'Nama maksimal 50 karakter.';

  @override
  String get profilePhoneInvalid => 'Nomor HP 9–16 digit, boleh diawali +.';

  @override
  String get profileEdit => 'Edit profil';

  @override
  String get profileSave => 'Simpan';

  @override
  String get profileSaving => 'Menyimpan…';

  @override
  String get profileCancel => 'Batal';

  @override
  String get profileSaved => 'Profil tersimpan.';

  @override
  String get profileRetry => 'Coba lagi';

  @override
  String get profileLogout => 'Keluar';

  @override
  String get profileLoggingOut => 'Keluar…';
}
