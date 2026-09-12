import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_starter/auth/cubit/auth_cubit.dart';
import 'package:flutter_starter/home/view/home_page.dart';
import 'package:flutter_starter/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/app_harness.dart';

void main() {
  group('HomePage', () {
    late FakeAuthRepository repository;
    late AppLocalizations l10n;

    setUpAll(() async {
      l10n = await AppLocalizations.delegate.load(const Locale('en'));
    });

    setUp(() {
      repository = FakeAuthRepository(initialUser: const AuthUser(id: 'u1'));
      addTearDown(repository.dispose);
    });

    /// Pumps the real [HomePage] so its own provider wiring is exercised.
    Future<void> pumpHomePage(WidgetTester tester) async {
      final authCubit = AuthCubit(authRepository: repository);
      addTearDown(authCubit.close);

      await tester.pumpWidget(
        wrapWithAppProviders(
          authRepository: repository,
          authCubit: authCubit,
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: HomePage(),
          ),
        ),
      );
      await tester.pump();
    }

    testWidgets('renders the welcome headline', (tester) async {
      await pumpHomePage(tester);

      expect(find.text(l10n.welcomeHeadline), findsOneWidget);
    });

    testWidgets('the theme switcher cycles ThemeCubit', (tester) async {
      await pumpHomePage(tester);

      final themeSwitcher = find.byTooltip(l10n.themeSwitcherTooltip);
      expect(find.byIcon(Icons.brightness_auto_outlined), findsOneWidget);

      await tester.tap(themeSwitcher);
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.light_mode_outlined), findsOneWidget);

      await tester.tap(themeSwitcher);
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.dark_mode_outlined), findsOneWidget);

      await tester.tap(themeSwitcher);
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.brightness_auto_outlined), findsOneWidget);
    });

    testWidgets('tapping sign out logs the user out', (tester) async {
      await pumpHomePage(tester);

      await tester.tap(find.byTooltip(l10n.signOutTooltip));
      await tester.pumpAndSettle();

      expect(repository.logoutCount, 1);
    });
  });
}
