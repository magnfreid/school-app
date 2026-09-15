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
      // The anchor the bloc asks for stops shifting with the week offset —
      // it stays the Monday of the ISO week containing "now" (Jan 8)
      // regardless of the offset navigated to.
      expect(repository.fetchCalls.last, DateTime(2024, 1, 8));
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

    test('the anchor on a weekday is this ISO week', () async {
      final repository = FakeScheduleRepository(today: fixedToday);
      final bloc = ScheduleBloc(
        scheduleRepository: repository,
        now: () => DateTime(2024, 1, 11, 8),
      );
      addTearDown(bloc.close);

      bloc.add(const ScheduleBlocEvent.started());
      await bloc.stream.firstWhere((s) => s is ScheduleLoaded);

      expect(repository.fetchCalls.single, DateTime(2024, 1, 8));
    });

    test('the anchor on a Saturday is next ISO week', () async {
      final repository = FakeScheduleRepository(today: DateTime(2024, 1, 13));
      final bloc = ScheduleBloc(
        scheduleRepository: repository,
        now: () => DateTime(2024, 1, 13, 8),
      );
      addTearDown(bloc.close);

      bloc.add(const ScheduleBlocEvent.started());
      await bloc.stream.firstWhere((s) => s is ScheduleLoaded);

      expect(repository.fetchCalls.single, DateTime(2024, 1, 15));
    });

    test('the anchor on a Sunday is next ISO week', () async {
      final repository = FakeScheduleRepository(today: DateTime(2024, 1, 14));
      final bloc = ScheduleBloc(
        scheduleRepository: repository,
        now: () => DateTime(2024, 1, 14, 8),
      );
      addTearDown(bloc.close);

      bloc.add(const ScheduleBlocEvent.started());
      await bloc.stream.firstWhere((s) => s is ScheduleLoaded);

      expect(repository.fetchCalls.single, DateTime(2024, 1, 15));
    });

    test('weekChanged clamps to the window radius (high)', () async {
      final repository = FakeScheduleRepository(today: fixedToday);
      final bloc = ScheduleBloc(
        scheduleRepository: repository,
        now: () => DateTime(2024, 1, 11, 8),
      );
      addTearDown(bloc.close);

      bloc.add(const ScheduleBlocEvent.started());
      await bloc.stream.firstWhere((s) => s is ScheduleLoaded);

      bloc.add(const ScheduleBlocEvent.weekChanged(5));
      final clamped =
          await bloc.stream.firstWhere(
                (s) => s is ScheduleLoaded && s.weekOffset == 2,
              )
              as ScheduleLoaded;

      expect(clamped.weekOffset, 2);
      // The anchor itself never shifts with the offset — only the index
      // into the fetched window does.
      expect(repository.fetchCalls.last, DateTime(2024, 1, 8));
    });

    test('weekChanged clamps to the window radius (low)', () async {
      final repository = FakeScheduleRepository(today: fixedToday);
      final bloc = ScheduleBloc(
        scheduleRepository: repository,
        now: () => DateTime(2024, 1, 11, 8),
      );
      addTearDown(bloc.close);

      bloc.add(const ScheduleBlocEvent.started());
      await bloc.stream.firstWhere((s) => s is ScheduleLoaded);

      bloc.add(const ScheduleBlocEvent.weekChanged(-5));
      final clamped =
          await bloc.stream.firstWhere(
                (s) => s is ScheduleLoaded && s.weekOffset == -2,
              )
              as ScheduleLoaded;

      expect(clamped.weekOffset, -2);
    });

    test('weekChanged with the current offset is a no-op', () async {
      final repository = FakeScheduleRepository(today: fixedToday);
      final bloc = ScheduleBloc(
        scheduleRepository: repository,
        now: () => DateTime(2024, 1, 11, 8),
      );
      addTearDown(bloc.close);

      bloc.add(const ScheduleBlocEvent.started());
      await bloc.stream.firstWhere((s) => s is ScheduleLoaded);
      bloc.add(const ScheduleBlocEvent.weekChanged(1));
      await bloc.stream.firstWhere(
        (s) => s is ScheduleLoaded && s.weekOffset == 1,
      );

      final callsAfterFirstNav = repository.fetchCalls.length;

      // This pins the echo guard: without it, `animateToPage`'s
      // `onPageChanged` feedback loop refetches on every arrow tap.
      bloc.add(const ScheduleBlocEvent.weekChanged(1));
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(repository.fetchCalls.length, callsAfterFirstNav);
    });

    test('restartable() keeps only the final weekChanged in flight', () async {
      final repository = FakeScheduleRepository(
        today: fixedToday,
        fetchDelay: const Duration(milliseconds: 30),
      );
      final bloc = ScheduleBloc(
        scheduleRepository: repository,
        now: () => DateTime(2024, 1, 11, 8),
      );
      addTearDown(bloc.close);

      bloc.add(const ScheduleBlocEvent.started());
      await bloc.stream.firstWhere((s) => s is ScheduleLoaded);

      final offsets = <int>[];
      final subscription = bloc.stream.listen((s) {
        if (s is ScheduleLoaded) offsets.add(s.weekOffset);
      });
      addTearDown(subscription.cancel);

      bloc.add(const ScheduleBlocEvent.weekChanged(1));
      bloc.add(const ScheduleBlocEvent.weekChanged(2));
      await bloc.stream.firstWhere(
        (s) => s is ScheduleLoaded && s.weekOffset == 2,
      );

      // Asserting only the final state would pass with the transformer
      // removed — assert the whole list.
      expect(offsets, [2]);
    });

    test('idle timeout auto-returns to the anchor week', () async {
      final repository = FakeScheduleRepository(today: fixedToday);
      final bloc = ScheduleBloc(
        scheduleRepository: repository,
        now: () => DateTime(2024, 1, 11, 8),
        idleTimeout: const Duration(milliseconds: 40),
      );
      addTearDown(bloc.close);

      bloc.add(const ScheduleBlocEvent.started());
      await bloc.stream.firstWhere((s) => s is ScheduleLoaded);

      bloc.add(const ScheduleBlocEvent.weekChanged(1));
      await bloc.stream.firstWhere(
        (s) => s is ScheduleLoaded && s.weekOffset == 1,
      );

      final autoReturned =
          await bloc.stream.firstWhere(
                (s) => s is ScheduleLoaded && s.weekOffset == 0,
              )
              as ScheduleLoaded;

      expect(autoReturned.weekOffset, 0);
    });

    test('the idle timer restarts on every navigation', () async {
      final repository = FakeScheduleRepository(today: fixedToday);
      final bloc = ScheduleBloc(
        scheduleRepository: repository,
        now: () => DateTime(2024, 1, 11, 8),
        idleTimeout: const Duration(milliseconds: 60),
      );
      addTearDown(bloc.close);

      bloc.add(const ScheduleBlocEvent.started());
      await bloc.stream.firstWhere((s) => s is ScheduleLoaded);

      bloc.add(const ScheduleBlocEvent.weekChanged(1));
      await bloc.stream.firstWhere(
        (s) => s is ScheduleLoaded && s.weekOffset == 1,
      );
      await Future<void>.delayed(const Duration(milliseconds: 40));

      bloc.add(const ScheduleBlocEvent.weekChanged(2));
      await bloc.stream.firstWhere(
        (s) => s is ScheduleLoaded && s.weekOffset == 2,
      );
      await Future<void>.delayed(const Duration(milliseconds: 40));

      // No offset-0 auto-return has happened yet: the state is still the
      // second manually chosen offset.
      expect(
        bloc.state,
        isA<ScheduleLoaded>().having((s) => s.weekOffset, 'weekOffset', 2),
      );
    });

    test('idle timeout at offset 0 is a no-op', () async {
      final repository = FakeScheduleRepository(today: fixedToday);
      final bloc = ScheduleBloc(
        scheduleRepository: repository,
        now: () => DateTime(2024, 1, 11, 8),
        idleTimeout: const Duration(milliseconds: 30),
      );
      addTearDown(bloc.close);

      bloc.add(const ScheduleBlocEvent.started());
      await bloc.stream.firstWhere((s) => s is ScheduleLoaded);

      final callsAfterStart = repository.fetchCalls.length;

      // Restarts the idle timer without changing the loaded week (same
      // offset as current).
      bloc.add(const ScheduleBlocEvent.weekChanged(0));
      await Future<void>.delayed(const Duration(milliseconds: 60));

      expect(repository.fetchCalls.length, callsAfterStart);
    });

    test('an anchor rollover resets a manually chosen offset', () async {
      var clock = DateTime(2024, 1, 12, 20); // Friday evening.
      final repository = FakeScheduleRepository(today: DateTime(2024, 1, 12));
      final bloc = ScheduleBloc(
        scheduleRepository: repository,
        now: () => clock,
        anchorCheckInterval: const Duration(milliseconds: 20),
      );
      addTearDown(bloc.close);

      bloc.add(const ScheduleBlocEvent.started());
      await bloc.stream.firstWhere((s) => s is ScheduleLoaded);

      bloc.add(const ScheduleBlocEvent.weekChanged(1));
      await bloc.stream.firstWhere(
        (s) => s is ScheduleLoaded && s.weekOffset == 1,
      );

      clock = DateTime(2024, 1, 13, 8); // Saturday: the anchor rolls over.

      final rolledOver =
          await bloc.stream.firstWhere(
                (s) => s is ScheduleLoaded && s.weekOffset == 0,
              )
              as ScheduleLoaded;

      expect(rolledOver.weekOffset, 0);
      expect(repository.fetchCalls.last, DateTime(2024, 1, 15));
    });

    test('an anchor tick with no rollover does not refetch', () async {
      final repository = FakeScheduleRepository(today: fixedToday);
      final bloc = ScheduleBloc(
        scheduleRepository: repository,
        now: () => DateTime(2024, 1, 11, 8),
        anchorCheckInterval: const Duration(milliseconds: 20),
      );
      addTearDown(bloc.close);

      bloc.add(const ScheduleBlocEvent.started());
      await bloc.stream.firstWhere((s) => s is ScheduleLoaded);

      // Without pinning this, a bloc that reloads on every tick looks
      // correct in the app and hammers the repository.
      await Future<void>.delayed(const Duration(milliseconds: 80));

      expect(repository.fetchCalls.length, 1);
    });

    test('close() cancels both timers', () async {
      final repository = FakeScheduleRepository(today: fixedToday);
      final bloc = ScheduleBloc(
        scheduleRepository: repository,
        now: () => DateTime(2024, 1, 11, 8),
        idleTimeout: const Duration(milliseconds: 10),
        anchorCheckInterval: const Duration(milliseconds: 10),
      );

      bloc.add(const ScheduleBlocEvent.started());
      await bloc.stream.firstWhere((s) => s is ScheduleLoaded);

      await bloc.close();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(repository.fetchCalls.length, 1);
    });

    test('weekChanged(2) reads the offset week from the fetched window '
        'without shifting the anchor', () async {
      final repository = FakeScheduleRepository(today: fixedToday);
      final bloc = ScheduleBloc(
        scheduleRepository: repository,
        now: () => DateTime(2024, 1, 11, 8),
      );
      addTearDown(bloc.close);

      bloc.add(const ScheduleBlocEvent.started());
      await bloc.stream.firstWhere((s) => s is ScheduleLoaded);

      bloc.add(const ScheduleBlocEvent.weekChanged(2));
      final loaded =
          await bloc.stream.firstWhere(
                (s) => s is ScheduleLoaded && s.weekOffset == 2,
              )
              as ScheduleLoaded;

      expect(loaded.week.weekStart, DateTime(2024, 1, 22));
      expect(repository.fetchCalls.last, DateTime(2024, 1, 8));
    });

    test('the refresh timer periodically requests a forced sync, starting '
        "unforced from started()'s own load", () async {
      final repository = FakeScheduleRepository(today: fixedToday);
      final bloc = ScheduleBloc(
        scheduleRepository: repository,
        now: () => DateTime(2024, 1, 11, 8),
        refreshInterval: const Duration(milliseconds: 20),
      );
      addTearDown(bloc.close);

      bloc.add(const ScheduleBlocEvent.started());
      await bloc.stream.firstWhere((s) => s is ScheduleLoaded);

      await Future<void>.delayed(const Duration(milliseconds: 60));

      expect(repository.forceSyncCalls.first, isFalse);
      expect(repository.forceSyncCalls, contains(true));
    });

    test('a stale refresh does not clobber a week the user navigated to '
        'while its fetch was in flight', () async {
      final repository = _SlowFirstForceSyncScheduleRepository(
        today: fixedToday,
        delay: const Duration(milliseconds: 50),
      );
      final bloc = ScheduleBloc(
        scheduleRepository: repository,
        now: () => DateTime(2024, 1, 11, 8),
      );
      addTearDown(bloc.close);

      bloc.add(const ScheduleBlocEvent.started());
      await bloc.stream.firstWhere((s) => s is ScheduleLoaded);

      // Simulates the 15-minute timer firing at offset 0; its fetch is held
      // open by the fake for 50ms.
      bloc.add(const ScheduleBlocEvent.refreshRequested());
      // The user navigates to a different week while that fetch is still in
      // flight — this weekChanged fetch is not delayed, so it lands first.
      await Future<void>.delayed(const Duration(milliseconds: 10));
      bloc.add(const ScheduleBlocEvent.weekChanged(1));
      await bloc.stream.firstWhere(
        (s) => s is ScheduleLoaded && s.weekOffset == 1,
      );

      // Give the stale refresh time to resolve and (incorrectly, without
      // the fix) emit weekOffset: 0 on top of it.
      await Future<void>.delayed(const Duration(milliseconds: 80));

      expect(
        bloc.state,
        isA<ScheduleLoaded>().having((s) => s.weekOffset, 'weekOffset', 1),
      );
    });

    test('after close(), no further fetchWindow call arrives from the '
        'refresh timer', () async {
      final repository = FakeScheduleRepository(today: fixedToday);
      final bloc = ScheduleBloc(
        scheduleRepository: repository,
        now: () => DateTime(2024, 1, 11, 8),
        refreshInterval: const Duration(milliseconds: 10),
      );

      bloc.add(const ScheduleBlocEvent.started());
      await bloc.stream.firstWhere((s) => s is ScheduleLoaded);

      await bloc.close();
      final callsAtClose = repository.fetchCalls.length;
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(repository.fetchCalls.length, callsAtClose);
    });

    test("lastSyncedAt in loaded is the repository's value, not the bloc's "
        'clock', () async {
      final fixedSync = DateTime(2024, 1, 1);
      final repository = FakeScheduleRepository(today: fixedToday)
        ..lastSyncedAt = fixedSync;
      final bloc = ScheduleBloc(
        scheduleRepository: repository,
        now: () => DateTime(2024, 1, 11, 8),
      );
      addTearDown(bloc.close);

      bloc.add(const ScheduleBlocEvent.started());
      final loaded =
          await bloc.stream.firstWhere((s) => s is ScheduleLoaded)
              as ScheduleLoaded;

      expect(loaded.lastSyncedAt, fixedSync);
    });

    test(
      'syncHealth crosses to warning strictly after '
      'syncWarningThreshold, staying healthy exactly at the threshold',
      () async {
        final now = DateTime(2024, 1, 11, 8);
        const threshold = Duration(minutes: 30);

        Future<ScheduleSyncHealth> healthFor(DateTime lastSyncedAt) async {
          final repository = FakeScheduleRepository(today: fixedToday)
            ..lastSyncedAt = lastSyncedAt;
          final bloc = ScheduleBloc(
            scheduleRepository: repository,
            now: () => now,
            syncWarningThreshold: threshold,
          );
          addTearDown(bloc.close);

          bloc.add(const ScheduleBlocEvent.started());
          final loaded =
              await bloc.stream.firstWhere((s) => s is ScheduleLoaded)
                  as ScheduleLoaded;
          return loaded.syncHealth;
        }

        expect(
          await healthFor(now.subtract(threshold + const Duration(seconds: 1))),
          ScheduleSyncHealth.warning,
        );
        expect(
          await healthFor(now.subtract(threshold)),
          ScheduleSyncHealth.healthy,
        );
        expect(
          await healthFor(now.subtract(threshold - const Duration(seconds: 1))),
          ScheduleSyncHealth.healthy,
        );
      },
    );

    test('a stale window still emits ScheduleLoaded, never failure', () async {
      final repository = FakeScheduleRepository(today: fixedToday)
        ..lastSyncedAt = DateTime(2020);
      final bloc = ScheduleBloc(
        scheduleRepository: repository,
        now: () => DateTime(2024, 1, 11, 8),
      );
      addTearDown(bloc.close);

      bloc.add(const ScheduleBlocEvent.started());
      final loaded =
          await bloc.stream.firstWhere((s) => s is ScheduleLoaded)
              as ScheduleLoaded;

      expect(loaded.syncHealth, ScheduleSyncHealth.warning);
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
  Future<ScheduleWindow> fetchWindow({
    required DateTime anchor,
    bool forceSync = false,
  }) async {
    throw StateError('boom');
  }
}

/// Delays only the first `forceSync: true` call — simulating the
/// 15-minute refresh's fetch staying in flight — while every other call
/// (including a concurrent `weekChanged`) resolves immediately.
/// [FakeScheduleRepository.fetchDelay] can't express this: it holds every
/// call open by the same amount, which can never let a later call finish
/// first.
class _SlowFirstForceSyncScheduleRepository extends FakeScheduleRepository {
  _SlowFirstForceSyncScheduleRepository({
    required this.delay,
    required DateTime super.today,
  });

  final Duration delay;
  bool _delayed = false;

  @override
  Future<ScheduleWindow> fetchWindow({
    required DateTime anchor,
    bool forceSync = false,
  }) async {
    if (forceSync && !_delayed) {
      _delayed = true;
      await Future<void>.delayed(delay);
    }
    return super.fetchWindow(anchor: anchor, forceSync: forceSync);
  }
}
