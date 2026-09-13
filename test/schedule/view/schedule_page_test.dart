import 'package:app_ui/app_ui.dart';
import 'package:calendar_config_repository/calendar_config_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_app/app/cubit/calendar_config_cubit.dart';
import 'package:school_app/l10n/app_localizations.dart';
import 'package:school_app/l10n/extensions/app_localizations_extension.dart';
import 'package:school_app/schedule/bloc/schedule_bloc.dart';
import 'package:school_app/schedule/bloc/schedule_state.dart';
import 'package:school_app/schedule/view/schedule_page.dart';
import 'package:school_app/schedule/view/schedule_view.dart';
import 'package:schedule_repository/schedule_repository.dart';

import '../../helpers/app_harness.dart';

Future<void> _pumpSchedulePage(
  WidgetTester tester,
  ScheduleRepository scheduleRepository,
) async {
  // This is a fixed-viewport kiosk screen (handoff § Overview), not a
  // responsive one — pump it at its design size rather than the default
  // test surface.
  tester.view.physicalSize = const Size(1024, 768);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final configRepository = FakeCalendarConfigRepository();
  addTearDown(configRepository.dispose);
  final configCubit = CalendarConfigCubit(configRepository: configRepository);
  addTearDown(configCubit.close);

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.darkTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: wrapWithAppProviders(
        configRepository: configRepository,
        scheduleRepository: scheduleRepository,
        configCubit: configCubit,
        child: const SchedulePage(),
      ),
    ),
  );
}

void main() {
  testWidgets('renders the mock week and lets the user page to the next week', (
    tester,
  ) async {
    await _pumpSchedulePage(tester, FakeScheduleRepository());
    await tester.pumpAndSettle();

    // Mock week content, verbatim from FakeScheduleRepository's seed.
    expect(find.text('Ekvationer'), findsOneWidget);
    expect(find.text('Källkritik'), findsOneWidget);

    final scheduleContext = tester.element(find.byType(ScheduleView));
    final l10n = scheduleContext.l10n;
    final bloc = scheduleContext.read<ScheduleBloc>();

    // The hero is derived from the displayed week only (handoff §
    // Interactions), so whether it shows an event or the empty state is a
    // property of which real-world day this suite happens to run on — not
    // something this smoke test should assume. Assert it matches the bloc's
    // own state instead of hardcoding one branch.
    final initialState = bloc.state as ScheduleLoaded;
    final initialNextEvent = initialState.nextEvent;
    if (initialNextEvent == null) {
      expect(find.text(l10n.scheduleNoUpcoming), findsOneWidget);
    } else {
      expect(find.text(initialNextEvent.event.title), findsWidgets);
    }
    final initialWeekNumber = initialState.week.weekNumber;

    await tester.tap(find.byTooltip(l10n.scheduleNavNextWeekTooltip));
    await tester.pumpAndSettle();

    final nextWeekNumber = (bloc.state as ScheduleLoaded).week.weekNumber;
    expect(nextWeekNumber, isNot(initialWeekNumber));
    expect(find.text(l10n.scheduleWeekLabel(nextWeekNumber)), findsOneWidget);
  });
}
