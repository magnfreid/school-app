import 'package:googleapis/calendar/v3.dart';

import 'week_math.dart';

/// In-memory store of the raw Calendar events covering one window.
///
/// Pure logic, no API calls: the repository owns the clock and assigns
/// [lastSyncedAt] itself, never this class.
class CalendarEventCache {
  /// Creates an empty [CalendarEventCache] covering
  /// `[windowStart, windowEnd)`.
  CalendarEventCache({required this.windowStart, required this.windowEnd});

  /// Monday, local midnight, inclusive.
  final DateTime windowStart;

  /// Monday, local midnight, exclusive.
  final DateTime windowEnd;

  /// Token for the next incremental pull; `null` forces a full pull.
  String? syncToken;

  /// When the backend was last read successfully; `null` before the first
  /// successful pull.
  DateTime? lastSyncedAt;

  final Map<String, Event> _events = {};

  /// Whether this cache has completed at least one successful pull.
  bool get isSynced => lastSyncedAt != null;

  /// Discards everything cached and seeds from a full pull.
  void replaceAll(Iterable<Event> events) {
    _events.clear();
    applyChanges(events);
  }

  /// Merges one incremental page.
  ///
  /// Per event: no `id` (or an empty one) is skipped — it cannot be keyed.
  /// `status == 'cancelled'`, an unreadable start instant, or a start that
  /// falls outside the window all remove that id from the cache. Otherwise
  /// the event is upserted.
  void applyChanges(Iterable<Event> changes) {
    for (final event in changes) {
      final id = event.id;
      if (id == null || id.isEmpty) continue;

      if (event.status == 'cancelled') {
        _events.remove(id);
        continue;
      }

      final startDate = _startInstant(event);
      if (startDate == null) {
        _events.remove(id);
        continue;
      }

      final weekStart = startOfIsoWeek(startDate);
      if (weekStart.isBefore(windowStart) || !weekStart.isBefore(windowEnd)) {
        _events.remove(id);
        continue;
      }

      _events[id] = event;
    }
  }

  /// Cached events ascending by start instant, ties broken by id.
  List<Event> get orderedEvents {
    final events = _events.values.toList()
      ..sort((a, b) {
        final byInstant = _startInstant(a)!.compareTo(_startInstant(b)!);
        return byInstant != 0 ? byInstant : a.id!.compareTo(b.id!);
      });
    return events;
  }

  /// Start instant, mirroring `google_calendar_event_mapper.dart` exactly:
  /// all-day -> local midnight of [EventDateTime.date]; timed ->
  /// [EventDateTime.dateTime] converted to local time. `null` when neither is
  /// set.
  DateTime? _startInstant(Event event) {
    final start = event.start;
    if (start == null) return null;
    final startDate = start.date;
    if (startDate != null) {
      return DateTime(startDate.year, startDate.month, startDate.day);
    }
    final dateTime = start.dateTime;
    if (dateTime == null) return null;
    return dateTime.toLocal();
  }
}
