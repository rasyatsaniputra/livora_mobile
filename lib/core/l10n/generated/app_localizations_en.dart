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
}
