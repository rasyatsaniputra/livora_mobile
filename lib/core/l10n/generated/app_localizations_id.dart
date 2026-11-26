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

  @override
  String get catalogSearchHint => 'Cari konser, artis, atau kota';

  @override
  String get catalogClearSearch => 'Hapus pencarian';

  @override
  String get catalogFilter => 'Filter';

  @override
  String get catalogFilterTitle => 'Filter katalog';

  @override
  String get catalogFilterCity => 'Kota';

  @override
  String get catalogFilterCityHint => 'Mis. Jakarta';

  @override
  String get catalogFilterGenre => 'Genre';

  @override
  String get catalogFilterGenreHint => 'Mis. Electronic';

  @override
  String get catalogSort => 'Urutkan';

  @override
  String get catalogSortNearest => 'Terdekat';

  @override
  String get catalogSortNewest => 'Terbaru';

  @override
  String get catalogSortCheapest => 'Termurah';

  @override
  String get catalogApplyFilters => 'Terapkan';

  @override
  String get catalogResetFilters => 'Reset';

  @override
  String get catalogEmptyTitle => 'Belum ada konser';

  @override
  String get catalogEmptyBody =>
      'Tidak ada event yang cocok dengan pencarian atau filter kamu.';

  @override
  String get catalogEmptyAction => 'Hapus pencarian & filter';

  @override
  String get catalogRetry => 'Coba lagi';

  @override
  String get catalogStatsTitle => 'Statistik platform';

  @override
  String get catalogStatEvents => 'Event aktif';

  @override
  String get catalogStatTickets => 'Tiket terjual';

  @override
  String get catalogStatOrganizers => 'Promotor terverifikasi';

  @override
  String get catalogStatCities => 'Kota';

  @override
  String get catalogDateTba => 'Jadwal menyusul';

  @override
  String get catalogVenueUnknown => 'Venue menyusul';

  @override
  String catalogPriceFrom(String price) {
    return 'Mulai $price';
  }

  @override
  String get catalogPriceUnavailable => 'Harga belum tersedia';

  @override
  String get catalogSoldOut => 'Tiket habis';

  @override
  String get eventDetailTitle => 'Detail event';

  @override
  String get eventDetailRetry => 'Coba lagi';

  @override
  String get eventDetailAbout => 'Tentang event';

  @override
  String get eventDetailAboutEmpty => 'Deskripsi belum tersedia.';

  @override
  String get eventDetailDate => 'Tanggal';

  @override
  String eventDetailDateRange(String start, String end) {
    return '$start – $end';
  }

  @override
  String get eventDetailVenue => 'Venue';

  @override
  String eventDetailVenueCity(String venue, String city) {
    return '$venue, $city';
  }

  @override
  String get eventDetailArtist => 'Artis';

  @override
  String get eventDetailCategories => 'Kategori tiket';

  @override
  String get eventDetailCategoriesEmpty => 'Kategori tiket belum tersedia.';

  @override
  String eventDetailRemaining(int count) {
    return '$count tiket tersisa';
  }

  @override
  String get eventDetailCategorySoldOut => 'Habis';

  @override
  String get eventDetailOrganizer => 'Penyelenggara';

  @override
  String get eventDetailOrganizerVerified => 'Promotor terverifikasi';

  @override
  String get eventDetailOrganizerUnknown => 'Penyelenggara belum diketahui';

  @override
  String get eventDetailContinue => 'Lanjut ke pemesanan';

  @override
  String get checkoutTitle => 'Pemesanan';
}
