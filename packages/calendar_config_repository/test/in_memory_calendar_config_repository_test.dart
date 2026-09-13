import 'package:calendar_config_repository/calendar_config_repository.dart';
import 'package:test/test.dart';

void main() {
  group('InMemoryCalendarConfigRepository', () {
    late InMemoryCalendarConfigRepository repository;

    setUp(() {
      repository = InMemoryCalendarConfigRepository();
      addTearDown(repository.dispose);
    });

    test('emits the placeholder config to a subscriber that arrives before '
        'anything happens', () {
      expect(
        repository.configChanges,
        emits(const CalendarConfig(calendarId: 'in-memory-calendar')),
      );
    });

    test('save emits the new config and carries calendarId through', () async {
      expect(
        repository.configChanges,
        emitsInOrder([
          const CalendarConfig(calendarId: 'in-memory-calendar'),
          const CalendarConfig(calendarId: 'new-calendar'),
        ]),
      );

      await repository.save(const CalendarConfig(calendarId: 'new-calendar'));
    });

    test('clear emits null', () async {
      expect(
        repository.configChanges,
        emitsInOrder([
          const CalendarConfig(calendarId: 'in-memory-calendar'),
          isNull,
        ]),
      );

      await repository.clear();
    });

    test('an empty calendarId throws CalendarConfigException and leaves the '
        'previous config on the stream', () async {
      await expectLater(
        () => repository.save(const CalendarConfig(calendarId: '')),
        throwsA(isA<CalendarConfigException>()),
      );

      await expectLater(
        repository.configChanges,
        emits(const CalendarConfig(calendarId: 'in-memory-calendar')),
      );
    });

    test('a save resolving after dispose() does not throw', () async {
      // The 300ms delay means dispose() can land mid-flight. Adding to a
      // closed StreamController throws "Cannot add new events after close".
      final save = repository.save(
        const CalendarConfig(calendarId: 'new-calendar'),
      );
      await repository.dispose();

      await expectLater(save, completes);
    });

    test('replays the current config to a late subscriber', () async {
      await repository.save(const CalendarConfig(calendarId: 'new-calendar'));

      await expectLater(
        repository.configChanges,
        emits(const CalendarConfig(calendarId: 'new-calendar')),
      );
    });

    test('does not drop a change emitted in the subscribing turn', () async {
      final seen = <CalendarConfig?>[];
      final subscription = repository.configChanges.listen(seen.add);
      addTearDown(subscription.cancel);

      await repository.clear();
      await pumpEventQueue();

      expect(seen, [
        const CalendarConfig(calendarId: 'in-memory-calendar'),
        null,
      ]);
    });
  });
}
