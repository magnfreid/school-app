import 'dart:async';

import 'package:calendar_config_repository/calendar_config_repository.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:schedule_repository/schedule_repository.dart';
import 'package:schedule_repository/src/calendar_events_source.dart';
import 'package:test/test.dart';

const _testKey = ServiceAccountKey('{"test":"not-a-real-key"}');
const _configuredConfig = CalendarConfig(
  calendarId: 'cal-1',
  serviceAccountKey: _testKey,
);

/// Scriptable [CalendarEventsSource] double. Records every call and throws
/// [error] (when set) instead of returning [events]. When [hang] is `true`,
/// [listEvents] never completes — used to pin timeout behaviour.
class _FakeCalendarEventsSource implements CalendarEventsSource {
  List<Event> events = const [];
  Object? error;
  bool hang = false;
  int closeCount = 0;

  final List<CalendarConfig> configCalls = [];
  final List<DateTime> timeMinCalls = [];
  final List<DateTime> timeMaxCalls = [];

  @override
  Future<List<Event>> listEvents({
    required CalendarConfig config,
    required DateTime timeMin,
    required DateTime timeMax,
  }) async {
    configCalls.add(config);
    timeMinCalls.add(timeMin);
    timeMaxCalls.add(timeMax);
    if (hang) return Completer<List<Event>>().future;
    final scriptedError = error;
    if (scriptedError != null) throw scriptedError;
    return events;
  }

  @override
  Future<void> close() async {
    closeCount++;
  }
}

/// [CalendarConfigRepository] whose [configChanges] always errors.
///
/// [FakeCalendarConfigRepository] cannot script a stream error, and
/// `test/helpers/app_harness.dart`'s `SilentCalendarConfigRepository` is the
/// existing precedent for a one-behaviour hand-written double.
class _ErroringCalendarConfigRepository implements CalendarConfigRepository {
  @override
  Stream<CalendarConfig?> get configChanges =>
      Stream.error(const CalendarConfigException('boom'));

  @override
  Future<void> save(CalendarConfig config) async {}

  @override
  Future<void> clear() async {}

  @override
  Future<void> dispose() async {}
}

void main() {
  group('GoogleCalendarScheduleRepository', () {
    late _FakeCalendarEventsSource source;
    late FakeCalendarConfigRepository configRepository;
    late GoogleCalendarScheduleRepository repository;

    setUp(() {
      source = _FakeCalendarEventsSource();
      configRepository = FakeCalendarConfigRepository(
        initialConfig: _configuredConfig,
      );
      repository = GoogleCalendarScheduleRepository(
        configRepository: configRepository,
        eventsSource: source,
      );
    });

    tearDown(() async {
      await repository.dispose();
      await configRepository.dispose();
    });

    test('window has 5 consecutive Mondays ascending, anchor at index '
        'windowRadiusInWeeks', () async {
      final anchor = DateTime(2026, 9, 17); // a Thursday, week of Sep 14
      final window = await repository.fetchWindow(anchor: anchor);

      expect(window, hasLength(2 * ScheduleRepository.windowRadiusInWeeks + 1));
      for (var i = 0; i < window.length; i++) {
        expect(window[i].weekStart.weekday, DateTime.monday);
        if (i > 0) {
          expect(
            window[i].weekStart.difference(window[i - 1].weekStart).inDays,
            7,
          );
        }
      }
      expect(
        window[ScheduleRepository.windowRadiusInWeeks].weekStart,
        DateTime(2026, 9, 14),
      );
    });

    test('exactly one listEvents call per fetchWindow, with the right '
        'calendarId/timeMin/timeMax', () async {
      final anchor = DateTime(2026, 9, 17); // week of Sep 14

      await repository.fetchWindow(anchor: anchor);

      expect(source.configCalls, hasLength(1));
      expect(source.configCalls.single.calendarId, 'cal-1');
      // Two weeks before the anchor week (Sep 14 - 14 days).
      expect(source.timeMinCalls.single, DateTime(2026, 8, 31));
      // Three weeks after the anchor week, exclusive (Sep 14 + 21 days).
      expect(source.timeMaxCalls.single, DateTime(2026, 10, 5));
    });

    test('unconfigured throws ScheduleException("No calendar is configured.") '
        'and never calls listEvents — the catch-ordering pin: a loose '
        'isA<ScheduleException>() here would still pass if the on '
        'ScheduleException rethrow clause were dropped and the catch-all '
        'silently rewrote the message', () async {
      final unconfiguredRepository = FakeCalendarConfigRepository();
      addTearDown(unconfiguredRepository.dispose);
      final unconfigured = GoogleCalendarScheduleRepository(
        configRepository: unconfiguredRepository,
        eventsSource: source,
      );
      addTearDown(unconfigured.dispose);

      try {
        await unconfigured.fetchWindow(anchor: DateTime(2026, 9, 17));
        fail('expected fetchWindow to throw');
      } catch (error) {
        expect(error, isA<ScheduleException>());
        expect(
          (error as ScheduleException).message,
          'No calendar is configured.',
        );
      }
      expect(source.configCalls, isEmpty);
    });

    test('a CalendarConfigException from configChanges maps to '
        '"Could not read the calendar configuration." with the original error '
        'as cause', () async {
      final erroringConfigRepository = _ErroringCalendarConfigRepository();
      final erroringRepository = GoogleCalendarScheduleRepository(
        configRepository: erroringConfigRepository,
        eventsSource: source,
      );
      addTearDown(erroringRepository.dispose);

      try {
        await erroringRepository.fetchWindow(anchor: DateTime(2026, 9, 17));
        fail('expected fetchWindow to throw');
      } catch (error) {
        expect(error, isA<ScheduleException>());
        final scheduleException = error as ScheduleException;
        expect(
          scheduleException.message,
          'Could not read the calendar configuration.',
        );
        expect(scheduleException.cause, isA<CalendarConfigException>());
      }
    });

    test('DetailedApiRequestError 403 -> not-shared message', () async {
      source.error = DetailedApiRequestError(403, 'Forbidden');

      try {
        await repository.fetchWindow(anchor: DateTime(2026, 9, 17));
        fail('expected fetchWindow to throw');
      } catch (error) {
        expect(error, isA<ScheduleException>());
        expect(
          (error as ScheduleException).message,
          'The calendar is not shared with this service account.',
        );
      }
    });

    test('DetailedApiRequestError 404 -> does-not-exist message', () async {
      source.error = DetailedApiRequestError(404, 'Not found');

      try {
        await repository.fetchWindow(anchor: DateTime(2026, 9, 17));
        fail('expected fetchWindow to throw');
      } catch (error) {
        expect(error, isA<ScheduleException>());
        expect(
          (error as ScheduleException).message,
          'The configured calendar does not exist.',
        );
      }
    });

    test('DetailedApiRequestError 500 -> rejected-request message', () async {
      source.error = DetailedApiRequestError(500, 'Server error');

      try {
        await repository.fetchWindow(anchor: DateTime(2026, 9, 17));
        fail('expected fetchWindow to throw');
      } catch (error) {
        expect(error, isA<ScheduleException>());
        expect(
          (error as ScheduleException).message,
          'The calendar service rejected the request.',
        );
      }
    });

    test('ServerRequestFailedException -> credentials-rejected message, no '
        'cause', () async {
      source.error = ServerRequestFailedException('bad', responseContent: null);

      try {
        await repository.fetchWindow(anchor: DateTime(2026, 9, 17));
        fail('expected fetchWindow to throw');
      } catch (error) {
        expect(error, isA<ScheduleException>());
        final scheduleException = error as ScheduleException;
        expect(
          scheduleException.message,
          'The service account credentials were rejected.',
        );
        expect(scheduleException.cause, isNull);
      }
    });

    test('FormatException -> not-valid-JSON message, no cause, and no secret '
        'text leaks into toString()', () async {
      source.error = const FormatException(
        'Unexpected character',
        '{"private_key":"SECRET"}',
      );

      try {
        await repository.fetchWindow(anchor: DateTime(2026, 9, 17));
        fail('expected fetchWindow to throw');
      } catch (error) {
        expect(error, isA<ScheduleException>());
        final scheduleException = error as ScheduleException;
        expect(
          scheduleException.message,
          'The stored service account key is not valid JSON.',
        );
        expect(scheduleException.cause, isNull);
        expect(scheduleException.toString(), isNot(contains('SECRET')));
      }
    });

    test('ArgumentError -> not-usable message, no cause', () async {
      source.error = ArgumentError('bad service account');

      try {
        await repository.fetchWindow(anchor: DateTime(2026, 9, 17));
        fail('expected fetchWindow to throw');
      } catch (error) {
        expect(error, isA<ScheduleException>());
        final scheduleException = error as ScheduleException;
        expect(
          scheduleException.message,
          'The stored service account key is not a usable service account.',
        );
        expect(scheduleException.cause, isNull);
      }
    });

    test('an unrecognized error -> "Could not read the schedule." with cause '
        'set', () async {
      source.error = Exception('network down');

      try {
        await repository.fetchWindow(anchor: DateTime(2026, 9, 17));
        fail('expected fetchWindow to throw');
      } catch (error) {
        expect(error, isA<ScheduleException>());
        final scheduleException = error as ScheduleException;
        expect(scheduleException.message, 'Could not read the schedule.');
        expect(scheduleException.cause, isNotNull);
      }
    });

    test('a stalled listEvents times out -> "Timed out fetching the '
        'calendar." with the TimeoutException as cause', () async {
      source.hang = true;
      final timingOutRepository = GoogleCalendarScheduleRepository(
        configRepository: configRepository,
        eventsSource: source,
        fetchTimeout: const Duration(milliseconds: 10),
      );
      addTearDown(timingOutRepository.dispose);

      try {
        await timingOutRepository.fetchWindow(anchor: DateTime(2026, 9, 17));
        fail('expected fetchWindow to throw');
      } catch (error) {
        expect(error, isA<ScheduleException>());
        final scheduleException = error as ScheduleException;
        expect(scheduleException.message, 'Timed out fetching the calendar.');
        expect(scheduleException.cause, isA<TimeoutException>());
      }
    });

    test('dispose() closes the source exactly once', () async {
      final localSource = _FakeCalendarEventsSource();
      final localRepository = GoogleCalendarScheduleRepository(
        configRepository: configRepository,
        eventsSource: localSource,
      );

      await localRepository.dispose();

      expect(localSource.closeCount, 1);
    });
  });
}
