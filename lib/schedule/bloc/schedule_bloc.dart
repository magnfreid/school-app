import 'dart:async';

import 'package:bloc_utils/bloc_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_repository/schedule_repository.dart';

import 'schedule_event.dart';
import 'schedule_state.dart';

/// Monday (local midnight) of the week offset 0 resolves to: this ISO week,
/// or next ISO week when [now] falls on Saturday or Sunday.
///
/// Uses `DateTime` constructor day arithmetic, never `.add(Duration(days:))`
/// — same DST reason as `week_math.startOfIsoWeek`, which is package-private
/// and deliberately not imported here.
DateTime _anchorWeekStart(DateTime now) {
  final daysSinceMonday = now.weekday - DateTime.monday;
  final weekStart = DateTime(now.year, now.month, now.day - daysSinceMonday);
  final isWeekend =
      now.weekday == DateTime.saturday || now.weekday == DateTime.sunday;
  final bump = isWeekend ? 7 : 0;
  return DateTime(weekStart.year, weekStart.month, weekStart.day + bump);
}

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
  /// [idleTimeout] is how long the display stays away from the anchor week
  /// before it auto-returns; [anchorCheckInterval] is how often the anchor
  /// week is recomputed to catch a rollover. Both are constructor parameters
  /// with production defaults so tests can inject short durations.
  ScheduleBloc({
    required ScheduleRepository scheduleRepository,
    DateTime Function()? now,
    Duration idleTimeout = const Duration(minutes: 5),
    Duration anchorCheckInterval = const Duration(minutes: 1),
  }) : _repository = scheduleRepository,
       _now = now ?? DateTime.now,
       // An initializing formal would make the named parameter private
       // (`this._idleTimeout`), which breaks the public `idleTimeout:`
       // constructor argument callers use.
       // ignore: prefer_initializing_formals
       _idleTimeout = idleTimeout,
       super(const ScheduleState.initial()) {
    on<ScheduleStarted>(_onStarted);
    on<ScheduleWeekChanged>(_onWeekChanged, transformer: restartable());
    on<ScheduleRefreshRequested>(_onRefreshRequested, transformer: droppable());
    on<ScheduleIdleTimeoutElapsed>(_onIdleTimeoutElapsed);
    on<ScheduleAnchorChanged>(_onAnchorChanged);

    _anchor = _anchorWeekStart(_now());
    _anchorTimer = Timer.periodic(anchorCheckInterval, (_) {
      if (isClosed) return;
      final next = _anchorWeekStart(_now());
      if (next != _anchor) {
        _anchor = next;
        add(const ScheduleBlocEvent.anchorChanged());
      }
    });
  }

  final ScheduleRepository _repository;
  final DateTime Function() _now;
  final Duration _idleTimeout;
  late DateTime _anchor;
  Timer? _idleTimer;
  Timer? _anchorTimer;

  @override
  Future<void> close() {
    _idleTimer?.cancel();
    _anchorTimer?.cancel();
    return super.close();
  }

  void _restartIdleTimer() {
    _idleTimer?.cancel();
    _idleTimer = Timer(_idleTimeout, () {
      if (!isClosed) add(const ScheduleBlocEvent.idleTimeoutElapsed());
    });
  }

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
    // Every received `weekChanged` restarts the idle timer, including an
    // edge tap that clamps to a no-op.
    _restartIdleTimer();
    final clamped = event.offset.clamp(
      -ScheduleRepository.windowRadiusInWeeks,
      ScheduleRepository.windowRadiusInWeeks,
    );
    // Absorbs the echo `onPageChanged` fires after a programmatic page
    // move; deliberately does not absorb a repeat while the state is
    // `failure`.
    if (clamped == state.weekOffset && state is ScheduleLoaded) return;
    // No `loading` emission here: bands 1–3 must not blank on a week change.
    await _load(clamped, emit);
  }

  Future<void> _onRefreshRequested(
    ScheduleRefreshRequested event,
    Emitter<ScheduleState> emit,
  ) async {
    await _load(state.weekOffset, emit);
  }

  Future<void> _onIdleTimeoutElapsed(
    ScheduleIdleTimeoutElapsed event,
    Emitter<ScheduleState> emit,
  ) async {
    _idleTimer?.cancel();
    if (state.weekOffset == 0) return;
    await _load(0, emit);
  }

  Future<void> _onAnchorChanged(
    ScheduleAnchorChanged event,
    Emitter<ScheduleState> emit,
  ) async {
    // Always loads, even when already at offset 0, because the anchor now
    // points at a different week. A manually chosen offset is discarded,
    // per the brief.
    _idleTimer?.cancel();
    await _load(0, emit);
  }

  Future<void> _load(int offset, Emitter<ScheduleState> emit) async {
    final n = _now();
    final anchor = DateTime(
      _anchor.year,
      _anchor.month,
      _anchor.day + offset * 7,
    );
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
