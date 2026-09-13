import 'package:calendar_config_repository/calendar_config_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_app/app/cubit/calendar_config_cubit.dart';
import 'package:school_app/app/cubit/theme_cubit.dart';
import 'package:schedule_repository/schedule_repository.dart';

/// Wraps [child] in the provider stack `bootstrap.dart` installs.
///
/// Widget tests pump through this so they exercise the same wiring the app
/// runs with, instead of a hand-built subset that drifts from it.
Widget wrapWithAppProviders({
  required CalendarConfigRepository configRepository,
  required ScheduleRepository scheduleRepository,
  required CalendarConfigCubit configCubit,
  required Widget child,
}) {
  return MultiRepositoryProvider(
    providers: [
      RepositoryProvider<CalendarConfigRepository>.value(
        value: configRepository,
      ),
      RepositoryProvider<ScheduleRepository>.value(value: scheduleRepository),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider.value(value: configCubit),
        BlocProvider(create: (_) => ThemeCubit()),
      ],
      child: child,
    ),
  );
}

/// [CalendarConfigRepository] whose stream never emits.
///
/// Holds [CalendarConfigCubit] in `CalendarConfigState.unknown`, the state
/// the app starts in before storage has answered.
///
/// [FakeCalendarConfigRepository] cannot stand in for this case — it emits
/// its current value (`null` by default) on subscription and so resolves the
/// gate to unconfigured.
class SilentCalendarConfigRepository implements CalendarConfigRepository {
  @override
  Stream<CalendarConfig?> get configChanges =>
      const Stream<CalendarConfig?>.empty();

  @override
  Future<void> save(CalendarConfig config) async {}

  @override
  Future<void> clear() async {}

  @override
  Future<void> dispose() async {}
}
