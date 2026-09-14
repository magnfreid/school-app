import 'package:calendar_config_repository/calendar_config_repository.dart';
import 'package:flutter/material.dart';
import 'package:school_app/app/app.dart';
import 'package:school_app/app/cubit/calendar_config_cubit.dart';
import 'package:school_app/l10n/extensions/app_localizations_extension.dart';
import 'package:school_app/schedule/view/schedule_page.dart';
import 'package:school_app/settings/view/settings_page.dart';
import 'package:school_app/setup/view/setup_page.dart';
import 'package:school_app/splash/view/splash_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:schedule_repository/schedule_repository.dart';

import 'helpers/app_harness.dart';

/// Builds a [FakeCalendarConfigRepository] and registers its own tear-down.
FakeCalendarConfigRepository buildRepository({CalendarConfig? initialConfig}) {
  final repository = FakeCalendarConfigRepository(initialConfig: initialConfig);
  addTearDown(repository.dispose);
  return repository;
}

/// Pumps [App] under the same providers `bootstrap.dart` installs.
Future<void> _pumpApp(
  WidgetTester tester,
  CalendarConfigRepository configRepository, {
  ScheduleRepository? scheduleRepository,
}) async {
  // SchedulePage is a fixed-viewport kiosk screen (handoff § Overview), not
  // a responsive one — pump at its design size rather than the default test
  // surface, since several of these tests land on it.
  tester.view.physicalSize = const Size(1024, 768);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final configCubit = CalendarConfigCubit(configRepository: configRepository);
  addTearDown(configCubit.close);

  await tester.pumpWidget(
    wrapWithAppProviders(
      configRepository: configRepository,
      scheduleRepository: scheduleRepository ?? FakeScheduleRepository(),
      configCubit: configCubit,
      child: const App(),
    ),
  );
}

void main() {
  testWidgets('shows SplashPage while config state is unknown', (tester) async {
    // A repository that never emits leaves the cubit in
    // CalendarConfigState.unknown.
    await _pumpApp(tester, SilentCalendarConfigRepository());
    await tester.pump();

    expect(find.byType(SplashPage), findsOneWidget);
  });

  testWidgets('shows SetupPage when unconfigured', (tester) async {
    await _pumpApp(tester, buildRepository());
    await tester.pumpAndSettle();

    expect(find.byType(SetupPage), findsOneWidget);
  });

  testWidgets('shows SchedulePage when configured', (tester) async {
    final configRepository = buildRepository(
      initialConfig: const CalendarConfig(calendarId: 'cal-1'),
    );

    await _pumpApp(tester, configRepository);
    await tester.pumpAndSettle();

    expect(find.byType(SchedulePage), findsOneWidget);

    // Disposes the tree so `BlocProvider` closes the `ScheduleBloc` and the
    // anchor `Timer.periodic` is cancelled.
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('clearing the config returns the user to SetupPage', (
    tester,
  ) async {
    final configRepository = buildRepository(
      initialConfig: const CalendarConfig(calendarId: 'cal-1'),
    );

    await _pumpApp(tester, configRepository);
    await tester.pumpAndSettle();
    expect(find.byType(SchedulePage), findsOneWidget);

    await configRepository.clear();
    await tester.pumpAndSettle();

    expect(find.byType(SetupPage), findsOneWidget);

    // Disposes the tree so `BlocProvider` closes the `ScheduleBloc` and the
    // anchor `Timer.periodic` is cancelled.
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('tapping the settings button opens SettingsPage', (tester) async {
    final configRepository = buildRepository(
      initialConfig: const CalendarConfig(calendarId: 'cal-1'),
    );

    await _pumpApp(tester, configRepository);
    await tester.pumpAndSettle();
    expect(find.byType(SchedulePage), findsOneWidget);

    final context = tester.element(find.byType(SchedulePage));
    await tester.tap(find.byTooltip(context.l10n.scheduleSettingsTooltip));
    await tester.pumpAndSettle();

    expect(find.byType(SettingsPage), findsOneWidget);

    // Disposes the tree so `BlocProvider` closes the `ScheduleBloc` and the
    // anchor `Timer.periodic` is cancelled.
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
