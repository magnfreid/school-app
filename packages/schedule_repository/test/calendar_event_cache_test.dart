import 'package:googleapis/calendar/v3.dart';
import 'package:schedule_repository/src/calendar_event_cache.dart';
import 'package:test/test.dart';

// windowStart is a Monday; windowEnd is exclusive, three weeks later — a
// small window is enough to exercise the merge rules.
final _windowStart = DateTime(2026, 9, 14);
final _windowEnd = DateTime(2026, 10, 5);

Event _event({String? id = 'evt-1', String? status, EventDateTime? start}) {
  return Event(id: id, status: status, start: start);
}

EventDateTime _allDay(DateTime date) =>
    EventDateTime(date: DateTime(date.year, date.month, date.day));

EventDateTime _timed(DateTime dateTime) => EventDateTime(dateTime: dateTime);

CalendarEventCache _newCache() =>
    CalendarEventCache(windowStart: _windowStart, windowEnd: _windowEnd);

void main() {
  group('CalendarEventCache', () {
    test('orderedEvents sorts a shuffled input ascending by start instant, '
        'all-day events at their local midnight, ties broken by id', () {
      final cache = _newCache();
      cache.applyChanges([
        _event(id: 'c', start: _timed(DateTime(2026, 9, 16, 9))),
        _event(id: 'a', start: _allDay(DateTime(2026, 9, 15))),
        _event(id: 'b', start: _timed(DateTime(2026, 9, 15, 8))),
        _event(id: 'd', start: _timed(DateTime(2026, 9, 16, 9))),
      ]);

      expect(cache.orderedEvents.map((e) => e.id).toList(), [
        'a',
        'b',
        'c',
        'd',
      ]);
    });

    test('applyChanges upserts by id — a second event with the same id '
        'replaces the first, and orderedEvents has one entry', () {
      final cache = _newCache();
      cache.applyChanges([
        _event(id: 'x', start: _timed(DateTime(2026, 9, 15, 8))),
      ]);
      cache.applyChanges([
        _event(id: 'x', start: _timed(DateTime(2026, 9, 16, 10))),
      ]);

      expect(cache.orderedEvents, hasLength(1));
      expect(
        cache.orderedEvents.single.start!.dateTime,
        DateTime(2026, 9, 16, 10),
      );
    });

    test("applyChanges with status: 'cancelled' removes an id that was "
        'cached', () {
      final cache = _newCache();
      cache.applyChanges([
        _event(id: 'y', start: _timed(DateTime(2026, 9, 15, 8))),
      ]);
      cache.applyChanges([_event(id: 'y', status: 'cancelled')]);

      expect(cache.orderedEvents, isEmpty);
    });

    test('applyChanges with an event whose start moved outside the window '
        'removes the previously cached copy', () {
      final cache = _newCache();
      cache.applyChanges([
        _event(id: 'z', start: _timed(DateTime(2026, 9, 15, 8))),
      ]);
      cache.applyChanges([
        _event(id: 'z', start: _allDay(DateTime(2026, 10, 12))),
      ]);

      expect(cache.orderedEvents.map((e) => e.id), isNot(contains('z')));
    });

    test('applyChanges skips an event with no id and one with no start; a '
        'no-start update to a cached id removes it', () {
      final cache = _newCache();
      cache.applyChanges([
        _event(id: null, start: _timed(DateTime(2026, 9, 15, 8))),
        _event(id: 'no-start'),
      ]);
      expect(cache.orderedEvents, isEmpty);

      cache.applyChanges([
        _event(id: 'w', start: _timed(DateTime(2026, 9, 15, 8))),
      ]);
      expect(cache.orderedEvents, hasLength(1));

      cache.applyChanges([_event(id: 'w')]);
      expect(cache.orderedEvents, isEmpty);
    });

    test('replaceAll drops everything previously cached, and drops '
        'cancelled / out-of-window entries from its own input', () {
      final cache = _newCache();
      cache.applyChanges([
        _event(id: 'old', start: _timed(DateTime(2026, 9, 15, 8))),
      ]);

      cache.replaceAll([
        _event(id: 'new', start: _timed(DateTime(2026, 9, 16, 9))),
        _event(id: 'cancelled', status: 'cancelled'),
        _event(id: 'outside', start: _allDay(DateTime(2026, 10, 12))),
      ]);

      expect(cache.orderedEvents.map((e) => e.id).toList(), ['new']);
    });

    test('an event on the last day of the last week of the window is kept, '
        'and one on the first day of the week after is dropped (the '
        'windowEnd-exclusive edge)', () {
      final cache = _newCache();
      // Last week of the window starts windowEnd - 7 days; its Sunday is
      // windowEnd - 1 day.
      final lastWeekSunday = DateTime(
        _windowEnd.year,
        _windowEnd.month,
        _windowEnd.day - 1,
      );
      final firstDayAfter = _windowEnd;

      cache.applyChanges([
        _event(id: 'kept', start: _allDay(lastWeekSunday)),
        _event(id: 'dropped', start: _allDay(firstDayAfter)),
      ]);

      expect(cache.orderedEvents.map((e) => e.id).toList(), ['kept']);
    });
  });
}
