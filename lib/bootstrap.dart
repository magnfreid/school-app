import 'dart:async';
import 'dart:developer' as developer;

import 'package:calendar_config_repository/calendar_config_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_app/app/app.dart';
import 'package:school_app/app/cubit/calendar_config_cubit.dart';
import 'package:school_app/app/cubit/theme_cubit.dart';
import 'package:schedule_repository/schedule_repository.dart';

/// Global [BlocObserver] used in debug mode only.
class _AppBlocObserver extends BlocObserver {
  const _AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    developer.log('onChange(${bloc.runtimeType}) $change');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    developer.log(
      'onError(${bloc.runtimeType})',
      error: error,
      stackTrace: stackTrace,
    );
    super.onError(bloc, error, stackTrace);
  }
}

/// Boots the app.
///
/// The only place a concrete implementation is named. Everything below this
/// point receives interfaces — swapping [InMemoryCalendarConfigRepository]
/// for a real backend is a one-line change here and touches no feature code.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  // This is a kiosk display, permanently on with system bars hidden — the
  // Week View handoff deliberately draws with no SafeArea on that
  // assumption. Real lock-task kiosk setup is device infrastructure (out of
  // scope for this repo), but hiding the system UI here makes the screen
  // render as designed on any device, not only a locked-down one.
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  if (kDebugMode) {
    Bloc.observer = const _AppBlocObserver();
  }

  FlutterError.onError = (details) {
    developer.log(details.exceptionAsString(), stackTrace: details.stack);
    FlutterError.presentError(details);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    developer.log('uncaught async error', error: error, stackTrace: stack);
    return true;
  };

  runApp(
    // Typed to the interfaces so `context.read<...Repository>()` in feature
    // code resolves to the contract, never to the implementation.
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<CalendarConfigRepository>(
          create: (_) => InMemoryCalendarConfigRepository(),
          dispose: (repository) => unawaited(repository.dispose()),
          lazy: false,
        ),
        RepositoryProvider<ScheduleRepository>(
          create: (_) => FakeScheduleRepository(),
          dispose: (repository) => unawaited(repository.dispose()),
          lazy: false,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => CalendarConfigCubit(
              configRepository: context.read<CalendarConfigRepository>(),
            ),
            lazy: false,
          ),
          BlocProvider(create: (_) => ThemeCubit()),
        ],
        child: const App(),
      ),
    ),
  );
}
