import 'package:calendar_config_repository/calendar_config_repository.dart';
import 'package:school_app/app/app.dart';
import 'package:school_app/app/cubit/calendar_config_cubit.dart';
import 'package:school_app/schedule/view/schedule_page.dart';
import 'package:school_app/setup/view/setup_page.dart';
import 'package:school_app/splash/view/splash_page.dart';
import 'package:flutter_test/flutter_test.dart';

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
  CalendarConfigRepository configRepository,
) async {
  final configCubit = CalendarConfigCubit(configRepository: configRepository);
  addTearDown(configCubit.close);

  await tester.pumpWidget(
    wrapWithAppProviders(
      configRepository: configRepository,
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
  });
}
