// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Afterglow';

  @override
  String get navCatalog => 'Catalog';

  @override
  String get navTickets => 'Tickets';

  @override
  String get navHistory => 'History';

  @override
  String get placeholderComingSoon =>
      'This module will arrive after the foundation and previous modules are done.';

  @override
  String get healthCheckTitle => 'Backend connection check';

  @override
  String get healthCheckDescription =>
      'Tests connectivity to the Soundtix API from the emulator.';

  @override
  String get healthCheckRun => 'Check /health/';

  @override
  String get healthCheckRunning => 'Checking…';

  @override
  String get healthCheckSuccess => 'Backend is reachable ✓';

  @override
  String get errorNetwork =>
      'Server unreachable. Make sure the backend is running.';

  @override
  String get errorTimeout => 'Connection timed out. Please try again.';

  @override
  String get errorServer => 'The server is having problems. Try again later.';

  @override
  String get errorRequest => 'Something went wrong. Please try again.';

  @override
  String get changeLanguage => 'Change language';

  @override
  String get languageIndonesian => 'Bahasa Indonesia';

  @override
  String get languageEnglish => 'English';

  @override
  String get registerEntryTooltip => 'Create a new account';

  @override
  String get registerTitle => 'Create Account';

  @override
  String get registerSubtitle =>
      'Create your Afterglow account — a verification code will be sent to your email.';

  @override
  String get registerNameLabel => 'Full name';

  @override
  String get registerEmailLabel => 'Email';

  @override
  String get registerNameInvalid => 'Name must be at least 3 characters.';

  @override
  String get registerEmailInvalid => 'Invalid email format.';

  @override
  String get registerSubmit => 'Sign up';

  @override
  String get registerSubmitting => 'Signing up…';

  @override
  String get errorEmailRegistered =>
      'This email is already registered. Use a different email.';

  @override
  String get otpTitle => 'OTP Verification';

  @override
  String otpSentTo(String email) {
    return 'Enter the 6-digit OTP code sent to $email.';
  }

  @override
  String get otpFieldLabel => 'OTP code';

  @override
  String get otpVerify => 'Verify';

  @override
  String get otpVerifying => 'Verifying…';

  @override
  String get otpResend => 'Resend OTP';

  @override
  String get otpResending => 'Resending…';

  @override
  String otpResent(String email) {
    return 'A new OTP code was sent to $email.';
  }

  @override
  String get otpWrongCode => 'The OTP code is wrong or expired. Try again.';

  @override
  String get otpTooManyAttempts =>
      'Too many code attempts. Request a new code and try again.';

  @override
  String get otpMissingDraft =>
      'Verification session not found. Start again from the sign-up page.';
}
