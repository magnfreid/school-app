import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_app/schedule/bloc/schedule_bloc.dart';
import 'package:school_app/schedule/bloc/schedule_event.dart';
import 'package:school_app/schedule/bloc/schedule_state.dart';
import 'package:schedule_repository/schedule_repository.dart';

void main() {
  group('ScheduleBloc', () {
    // Thursday. The mock week's Mon–Fri runs Jan 8–12, 2024.
    final fixedToday = DateTime(2024, 1, 11);

    blocTest<ScheduleBloc, ScheduleState>(
      'started loads the mock week: 5 days, today flag, next event, specials',
      build: () => ScheduleBloc(
        scheduleRepository: FakeScheduleRepository(today: fixedToday),
        now: () => DateTime(2024, 1, 11, 8),
      ),
      act: (bloc) => bloc.add(const ScheduleBlocEvent.started()),
      expect: () => [
        const ScheduleState.loading(),
        isA<ScheduleLoaded>()
            .having((s) => s.days.length, 'days.length', 5)
            .having(
              (s) => s.days.map((d) => d.isToday).toList(),
              'isToday flags',
              [false, false, false, true, false],
            )
            .having(
              (s) => s.nextEvent?.event.id,
              'nextEvent.id',
              'mock-thu-ma-prov',
            )
            .having((s) => s.nextEvent?.daysUntil, 'nextEvent.daysUntil', 0)
            .having(
              (s) => s.nextEvent?.relativeDay,
              'nextEvent.relativeDay',
              RelativeDay.today,
            )
            .having(
              (s) => s.weekSpecial?.title,
              'weekSpecial.title',
              'Temavecka: Hållbarhet',
            )
            .having(
              (s) => s.days[2].special?.title,
              'Wednesday.special.title',
              'Friluftsdag',
            ),
      ],
    );

    blocTest<ScheduleBloc, ScheduleState>(
      'a ScheduleException from the repository emits failure',
      build: () => ScheduleBloc(
        scheduleRepository: FakeScheduleRepository(
          today: fixedToday,
          fetchError: const ScheduleException('unreachable'),
        ),
        now: () => DateTime(2024, 1, 11, 8),
      ),
      act: (bloc) => bloc.add(const ScheduleBlocEvent.started()),
      expect: () => [
        const ScheduleState.loading(),
        const ScheduleState.failure(),
      ],
    );

    blocTest<ScheduleBloc, ScheduleState>(
      'an unexpected error from the repository also emits failure (catch-all)',
      build: () => ScheduleBloc(
        scheduleRepository: _ThrowingScheduleRepository(),
        now: () => DateTime(2024, 1, 11, 8),
      ),
      act: (bloc) => bloc.add(const ScheduleBlocEvent.started()),
      expect: () => [
        const ScheduleState.loading(),
        const ScheduleState.failure(),
      ],
    );

    test('weekChanged from loaded emits a single loaded (no loading in '
        'between), anchored 7 days on', () async {
      final repository = FakeScheduleRepository(today: fixedToday);
      final bloc = ScheduleBloc(
        scheduleRepository: repository,
        now: () => DateTime(2024, 1, 11, 8),
      );
      addTearDown(bloc.close);

      final states = <ScheduleState>[];
      final subscription = bloc.stream.listen(states.add);
      addTearDown(subscription.cancel);

      bloc.add(const ScheduleBlocEvent.started());
      await bloc.stream.firstWhere((s) => s is ScheduleLoaded);
      states.clear();

      bloc.add(const ScheduleBlocEvent.weekChanged(1));
      await bloc.stream.firstWhere(
        (s) => s is ScheduleLoaded && s.weekOffset == 1,
      );

      expect(states, [isA<ScheduleLoaded>()]);
      // The anchor drops time-of-day (§4.6): only the date carries over.
      expect(repository.fetchCalls.last, DateTime(2024, 1, 18));
    });

    test('droppable() drops a second in-flight refresh', () async {
      final repository = FakeScheduleRepository(
        today: fixedToday,
        fetchDelay: const Duration(milliseconds: 30),
      );
      // A clock that ticks on every call, so two loads of the same week
      // produce distinct `lastSyncedAt` values and therefore distinct
      // `ScheduleLoaded` states — otherwise bloc's own no-op-on-equal-state
      // behavior would coalesce them and this test couldn't tell "emitted
      // once" from "emitted twice with identical content".
      var tick = 0;
      final bloc = ScheduleBloc(
        scheduleRepository: repository,
        now: () => DateTime(2024, 1, 11, 8, 0, tick++),
      );
      addTearDown(bloc.close);

      final states = <ScheduleState>[];
      final subscription = bloc.stream.listen(states.add);
      addTearDown(subscription.cancel);

      bloc.add(const ScheduleBlocEvent.started());
      await Future<void>.delayed(const Duration(milliseconds: 50));
      bloc.add(const ScheduleBlocEvent.refreshRequested());
      bloc.add(const ScheduleBlocEvent.refreshRequested());
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // 1 call from `started`, 1 from the single refresh that wasn't
      // dropped. Without droppable() this would be 3.
      expect(repository.fetchCalls.length, 2);
      expect(states.whereType<ScheduleLoaded>().length, 2);
    });

    blocTest<ScheduleBloc, ScheduleState>(
      'a week whose events are all in the past has no next event',
      build: () => ScheduleBloc(
        scheduleRepository: FakeScheduleRepository(
          week: WeekSchedule(
            weekStart: DateTime(2024, 1, 8),
            weekNumber: 2,
            events: [
              ScheduleEvent(
                id: 'past-event',
                title: 'Old news',
                subjectCode: 'MA',
                date: DateTime(2024, 1, 9),
                severity: EventSeverity.other,
                time: DateTime(2024, 1, 9, 9),
              ),
            ],
          ),
        ),
        now: () => DateTime(2024, 1, 11, 18),
      ),
      act: (bloc) => bloc.add(const ScheduleBlocEvent.started()),
      expect: () => [
        const ScheduleState.loading(),
        isA<ScheduleLoaded>().having((s) => s.nextEvent, 'nextEvent', isNull),
      ],
    );

    blocTest<ScheduleBloc, ScheduleState>(
      'a day-only event today still counts as next at 18:00',
      build: () => ScheduleBloc(
        scheduleRepository: FakeScheduleRepository(
          week: WeekSchedule(
            weekStart: DateTime(2024, 1, 8),
            weekNumber: 2,
            events: [
              ScheduleEvent(
                id: 'today-day-only',
                title: 'Ta med simkläder',
                subjectCode: 'IDH',
                date: DateTime(2024, 1, 11),
                severity: EventSeverity.other,
              ),
            ],
          ),
        ),
        now: () => DateTime(2024, 1, 11, 18),
      ),
      act: (bloc) => bloc.add(const ScheduleBlocEvent.started()),
      expect: () => [
        const ScheduleState.loading(),
        isA<ScheduleLoaded>()
            .having(
              (s) => s.nextEvent?.event.id,
              'nextEvent.id',
              'today-day-only',
            )
            .having(
              (s) => s.nextEvent?.relativeDay,
              'nextEvent.relativeDay',
              RelativeDay.today,
            ),
      ],
    );

    blocTest<ScheduleBloc, ScheduleState>(
      'a seeded Saturday event adds a sixth day column',
      build: () => ScheduleBloc(
        scheduleRepository: FakeScheduleRepository(
          week: WeekSchedule(
            weekStart: DateTime(2024, 1, 8),
            weekNumber: 2,
            events: [
              ScheduleEvent(
                id: 'sat-event',
                title: 'Träning',
                subjectCode: 'IDH',
                date: DateTime(2024, 1, 13),
                severity: EventSeverity.other,
              ),
            ],
          ),
        ),
        now: () => DateTime(2024, 1, 11, 8),
      ),
      act: (bloc) => bloc.add(const ScheduleBlocEvent.started()),
      expect: () => [
        const ScheduleState.loading(),
        isA<ScheduleLoaded>().having((s) => s.days.length, 'days.length', 6),
      ],
    );

    blocTest<ScheduleBloc, ScheduleState>(
      'a seeded Sunday event adds a seventh day column',
      build: () => ScheduleBloc(
        scheduleRepository: FakeScheduleRepository(
          week: WeekSchedule(
            weekStart: DateTime(2024, 1, 8),
            weekNumber: 2,
            events: [
              ScheduleEvent(
                id: 'sun-event',
                title: 'Läs s. 1–2',
                subjectCode: 'SV',
                date: DateTime(2024, 1, 14),
                severity: EventSeverity.laxa,
                kindLabel: 'LÄXA',
              ),
            ],
          ),
        ),
        now: () => DateTime(2024, 1, 11, 8),
      ),
      act: (bloc) => bloc.add(const ScheduleBlocEvent.started()),
      expect: () => [
        const ScheduleState.loading(),
        isA<ScheduleLoaded>().having((s) => s.days.length, 'days.length', 7),
      ],
    );
  });
}

/// Throws a plain [StateError] instead of a [ScheduleException] — the
/// catch-all path, since [FakeScheduleRepository.fetchError] is typed
/// `ScheduleException?` and cannot script this.
class _ThrowingScheduleRepository extends FakeScheduleRepository {
  @override
  Future<List<WeekSchedule>> fetchWindow({required DateTime anchor}) async {
    throw StateError('boom');
  }
}
