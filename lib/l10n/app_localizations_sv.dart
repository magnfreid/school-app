// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get appTitle => 'Skolschema';

  @override
  String get scheduleTitle => 'Schema';

  @override
  String get schedulePlaceholder => 'Schema — kommer snart';

  @override
  String get setupTitle => 'Konfiguration';

  @override
  String get setupPlaceholder => 'Konfiguration — kommer snart';

  @override
  String get settingsTitle => 'Inställningar';

  @override
  String get settingsPlaceholder => 'Inställningar — kommer snart';

  @override
  String get themeSwitcherTooltip => 'Byt tema';

  @override
  String get splashLabel => 'Startskärm';
}
