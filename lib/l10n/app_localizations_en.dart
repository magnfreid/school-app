// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Flutter Starter';

  @override
  String get welcomeHeadline => 'Welcome';

  @override
  String get loginTitle => 'Sign in';

  @override
  String get loginButton => 'Sign in';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get themeSwitcherTooltip => 'Switch theme';

  @override
  String get signOutTooltip => 'Sign out';

  @override
  String get splashLabel => 'Splash screen';

  @override
  String get loginFailed =>
      'Could not sign in. Check your details and try again.';

  @override
  String get loginUnexpectedError => 'Something went wrong. Please try again.';
}
