import 'package:bloc_utils/bloc_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_repository/schedule_repository.dart';

import 'schedule_event.dart';
import 'schedule_state.dart';

/// Owns the displayed week: fetching it, week navigation, and every date
/// derivation the view needs (next event, day columns, specials).
///
/// A Bloc, not a Cubit: week navigation is a user-triggered event, and
/// [ScheduleBlocEvent.refreshRequested] has a real concurrency requirement
/// (`droppable()`).
class ScheduleBloc extends Bloc<ScheduleBlocEvent, ScheduleState> {
  /// Creates a [ScheduleBloc] backed by [scheduleRepository].
  ///
  /// [now] defaults to [DateTime.now]; inject a fixed clock in tests.
  ScheduleBloc({
    required ScheduleRepository scheduleRepository,
    DateTime Function()? now,
  }) : _repository = scheduleRepository,
       _now = now ?? DateTime.now,
       super(const ScheduleState.initial()) {
    on<ScheduleStarted>(_onStarted);
    on<ScheduleWeekChanged>(_onWeekChanged);
    on<ScheduleRefreshRequested>(_onRefreshRequested, transformer: droppable());
  }

  final ScheduleRepository _repository;
  final DateTime Function() _now;

  Future<void> _onStarted(
    ScheduleStarted event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(const ScheduleState.loading());
    await _load(0, emit);
  }

  Future<void> _onWeekChanged(
    ScheduleWeekChanged event,
    Emitter<ScheduleState> emit,
  ) async {
    // No `loading` emission here: bands 1–3 must not blank on a week change.
    await _load(event.offset, emit);
  }

  Future<void> _onRefreshRequested(
    ScheduleRefreshRequested event,
    Emitter<ScheduleState> emit,
  ) async {
    await _load(state.weekOffset, emit);
  }

  Future<void> _load(int offset, Emitter<ScheduleState> emit) async {
    final n = _now();
    final anchor = DateTime(n.year, n.month, n.day + offset * 7);
    try {
      final window = await _repository.fetchWindow(anchor: anchor);
      // Indexing directly is deliberate: a short list from a
      // contract-violating implementation becomes a RangeError and lands in
      // the catch-all below.
      final week = window[ScheduleRepository.windowRadiusInWeeks];
      final today = DateTime(n.year, n.month, n.day);
      emit(
        ScheduleState.loaded(
          weekOffset: offset,
          week: week,
          lastSyncedAt: _now(),
          days: _buildDays(week, today),
          nextEvent: _nextEvent(week, n),
          weekSpecial: week.specialEvents
              .whereType<SpecialEventWholeWeek>()
              .firstOrNull,
        ),
      );
    } on ScheduleException {
      emit(ScheduleState.failure(weekOffset: offset));
    } catch (_) {
      // A kiosk must not hang: both catch clauses reach the same state, so
      // there is no order-dependent behaviour beyond both paths reaching
      // `failure`. The typed clause must stay first — reversing them is
      // `dead_code_on_catch_subtype`.
      emit(ScheduleState.failure(weekOffset: offset));
    }
  }

  List<ScheduleDay> _buildDays(WeekSchedule week, DateTime today) {
    final weekStart = week.weekStart;

    bool hasContentOn(int weekday) {
      final hasEvent = week.events.any((e) => e.date.weekday == weekday);
      final hasSpecial = week.specialEvents.any(
        (s) => s is SpecialEventDay && s.date.weekday == weekday,
      );
      return hasEvent || hasSpecial;
    }

    final hasSunday = hasContentOn(DateTime.sunday);
    final hasSaturday = hasSunday || hasContentOn(DateTime.saturday);
    final dayCount = hasSaturday
        ? (hasSunday ? 7 : 6)
        : DateTime.friday - DateTime.monday + 1;

    return [
      for (var i = 0; i < dayCount; i++)
        _buildDay(
          week,
          DateTime(weekStart.year, weekStart.month, weekStart.day + i),
          today,
        ),
    ];
  }

  ScheduleDay _buildDay(WeekSchedule week, DateTime date, DateTime today) {
    return ScheduleDay(
      date: date,
      isToday: _isSameDay(date, today),
      // Repository order, not sorted by time — that order is the
      // calendar's, and it is what reproduces the mock week.
      events: [
        for (final e in week.events)
          if (_isSameDay(e.date, date)) e,
      ],
      special: week.specialEvents
          .whereType<SpecialEventDay>()
          .where((s) => _isSameDay(s.date, date))
          .firstOrNull,
    );
  }

  NextEvent? _nextEvent(WeekSchedule week, DateTime now) {
    final upcoming =
        [
          for (final e in week.events)
            if (_eventInstant(e).isAfter(now)) e,
        ]..sort((a, b) {
          final byInstant = _eventInstant(a).compareTo(_eventInstant(b));
          return byInstant != 0 ? byInstant : a.id.compareTo(b.id);
        });

    if (upcoming.isEmpty) return null;

    final event = upcoming.first;
    final today = DateTime.utc(now.year, now.month, now.day);
    final eventDay = DateTime.utc(
      event.date.year,
      event.date.month,
      event.date.day,
    );
    final daysUntil = eventDay.difference(today).inDays;

    return NextEvent(
      event: event,
      daysUntil: daysUntil,
      relativeDay: switch (daysUntil) {
        0 => RelativeDay.today,
        1 => RelativeDay.tomorrow,
        _ => RelativeDay.later,
      },
    );
  }

  DateTime _eventInstant(ScheduleEvent e) =>
      e.time ?? DateTime(e.date.year, e.date.month, e.date.day, 23, 59, 59);

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
