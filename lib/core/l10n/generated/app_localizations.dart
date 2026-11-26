import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In id, this message translates to:
  /// **'Afterglow'**
  String get appTitle;

  /// No description provided for @navCatalog.
  ///
  /// In id, this message translates to:
  /// **'Katalog'**
  String get navCatalog;

  /// No description provided for @navTickets.
  ///
  /// In id, this message translates to:
  /// **'Tiket'**
  String get navTickets;

  /// No description provided for @navHistory.
  ///
  /// In id, this message translates to:
  /// **'Riwayat'**
  String get navHistory;

  /// No description provided for @navProfile.
  ///
  /// In id, this message translates to:
  /// **'Profil'**
  String get navProfile;

  /// No description provided for @placeholderComingSoon.
  ///
  /// In id, this message translates to:
  /// **'Modul ini akan hadir setelah fondasi dan modul sebelumnya selesai.'**
  String get placeholderComingSoon;

  /// No description provided for @healthCheckTitle.
  ///
  /// In id, this message translates to:
  /// **'Cek koneksi backend'**
  String get healthCheckTitle;

  /// No description provided for @healthCheckDescription.
  ///
  /// In id, this message translates to:
  /// **'Menguji konektivitas ke Soundtix API dari emulator.'**
  String get healthCheckDescription;

  /// No description provided for @healthCheckRun.
  ///
  /// In id, this message translates to:
  /// **'Cek /health/'**
  String get healthCheckRun;

  /// No description provided for @healthCheckRunning.
  ///
  /// In id, this message translates to:
  /// **'Memeriksa…'**
  String get healthCheckRunning;

  /// No description provided for @healthCheckSuccess.
  ///
  /// In id, this message translates to:
  /// **'Backend terjangkau ✓'**
  String get healthCheckSuccess;

  /// No description provided for @errorNetwork.
  ///
  /// In id, this message translates to:
  /// **'Server tidak terjangkau. Pastikan backend berjalan.'**
  String get errorNetwork;

  /// No description provided for @errorTimeout.
  ///
  /// In id, this message translates to:
  /// **'Koneksi habis waktu. Silakan coba lagi.'**
  String get errorTimeout;

  /// No description provided for @errorServer.
  ///
  /// In id, this message translates to:
  /// **'Server sedang bermasalah. Coba lagi nanti.'**
  String get errorServer;

  /// No description provided for @errorRequest.
  ///
  /// In id, this message translates to:
  /// **'Terjadi kesalahan. Silakan coba lagi.'**
  String get errorRequest;

  /// No description provided for @changeLanguage.
  ///
  /// In id, this message translates to:
  /// **'Ganti bahasa'**
  String get changeLanguage;

  /// No description provided for @languageIndonesian.
  ///
  /// In id, this message translates to:
  /// **'Bahasa Indonesia'**
  String get languageIndonesian;

  /// No description provided for @languageEnglish.
  ///
  /// In id, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @loginTitle.
  ///
  /// In id, this message translates to:
  /// **'Masuk'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Masuk dengan email — kode verifikasi akan dikirim ke email kamu.'**
  String get loginSubtitle;

  /// No description provided for @loginEmailLabel.
  ///
  /// In id, this message translates to:
  /// **'Email'**
  String get loginEmailLabel;

  /// No description provided for @loginEmailInvalid.
  ///
  /// In id, this message translates to:
  /// **'Format email tidak valid.'**
  String get loginEmailInvalid;

  /// No description provided for @loginSubmit.
  ///
  /// In id, this message translates to:
  /// **'Masuk'**
  String get loginSubmit;

  /// No description provided for @loginSubmitting.
  ///
  /// In id, this message translates to:
  /// **'Mengirim kode…'**
  String get loginSubmitting;

  /// No description provided for @loginRegisterPrompt.
  ///
  /// In id, this message translates to:
  /// **'Belum punya akun?'**
  String get loginRegisterPrompt;

  /// No description provided for @loginRegisterAction.
  ///
  /// In id, this message translates to:
  /// **'Daftar'**
  String get loginRegisterAction;

  /// No description provided for @registerTitle.
  ///
  /// In id, this message translates to:
  /// **'Daftar Akun'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Buat akun Afterglow — kode verifikasi akan dikirim ke email kamu.'**
  String get registerSubtitle;

  /// No description provided for @registerNameLabel.
  ///
  /// In id, this message translates to:
  /// **'Nama lengkap'**
  String get registerNameLabel;

  /// No description provided for @registerEmailLabel.
  ///
  /// In id, this message translates to:
  /// **'Email'**
  String get registerEmailLabel;

  /// No description provided for @registerNameInvalid.
  ///
  /// In id, this message translates to:
  /// **'Nama minimal 3 karakter.'**
  String get registerNameInvalid;

  /// No description provided for @registerEmailInvalid.
  ///
  /// In id, this message translates to:
  /// **'Format email tidak valid.'**
  String get registerEmailInvalid;

  /// No description provided for @registerSubmit.
  ///
  /// In id, this message translates to:
  /// **'Daftar'**
  String get registerSubmit;

  /// No description provided for @registerSubmitting.
  ///
  /// In id, this message translates to:
  /// **'Mendaftarkan…'**
  String get registerSubmitting;

  /// No description provided for @errorEmailRegistered.
  ///
  /// In id, this message translates to:
  /// **'Email sudah terdaftar. Gunakan email lain.'**
  String get errorEmailRegistered;

  /// No description provided for @otpTitle.
  ///
  /// In id, this message translates to:
  /// **'Verifikasi OTP'**
  String get otpTitle;

  /// No description provided for @otpSentTo.
  ///
  /// In id, this message translates to:
  /// **'Masukkan 6 kode OTP yang dikirim ke {email}.'**
  String otpSentTo(String email);

  /// No description provided for @otpFieldLabel.
  ///
  /// In id, this message translates to:
  /// **'Kode OTP'**
  String get otpFieldLabel;

  /// No description provided for @otpVerify.
  ///
  /// In id, this message translates to:
  /// **'Verifikasi'**
  String get otpVerify;

  /// No description provided for @otpVerifying.
  ///
  /// In id, this message translates to:
  /// **'Memverifikasi…'**
  String get otpVerifying;

  /// No description provided for @otpResend.
  ///
  /// In id, this message translates to:
  /// **'Kirim ulang OTP'**
  String get otpResend;

  /// No description provided for @otpResending.
  ///
  /// In id, this message translates to:
  /// **'Mengirim ulang…'**
  String get otpResending;

  /// No description provided for @otpResent.
  ///
  /// In id, this message translates to:
  /// **'Kode OTP dikirim ulang ke {email}.'**
  String otpResent(String email);

  /// No description provided for @otpWrongCode.
  ///
  /// In id, this message translates to:
  /// **'Kode OTP salah atau kedaluwarsa. Coba lagi.'**
  String get otpWrongCode;

  /// No description provided for @otpTooManyAttempts.
  ///
  /// In id, this message translates to:
  /// **'Terlalu banyak percobaan kode. Minta kode baru lalu coba lagi.'**
  String get otpTooManyAttempts;

  /// No description provided for @otpMissingDraft.
  ///
  /// In id, this message translates to:
  /// **'Sesi verifikasi tidak ditemukan. Ulangi dari halaman masuk atau daftar.'**
  String get otpMissingDraft;

  /// No description provided for @profileNameLabel.
  ///
  /// In id, this message translates to:
  /// **'Nama lengkap'**
  String get profileNameLabel;

  /// No description provided for @profileEmailLabel.
  ///
  /// In id, this message translates to:
  /// **'Email'**
  String get profileEmailLabel;

  /// No description provided for @profilePhoneLabel.
  ///
  /// In id, this message translates to:
  /// **'Nomor HP'**
  String get profilePhoneLabel;

  /// No description provided for @profilePhoneEmpty.
  ///
  /// In id, this message translates to:
  /// **'Belum diisi'**
  String get profilePhoneEmpty;

  /// No description provided for @profileNameInvalid.
  ///
  /// In id, this message translates to:
  /// **'Nama minimal 3 karakter.'**
  String get profileNameInvalid;

  /// No description provided for @profileNameTooLong.
  ///
  /// In id, this message translates to:
  /// **'Nama maksimal 50 karakter.'**
  String get profileNameTooLong;

  /// No description provided for @profilePhoneInvalid.
  ///
  /// In id, this message translates to:
  /// **'Nomor HP 9–16 digit, boleh diawali +.'**
  String get profilePhoneInvalid;

  /// No description provided for @profileEdit.
  ///
  /// In id, this message translates to:
  /// **'Edit profil'**
  String get profileEdit;

  /// No description provided for @profileSave.
  ///
  /// In id, this message translates to:
  /// **'Simpan'**
  String get profileSave;

  /// No description provided for @profileSaving.
  ///
  /// In id, this message translates to:
  /// **'Menyimpan…'**
  String get profileSaving;

  /// No description provided for @profileCancel.
  ///
  /// In id, this message translates to:
  /// **'Batal'**
  String get profileCancel;

  /// No description provided for @profileSaved.
  ///
  /// In id, this message translates to:
  /// **'Profil tersimpan.'**
  String get profileSaved;

  /// No description provided for @profileRetry.
  ///
  /// In id, this message translates to:
  /// **'Coba lagi'**
  String get profileRetry;

  /// No description provided for @profileLogout.
  ///
  /// In id, this message translates to:
  /// **'Keluar'**
  String get profileLogout;

  /// No description provided for @profileLoggingOut.
  ///
  /// In id, this message translates to:
  /// **'Keluar…'**
  String get profileLoggingOut;

  /// No description provided for @catalogSearchHint.
  ///
  /// In id, this message translates to:
  /// **'Cari konser, artis, atau kota'**
  String get catalogSearchHint;

  /// No description provided for @catalogClearSearch.
  ///
  /// In id, this message translates to:
  /// **'Hapus pencarian'**
  String get catalogClearSearch;

  /// No description provided for @catalogFilter.
  ///
  /// In id, this message translates to:
  /// **'Filter'**
  String get catalogFilter;

  /// No description provided for @catalogFilterTitle.
  ///
  /// In id, this message translates to:
  /// **'Filter katalog'**
  String get catalogFilterTitle;

  /// No description provided for @catalogFilterCity.
  ///
  /// In id, this message translates to:
  /// **'Kota'**
  String get catalogFilterCity;

  /// No description provided for @catalogFilterCityHint.
  ///
  /// In id, this message translates to:
  /// **'Mis. Jakarta'**
  String get catalogFilterCityHint;

  /// No description provided for @catalogFilterGenre.
  ///
  /// In id, this message translates to:
  /// **'Genre'**
  String get catalogFilterGenre;

  /// No description provided for @catalogFilterGenreHint.
  ///
  /// In id, this message translates to:
  /// **'Mis. Electronic'**
  String get catalogFilterGenreHint;

  /// No description provided for @catalogSort.
  ///
  /// In id, this message translates to:
  /// **'Urutkan'**
  String get catalogSort;

  /// No description provided for @catalogSortNearest.
  ///
  /// In id, this message translates to:
  /// **'Terdekat'**
  String get catalogSortNearest;

  /// No description provided for @catalogSortNewest.
  ///
  /// In id, this message translates to:
  /// **'Terbaru'**
  String get catalogSortNewest;

  /// No description provided for @catalogSortCheapest.
  ///
  /// In id, this message translates to:
  /// **'Termurah'**
  String get catalogSortCheapest;

  /// No description provided for @catalogApplyFilters.
  ///
  /// In id, this message translates to:
  /// **'Terapkan'**
  String get catalogApplyFilters;

  /// No description provided for @catalogResetFilters.
  ///
  /// In id, this message translates to:
  /// **'Reset'**
  String get catalogResetFilters;

  /// No description provided for @catalogEmptyTitle.
  ///
  /// In id, this message translates to:
  /// **'Belum ada konser'**
  String get catalogEmptyTitle;

  /// No description provided for @catalogEmptyBody.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada event yang cocok dengan pencarian atau filter kamu.'**
  String get catalogEmptyBody;

  /// No description provided for @catalogEmptyAction.
  ///
  /// In id, this message translates to:
  /// **'Hapus pencarian & filter'**
  String get catalogEmptyAction;

  /// No description provided for @catalogRetry.
  ///
  /// In id, this message translates to:
  /// **'Coba lagi'**
  String get catalogRetry;

  /// No description provided for @catalogStatsTitle.
  ///
  /// In id, this message translates to:
  /// **'Statistik platform'**
  String get catalogStatsTitle;

  /// No description provided for @catalogStatEvents.
  ///
  /// In id, this message translates to:
  /// **'Event aktif'**
  String get catalogStatEvents;

  /// No description provided for @catalogStatTickets.
  ///
  /// In id, this message translates to:
  /// **'Tiket terjual'**
  String get catalogStatTickets;

  /// No description provided for @catalogStatOrganizers.
  ///
  /// In id, this message translates to:
  /// **'Promotor terverifikasi'**
  String get catalogStatOrganizers;

  /// No description provided for @catalogStatCities.
  ///
  /// In id, this message translates to:
  /// **'Kota'**
  String get catalogStatCities;

  /// No description provided for @catalogDateTba.
  ///
  /// In id, this message translates to:
  /// **'Jadwal menyusul'**
  String get catalogDateTba;

  /// No description provided for @catalogVenueUnknown.
  ///
  /// In id, this message translates to:
  /// **'Venue menyusul'**
  String get catalogVenueUnknown;

  /// No description provided for @catalogPriceFrom.
  ///
  /// In id, this message translates to:
  /// **'Mulai {price}'**
  String catalogPriceFrom(String price);

  /// No description provided for @catalogPriceUnavailable.
  ///
  /// In id, this message translates to:
  /// **'Harga belum tersedia'**
  String get catalogPriceUnavailable;

  /// No description provided for @catalogSoldOut.
  ///
  /// In id, this message translates to:
  /// **'Tiket habis'**
  String get catalogSoldOut;

  /// No description provided for @eventDetailTitle.
  ///
  /// In id, this message translates to:
  /// **'Detail event'**
  String get eventDetailTitle;

  /// No description provided for @eventDetailRetry.
  ///
  /// In id, this message translates to:
  /// **'Coba lagi'**
  String get eventDetailRetry;

  /// No description provided for @eventDetailAbout.
  ///
  /// In id, this message translates to:
  /// **'Tentang event'**
  String get eventDetailAbout;

  /// No description provided for @eventDetailAboutEmpty.
  ///
  /// In id, this message translates to:
  /// **'Deskripsi belum tersedia.'**
  String get eventDetailAboutEmpty;

  /// No description provided for @eventDetailDate.
  ///
  /// In id, this message translates to:
  /// **'Tanggal'**
  String get eventDetailDate;

  /// No description provided for @eventDetailDateRange.
  ///
  /// In id, this message translates to:
  /// **'{start} – {end}'**
  String eventDetailDateRange(String start, String end);

  /// No description provided for @eventDetailVenue.
  ///
  /// In id, this message translates to:
  /// **'Venue'**
  String get eventDetailVenue;

  /// No description provided for @eventDetailVenueCity.
  ///
  /// In id, this message translates to:
  /// **'{venue}, {city}'**
  String eventDetailVenueCity(String venue, String city);

  /// No description provided for @eventDetailArtist.
  ///
  /// In id, this message translates to:
  /// **'Artis'**
  String get eventDetailArtist;

  /// No description provided for @eventDetailCategories.
  ///
  /// In id, this message translates to:
  /// **'Kategori tiket'**
  String get eventDetailCategories;

  /// No description provided for @eventDetailCategoriesEmpty.
  ///
  /// In id, this message translates to:
  /// **'Kategori tiket belum tersedia.'**
  String get eventDetailCategoriesEmpty;

  /// No description provided for @eventDetailRemaining.
  ///
  /// In id, this message translates to:
  /// **'{count} tiket tersisa'**
  String eventDetailRemaining(int count);

  /// No description provided for @eventDetailCategorySoldOut.
  ///
  /// In id, this message translates to:
  /// **'Habis'**
  String get eventDetailCategorySoldOut;

  /// No description provided for @eventDetailOrganizer.
  ///
  /// In id, this message translates to:
  /// **'Penyelenggara'**
  String get eventDetailOrganizer;

  /// No description provided for @eventDetailOrganizerVerified.
  ///
  /// In id, this message translates to:
  /// **'Promotor terverifikasi'**
  String get eventDetailOrganizerVerified;

  /// No description provided for @eventDetailOrganizerUnknown.
  ///
  /// In id, this message translates to:
  /// **'Penyelenggara belum diketahui'**
  String get eventDetailOrganizerUnknown;

  /// No description provided for @eventDetailContinue.
  ///
  /// In id, this message translates to:
  /// **'Lanjut ke pemesanan'**
  String get eventDetailContinue;

  /// No description provided for @checkoutTitle.
  ///
  /// In id, this message translates to:
  /// **'Pemesanan'**
  String get checkoutTitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
