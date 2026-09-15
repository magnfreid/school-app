import 'package:calendar_config_repository/calendar_config_repository.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis_auth/auth_io.dart';

/// The slice of the Calendar API this package uses.
///
/// Not exported from the barrel: internal to the package, injected so the
/// repository's tests need no network and no real credentials.
abstract interface class CalendarEventsSource {
  /// Returns every event on [config]'s calendar between [timeMin]
  /// (inclusive) and [timeMax] (exclusive), across as many pages as the
  /// Calendar API returns.
  Future<List<Event>> listEvents({
    required CalendarConfig config,
    required DateTime timeMin,
    required DateTime timeMax,
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
  /// [listEvents] call, guarding against an API that never stops paging.
  static const _maxPages = 10;

  AutoRefreshingAuthClient? _client;
  CalendarConfig? _clientConfig;

  @override
  Future<List<Event>> listEvents({
    required CalendarConfig config,
    required DateTime timeMin,
    required DateTime timeMax,
  }) async {
    final client = await _clientFor(config);
    final calendarApi = CalendarApi(client);

    final events = <Event>[];
    String? pageToken;
    var pageCount = 0;
    do {
      pageCount++;
      if (pageCount > _maxPages) {
        throw StateError('Calendar returned more pages than expected.');
      }
      final response = await calendarApi.events.list(
        config.calendarId,
        timeMin: timeMin,
        timeMax: timeMax,
        singleEvents: true,
        orderBy: 'startTime',
        maxResults: 2500,
        showDeleted: false,
        pageToken: pageToken,
      );
      events.addAll(response.items ?? const []);
      pageToken = response.nextPageToken;
    } while (pageToken != null);

    return events;
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
