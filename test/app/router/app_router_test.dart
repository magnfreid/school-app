import 'package:app_ui/app_ui.dart';
import 'package:calendar_config_repository/calendar_config_repository.dart';
import 'package:flutter/material.dart';
import 'package:school_app/app/cubit/calendar_config_cubit.dart';
import 'package:school_app/app/router/app_router.dart';
import 'package:school_app/app/router/routes.dart';
import 'package:school_app/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:schedule_repository/schedule_repository.dart';

import '../../helpers/app_harness.dart';

const _testKey = ServiceAccountKey('{"placeholder":"not-a-real-key"}');

/// Builds a [FakeCalendarConfigRepository] and registers its own tear-down.
FakeCalendarConfigRepository buildRepository({CalendarConfig? initialConfig}) {
  final repository = FakeCalendarConfigRepository(initialConfig: initialConfig);
  addTearDown(repository.dispose);
  return repository;
}

/// Builds the real router over a scriptable repository and pumps it, so the
/// redirect is exercised through `GoRouter` rather than called directly.
Future<GoRouter> _pumpRouter(
  WidgetTester tester,
  CalendarConfigRepository repository, {
  List<RouteBase>? routeOverride,
}) async {
  // SchedulePage is a fixed-viewport kiosk screen (handoff § Overview), not
  // a responsive one — pump at its design size rather than the default test
  // surface, since a couple of these tests land on it.
  tester.view.physicalSize = const Size(1024, 768);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final configCubit = CalendarConfigCubit(configRepository: repository);
  addTearDown(configCubit.close);

  final router = AppRouter.build(
    configCubit: configCubit,
    routeOverride: routeOverride,
  );
  addTearDown(router.dispose);

  await tester.pumpWidget(
    wrapWithAppProviders(
      configRepository: repository,
      scheduleRepository: FakeScheduleRepository(),
      configCubit: configCubit,
      child: MaterialApp.router(
        theme: AppTheme.darkTheme,
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
    late FakeCalendarConfigRepository repository;

    setUp(() {
      repository = buildRepository();
    });

    testWidgets('holds on splash while config state is unknown', (
      tester,
    ) async {
      final router = await _pumpRouter(
        tester,
        SilentCalendarConfigRepository(),
      );
      await tester.pump();

      expect(_location(router), AppRoutes.splash.path);
    });

    testWidgets('sends an unconfigured user to setup', (tester) async {
      final router = await _pumpRouter(tester, repository);
      await tester.pumpAndSettle();

      expect(_location(router), AppRoutes.setup.path);
    });

    testWidgets('sends a configured user to the schedule', (tester) async {
      final configured = buildRepository(
        initialConfig: const CalendarConfig(
          calendarId: 'cal-1',
          serviceAccountKey: _testKey,
        ),
      );
      final router = await _pumpRouter(tester, configured);
      await tester.pumpAndSettle();

      expect(_location(router), AppRoutes.schedule.path);
    });

    testWidgets('bounces a configured user off setup', (tester) async {
      final configured = buildRepository(
        initialConfig: const CalendarConfig(
          calendarId: 'cal-1',
          serviceAccountKey: _testKey,
        ),
      );
      final router = await _pumpRouter(tester, configured);
      await tester.pumpAndSettle();

      router.go(AppRoutes.setup.path);
      await tester.pumpAndSettle();

      expect(_location(router), AppRoutes.schedule.path);
    });

    testWidgets('returns to setup when the config is cleared', (tester) async {
      final configured = buildRepository(
        initialConfig: const CalendarConfig(
          calendarId: 'cal-1',
          serviceAccountKey: _testKey,
        ),
      );
      final router = await _pumpRouter(tester, configured);
      await tester.pumpAndSettle();
      expect(_location(router), AppRoutes.schedule.path);

      configured.emit(null);
      await tester.pumpAndSettle();

      expect(_location(router), AppRoutes.setup.path);
    });

    testWidgets('lets a configured user reach a route beyond the schedule', (
      tester,
    ) async {
      // Regression guard. The redirect used to pin each config state to a
      // single location, so every route past the schedule was unreachable —
      // a bug invisible until a fourth route existed. Composes its own route
      // list rather than mutating the shared global, so a failure between
      // add and tearDown can't leak a route into later tests.
      final diagnostics = GoRoute(
        path: '/diagnostics',
        builder: (_, _) => const Scaffold(body: Text('diagnostics')),
      );

      final configured = buildRepository(
        initialConfig: const CalendarConfig(
          calendarId: 'cal-1',
          serviceAccountKey: _testKey,
        ),
      );
      final router = await _pumpRouter(
        tester,
        configured,
        routeOverride: [...routes, diagnostics],
      );
      await tester.pumpAndSettle();

      router.go('/diagnostics');
      await tester.pumpAndSettle();

      expect(_location(router), '/diagnostics');
      expect(find.text('diagnostics'), findsOneWidget);
    });
  });
}
