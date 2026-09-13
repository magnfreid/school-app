import 'package:schedule_repository/schedule_repository.dart';
import 'package:schedule_repository/src/week_math.dart';
import 'package:test/test.dart';

void main() {
  const windowLength = 2 * ScheduleRepository.windowRadiusInWeeks + 1;
  final fixedToday = DateTime(2026, 9, 17);

  group('FakeScheduleRepository', () {
    late FakeScheduleRepository repository;

    setUp(() {
      repository = FakeScheduleRepository(today: fixedToday);
      addTearDown(repository.dispose);
    });

    test(
      'window has exactly windowLength consecutive Mondays, ascending',
      () async {
        final window = await repository.fetchWindow(anchor: fixedToday);

        expect(window, hasLength(windowLength));
        for (var i = 0; i < window.length; i++) {
          expect(window[i].weekStart.weekday, DateTime.monday);
          expect(window[i].weekStart.hour, 0);
          expect(window[i].weekStart.minute, 0);
          if (i > 0) {
            expect(
              window[i].weekStart.difference(window[i - 1].weekStart).inDays,
              7,
            );
          }
        }
      },
    );

    test("the anchor's week sits at windowRadiusInWeeks with the right "
        'weekStart', () async {
      final window = await repository.fetchWindow(anchor: fixedToday);

      expect(
        window[ScheduleRepository.windowRadiusInWeeks].weekStart,
        startOfIsoWeek(fixedToday),
      );
    });

    test('the seeded content appears in exactly one entry; the rest are empty '
        'but have correct weekStart/weekNumber', () async {
      final window = await repository.fetchWindow(anchor: fixedToday);

      final seeded = window.where(
        (week) => week.weekStart == repository.week.weekStart,
      );
      expect(seeded, hasLength(1));

      for (final week in window) {
        if (week.weekStart == repository.week.weekStart) continue;
        expect(week.events, isEmpty);
        expect(week.specialEvents, isEmpty);
        expect(week.weekNumber, isoWeekNumber(week.weekStart));
      }
    });

    test(
      'an anchor late in the day yields the same window as midnight',
      () async {
        final midnightWindow = await repository.fetchWindow(anchor: fixedToday);
        final lateWindow = await repository.fetchWindow(
          anchor: DateTime(2026, 9, 17, 23, 30),
        );

        expect(
          lateWindow.map((w) => w.weekStart),
          midnightWindow.map((w) => w.weekStart),
        );
      },
    );

    test('default constructor seeds the week containing DateTime.now()', () {
      final defaultRepository = FakeScheduleRepository();
      addTearDown(defaultRepository.dispose);

      expect(defaultRepository.week.weekStart, startOfIsoWeek(DateTime.now()));
    });

    test('a week override replaces the seeded content', () async {
      final customWeekStart = startOfIsoWeek(fixedToday);
      final override = WeekSchedule(
        weekStart: customWeekStart,
        weekNumber: isoWeekNumber(customWeekStart),
        events: [
          ScheduleEvent(
            id: 'custom',
            title: 'Custom',
            subjectCode: 'XX',
            date: customWeekStart,
            severity: EventSeverity.other,
          ),
        ],
      );
      final overriddenRepository = FakeScheduleRepository(
        today: fixedToday,
        week: override,
      );
      addTearDown(overriddenRepository.dispose);

      final window = await overriddenRepository.fetchWindow(anchor: fixedToday);
      final seeded = window.firstWhere(
        (week) => week.weekStart == customWeekStart,
      );

      expect(seeded.events, hasLength(1));
      expect(seeded.events.single.id, 'custom');
    });

    test('fetchCalls records two different anchors in order', () async {
      final first = fixedToday;
      final second = DateTime(2026, 9, 24);

      await repository.fetchWindow(anchor: first);
      await repository.fetchWindow(anchor: second);

      expect(repository.fetchCalls, [first, second]);
    });

    test(
      'fetchError makes fetchWindow throw ScheduleException and still '
      'records the call; clearing it mid-run lets the next call succeed',
      () async {
        repository.fetchError = const ScheduleException('nope');

        await expectLater(
          () => repository.fetchWindow(anchor: fixedToday),
          throwsA(isA<ScheduleException>()),
        );
        expect(repository.fetchCalls, [fixedToday]);

        repository.fetchError = null;
        await repository.fetchWindow(anchor: fixedToday);

        expect(repository.fetchCalls, hasLength(2));
      },
    );

    test('fetchDelay holds the call open', () async {
      final delayedRepository = FakeScheduleRepository(
        today: fixedToday,
        fetchDelay: const Duration(milliseconds: 50),
      );
      addTearDown(delayedRepository.dispose);

      final stopwatch = Stopwatch()..start();
      await delayedRepository.fetchWindow(anchor: fixedToday);
      stopwatch.stop();

      expect(stopwatch.elapsedMilliseconds, greaterThanOrEqualTo(50));
    });

    test('a delayed fetchWindow resolving after dispose() completes', () async {
      final delayedRepository = FakeScheduleRepository(
        today: fixedToday,
        fetchDelay: const Duration(milliseconds: 30),
      );
      final fetch = delayedRepository.fetchWindow(anchor: fixedToday);
      await delayedRepository.dispose();

      await expectLater(fetch, completes);
    });

    group('mock content', () {
      test('has ten events', () async {
        final window = await repository.fetchWindow(anchor: fixedToday);
        final seeded = window.firstWhere(
          (week) => week.weekStart == repository.week.weekStart,
        );

        expect(seeded.events, hasLength(10));
      });

      test('Ekvationer is the Thursday prov event', () async {
        final event = repository.week.events.firstWhere(
          (e) => e.title == 'Ekvationer',
        );

        expect(event.severity, EventSeverity.prov);
        expect(event.subjectCode, 'MA');
        expect(event.kindLabel, 'PROV');
        expect(event.date.weekday, DateTime.thursday);
        expect(event.time, isNotNull);
        expect(event.time!.hour, 10);
        expect(event.time!.minute, 0);
        expect(
          DateTime(event.time!.year, event.time!.month, event.time!.day),
          DateTime(event.date.year, event.date.month, event.date.day),
        );
      });

      test('the IDH event has no kindLabel and no time', () async {
        final event = repository.week.events.firstWhere(
          (e) => e.subjectCode == 'IDH',
        );

        expect(event.kindLabel, isNull);
        expect(event.time, isNull);
      });

      test('every event with a time falls on the same day as its date', () {
        for (final event in repository.week.events) {
          final time = event.time;
          if (time == null) continue;
          expect(
            DateTime(time.year, time.month, time.day),
            DateTime(event.date.year, event.date.month, event.date.day),
          );
        }
      });

      test('weekNumber matches isoWeekNumber(weekStart)', () {
        expect(
          repository.week.weekNumber,
          isoWeekNumber(repository.week.weekStart),
        );
      });

      test('the MS title carries the computed week number', () {
        final event = repository.week.events.firstWhere(
          (e) => e.subjectCode == 'MS',
        );

        expect(event.title, 'Glosor v.${repository.week.weekNumber}');
      });

      test('specialEvents is exactly one teal week banner and one amber '
          'Wednesday banner', () {
        final specials = repository.week.specialEvents;
        expect(specials, hasLength(2));

        final wholeWeek = specials.whereType<SpecialEventWholeWeek>();
        expect(wholeWeek, hasLength(1));
        expect(wholeWeek.single.colorPreset, SpecialEventColorPreset.teal);

        final day = specials.whereType<SpecialEventDay>();
        expect(day, hasLength(1));
        expect(day.single.colorPreset, SpecialEventColorPreset.amber);
        expect(day.single.date.weekday, DateTime.wednesday);
      });
    });
  });
}
