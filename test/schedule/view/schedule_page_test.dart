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

/// The anchor week's "today", mirroring `ScheduleBloc`'s own weekend bump:
/// next Mon–Fri week on a Saturday or Sunday, else this week.
///
/// Without this, the `FakeScheduleRepository`'s default seed (the just-ended
/// week) and the bloc's anchor (next week) disagree every weekend, and the
/// mock-week content assertions below fail.
DateTime _anchorToday() {
  final now = DateTime.now();
  final isWeekend =
      now.weekday == DateTime.saturday || now.weekday == DateTime.sunday;
  return isWeekend
      ? DateTime(now.year, now.month, now.day + 7)
      : DateTime(now.year, now.month, now.day);
}

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
    await _pumpSchedulePage(
      tester,
      FakeScheduleRepository(today: _anchorToday()),
    );
    await tester.pumpAndSettle();

    // Mock week content, verbatim from FakeScheduleRepository's seed.
    expect(find.text('Ekvationer'), findsOneWidget);
    expect(find.text('Källkritik'), findsWidgets);

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

    // Disposes the tree so `BlocProvider` closes the bloc and the anchor
    // `Timer.periodic` is cancelled — otherwise this fails with "A periodic
    // timer is still running after the widget tree was disposed".
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('swiping the grid navigates to the next week', (tester) async {
    await _pumpSchedulePage(
      tester,
      FakeScheduleRepository(today: _anchorToday()),
    );
    await tester.pumpAndSettle();

    final scheduleContext = tester.element(find.byType(ScheduleView));
    final l10n = scheduleContext.l10n;
    final bloc = scheduleContext.read<ScheduleBloc>();

    // A half-width drag does not reliably settle onto the next page at this
    // viewport — use `fling`, not `drag`.
    await tester.fling(find.byType(PageView), const Offset(-400, 0), 1000);
    await tester.pumpAndSettle();

    final state = bloc.state as ScheduleLoaded;
    expect(state.weekOffset, 1);
    expect(
      find.text(l10n.scheduleWeekLabel(state.week.weekNumber)),
      findsOneWidget,
    );

    await tester.pumpWidget(const SizedBox.shrink());
  });
}
