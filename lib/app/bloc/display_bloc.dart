import 'dart:async';
import 'dart:developer' as developer;

import 'package:display_repository/display_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'display_event.dart';
import 'display_state.dart';

/// Owns the kiosk display's wakelock and backlight, on an idle/interacting
/// cycle while the app is foregrounded and on external power.
///
/// A Bloc, not a Cubit: touch and power are user/world events worth naming,
/// per CLAUDE.md.
class DisplayBloc extends Bloc<DisplayEvent, DisplayState> {
  /// Creates a [DisplayBloc] backed by [displayRepository].
  ///
  /// [now] defaults to [DateTime.now]; inject a fixed clock in tests.
  /// [idleTimeout] is how long without a touch before the display dims.
  /// [dimLevelCheckInterval] is how often the day/night boundary is
  /// re-checked while dimmed. Both are constructor parameters with
  /// production defaults so tests can inject short durations — same shape as
  /// `ScheduleBloc`.
  DisplayBloc({
    required DisplayRepository displayRepository,
    DateTime Function()? now,
    Duration idleTimeout = const Duration(seconds: 30),
    Duration dimLevelCheckInterval = const Duration(minutes: 1),
  }) : // An initializing formal would make the named parameter private
       // (`this._displayRepository`), which breaks the public
       // `displayRepository:` constructor argument callers use.
       // ignore: prefer_initializing_formals
       _displayRepository = displayRepository,
       _now = now ?? DateTime.now,
       // Same reasoning as above for `idleTimeout:` and
       // `dimLevelCheckInterval:`.
       // ignore: prefer_initializing_formals
       _idleTimeout = idleTimeout,
       // ignore: prefer_initializing_formals
       _dimLevelCheckInterval = dimLevelCheckInterval,
       super(const DisplayState.released()) {
    on<DisplayStarted>(_onStarted);
    on<DisplayPowerChanged>(_onPowerChanged);
    on<DisplayUserInteracted>(_onUserInteracted);
    on<DisplayIdleTimeoutElapsed>(_onIdleTimeoutElapsed);
    on<DisplayDimLevelChecked>(_onDimLevelChecked);
    on<DisplayForegroundChanged>(_onForegroundChanged);
  }

  /// First hour of the night window, device-local, inclusive.
  static const nightStartHour = 21;

  /// First hour of the day window, device-local, inclusive.
  static const dayStartHour = 6;

  /// Fraction of normal brightness while idle during the day.
  static const daytimeDimFactor = 0.6;

  /// Fraction of normal brightness while idle at night.
  static const nightDimFactor = 0.1;

  /// Floor applied to any computed brightness so the display is never fully
  /// black — the night level must stay technically visible.
  static const minimumBrightness = 0.01;

  final DisplayRepository _displayRepository;
  final DateTime Function() _now;
  final Duration _idleTimeout;
  final Duration _dimLevelCheckInterval;

  bool _isExternallyPowered = false;
  bool _isForeground = true;
  bool _isIdle = false;
  Timer? _idleTimer;
  Timer? _dimLevelTimer;
  StreamSubscription<bool>? _powerSubscription;

  /// Serialises every `_settle` call across all six `on<E>` handlers — a
  /// `transformer` only orders one handler's own events, and this race is
  /// across handlers. Each call chains onto this future and replaces it, so
  /// no two `_apply` calls are ever in flight at once.
  Future<void> _settleQueue = Future<void>.value();

  /// The target last actually applied via [_apply]. `_settle` compares the
  /// newly computed target against this — not against [state] — so a call
  /// queued behind another one, whose fields changed while it waited, still
  /// notices the divergence and re-applies rather than short-circuiting.
  DisplayState? _appliedTarget;

  /// The whole policy: which [DisplayState] applies right now.
  DisplayState _targetState() {
    if (!_isExternallyPowered || !_isForeground) {
      return const DisplayState.released();
    }
    if (!_isIdle) {
      return const DisplayState.awake();
    }
    final hour = _now().hour;
    final level = hour >= nightStartHour || hour < dayStartHour
        ? DisplayDimLevel.night
        : DisplayDimLevel.daytime;
    return DisplayState.dimmed(level);
  }

  Future<void> _settle(Emitter<DisplayState> emit, {bool force = false}) {
    final previous = _settleQueue;
    final completer = Completer<void>();
    _settleQueue = completer.future;
    return previous.then((_) async {
      try {
        if (emit.isDone) return;
        final target = _targetState();
        if (!force && target == _appliedTarget) return;
        await _apply(target);
        _appliedTarget = target;
        if (emit.isDone) return;
        emit(target);
      } finally {
        // Release the queue even if the body above threw, so a later queued
        // call is never stuck waiting on a failed one.
        completer.complete();
      }
    });
  }

  /// Effect order is load-bearing: the wakelock goes first on both charging
  /// targets so a brightness failure still leaves the screen on. Released
  /// restores brightness first so the backlight is never handed back to the
  /// OS still dimmed.
  Future<void> _apply(DisplayState target) async {
    switch (target) {
      case DisplayReleased():
        await _guarded(target, _displayRepository.restoreBrightness);
        await _guarded(
          target,
          () => _displayRepository.setWakelock(enabled: false),
        );
      case DisplayAwake():
        await _guarded(
          target,
          () => _displayRepository.setWakelock(enabled: true),
        );
        await _guarded(target, _displayRepository.restoreBrightness);
      case DisplayDimmed(:final level):
        await _guarded(
          target,
          () => _displayRepository.setWakelock(enabled: true),
        );
        await _guarded(target, () async {
          final normal = await _displayRepository.normalBrightness();
          final factor = level == DisplayDimLevel.night
              ? nightDimFactor
              : daytimeDimFactor;
          await _displayRepository.setBrightness(
            (normal * factor).clamp(minimumBrightness, 1.0),
          );
        });
    }
  }

  /// Runs one platform [call] for [target], guarded on its own — mirrors
  /// `DeviceDisplayRepository.dispose()` — so a failing call never skips a
  /// later, unrelated call in the same [_apply] branch (a failing
  /// `restoreBrightness()` must still let `setWakelock(enabled: false)` run,
  /// and vice versa). Log-and-continue: the state is emitted regardless in
  /// `_settle`, since it is a statement of intent, and the next
  /// `dimLevelChecked` tick retries a failed dim. The typed clause must stay
  /// first — reversing it is `dead_code_on_catch_subtype`. Mirrors
  /// `SettingsBloc._onUnsubscribeConfirmed`.
  Future<void> _guarded(
    DisplayState target,
    Future<void> Function() call,
  ) async {
    try {
      await call();
    } on DisplayException catch (e, s) {
      developer.log(
        'DisplayBloc failed to apply $target',
        error: e,
        stackTrace: s,
      );
    } catch (e, s) {
      developer.log(
        'DisplayBloc failed to apply $target',
        error: e,
        stackTrace: s,
      );
    }
  }

  /// Cancels any pending idle timer. Starts a new one only while charging
  /// and foregrounded — this is what keeps an unstarted or released bloc
  /// from creating any timers, which is what keeps existing widget tests
  /// free of pending-timer failures.
  void _restartIdleTimer() {
    _idleTimer?.cancel();
    if (!_isExternallyPowered || !_isForeground) return;
    _idleTimer = Timer(_idleTimeout, () {
      if (!isClosed) add(const DisplayEvent.idleTimeoutElapsed());
    });
  }

  Future<void> _onStarted(
    DisplayStarted event,
    Emitter<DisplayState> emit,
  ) async {
    // A second `started` must not double-subscribe.
    await _powerSubscription?.cancel();
    _dimLevelTimer?.cancel();

    _powerSubscription = _displayRepository.powerChanges.listen((
      isExternallyPowered,
    ) {
      if (isClosed) return;
      add(DisplayEvent.powerChanged(isExternallyPowered: isExternallyPowered));
    });
    _dimLevelTimer = Timer.periodic(_dimLevelCheckInterval, (_) {
      if (isClosed) return;
      add(const DisplayEvent.dimLevelChecked());
    });

    _isIdle = false;
    _restartIdleTimer();
    await _settle(emit, force: true);
  }

  Future<void> _onPowerChanged(
    DisplayPowerChanged event,
    Emitter<DisplayState> emit,
  ) async {
    _isExternallyPowered = event.isExternallyPowered;
    _isIdle = false;
    _restartIdleTimer();
    await _settle(emit);
  }

  Future<void> _onUserInteracted(
    DisplayUserInteracted event,
    Emitter<DisplayState> emit,
  ) async {
    _isIdle = false;
    _restartIdleTimer();
    await _settle(emit);
  }

  Future<void> _onIdleTimeoutElapsed(
    DisplayIdleTimeoutElapsed event,
    Emitter<DisplayState> emit,
  ) async {
    _idleTimer?.cancel();
    _isIdle = true;
    await _settle(emit);
  }

  Future<void> _onDimLevelChecked(
    DisplayDimLevelChecked event,
    Emitter<DisplayState> emit,
  ) async {
    if (state is! DisplayDimmed) return;
    await _settle(emit, force: true);
  }

  Future<void> _onForegroundChanged(
    DisplayForegroundChanged event,
    Emitter<DisplayState> emit,
  ) async {
    // A resume is treated as an interaction, which is what re-applies the
    // backlight after iOS's auto-reset.
    _isForeground = event.isForeground;
    _isIdle = false;
    _restartIdleTimer();
    await _settle(emit);
  }

  @override
  Future<void> close() {
    _idleTimer?.cancel();
    _dimLevelTimer?.cancel();
    // Do not call repository methods here — releasing the display is
    // DeviceDisplayRepository.dispose()'s job.
    unawaited(_powerSubscription?.cancel());
    return super.close();
  }
}
