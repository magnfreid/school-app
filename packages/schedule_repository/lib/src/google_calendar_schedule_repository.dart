import 'dart:async';

import 'package:calendar_config_repository/calendar_config_repository.dart';
import 'package:googleapis/calendar/v3.dart' show DetailedApiRequestError;
import 'package:googleapis_auth/googleapis_auth.dart'
    show ServerRequestFailedException;

import 'calendar_event_cache.dart';
import 'calendar_events_source.dart';
import 'google_calendar_event_mapper.dart';
import 'models/schedule_window.dart';
import 'schedule_exception.dart';
import 'schedule_repository.dart';
import 'week_math.dart';

/// [ScheduleRepository] backed by the Google Calendar API.
///
/// Reads through a service account: the calendar id and key come from
/// [CalendarConfigRepository] on every [fetchWindow] call — the
/// secure-storage implementation replays its current value on every
/// subscription, so `.first` per call costs nothing. The config is checked
/// on every call, including a warm-cache hit: a value different from the one
/// the cache was built for cannot go unnoticed after an unsubscribe followed
/// by a subscription to a different calendar, because it forces a cold
/// rebuild rather than reusing the stale cache.
///
/// Holds the current 5-week window's raw events in memory and refreshes them
/// with the Calendar API's `syncToken` instead of a full re-fetch. A window
/// around a different anchor, or a changed calendar configuration, discards
/// the cache and pulls fresh.
class GoogleCalendarScheduleRepository implements ScheduleRepository {
  /// Creates a [GoogleCalendarScheduleRepository] reading its configuration
  /// from [configRepository].
  ///
  /// [eventsSource] defaults to a real [GoogleCalendarEventsSource];
  /// override it in tests. [now] defaults to [DateTime.now]; inject a fixed
  /// clock in tests. [configTimeout] bounds how long a single [fetchWindow]
  /// call waits for [CalendarConfigRepository.configChanges] to emit before
  /// failing. [fetchTimeout] bounds how long the same call waits for a
  /// [CalendarEventsSource] call to complete before failing.
  GoogleCalendarScheduleRepository({
    required CalendarConfigRepository configRepository,
    CalendarEventsSource? eventsSource,
    DateTime Function()? now,
    Duration configTimeout = const Duration(seconds: 10),
    Duration fetchTimeout = const Duration(seconds: 10),
  }) : _configRepository = configRepository,
       _source = eventsSource ?? GoogleCalendarEventsSource(),
       _now = now ?? DateTime.now,
       _configTimeout = configTimeout,
       _fetchTimeout = fetchTimeout;

  final CalendarConfigRepository _configRepository;
  final CalendarEventsSource _source;
  final DateTime Function() _now;
  final Duration _configTimeout;
  final Duration _fetchTimeout;

  CalendarEventCache? _cache;
  CalendarConfig? _cacheConfig;

  @override
  Future<ScheduleWindow> fetchWindow({
    required DateTime anchor,
    bool forceSync = false,
  }) async {
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
      // Cheap — replayed from the current subscription, not a network call
      // — and read on every call so a config change (e.g. unsubscribe then
      // subscribe to a different calendar) is never served from a cache
      // built for the previous one.
      final config = await _readConfig();

      final cache = _cache;
      if (cache != null &&
          cache.windowStart == windowStart &&
          cache.isSynced &&
          _cacheConfig == config) {
        if (forceSync) {
          try {
            await _sync(cache, config);
          } catch (_) {
            // There is data to show; the stale `lastSyncedAt` is the signal
            // that the background sync failed. Swallowed deliberately — do
            // not touch `cache.lastSyncedAt` here.
          }
        }
        return _windowFrom(cache);
      }

      final newCache = CalendarEventCache(
        windowStart: windowStart,
        windowEnd: windowEnd,
      );
      await _fullPull(newCache, config);
      _cache = newCache;
      _cacheConfig = config;
      return _windowFrom(newCache);
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

  Future<void> _fullPull(
    CalendarEventCache cache,
    CalendarConfig config,
  ) async {
    final result = await _source
        .listEvents(
          config: config,
          timeMin: cache.windowStart,
          timeMax: cache.windowEnd,
        )
        .timeout(_fetchTimeout);
    cache.replaceAll(result.events);
    cache.syncToken = result.nextSyncToken;
    cache.lastSyncedAt = _now();
  }

  Future<void> _sync(CalendarEventCache cache, CalendarConfig config) async {
    final token = cache.syncToken;
    if (token == null) {
      await _fullPull(cache, config);
      return;
    }

    final CalendarEventsResult result;
    try {
      result = await _source
          .listChanges(config: config, syncToken: token)
          .timeout(_fetchTimeout);
    } on DetailedApiRequestError catch (error) {
      if (error.status == 410) {
        cache.syncToken = null;
        await _fullPull(cache, config);
        return;
      }
      rethrow;
    }

    cache.applyChanges(result.events);
    cache.syncToken = result.nextSyncToken;
    cache.lastSyncedAt = _now();
  }

  ScheduleWindow _windowFrom(CalendarEventCache cache) {
    return ScheduleWindow(
      weeks: mapCalendarEventsToWindow(
        events: cache.orderedEvents,
        windowStart: cache.windowStart,
        weekCount: 2 * ScheduleRepository.windowRadiusInWeeks + 1,
      ),
      lastSyncedAt: cache.lastSyncedAt!,
    );
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
  Future<void> dispose() {
    _cache = null;
    _cacheConfig = null;
    return _source.close();
  }
}
