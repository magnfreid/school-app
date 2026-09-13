import 'dart:async';
import 'dart:developer' as developer;

import 'package:calendar_config_repository/calendar_config_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_config_cubit.freezed.dart';

/// Config-gate state driven by [CalendarConfigRepository.configChanges].
///
/// [CalendarConfigStateUnknown] is the startup state, held until the
/// repository reports its first value. The router keeps the app on splash
/// while it is active.
@freezed
sealed class CalendarConfigState with _$CalendarConfigState {
  /// Calendar config has not been resolved yet.
  const factory CalendarConfigState.unknown() = CalendarConfigStateUnknown;

  /// The calendar is configured.
  const factory CalendarConfigState.configured(CalendarConfig config) =
      CalendarConfigStateConfigured;

  /// No calendar is configured.
  const factory CalendarConfigState.unconfigured() =
      CalendarConfigStateUnconfigured;
}

/// Owns the app-wide calendar-config gate.
///
/// A Cubit rather than a Bloc deliberately: there are no events worth naming —
/// the state is whatever the repository last reported.
class CalendarConfigCubit extends Cubit<CalendarConfigState> {
  /// Subscribes to [configRepository] and mirrors it into
  /// [CalendarConfigState].
  CalendarConfigCubit({required this._configRepository})
    : super(const CalendarConfigState.unknown()) {
    _configSubscription = _configRepository.configChanges.listen(
      (config) => emit(
        config == null
            ? const CalendarConfigState.unconfigured()
            : CalendarConfigState.configured(config),
      ),
      // Without this, an error before the first value strands the cubit in
      // `unknown` and the router holds the app on splash forever. Treat an
      // unreadable config as no config — the user can configure again.
      onError: (Object error, StackTrace stackTrace) {
        developer.log(
          'calendar config stream failed',
          error: error,
          stackTrace: stackTrace,
        );
        emit(const CalendarConfigState.unconfigured());
      },
    );
  }

  final CalendarConfigRepository _configRepository;
  late final StreamSubscription<CalendarConfig?> _configSubscription;

  @override
  Future<void> close() {
    _configSubscription.cancel();
    return super.close();
  }
}
