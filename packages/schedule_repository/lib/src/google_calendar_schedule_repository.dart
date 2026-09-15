import 'dart:async';

import 'package:calendar_config_repository/calendar_config_repository.dart';
import 'package:googleapis/calendar/v3.dart' show DetailedApiRequestError;
import 'package:googleapis_auth/googleapis_auth.dart'
    show ServerRequestFailedException;

import 'calendar_events_source.dart';
import 'google_calendar_event_mapper.dart';
import 'models/week_schedule.dart';
import 'schedule_exception.dart';
import 'schedule_repository.dart';
import 'week_math.dart';

/// [ScheduleRepository] backed by the Google Calendar API.
///
/// Reads through a service account: the calendar id and key come from
/// [CalendarConfigRepository] on every fetch, never cached across calls — the
/// secure-storage implementation replays its current value on every
/// subscription, so `.first` per fetch costs nothing and cannot go stale
/// after an unsubscribe.
class GoogleCalendarScheduleRepository implements ScheduleRepository {
  /// Creates a [GoogleCalendarScheduleRepository] reading its configuration
  /// from [configRepository].
  ///
  /// [eventsSource] defaults to a real [GoogleCalendarEventsSource];
  /// override it in tests. [configTimeout] bounds how long a single
  /// [fetchWindow] call waits for [CalendarConfigRepository.configChanges] to
  /// emit before failing. [fetchTimeout] bounds how long the same call waits
  /// for [CalendarEventsSource.listEvents] to complete before failing.
  GoogleCalendarScheduleRepository({
    required CalendarConfigRepository configRepository,
    CalendarEventsSource? eventsSource,
    Duration configTimeout = const Duration(seconds: 10),
    Duration fetchTimeout = const Duration(seconds: 10),
  }) : _configRepository = configRepository,
       _source = eventsSource ?? GoogleCalendarEventsSource(),
       _configTimeout = configTimeout,
       _fetchTimeout = fetchTimeout;

  final CalendarConfigRepository _configRepository;
  final CalendarEventsSource _source;
  final Duration _configTimeout;
  final Duration _fetchTimeout;

  @override
  Future<List<WeekSchedule>> fetchWindow({required DateTime anchor}) async {
    const radius = ScheduleRepository.windowRadiusInWeeks;
    final anchorWeekStart = startOfIsoWeek(anchor);
    final windowStart = DateTime(
      anchorWeekStart.year,
      anchorWeekStart.month,
      anchorWeekStart.day - radius * 7,
    );
    final windowEnd = DateTime(
      anchorWeekStart.year,
      anchorWeekStart.month,
      anchorWeekStart.day + (radius + 1) * 7,
    );

    try {
      final config = await _readConfig();
      final events = await _source
          .listEvents(config: config, timeMin: windowStart, timeMax: windowEnd)
          .timeout(_fetchTimeout);
      return mapCalendarEventsToWindow(
        events: events,
        windowStart: windowStart,
        weekCount: 2 * radius + 1,
      );
    } on ScheduleException {
      rethrow;
    } on CalendarConfigException catch (error) {
      throw ScheduleException(
        'Could not read the calendar configuration.',
        cause: error,
      );
    } on TimeoutException catch (error) {
      throw ScheduleException('Timed out fetching the calendar.', cause: error);
    } on DetailedApiRequestError catch (error) {
      final status = error.status;
      if (status == 401 || status == 403) {
        throw ScheduleException(
          'The calendar is not shared with this service account.',
          cause: error,
        );
      }
      if (status == 404) {
        throw ScheduleException(
          'The configured calendar does not exist.',
          cause: error,
        );
      }
      throw ScheduleException(
        'The calendar service rejected the request.',
        cause: error,
      );
    } on ServerRequestFailedException {
      throw const ScheduleException(
        'The service account credentials were rejected.',
      );
    } on FormatException {
      throw const ScheduleException(
        'The stored service account key is not valid JSON.',
      );
    } on ArgumentError {
      throw const ScheduleException(
        'The stored service account key is not a usable service account.',
      );
    } catch (error) {
      throw ScheduleException('Could not read the schedule.', cause: error);
    }
  }

  Future<CalendarConfig> _readConfig() async {
    final CalendarConfig? config;
    try {
      config = await _configRepository.configChanges.first.timeout(
        _configTimeout,
      );
    } on TimeoutException catch (error) {
      throw ScheduleException(
        'Timed out reading the calendar configuration.',
        cause: error,
      );
    }
    if (config == null) {
      throw const ScheduleException('No calendar is configured.');
    }
    return config;
  }

  @override
  Future<void> dispose() => _source.close();
}
