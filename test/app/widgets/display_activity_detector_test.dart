import 'package:bloc_test/bloc_test.dart';
import 'package:calendar_config_repository/calendar_config_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:school_app/app/app.dart';
import 'package:school_app/app/bloc/display_bloc.dart';
import 'package:school_app/app/bloc/display_event.dart';
import 'package:school_app/app/bloc/display_state.dart';
import 'package:school_app/app/cubit/calendar_config_cubit.dart';
import 'package:school_app/l10n/extensions/app_localizations_extension.dart';
import 'package:school_app/schedule/view/schedule_page.dart';
import 'package:school_app/settings/view/settings_page.dart';
import 'package:schedule_repository/schedule_repository.dart';

import '../../helpers/app_harness.dart';

class _MockDisplayBloc extends MockBloc<DisplayEvent, DisplayState>
    implements DisplayBloc {}

const _testKey = ServiceAccountKey('{"placeholder":"not-a-real-key"}');

/// Pumps the real [App] with a scripted [DisplayBloc], configured so it
/// lands on [SchedulePage].
Future<_MockDisplayBloc> _pumpApp(WidgetTester tester) async {
  // SchedulePage is a fixed-viewport kiosk screen (handoff § Overview), not
  // a responsive one — pump at its design size rather than the default test
  // surface.
  tester.view.physicalSize = const Size(1024, 768);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final configRepository = FakeCalendarConfigRepository(
    initialConfig: const CalendarConfig(
      calendarId: 'cal-1',
      serviceAccountKey: _testKey,
    ),
  );
  addTearDown(configRepository.dispose);
  final configCubit = CalendarConfigCubit(configRepository: configRepository);
  addTearDown(configCubit.close);

  final displayBloc = _MockDisplayBloc();
  whenListen(
    displayBloc,
    const Stream<DisplayState>.empty(),
    initialState: const DisplayState.released(),
  );
  addTearDown(displayBloc.close);

  await tester.pumpWidget(
    wrapWithAppProviders(
      configRepository: configRepository,
      scheduleRepository: FakeScheduleRepository(),
      configCubit: configCubit,
      displayBloc: displayBloc,
      child: const App(),
    ),
  );
  await tester.pumpAndSettle();

  return displayBloc;
}

void main() {
  setUpAll(() {
    registerFallbackValue(const DisplayEvent.userInteracted());
  });

  group('DisplayActivityDetector', () {
    testWidgets('tapping anywhere adds userInteracted', (tester) async {
      final displayBloc = await _pumpApp(tester);
      expect(find.byType(SchedulePage), findsOneWidget);

      await tester.tapAt(const Offset(20, 20));
      await tester.pump();

      verify(
        () => displayBloc.add(const DisplayEvent.userInteracted()),
      ).called(greaterThan(0));

      // Disposes the tree so BlocProvider closes the ScheduleBloc and the
      // anchor Timer.periodic is cancelled.
      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets(
      'a lifecycle pause then resume adds foregroundChanged(false) then '
      '(true)',
      (tester) async {
        final displayBloc = await _pumpApp(tester);

        // AppLifecycleListener enforces the real OS state machine
        // (resumed -> inactive -> hidden -> paused, and back the same way)
        // — going straight from paused to resumed is an invalid transition
        // and asserts.
        tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
        await tester.pump();
        verify(
          () => displayBloc.add(
            const DisplayEvent.foregroundChanged(isForeground: false),
          ),
        ).called(greaterThan(0));

        tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
        tester.binding.handleAppLifecycleStateChanged(
          AppLifecycleState.inactive,
        );
        tester.binding.handleAppLifecycleStateChanged(
          AppLifecycleState.resumed,
        );
        await tester.pump();
        verify(
          () => displayBloc.add(
            const DisplayEvent.foregroundChanged(isForeground: true),
          ),
        ).called(1);

        // Disposes the tree so BlocProvider closes the ScheduleBloc and the
        // anchor Timer.periodic is cancelled.
        await tester.pumpWidget(const SizedBox.shrink());
      },
    );

    testWidgets(
      'a tap on the schedule app bar settings button still navigates: the '
      'Listener does not swallow the gesture',
      (tester) async {
        await _pumpApp(tester);
        expect(find.byType(SchedulePage), findsOneWidget);

        final context = tester.element(find.byType(SchedulePage));
        await tester.tap(find.byTooltip(context.l10n.scheduleSettingsTooltip));
        await tester.pumpAndSettle();

        expect(find.byType(SettingsPage), findsOneWidget);

        // Disposes the tree so BlocProvider closes the ScheduleBloc and the
        // anchor Timer.periodic is cancelled.
        await tester.pumpWidget(const SizedBox.shrink());
      },
    );
  });
}
