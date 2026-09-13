import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_sv.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('sv'),
  ];

  /// The title of the application.
  ///
  /// In en, this message translates to:
  /// **'School Schedule'**
  String get appTitle;

  /// Week number label in the schedule app bar.
  ///
  /// In en, this message translates to:
  /// **'Week {week}'**
  String scheduleWeekLabel(int week);

  /// Date range for a displayed week that stays within one month.
  ///
  /// In en, this message translates to:
  /// **'{start}–{end} {month}'**
  String scheduleWeekRange(String start, String end, String month);

  /// Date range for a displayed week that spans two months.
  ///
  /// In en, this message translates to:
  /// **'{startDay} {startMonth}–{endDay} {endMonth}'**
  String scheduleWeekRangeCrossMonth(
    String startDay,
    String startMonth,
    String endDay,
    String endMonth,
  );

  /// Eyebrow above the next-event hero title, naming the event's kind.
  ///
  /// In en, this message translates to:
  /// **'NEXT · {kind}'**
  String scheduleNextEventEyebrow(String kind);

  /// Eyebrow above the next-event hero title when the event has no kind word.
  ///
  /// In en, this message translates to:
  /// **'NEXT'**
  String get scheduleNextEventEyebrowPlain;

  /// Countdown pill text in the next-event hero, shown when the event is more than one day away.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{1 day left} other{{days} days left}}'**
  String scheduleDaysUntil(int days);

  /// Relative day word used in the hero when the next event is today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get scheduleRelativeToday;

  /// Relative day word used in the hero when the next event is tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get scheduleRelativeTomorrow;

  /// Sync-status text showing the time of the last successful sync.
  ///
  /// In en, this message translates to:
  /// **'Updated {time}'**
  String scheduleLastSynced(String time);

  /// Sync-status text shown while the schedule is loading.
  ///
  /// In en, this message translates to:
  /// **'Updating…'**
  String get scheduleSyncing;

  /// Sync-status text shown when the schedule failed to load.
  ///
  /// In en, this message translates to:
  /// **'Update failed'**
  String get scheduleSyncFailed;

  /// Eyebrow label on a week-spanning special-event banner.
  ///
  /// In en, this message translates to:
  /// **'ALL WEEK'**
  String get scheduleSpecialWeekLabel;

  /// Eyebrow label on a single-day special-event banner.
  ///
  /// In en, this message translates to:
  /// **'ALL DAY'**
  String get scheduleSpecialDayLabel;

  /// Severity word shown on a graded-test event.
  ///
  /// In en, this message translates to:
  /// **'TEST'**
  String get scheduleSeverityProv;

  /// Severity word shown on a homework event.
  ///
  /// In en, this message translates to:
  /// **'HOMEWORK'**
  String get scheduleSeverityLaxa;

  /// Severity word shown on a hand-in / submission event.
  ///
  /// In en, this message translates to:
  /// **'HAND-IN'**
  String get scheduleSeverityInlamning;

  /// Next-event hero empty state, shown when there is no upcoming event this week.
  ///
  /// In en, this message translates to:
  /// **'Nothing coming up this week'**
  String get scheduleNoUpcoming;

  /// Next-event hero title while the schedule is loading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get scheduleLoading;

  /// Next-event hero title when the schedule failed to load.
  ///
  /// In en, this message translates to:
  /// **'Schedule unavailable'**
  String get scheduleUnavailable;

  /// Tooltip for the previous-week navigation arrow.
  ///
  /// In en, this message translates to:
  /// **'Previous week'**
  String get scheduleNavPreviousWeekTooltip;

  /// Tooltip for the next-week navigation arrow.
  ///
  /// In en, this message translates to:
  /// **'Next week'**
  String get scheduleNavNextWeekTooltip;

  /// Tooltip for the settings icon button.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get scheduleSettingsTooltip;

  /// Tooltip for the placeholder alternate-view icon button.
  ///
  /// In en, this message translates to:
  /// **'Alternate view'**
  String get scheduleAlternateViewTooltip;

  /// Title shown on the setup page.
  ///
  /// In en, this message translates to:
  /// **'Setup'**
  String get setupTitle;

  /// Placeholder body text shown on the setup page.
  ///
  /// In en, this message translates to:
  /// **'Setup — coming soon'**
  String get setupPlaceholder;

  /// Title shown on the settings page.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Placeholder body text shown on the settings page.
  ///
  /// In en, this message translates to:
  /// **'Settings — coming soon'**
  String get settingsPlaceholder;

  /// Tooltip for the theme switcher button in the app bar.
  ///
  /// In en, this message translates to:
  /// **'Switch theme'**
  String get themeSwitcherTooltip;

  /// Placeholder text shown on the splash/loading screen.
  ///
  /// In en, this message translates to:
  /// **'Splash screen'**
  String get splashLabel;
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
      <String>['en', 'sv'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'sv':
      return AppLocalizationsSv();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
