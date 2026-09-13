// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'School Schedule';

  @override
  String get scheduleTitle => 'Schedule';

  @override
  String get schedulePlaceholder => 'Schedule — coming soon';

  @override
  String get setupTitle => 'Setup';

  @override
  String get setupPlaceholder => 'Setup — coming soon';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsPlaceholder => 'Settings — coming soon';

  @override
  String get themeSwitcherTooltip => 'Switch theme';

  @override
  String get splashLabel => 'Splash screen';
}
