import 'package:calendar_config_repository/calendar_config_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ServiceAccountKey', () {
    test('toString() does not contain the JSON', () {
      const key = ServiceAccountKey(
        '{"private_key":"not-a-real-key","client_email":"a@b.com"}',
      );

      expect(key.toString(), isNot(contains('private_key')));
      expect(key.toString(), isNot(contains('a@b.com')));
    });

    test('two keys with equal JSON are == with equal hashCode', () {
      const a = ServiceAccountKey('{"test":"not-a-real-key"}');
      const b = ServiceAccountKey('{"test":"not-a-real-key"}');

      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });

    test('CalendarConfig.toString() does not contain the JSON', () {
      const config = CalendarConfig(
        calendarId: 'cal-1',
        serviceAccountKey: ServiceAccountKey(
          '{"private_key":"not-a-real-key"}',
        ),
      );

      expect(config.toString(), isNot(contains('private_key')));
    });
  });
}
