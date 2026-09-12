import 'package:flutter/material.dart';
import 'package:flutter_starter/l10n/app_localizations.dart';
import 'package:flutter_starter/splash/view/splash_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SplashPage', () {
    late AppLocalizations l10n;

    setUpAll(() async {
      l10n = await AppLocalizations.delegate.load(const Locale('en'));
    });

    testWidgets('renders the splash label and a progress indicator', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: SplashPage(),
        ),
      );

      expect(find.text(l10n.splashLabel), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
