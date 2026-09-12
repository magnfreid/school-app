import 'dart:async';
import 'dart:developer' as developer;

import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter/app/app.dart';
import 'package:flutter_starter/app/cubit/theme_cubit.dart';
import 'package:flutter_starter/auth/cubit/auth_cubit.dart';

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
/// point receives interfaces — swapping [InMemoryAuthRepository] for a real
/// backend is a one-line change here and touches no feature code.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

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
    // Typed to the interface so `context.read<AuthRepository>()` in feature
    // code resolves to the contract, never to the implementation.
    RepositoryProvider<AuthRepository>(
      create: (_) => InMemoryAuthRepository(),
      dispose: (repository) => unawaited(repository.dispose()),
      lazy: false,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AuthCubit(authRepository: context.read<AuthRepository>()),
            lazy: false,
          ),
          BlocProvider(create: (_) => ThemeCubit()),
        ],
        child: const App(),
      ),
    ),
  );
}
