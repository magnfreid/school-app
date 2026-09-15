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
  String get setupTitle => 'Calendar setup';

  @override
  String get setupIntro =>
      'Paste the calendar ID and the service-account key. Both are stored on this device only.';

  @override
  String get setupCalendarIdLabel => 'Calendar ID';

  @override
  String get setupCalendarIdHint => 'name@group.calendar.google.com';

  @override
  String get setupServiceAccountKeyLabel => 'Service account key (JSON)';

  @override
  String get setupServiceAccountKeyHint =>
      'Paste the whole contents of the JSON key file';

  @override
  String get setupErrorCalendarIdEmpty => 'Enter a calendar ID';

  @override
  String get setupErrorKeyEmpty => 'Paste the service account key';

  @override
  String get setupErrorKeyMalformed =>
      'This is not valid JSON. Paste the whole key file, braces included.';

  @override
  String get setupSaveButton => 'Save';

  @override
  String get setupSaveFailed => 'Could not save. Try again.';

  @override
  String get setupSaveSucceeded => 'Calendar saved';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsUnsubscribeDescription =>
      'Unsubscribing removes the calendar ID and the service-account key from this device. Nothing changes in Google Calendar.';

  @override
  String get settingsUnsubscribeButton => 'Unsubscribe';

  @override
  String get settingsUnsubscribeDialogTitle =>
      'Unsubscribe from this calendar?';

  @override
  String get settingsUnsubscribeDialogBody =>
      'The calendar ID and the service-account key will be deleted from this device. You will need to enter them again to see the schedule.';

  @override
  String get settingsUnsubscribeDialogCancel => 'Cancel';

  @override
  String get settingsUnsubscribeDialogConfirm => 'Unsubscribe';

  @override
  String get settingsUnsubscribeFailed => 'Could not unsubscribe. Try again.';

  @override
  String get themeSwitcherTooltip => 'Switch theme';

  @override
  String get splashLabel => 'Splash screen';
}
