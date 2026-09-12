import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:school_app/app/app.dart';
import 'package:school_app/auth/cubit/auth_cubit.dart';
import 'package:school_app/home/view/home_page.dart';
import 'package:school_app/login/view/login_page.dart';
import 'package:school_app/splash/view/splash_page.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/app_harness.dart';

/// Pumps [App] under the same providers `bootstrap.dart` installs.
Future<void> _pumpApp(
  WidgetTester tester,
  AuthRepository authRepository,
) async {
  final authCubit = AuthCubit(authRepository: authRepository);
  addTearDown(authCubit.close);

  await tester.pumpWidget(
    wrapWithAppProviders(
      authRepository: authRepository,
      authCubit: authCubit,
      child: const App(),
    ),
  );
}

/// Builds a [FakeAuthRepository] and registers its own tear-down.
FakeAuthRepository buildRepository({AuthUser? initialUser}) {
  final repository = FakeAuthRepository(initialUser: initialUser);
  addTearDown(repository.dispose);
  return repository;
}

void main() {
  testWidgets('shows SplashPage while auth state is unknown', (tester) async {
    // A repository that never emits leaves the cubit in AuthState.unknown.
    await _pumpApp(tester, SilentAuthRepository());
    await tester.pump();

    expect(find.byType(SplashPage), findsOneWidget);
  });

  testWidgets('shows LoginPage when unauthenticated', (tester) async {
    await _pumpApp(tester, buildRepository());
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets('shows HomePage when authenticated', (tester) async {
    final authRepository = buildRepository(
      initialUser: const AuthUser(id: 'u1'),
    );

    await _pumpApp(tester, authRepository);
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('signing out returns the user to LoginPage', (tester) async {
    final authRepository = buildRepository(
      initialUser: const AuthUser(id: 'u1'),
    );

    await _pumpApp(tester, authRepository);
    await tester.pumpAndSettle();
    expect(find.byType(HomePage), findsOneWidget);

    await tester.tap(find.byIcon(Icons.logout));
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
  });
}
