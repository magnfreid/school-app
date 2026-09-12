// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get appTitle => 'Flutter Starter';

  @override
  String get welcomeHeadline => 'Välkommen';

  @override
  String get loginTitle => 'Logga in';

  @override
  String get loginButton => 'Logga in';

  @override
  String get loginEmailLabel => 'E-post';

  @override
  String get loginPasswordLabel => 'Lösenord';

  @override
  String get themeSwitcherTooltip => 'Byt tema';

  @override
  String get signOutTooltip => 'Logga ut';

  @override
  String get splashLabel => 'Startskärm';

  @override
  String get loginFailed =>
      'Kunde inte logga in. Kontrollera dina uppgifter och försök igen.';

  @override
  String get loginUnexpectedError => 'Något gick fel. Försök igen.';
}
