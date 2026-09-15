import 'package:googleapis/calendar/v3.dart';
import 'package:schedule_repository/schedule_repository.dart';
import 'package:schedule_repository/src/google_calendar_event_mapper.dart';
import 'package:schedule_repository/src/week_math.dart';
import 'package:test/test.dart';

final _windowStart = DateTime(2026, 9, 14); // a Monday
const _weekCount = 5;

Event _event({
  String? id = 'evt-1',
  String? summary,
  String? status,
  EventDateTime? start,
  Map<String, String>? private,
}) {
  return Event(
    id: id,
    summary: summary,
    status: status,
    start: start,
    extendedProperties: private == null
        ? null
        : EventExtendedProperties(private: private),
  );
}

List<WeekSchedule> _mapOne(Event event) => mapCalendarEventsToWindow(
  events: [event],
  windowStart: _windowStart,
  weekCount: _weekCount,
);

void main() {
  group('mapCalendarEventsToWindow', () {
    test('window shape: 5 consecutive Mondays at local midnight, ISO week '
        'numbers, empty lists where nothing lands', () {
      final window = mapCalendarEventsToWindow(
        events: const [],
        windowStart: _windowStart,
        weekCount: _weekCount,
      );

      expect(window, hasLength(_weekCount));
      for (var i = 0; i < window.length; i++) {
        final week = window[i];
        expect(week.weekStart.weekday, DateTime.monday);
        expect(week.weekStart.hour, 0);
        expect(week.weekStart.minute, 0);
        expect(
          week.weekStart,
          DateTime(_windowStart.year, _windowStart.month, 14 + i * 7),
        );
        expect(week.weekNumber, isoWeekNumber(week.weekStart));
        expect(week.events, isEmpty);
        expect(week.specialEvents, isEmpty);
      }
    });

    test('kind = schedule maps title/id from summary/id, never from '
        'extendedProperties', () {
      final window = _mapOne(
        _event(
          id: 'evt-42',
          summary: 'My Title',
          start: EventDateTime(date: DateTime(2026, 9, 14)),
          private: const {
            'kind': 'schedule',
            'subjectCode': 'MA',
            'severity': 'prov',
          },
        ),
      );

      final event = window[0].events.single;
      expect(event.id, 'evt-42');
      expect(event.title, 'My Title');
    });

    test('all-day event (start.date) yields time == null and date at local '
        'midnight of that date', () {
      final window = _mapOne(
        _event(
          start: EventDateTime(date: DateTime(2026, 9, 14)),
          private: const {'kind': 'schedule'},
        ),
      );

      final event = window[0].events.single;
      expect(event.time, isNull);
      expect(event.date, DateTime(2026, 9, 14));
    });

    test(
      'timed event (start.dateTime parsed from an offset string, arrives '
      'UTC-flagged) is converted to local time without shifting the instant',
      () {
        final source = DateTime.parse('2026-09-17T14:00:00+02:00');
        expect(source.isUtc, isTrue); // sanity: this is how it arrives

        final window = _mapOne(
          _event(
            start: EventDateTime(dateTime: source),
            private: const {'kind': 'schedule'},
          ),
        );

        final scheduleEvent = window.expand((week) => week.events).single;
        final time = scheduleEvent.time!;

        expect(time.isUtc, isFalse);
        expect(time.isAtSameMomentAs(source), isTrue);
        expect(scheduleEvent.date, DateTime(time.year, time.month, time.day));
      },
    );

    group('skips', () {
      test('no kind property at all', () {
        final window = _mapOne(
          _event(start: EventDateTime(date: DateTime(2026, 9, 14))),
        );
        expect(window.expand((week) => week.events), isEmpty);
        expect(window.expand((week) => week.specialEvents), isEmpty);
      });

      test('kind = "holiday"', () {
        final window = _mapOne(
          _event(
            start: EventDateTime(date: DateTime(2026, 9, 14)),
            private: const {'kind': 'holiday'},
          ),
        );
        expect(window.expand((week) => week.events), isEmpty);
        expect(window.expand((week) => week.specialEvents), isEmpty);
      });

      test("status: 'cancelled'", () {
        final window = _mapOne(
          _event(
            status: 'cancelled',
            start: EventDateTime(date: DateTime(2026, 9, 14)),
            private: const {'kind': 'schedule'},
          ),
        );
        expect(window.expand((week) => week.events), isEmpty);
      });

      test('id null', () {
        final window = _mapOne(
          _event(
            id: null,
            start: EventDateTime(date: DateTime(2026, 9, 14)),
            private: const {'kind': 'schedule'},
          ),
        );
        expect(window.expand((week) => week.events), isEmpty);
      });

      test('start null', () {
        final window = _mapOne(
          _event(start: null, private: const {'kind': 'schedule'}),
        );
        expect(window.expand((week) => week.events), isEmpty);
      });
    });

    group('schedule fallbacks', () {
      test('missing subjectCode -> ""', () {
        final window = _mapOne(
          _event(
            start: EventDateTime(date: DateTime(2026, 9, 14)),
            private: const {'kind': 'schedule'},
          ),
        );
        expect(window[0].events.single.subjectCode, '');
      });

      test('missing severity -> other', () {
        final window = _mapOne(
          _event(
            start: EventDateTime(date: DateTime(2026, 9, 14)),
            private: const {'kind': 'schedule'},
          ),
        );
        expect(window[0].events.single.severity, EventSeverity.other);
      });

      test('severity = "nonsense" -> other', () {
        final window = _mapOne(
          _event(
            start: EventDateTime(date: DateTime(2026, 9, 14)),
            private: const {'kind': 'schedule', 'severity': 'nonsense'},
          ),
        );
        expect(window[0].events.single.severity, EventSeverity.other);
      });

      test('missing kindLabel -> null', () {
        final window = _mapOne(
          _event(
            start: EventDateTime(date: DateTime(2026, 9, 14)),
            private: const {'kind': 'schedule'},
          ),
        );
        expect(window[0].events.single.kindLabel, isNull);
      });

      test('kindLabel = "  " -> null', () {
        final window = _mapOne(
          _event(
            start: EventDateTime(date: DateTime(2026, 9, 14)),
            private: const {'kind': 'schedule', 'kindLabel': '  '},
          ),
        );
        expect(window[0].events.single.kindLabel, isNull);
      });
    });

    group('severity table', () {
      const table = {
        'prov': EventSeverity.prov,
        'laxa': EventSeverity.laxa,
        'other': EventSeverity.other,
      };

      table.forEach((value, expected) {
        test('severity = "$value" -> $expected', () {
          final window = _mapOne(
            _event(
              start: EventDateTime(date: DateTime(2026, 9, 14)),
              private: {'kind': 'schedule', 'severity': value},
            ),
          );
          expect(window[0].events.single.severity, expected);
        });
      });
    });

    group('colorPreset table', () {
      const table = {
        'teal': SpecialEventColorPreset.teal,
        'amber': SpecialEventColorPreset.amber,
        'purple': SpecialEventColorPreset.purple,
        'green': SpecialEventColorPreset.green,
        'pink': SpecialEventColorPreset.pink,
      };

      table.forEach((value, expected) {
        test('colorPreset = "$value" -> $expected', () {
          final window = _mapOne(
            _event(
              start: EventDateTime(date: DateTime(2026, 9, 14)),
              private: {'kind': 'special', 'colorPreset': value, 'span': 'day'},
            ),
          );
          expect(window[0].specialEvents.single.colorPreset, expected);
        });
      });

      test('missing colorPreset -> teal', () {
        final window = _mapOne(
          _event(
            start: EventDateTime(date: DateTime(2026, 9, 14)),
            private: const {'kind': 'special'},
          ),
        );
        expect(
          window[0].specialEvents.single.colorPreset,
          SpecialEventColorPreset.teal,
        );
      });

      test('colorPreset = "nonsense" -> teal', () {
        final window = _mapOne(
          _event(
            start: EventDateTime(date: DateTime(2026, 9, 14)),
            private: const {'kind': 'special', 'colorPreset': 'nonsense'},
          ),
        );
        expect(
          window[0].specialEvents.single.colorPreset,
          SpecialEventColorPreset.teal,
        );
      });
    });

    test(
      'span = "week" -> SpecialEventWholeWeek in the week its start falls in',
      () {
        final window = _mapOne(
          _event(
            summary: 'Temavecka',
            start: EventDateTime(date: DateTime(2026, 9, 16)),
            private: const {
              'kind': 'special',
              'colorPreset': 'teal',
              'span': 'week',
            },
          ),
        );

        final special = window[0].specialEvents.single;
        expect(special, isA<SpecialEventWholeWeek>());
      },
    );

    group('span = "day", missing, and unknown all yield SpecialEventDay', () {
      for (final span in ['day', null, 'nonsense']) {
        test('span = $span', () {
          final private = <String, String>{
            'kind': 'special',
            'colorPreset': 'amber',
          };
          if (span != null) private['span'] = span;

          final window = _mapOne(
            _event(
              summary: 'Friluftsdag',
              start: EventDateTime(date: DateTime(2026, 9, 16)),
              private: private,
            ),
          );

          final special = window[0].specialEvents.single;
          expect(special, isA<SpecialEventDay>());
          expect((special as SpecialEventDay).date, DateTime(2026, 9, 16));
        });
      }
    });

    test('an event before windowStart and one after the last week are both '
        'dropped; an event in week index 3 lands in week index 3, not 2', () {
      final beforeWindow = _event(
        id: 'before',
        start: EventDateTime(date: DateTime(2026, 9, 7)),
        private: const {'kind': 'schedule'},
      );
      final afterWindow = _event(
        id: 'after',
        start: EventDateTime(date: DateTime(2026, 10, 19)),
        private: const {'kind': 'schedule'},
      );
      final inWeek3 = _event(
        id: 'week-3',
        start: EventDateTime(date: DateTime(2026, 10, 6)),
        private: const {'kind': 'schedule'},
      );

      final window = mapCalendarEventsToWindow(
        events: [beforeWindow, afterWindow, inWeek3],
        windowStart: _windowStart,
        weekCount: _weekCount,
      );

      expect(window.expand((week) => week.events), hasLength(1));
      expect(window[3].events.single.id, 'week-3');
      expect(window[2].events, isEmpty);
    });

    test('two schedule events on the same day keep input order', () {
      final first = _event(
        id: 'first',
        start: EventDateTime(date: DateTime(2026, 9, 14)),
        private: const {'kind': 'schedule'},
      );
      final second = _event(
        id: 'second',
        start: EventDateTime(date: DateTime(2026, 9, 14)),
        private: const {'kind': 'schedule'},
      );

      final window = mapCalendarEventsToWindow(
        events: [first, second],
        windowStart: _windowStart,
        weekCount: _weekCount,
      );

      expect(window[0].events.map((e) => e.id), ['first', 'second']);
    });
  });
}
