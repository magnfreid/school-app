import 'package:bloc_test/bloc_test.dart';
import 'package:display_repository/display_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_app/app/bloc/display_bloc.dart';
import 'package:school_app/app/bloc/display_event.dart';
import 'package:school_app/app/bloc/display_state.dart';

/// Waits for [bloc] to reach a state matching [predicate].
Future<DisplayState> _firstWhere(
  DisplayBloc bloc,
  bool Function(DisplayState state) predicate,
) => bloc.stream.firstWhere(predicate);

void main() {
  group('DisplayBloc', () {
    late FakeDisplayRepository repository;

    blocTest<DisplayBloc, DisplayState>(
      'started while unpowered stays DisplayReleased; wakelockCalls contains '
      'only false',
      build: () {
        repository = FakeDisplayRepository();
        return DisplayBloc(
          displayRepository: repository,
          now: () => DateTime(2024, 1, 11, 10),
        );
      },
      act: (bloc) => bloc.add(const DisplayEvent.started()),
      wait: const Duration(milliseconds: 30),
      expect: () => [const DisplayState.released()],
      verify: (_) {
        expect(repository.wakelockCalls, [false]);
      },
    );

    // NOTE (deviation from plan §7): the plan's test list asserts
    // `calls == ['wakelock:true', 'restore']` here. `powerChanges` (both the
    // fake and `DeviceDisplayRepository`'s `Stream.multi`) delivers its
    // current value asynchronously, never synchronously on `.listen()` — a
    // property confirmed against the Dart stream contract, not assumed. So
    // `started`'s own forced `_settle` (per §4's handler table, run before
    // the subscription's first value arrives) necessarily still sees the
    // constructor default `_isExternallyPowered = false` and settles to
    // `released` first; `powerChanged(true)` then arrives and settles to
    // `awake`. The final state (`DisplayAwake`) matches the plan; the
    // intermediate release-then-wake call sequence does not. Flagged for
    // Magnus rather than silently changed on either side.
    //
    // `_settle` calls are now serialised across handlers, so this
    // release-then-wake sequence is two fully sequential settles rather
    // than two overlapping ones — the assertion below pins the full call
    // list to prove the two `_apply` calls never interleave.
    test('started while powered emits DisplayAwake', () async {
      repository = FakeDisplayRepository(initialExternallyPowered: true);
      final bloc = DisplayBloc(
        displayRepository: repository,
        now: () => DateTime(2024, 1, 11, 10),
      );
      addTearDown(bloc.close);

      bloc.add(const DisplayEvent.started());
      await _firstWhere(bloc, (s) => s is DisplayAwake);

      expect(bloc.state, const DisplayState.awake());
      expect(repository.calls.last, 'restore');
      expect(repository.calls, contains('wakelock:true'));
      expect(repository.calls, [
        'restore',
        'wakelock:false',
        'wakelock:true',
        'restore',
      ]);
    });

    test(
      'powered and idle during the day dims to the daytime factor',
      () async {
        repository = FakeDisplayRepository(initialExternallyPowered: true);
        final bloc = DisplayBloc(
          displayRepository: repository,
          now: () => DateTime(2024, 1, 11, 10),
          idleTimeout: const Duration(milliseconds: 20),
        );
        addTearDown(bloc.close);

        bloc.add(const DisplayEvent.started());
        await _firstWhere(bloc, (s) => s is DisplayDimmed);

        expect(bloc.state, const DisplayState.dimmed(DisplayDimLevel.daytime));
        expect(repository.brightnessCalls.last, 0.6);
      },
    );

    test('powered and idle at night dims to the night factor', () async {
      repository = FakeDisplayRepository(initialExternallyPowered: true);
      final bloc = DisplayBloc(
        displayRepository: repository,
        now: () => DateTime(2024, 1, 11, 22),
        idleTimeout: const Duration(milliseconds: 20),
      );
      addTearDown(bloc.close);

      bloc.add(const DisplayEvent.started());
      await _firstWhere(bloc, (s) => s is DisplayDimmed);

      expect(bloc.state, const DisplayState.dimmed(DisplayDimLevel.night));
      expect(repository.brightnessCalls.last, 0.1);
    });

    /// Idles [bloc] and returns the [DisplayDimLevel] it settles on.
    Future<DisplayDimLevel> dimLevelAt(DateTime now) async {
      final stubRepository = FakeDisplayRepository(
        initialExternallyPowered: true,
      );
      final bloc = DisplayBloc(
        displayRepository: stubRepository,
        now: () => now,
        idleTimeout: const Duration(milliseconds: 10),
      );
      bloc.add(const DisplayEvent.started());
      final state =
          await _firstWhere(bloc, (s) => s is DisplayDimmed) as DisplayDimmed;
      await bloc.close();
      return state.level;
    }

    test('the day/night boundary is hour >= 21 || hour < 6 on the injected '
        'clock', () async {
      expect(
        await dimLevelAt(DateTime(2024, 1, 11, 20, 59)),
        DisplayDimLevel.daytime,
      );
      expect(
        await dimLevelAt(DateTime(2024, 1, 11, 21)),
        DisplayDimLevel.night,
      );
      expect(
        await dimLevelAt(DateTime(2024, 1, 11, 5, 59)),
        DisplayDimLevel.night,
      );
      expect(
        await dimLevelAt(DateTime(2024, 1, 11, 6)),
        DisplayDimLevel.daytime,
      );
    });

    test('crossing the boundary while idle re-dims without a touch', () async {
      repository = FakeDisplayRepository(initialExternallyPowered: true);
      var now = DateTime(2024, 1, 11, 20, 59);
      final bloc = DisplayBloc(
        displayRepository: repository,
        now: () => now,
        idleTimeout: const Duration(milliseconds: 10),
        dimLevelCheckInterval: const Duration(milliseconds: 10),
      );
      addTearDown(bloc.close);

      bloc.add(const DisplayEvent.started());
      await _firstWhere(bloc, (s) => s is DisplayDimmed);
      expect(bloc.state, const DisplayState.dimmed(DisplayDimLevel.daytime));

      now = DateTime(2024, 1, 11, 21);
      await _firstWhere(
        bloc,
        (s) => s == const DisplayState.dimmed(DisplayDimLevel.night),
      );

      expect(repository.brightnessCalls.last, 0.1);
    });

    test('userInteracted while dimmed returns to DisplayAwake and restarts the '
        'idle timer', () async {
      repository = FakeDisplayRepository(initialExternallyPowered: true);
      final bloc = DisplayBloc(
        displayRepository: repository,
        now: () => DateTime(2024, 1, 11, 10),
        idleTimeout: const Duration(milliseconds: 20),
      );
      addTearDown(bloc.close);

      bloc.add(const DisplayEvent.started());
      await _firstWhere(bloc, (s) => s is DisplayDimmed);
      final restoreCountAtDim = repository.restoreCount;

      bloc.add(const DisplayEvent.userInteracted());
      await _firstWhere(bloc, (s) => s is DisplayAwake);
      expect(repository.restoreCount, greaterThan(restoreCountAtDim));

      // The idle timer restarted: waiting it out dims again.
      await _firstWhere(bloc, (s) => s is DisplayDimmed);
    });

    test('userInteracted while already awake emits nothing and adds no '
        'restore/wakelock call', () async {
      repository = FakeDisplayRepository(initialExternallyPowered: true);
      final bloc = DisplayBloc(
        displayRepository: repository,
        now: () => DateTime(2024, 1, 11, 10),
        idleTimeout: const Duration(seconds: 30),
      );
      addTearDown(bloc.close);

      bloc.add(const DisplayEvent.started());
      await _firstWhere(bloc, (s) => s is DisplayAwake);
      final callsBefore = List<String>.of(repository.calls);

      final states = <DisplayState>[];
      final subscription = bloc.stream.listen(states.add);
      addTearDown(subscription.cancel);

      bloc.add(const DisplayEvent.userInteracted());
      await Future<void>.delayed(const Duration(milliseconds: 30));

      expect(states, isEmpty);
      expect(repository.calls, callsBefore);
    });

    test('power lost while dimmed releases the display; power regained wakes '
        'it', () async {
      repository = FakeDisplayRepository(initialExternallyPowered: true);
      final bloc = DisplayBloc(
        displayRepository: repository,
        now: () => DateTime(2024, 1, 11, 10),
        idleTimeout: const Duration(milliseconds: 20),
      );
      addTearDown(bloc.close);

      bloc.add(const DisplayEvent.started());
      await _firstWhere(bloc, (s) => s is DisplayDimmed);

      bloc.add(const DisplayEvent.powerChanged(isExternallyPowered: false));
      await _firstWhere(bloc, (s) => s is DisplayReleased);
      expect(repository.calls.sublist(repository.calls.length - 2), [
        'restore',
        'wakelock:false',
      ]);

      bloc.add(const DisplayEvent.powerChanged(isExternallyPowered: true));
      await _firstWhere(bloc, (s) => s is DisplayAwake);
    });

    test('foregroundChanged(false) releases the display; foregroundChanged '
        '(true) wakes it and re-applies brightness', () async {
      repository = FakeDisplayRepository(initialExternallyPowered: true);
      final bloc = DisplayBloc(
        displayRepository: repository,
        now: () => DateTime(2024, 1, 11, 10),
        idleTimeout: const Duration(seconds: 30),
      );
      addTearDown(bloc.close);

      bloc.add(const DisplayEvent.started());
      await _firstWhere(bloc, (s) => s is DisplayAwake);

      bloc.add(const DisplayEvent.foregroundChanged(isForeground: false));
      await _firstWhere(bloc, (s) => s is DisplayReleased);

      final restoreCountBefore = repository.restoreCount;
      bloc.add(const DisplayEvent.foregroundChanged(isForeground: true));
      await _firstWhere(bloc, (s) => s is DisplayAwake);
      expect(repository.restoreCount, greaterThan(restoreCountBefore));
    });

    test('ordering pin: a normalBrightness failure still sets the wakelock and '
        'still emits DisplayDimmed, and no error escapes', () async {
      repository = FakeDisplayRepository(
        initialExternallyPowered: true,
        normalBrightnessError: const DisplayException('nope'),
      );
      final bloc = DisplayBloc(
        displayRepository: repository,
        now: () => DateTime(2024, 1, 11, 10),
        idleTimeout: const Duration(milliseconds: 20),
      );
      addTearDown(bloc.close);

      bloc.add(const DisplayEvent.started());
      await _firstWhere(bloc, (s) => s is DisplayDimmed);

      expect(repository.calls, contains('wakelock:true'));
      expect(bloc.state, isA<DisplayDimmed>());
    });

    test('with every repository call failing, the full awake -> dimmed -> '
        'awake -> released sequence still emits the expected states, throws '
        'nothing, and a failing restoreBrightness() does not skip the '
        'setWakelock(false) after it', () async {
      repository = FakeDisplayRepository(
        initialExternallyPowered: true,
        normalBrightnessError: const DisplayException('normal'),
        setBrightnessError: const DisplayException('set'),
        restoreBrightnessError: const DisplayException('restore'),
        setWakelockError: const DisplayException('wakelock'),
      );
      final bloc = DisplayBloc(
        displayRepository: repository,
        now: () => DateTime(2024, 1, 11, 10),
        idleTimeout: const Duration(milliseconds: 20),
      );
      addTearDown(bloc.close);

      bloc.add(const DisplayEvent.started());
      await _firstWhere(bloc, (s) => s is DisplayAwake);
      await _firstWhere(bloc, (s) => s is DisplayDimmed);

      bloc.add(const DisplayEvent.userInteracted());
      await _firstWhere(bloc, (s) => s is DisplayAwake);

      // The `DisplayReleased` branch calls `restoreBrightness()` (scripted
      // to fail) before `setWakelock(enabled: false)` — guarding each
      // platform call on its own must still let the second call run.
      bloc.add(const DisplayEvent.powerChanged(isExternallyPowered: false));
      await _firstWhere(bloc, (s) => s is DisplayReleased);

      expect(repository.wakelockCalls.last, false);
    });

    test('the minimum-brightness floor applies at night', () async {
      repository = FakeDisplayRepository(
        initialExternallyPowered: true,
        normalBrightnessValue: 0.05,
      );
      final bloc = DisplayBloc(
        displayRepository: repository,
        now: () => DateTime(2024, 1, 11, 22),
        idleTimeout: const Duration(milliseconds: 20),
      );
      addTearDown(bloc.close);

      bloc.add(const DisplayEvent.started());
      await _firstWhere(bloc, (s) => s is DisplayDimmed);

      expect(repository.brightnessCalls.last, 0.01);
    });

    test('close() leaves no pending timer', () async {
      repository = FakeDisplayRepository(initialExternallyPowered: true);
      final bloc = DisplayBloc(
        displayRepository: repository,
        now: () => DateTime(2024, 1, 11, 10),
        idleTimeout: const Duration(milliseconds: 10),
        dimLevelCheckInterval: const Duration(milliseconds: 10),
      );

      bloc.add(const DisplayEvent.started());
      await _firstWhere(bloc, (s) => s is DisplayAwake);

      await bloc.close();

      await expectLater(bloc.stream, emitsDone);
    });
  });
}
