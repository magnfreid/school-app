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
  String scheduleWeekLabel(int week) {
    return 'Vecka $week';
  }

  @override
  String scheduleWeekRange(String start, String end, String month) {
    return '$start–$end $month';
  }

  @override
  String scheduleWeekRangeCrossMonth(
    String startDay,
    String startMonth,
    String endDay,
    String endMonth,
  ) {
    return '$startDay $startMonth–$endDay $endMonth';
  }

  @override
  String scheduleNextEventEyebrow(String kind) {
    return 'NÄSTA · $kind';
  }

  @override
  String get scheduleNextEventEyebrowPlain => 'NÄSTA';

  @override
  String scheduleDaysUntil(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dagar kvar',
      one: '1 dag kvar',
    );
    return '$_temp0';
  }

  @override
  String get scheduleRelativeToday => 'Idag';

  @override
  String get scheduleRelativeTomorrow => 'Imorgon';

  @override
  String scheduleLastSynced(String time) {
    return 'Uppdaterad $time';
  }

  @override
  String get scheduleSyncing => 'Uppdaterar…';

  @override
  String get scheduleSyncFailed => 'Uppdateringen misslyckades';

  @override
  String get scheduleSpecialWeekLabel => 'HELA VECKAN';

  @override
  String get scheduleSpecialDayLabel => 'HELDAG';

  @override
  String get scheduleSeverityProv => 'PROV';

  @override
  String get scheduleSeverityLaxa => 'LÄXA';

  @override
  String get scheduleSeverityInlamning => 'INLÄMNING';

  @override
  String get scheduleNoUpcoming => 'Inget på gång den här veckan';

  @override
  String get scheduleLoading => 'Laddar…';

  @override
  String get scheduleUnavailable => 'Schemat kan inte visas';

  @override
  String get scheduleNavPreviousWeekTooltip => 'Föregående vecka';

  @override
  String get scheduleNavNextWeekTooltip => 'Nästa vecka';

  @override
  String get scheduleSettingsTooltip => 'Inställningar';

  @override
  String get scheduleAlternateViewTooltip => 'Alternativ vy';

  @override
  String get setupTitle => 'Kalenderinställning';

  @override
  String get setupIntro =>
      'Klistra in kalender-ID och tjänstekontots nyckel. Båda sparas endast på den här enheten.';

  @override
  String get setupCalendarIdLabel => 'Kalender-ID';

  @override
  String get setupCalendarIdHint => 'name@group.calendar.google.com';

  @override
  String get setupServiceAccountKeyLabel => 'Tjänstekontots nyckel (JSON)';

  @override
  String get setupServiceAccountKeyHint =>
      'Klistra in hela innehållet i JSON-nyckelfilen';

  @override
  String get setupErrorCalendarIdEmpty => 'Ange ett kalender-ID';

  @override
  String get setupErrorKeyEmpty => 'Klistra in tjänstekontots nyckel';

  @override
  String get setupErrorKeyMalformed =>
      'Det här är inte giltig JSON. Klistra in hela nyckelfilen, inklusive klamrarna.';

  @override
  String get setupSaveButton => 'Spara';

  @override
  String get setupSaveFailed => 'Kunde inte spara. Försök igen.';

  @override
  String get setupSaveSucceeded => 'Kalendern är sparad';

  @override
  String get settingsTitle => 'Inställningar';

  @override
  String get settingsPlaceholder => 'Inställningar — kommer snart';

  @override
  String get themeSwitcherTooltip => 'Byt tema';

  @override
  String get splashLabel => 'Startskärm';
}
