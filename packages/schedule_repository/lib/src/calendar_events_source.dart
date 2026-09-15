import 'package:calendar_config_repository/calendar_config_repository.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis_auth/auth_io.dart';

/// One `events.list` response, flattened across pages.
class CalendarEventsResult {
  /// Creates a [CalendarEventsResult].
  const CalendarEventsResult({required this.events, this.nextSyncToken});

  /// Every event returned, across all pages.
  final List<Event> events;

  /// Token for the next incremental pull, from the last page. `null` when
  /// the backend did not issue one.
  final String? nextSyncToken;
}

/// The slice of the Calendar API this package uses.
///
/// Not exported from the barrel: internal to the package, injected so the
/// repository's tests need no network and no real credentials.
abstract interface class CalendarEventsSource {
  /// Full pull of every event on [config]'s calendar between [timeMin]
  /// (inclusive) and [timeMax] (exclusive), across as many pages as the
  /// Calendar API returns.
  Future<CalendarEventsResult> listEvents({
    required CalendarConfig config,
    required DateTime timeMin,
    required DateTime timeMax,
  });

  /// Incremental pull of everything changed since [syncToken] was issued.
  Future<CalendarEventsResult> listChanges({
    required CalendarConfig config,
    required String syncToken,
  });

  /// Releases any HTTP client held by this source. Safe to call twice.
  Future<void> close();
}

/// [CalendarEventsSource] backed by googleapis + googleapis_auth.
///
/// A pass-through: it catches nothing and maps nothing, the same contract as
/// `FlutterSecureStore`. Every vendor failure surfaces to the repository,
/// which maps it onto a `ScheduleException`.
class GoogleCalendarEventsSource implements CalendarEventsSource {
  /// Creates a [GoogleCalendarEventsSource].
  GoogleCalendarEventsSource();

  /// Hard cap on the number of `events.list` pages fetched for a single
  /// [listEvents] or [listChanges] call, guarding against an API that never
  /// stops paging.
  static const _maxPages = 10;

  AutoRefreshingAuthClient? _client;
  CalendarConfig? _clientConfig;

  @override
  Future<CalendarEventsResult> listEvents({
    required CalendarConfig config,
    required DateTime timeMin,
    required DateTime timeMax,
  }) async {
    final client = await _clientFor(config);
    final calendarApi = CalendarApi(client);

    return _listPages(
      (pageToken) => calendarApi.events.list(
        config.calendarId,
        timeMin: timeMin,
        timeMax: timeMax,
        singleEvents: true,
        maxResults: 2500,
        showDeleted: true,
        pageToken: pageToken,
      ),
    );
  }

  @override
  Future<CalendarEventsResult> listChanges({
    required CalendarConfig config,
    required String syncToken,
  }) async {
    final client = await _clientFor(config);
    final calendarApi = CalendarApi(client);

    return _listPages(
      (pageToken) => calendarApi.events.list(
        config.calendarId,
        singleEvents: true,
        maxResults: 2500,
        showDeleted: true,
        syncToken: syncToken,
        pageToken: pageToken,
      ),
    );
  }

  /// Pages through `events.list`, calling [requestPage] with each
  /// `pageToken` in turn. `nextSyncToken` only appears on the last page, so
  /// each iteration's value (when non-null) is kept over the previous one.
  Future<CalendarEventsResult> _listPages(
    Future<Events> Function(String? pageToken) requestPage,
  ) async {
    final events = <Event>[];
    String? pageToken;
    String? nextSyncToken;
    var pageCount = 0;
    do {
      pageCount++;
      if (pageCount > _maxPages) {
        throw StateError('Calendar returned more pages than expected.');
      }
      final response = await requestPage(pageToken);
      events.addAll(response.items ?? const []);
      nextSyncToken = response.nextSyncToken ?? nextSyncToken;
      pageToken = response.nextPageToken;
    } while (pageToken != null);

    return CalendarEventsResult(events: events, nextSyncToken: nextSyncToken);
  }

  Future<AutoRefreshingAuthClient> _clientFor(CalendarConfig config) async {
    final cachedClient = _client;
    if (cachedClient != null && _clientConfig == config) {
      return cachedClient;
    }
    if (cachedClient != null) {
      cachedClient.close();
    }

    final credentials = ServiceAccountCredentials.fromJson(
      config.serviceAccountKey.json,
    );
    final client = await clientViaServiceAccount(credentials, [
      CalendarApi.calendarEventsReadonlyScope,
    ]);

    _client = client;
    _clientConfig = config;
    return client;
  }

  @override
  Future<void> close() async {
    _client?.close();
    _client = null;
    _clientConfig = null;
  }
}
