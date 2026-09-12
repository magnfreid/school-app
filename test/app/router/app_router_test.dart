import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:school_app/app/router/app_router.dart';
import 'package:school_app/app/router/routes.dart';
import 'package:school_app/auth/cubit/auth_cubit.dart';
import 'package:school_app/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../helpers/app_harness.dart';

/// Builds the real router over a scriptable repository and pumps it, so the
/// redirect is exercised through `GoRouter` rather than called directly.
Future<GoRouter> _pumpRouter(
  WidgetTester tester,
  AuthRepository repository, {
  List<RouteBase>? routeOverride,
}) async {
  final authCubit = AuthCubit(authRepository: repository);
  addTearDown(authCubit.close);

  final router = AppRouter.build(
    authCubit: authCubit,
    routeOverride: routeOverride,
  );
  addTearDown(router.dispose);

  await tester.pumpWidget(
    wrapWithAppProviders(
      authRepository: repository,
      authCubit: authCubit,
      child: MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    ),
  );
  return router;
}

String _location(GoRouter router) =>
    router.routerDelegate.currentConfiguration.uri.path;

void main() {
  group('AppRouter redirect', () {
    late FakeAuthRepository repository;

    setUp(() {
      repository = FakeAuthRepository();
      addTearDown(repository.dispose);
    });

    testWidgets('holds on splash while auth state is unknown', (tester) async {
      final router = await _pumpRouter(tester, SilentAuthRepository());
      await tester.pump();

      expect(_location(router), AppRoutes.splash.path);
    });

    testWidgets('sends an unauthenticated user to login', (tester) async {
      final router = await _pumpRouter(tester, repository);
      await tester.pumpAndSettle();

      expect(_location(router), AppRoutes.login.path);
    });

    testWidgets('sends an authenticated user to home', (tester) async {
      repository.emit(const AuthUser(id: 'u1'));
      final router = await _pumpRouter(tester, repository);
      await tester.pumpAndSettle();

      expect(_location(router), AppRoutes.home.path);
    });

    testWidgets('bounces an authenticated user off login', (tester) async {
      repository.emit(const AuthUser(id: 'u1'));
      final router = await _pumpRouter(tester, repository);
      await tester.pumpAndSettle();

      router.go(AppRoutes.login.path);
      await tester.pumpAndSettle();

      expect(_location(router), AppRoutes.home.path);
    });

    testWidgets('redirects to login when the session ends', (tester) async {
      repository.emit(const AuthUser(id: 'u1'));
      final router = await _pumpRouter(tester, repository);
      await tester.pumpAndSettle();
      expect(_location(router), AppRoutes.home.path);

      repository.emit(null);
      await tester.pumpAndSettle();

      expect(_location(router), AppRoutes.login.path);
    });

    testWidgets('lets an authenticated user reach a route beyond home', (
      tester,
    ) async {
      // Regression guard. The redirect used to pin each auth state to a single
      // location, so every route past home was unreachable — a bug invisible
      // until a fourth route existed. Composes its own route list rather than
      // mutating the shared global, so a failure between add and tearDown
      // can't leak a route into later tests.
      final settings = GoRoute(
        path: '/settings',
        builder: (_, _) => const Scaffold(body: Text('settings')),
      );

      repository.emit(const AuthUser(id: 'u1'));
      final router = await _pumpRouter(
        tester,
        repository,
        routeOverride: [...routes, settings],
      );
      await tester.pumpAndSettle();

      router.go('/settings');
      await tester.pumpAndSettle();

      expect(_location(router), '/settings');
      expect(find.text('settings'), findsOneWidget);
    });
  });
}
