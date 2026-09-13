import 'package:schedule_repository/src/week_math.dart';
import 'package:test/test.dart';

void main() {
  group('isoWeekNumber', () {
    // Verified against an external ISO-8601 calendar; do not recompute these
    // expectations by hand.
    const table = {
      '2026-09-14': 38,
      '2026-09-20': 38,
      '2026-01-01': 1,
      '2025-12-29': 1,
      '2026-12-28': 53,
      '2027-01-01': 53,
      '2021-01-04': 1,
      '2020-12-31': 53,
    };

    table.forEach((iso, expected) {
      test('$iso -> $expected', () {
        expect(isoWeekNumber(DateTime.parse(iso)), expected);
      });
    });
  });

  group('startOfIsoWeek', () {
    test('returns the same Monday for every day of that week', () {
      final monday = DateTime(2026, 9, 14);
      for (var day = 0; day < 7; day++) {
        final date = DateTime(2026, 9, 14 + day);
        expect(startOfIsoWeek(date), monday);
      }
    });

    test('is idempotent on a Monday', () {
      final monday = DateTime(2026, 9, 14);
      expect(startOfIsoWeek(monday), monday);
    });

    test('crosses the year boundary', () {
      expect(startOfIsoWeek(DateTime(2026, 1, 1)), DateTime(2025, 12, 29));
    });

    test('result always has hour == 0 and minute == 0, including across '
        'Swedish DST transitions', () {
      // This assertion only bites when the test is run in a DST-observing
      // local time zone (e.g. Europe/Stockholm) — DateTime.now()'s
      // surrounding zone determines whether this actually exercises the
      // transition, but the arithmetic must be correct regardless of zone.
      final dates = [
        DateTime(2026, 9, 17),
        DateTime(2026, 3, 29),
        DateTime(2026, 3, 30),
        DateTime(2026, 10, 25),
        DateTime(2026, 10, 26),
      ];
      for (final date in dates) {
        final start = startOfIsoWeek(date);
        expect(start.hour, 0);
        expect(start.minute, 0);
      }
    });
  });
}
