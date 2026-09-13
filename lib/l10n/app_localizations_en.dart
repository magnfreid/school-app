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
  String scheduleWeekLabel(int week) {
    return 'Week $week';
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
    return 'NEXT · $kind';
  }

  @override
  String get scheduleNextEventEyebrowPlain => 'NEXT';

  @override
  String scheduleDaysUntil(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days left',
      one: '1 day left',
    );
    return '$_temp0';
  }

  @override
  String get scheduleRelativeToday => 'Today';

  @override
  String get scheduleRelativeTomorrow => 'Tomorrow';

  @override
  String scheduleLastSynced(String time) {
    return 'Updated $time';
  }

  @override
  String get scheduleSyncing => 'Updating…';

  @override
  String get scheduleSyncFailed => 'Update failed';

  @override
  String get scheduleSpecialWeekLabel => 'ALL WEEK';

  @override
  String get scheduleSpecialDayLabel => 'ALL DAY';

  @override
  String get scheduleSeverityProv => 'TEST';

  @override
  String get scheduleSeverityLaxa => 'HOMEWORK';

  @override
  String get scheduleSeverityInlamning => 'HAND-IN';

  @override
  String get scheduleNoUpcoming => 'Nothing coming up this week';

  @override
  String get scheduleLoading => 'Loading…';

  @override
  String get scheduleUnavailable => 'Schedule unavailable';

  @override
  String get scheduleNavPreviousWeekTooltip => 'Previous week';

  @override
  String get scheduleNavNextWeekTooltip => 'Next week';

  @override
  String get scheduleSettingsTooltip => 'Settings';

  @override
  String get scheduleAlternateViewTooltip => 'Alternate view';

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
