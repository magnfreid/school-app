import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_app/l10n/app_localizations.dart';
import 'package:school_app/schedule/bloc/schedule_bloc.dart';
import 'package:school_app/schedule/bloc/schedule_event.dart';
import 'package:school_app/schedule/bloc/schedule_state.dart';
import 'package:school_app/schedule/view/schedule_view.dart';
import 'package:school_app/schedule/widgets/day_column.dart';
import 'package:schedule_repository/schedule_repository.dart';

class _MockScheduleBloc extends MockBloc<ScheduleBlocEvent, ScheduleState>
    implements ScheduleBloc {}

ScheduleEvent _event({
  String id = 'e1',
  String title = 'Title',
  EventSeverity severity = EventSeverity.other,
  DateTime? date,
  DateTime? time,
}) => ScheduleEvent(
  id: id,
  title: title,
  subjectCode: 'MA',
  date: date ?? DateTime(2024, 1, 11),
  severity: severity,
  time: time,
);

WeekSchedule _week({
  List<ScheduleEvent> events = const [],
  List<SpecialEvent> specialEvents = const [],
}) => WeekSchedule(
  weekStart: DateTime(2024, 1, 8),
  weekNumber: 2,
  events: events,
  specialEvents: specialEvents,
);

List<ScheduleDay> _days(
  WeekSchedule week, {
  int count = 5,
  DateTime? todayDate,
}) {
  return [
    for (var i = 0; i < count; i++)
      ScheduleDay(
        date: DateTime(
          week.weekStart.year,
          week.weekStart.month,
          week.weekStart.day + i,
        ),
        isToday:
            todayDate != null &&
            DateTime(
                  week.weekStart.year,
                  week.weekStart.month,
                  week.weekStart.day + i,
                ) ==
                todayDate,
        events: [
          for (final e in week.events)
            if (e.date.year == week.weekStart.year &&
                e.date.month == week.weekStart.month &&
                e.date.day == week.weekStart.day + i)
              e,
        ],
        special: week.specialEvents
            .whereType<SpecialEventDay>()
            .where(
              (s) =>
                  s.date.year == week.weekStart.year &&
                  s.date.month == week.weekStart.month &&
                  s.date.day == week.weekStart.day + i,
            )
            .firstOrNull,
      ),
  ];
}

Future<void> _pumpScheduleView(
  WidgetTester tester,
  ScheduleState state, {
  Locale locale = const Locale('en'),
}) async {
  // This is a fixed-viewport kiosk screen (handoff § Overview), not a
  // responsive one — pump it at its design size rather than the default test
  // surface.
  tester.view.physicalSize = const Size(1024, 768);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final bloc = _MockScheduleBloc();
  whenListen(bloc, const Stream<ScheduleState>.empty(), initialState: state);
  addTearDown(bloc.close);

  await tester.pumpWidget(
    MaterialApp(
      locale: locale,
      theme: AppTheme.darkTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<ScheduleBloc>.value(
        value: bloc,
        child: const ScheduleView(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Color? _syncDotColor(WidgetTester tester) {
  final dotSize = const AppSizes().syncDotSize;
  for (final container in tester.widgetList<Container>(
    find.byType(Container),
  )) {
    final constraints = container.constraints;
    if (constraints != null &&
        constraints.maxWidth == dotSize &&
        constraints.maxHeight == dotSize) {
      return (container.decoration as BoxDecoration?)?.color;
    }
  }
  return null;
}

void main() {
  group('ScheduleView', () {
    late AppLocalizations en;
    late AppLocalizations sv;

    setUpAll(() async {
      en = await AppLocalizations.delegate.load(const Locale('en'));
      sv = await AppLocalizations.delegate.load(const Locale('sv'));
    });

    testWidgets('loading renders all four bands with an unhealthy dot', (
      tester,
    ) async {
      await _pumpScheduleView(tester, const ScheduleState.loading());

      expect(find.text(en.scheduleSyncing), findsOneWidget);
      expect(find.text(en.scheduleLoading), findsOneWidget);
      expect(find.byType(DayColumn), findsNothing);
      expect(_syncDotColor(tester), AppColors.dark.onSurfaceVariant);
    });

    testWidgets('failure renders all four bands with an unhealthy dot', (
      tester,
    ) async {
      await _pumpScheduleView(tester, const ScheduleState.failure());

      expect(find.text(en.scheduleSyncFailed), findsOneWidget);
      expect(find.text(en.scheduleUnavailable), findsOneWidget);
      expect(find.byType(DayColumn), findsNothing);
    });

    testWidgets('loaded with no next event shows the no-upcoming copy', (
      tester,
    ) async {
      final week = _week();
      await _pumpScheduleView(
        tester,
        ScheduleState.loaded(
          weekOffset: 0,
          week: week,
          lastSyncedAt: DateTime(2024, 1, 11, 8),
          days: _days(week),
        ),
      );

      expect(find.text(en.scheduleNoUpcoming), findsOneWidget);
    });

    testWidgets('a next event more than a day away shows the countdown pill', (
      tester,
    ) async {
      final event = _event(time: DateTime(2024, 1, 14, 10));
      final week = _week(events: [event]);
      await _pumpScheduleView(
        tester,
        ScheduleState.loaded(
          weekOffset: 0,
          week: week,
          lastSyncedAt: DateTime(2024, 1, 11, 8),
          days: _days(week),
          nextEvent: NextEvent(
            event: event,
            daysUntil: 3,
            relativeDay: RelativeDay.later,
          ),
        ),
      );

      expect(find.text(en.scheduleDaysUntil(3)), findsOneWidget);
    });

    testWidgets('a next event tomorrow shows no pill and the tomorrow word', (
      tester,
    ) async {
      final event = _event(time: DateTime(2024, 1, 9, 10));
      final week = _week(events: [event]);
      await _pumpScheduleView(
        tester,
        ScheduleState.loaded(
          weekOffset: 0,
          week: week,
          lastSyncedAt: DateTime(2024, 1, 11, 8),
          days: _days(week),
          nextEvent: NextEvent(
            event: event,
            daysUntil: 1,
            relativeDay: RelativeDay.tomorrow,
          ),
        ),
      );

      expect(find.text(en.scheduleRelativeTomorrow), findsOneWidget);
      expect(find.textContaining('days left'), findsNothing);
      expect(find.textContaining('day left'), findsNothing);
    });

    testWidgets(
      'a loaded state renders one PageView with only the current page',
      (tester) async {
        final week = _week();
        await _pumpScheduleView(
          tester,
          ScheduleState.loaded(
            weekOffset: 0,
            week: week,
            lastSyncedAt: DateTime(2024, 1, 11, 8),
            days: _days(week),
          ),
        );

        expect(find.byType(PageView), findsOneWidget);
        // Pins "only the current page renders" — not `days.length * 5` for
        // the whole ±2-week window.
        expect(find.byType(DayColumn), findsNWidgets(5));
      },
    );

    testWidgets('a 6-day week renders six day columns', (tester) async {
      final week = _week();
      await _pumpScheduleView(
        tester,
        ScheduleState.loaded(
          weekOffset: 0,
          week: week,
          lastSyncedAt: DateTime(2024, 1, 11, 8),
          days: _days(week, count: 6),
        ),
      );

      expect(find.byType(DayColumn), findsNWidgets(6));
    });

    testWidgets('week and day specials both render', (tester) async {
      const weekSpecial = SpecialEventWholeWeek(
        title: 'Temavecka: Hållbarhet',
        colorPreset: SpecialEventColorPreset.teal,
      );
      final daySpecial = SpecialEventDay(
        title: 'Friluftsdag',
        colorPreset: SpecialEventColorPreset.amber,
        date: DateTime(2024, 1, 10),
      );
      final week = _week(specialEvents: [weekSpecial, daySpecial]);

      await _pumpScheduleView(
        tester,
        ScheduleState.loaded(
          weekOffset: 0,
          week: week,
          lastSyncedAt: DateTime(2024, 1, 11, 8),
          days: _days(week),
          weekSpecial: weekSpecial,
        ),
      );

      expect(find.text('Temavecka: Hållbarhet'), findsOneWidget);
      expect(find.text('Friluftsdag'), findsOneWidget);
    });

    testWidgets('renders against the Swedish locale', (tester) async {
      await _pumpScheduleView(
        tester,
        const ScheduleState.failure(),
        locale: const Locale('sv'),
      );

      expect(find.text(sv.scheduleSyncFailed), findsOneWidget);
      expect(find.text(sv.scheduleUnavailable), findsOneWidget);
    });
  });
}
