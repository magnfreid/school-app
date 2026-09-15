import 'package:calendar_config_repository/calendar_config_repository.dart';
import 'package:flutter_test/flutter_test.dart';

const _testKey = ServiceAccountKey('{"placeholder":"not-a-real-key"}');

void main() {
  test('FakeCalendarConfigRepository: delayed save resolving after dispose is '
      'safe', () async {
    final repo = FakeCalendarConfigRepository(
      saveDelay: const Duration(milliseconds: 30),
    );
    final save = repo.save(
      const CalendarConfig(calendarId: 'x', serviceAccountKey: _testKey),
    );
    await repo.dispose();

    await expectLater(save, completes);
  });

  group('FakeCalendarConfigRepository', () {
    late FakeCalendarConfigRepository repository;

    setUp(() {
      repository = FakeCalendarConfigRepository();
      addTearDown(repository.dispose);
    });

    test('defaults to null (unconfigured) when no initialConfig is given', () {
      expect(repository.configChanges, emits(isNull));
    });

    test('initialConfig seeds a config', () {
      final seeded = FakeCalendarConfigRepository(
        initialConfig: const CalendarConfig(
          calendarId: 'seeded',
          serviceAccountKey: _testKey,
        ),
      );
      addTearDown(seeded.dispose);

      expect(
        seeded.configChanges,
        emits(
          const CalendarConfig(
            calendarId: 'seeded',
            serviceAccountKey: _testKey,
          ),
        ),
      );
    });

    test('saveCalls records both calls in order', () async {
      await repository.save(
        const CalendarConfig(calendarId: 'a', serviceAccountKey: _testKey),
      );
      await repository.save(
        const CalendarConfig(calendarId: 'b', serviceAccountKey: _testKey),
      );

      expect(repository.saveCalls, [
        const CalendarConfig(calendarId: 'a', serviceAccountKey: _testKey),
        const CalendarConfig(calendarId: 'b', serviceAccountKey: _testKey),
      ]);
    });

    test('save emits the config', () async {
      expect(
        repository.configChanges,
        emitsInOrder([
          isNull,
          const CalendarConfig(calendarId: 'a', serviceAccountKey: _testKey),
        ]),
      );

      await repository.save(
        const CalendarConfig(calendarId: 'a', serviceAccountKey: _testKey),
      );
    });

    test('saveError makes save throw, still records the call, and leaves the '
        'stream unchanged', () async {
      repository.saveError = const CalendarConfigException('nope');

      await expectLater(
        () => repository.save(
          const CalendarConfig(calendarId: 'a', serviceAccountKey: _testKey),
        ),
        throwsA(isA<CalendarConfigException>()),
      );

      expect(repository.saveCalls, [
        const CalendarConfig(calendarId: 'a', serviceAccountKey: _testKey),
      ]);
      await expectLater(repository.configChanges, emits(isNull));
    });

    test('saveError can be cleared mid-run', () async {
      repository.saveError = const CalendarConfigException('nope');
      await expectLater(
        () => repository.save(
          const CalendarConfig(calendarId: 'a', serviceAccountKey: _testKey),
        ),
        throwsA(isA<CalendarConfigException>()),
      );

      repository.saveError = null;
      await repository.save(
        const CalendarConfig(calendarId: 'a', serviceAccountKey: _testKey),
      );

      expect(repository.saveCalls, hasLength(2));
    });

    test('saveDelay holds the call open', () async {
      final delayedRepository = FakeCalendarConfigRepository(
        saveDelay: const Duration(milliseconds: 50),
      );
      addTearDown(delayedRepository.dispose);

      final stopwatch = Stopwatch()..start();
      await delayedRepository.save(
        const CalendarConfig(calendarId: 'a', serviceAccountKey: _testKey),
      );
      stopwatch.stop();

      expect(stopwatch.elapsedMilliseconds, greaterThanOrEqualTo(50));
    });

    test('clear increments clearCount and emits null', () async {
      await repository.save(
        const CalendarConfig(calendarId: 'a', serviceAccountKey: _testKey),
      );
      await expectLater(
        repository.configChanges,
        emits(
          const CalendarConfig(calendarId: 'a', serviceAccountKey: _testKey),
        ),
      );

      await repository.clear();

      expect(repository.clearCount, 1);
      await expectLater(repository.configChanges, emits(isNull));
    });

    test('emit pushes out-of-band changes', () {
      expect(
        repository.configChanges,
        emitsInOrder([
          isNull,
          const CalendarConfig(
            calendarId: 'external',
            serviceAccountKey: _testKey,
          ),
        ]),
      );

      repository.emit(
        const CalendarConfig(
          calendarId: 'external',
          serviceAccountKey: _testKey,
        ),
      );
    });

    test('does not drop a change emitted in the subscribing turn', () async {
      final seen = <CalendarConfig?>[];
      final subscription = repository.configChanges.listen(seen.add);
      addTearDown(subscription.cancel);

      repository.emit(
        const CalendarConfig(calendarId: 'a', serviceAccountKey: _testKey),
      );
      await pumpEventQueue();

      expect(seen, [
        null,
        const CalendarConfig(calendarId: 'a', serviceAccountKey: _testKey),
      ]);
    });
  });
}
