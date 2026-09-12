import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_app/app/cubit/theme_cubit.dart';
import 'package:school_app/auth/cubit/auth_cubit.dart';

/// Wraps [child] in the provider stack `bootstrap.dart` installs.
///
/// Widget tests pump through this so they exercise the same wiring the app
/// runs with, instead of a hand-built subset that drifts from it.
Widget wrapWithAppProviders({
  required AuthRepository authRepository,
  required AuthCubit authCubit,
  required Widget child,
}) {
  return RepositoryProvider<AuthRepository>.value(
    value: authRepository,
    child: MultiBlocProvider(
      providers: [
        BlocProvider.value(value: authCubit),
        BlocProvider(create: (_) => ThemeCubit()),
      ],
      child: child,
    ),
  );
}

/// [AuthRepository] whose stream never emits.
///
/// Holds [AuthCubit] in `AuthState.unknown`, the state the app starts in
/// before the real backend has answered.
class SilentAuthRepository implements AuthRepository {
  @override
  Stream<AuthUser?> get authStateChanges => const Stream.empty();

  @override
  Future<void> login({required String email, required String password}) async {}

  @override
  Future<void> logout() async {}

  @override
  Future<void> dispose() async {}
}
