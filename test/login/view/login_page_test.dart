import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_starter/auth/cubit/auth_cubit.dart';
import 'package:flutter_starter/l10n/app_localizations.dart';
import 'package:flutter_starter/login/view/login_page.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/app_harness.dart';

void main() {
  group('LoginPage', () {
    late FakeAuthRepository repository;
    late AppLocalizations l10n;

    setUpAll(() async {
      // Resolve the real strings so assertions never hardcode English.
      l10n = await AppLocalizations.delegate.load(const Locale('en'));
    });

    setUp(() {
      repository = FakeAuthRepository();
      addTearDown(repository.dispose);
    });

    /// Pumps the real [LoginPage] — not [LoginView] — so the page's own
    /// BlocProvider wiring is part of what is under test.
    Future<void> pumpLoginPage(WidgetTester tester) async {
      final authCubit = AuthCubit(authRepository: repository);
      addTearDown(authCubit.close);

      await tester.pumpWidget(
        wrapWithAppProviders(
          authRepository: repository,
          authCubit: authCubit,
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: LoginPage(),
          ),
        ),
      );
      await tester.pump();
    }

    testWidgets('renders the sign-in form', (tester) async {
      await pumpLoginPage(tester);

      // The heading and the button both read "Sign in" in English, so a bare
      // text finder can't tell them apart — match the heading by its key.
      final heading = find.byKey(LoginView.headingKey);
      expect(heading, findsOneWidget);
      expect(tester.widget<Text>(heading).data, l10n.loginTitle);
      expect(find.widgetWithText(TextField, l10n.loginEmailLabel), findsOne);
      expect(find.widgetWithText(TextField, l10n.loginPasswordLabel), findsOne);
      expect(find.widgetWithText(FilledButton, l10n.loginButton), findsOne);
    });

    testWidgets('submits the entered credentials', (tester) async {
      await pumpLoginPage(tester);

      await tester.enterText(
        find.widgetWithText(TextField, l10n.loginEmailLabel),
        'a@b.com',
      );
      await tester.enterText(
        find.widgetWithText(TextField, l10n.loginPasswordLabel),
        'pw',
      );
      await tester.tap(find.widgetWithText(FilledButton, l10n.loginButton));
      await tester.pumpAndSettle();

      expect(repository.loginCalls, [(email: 'a@b.com', password: 'pw')]);
    });

    testWidgets('shows a localized snackbar when sign-in fails', (
      tester,
    ) async {
      repository.loginError = const AuthException('rejected');
      await pumpLoginPage(tester);

      await tester.tap(find.widgetWithText(FilledButton, l10n.loginButton));
      await tester.pumpAndSettle();

      expect(find.text(l10n.loginFailed), findsOneWidget);
    });

    testWidgets('disables the button while a submission is in flight', (
      tester,
    ) async {
      repository = FakeAuthRepository(
        loginDelay: const Duration(milliseconds: 50),
      );
      addTearDown(repository.dispose);
      await pumpLoginPage(tester);

      await tester.tap(find.byType(FilledButton));
      await tester.pump();

      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);

      await tester.pumpAndSettle();
    });
  });
}
