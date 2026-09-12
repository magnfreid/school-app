import 'dart:async';
import 'dart:developer' as developer;

import 'package:auth_repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_cubit.freezed.dart';

/// Session state driven by [AuthRepository.authStateChanges].
///
/// [AuthStateUnknown] is the startup state, held until the repository reports
/// its first value. The router keeps the app on splash while it is active.
@freezed
sealed class AuthState with _$AuthState {
  /// Auth state has not been resolved yet.
  const factory AuthState.unknown() = AuthStateUnknown;

  /// A user is signed in.
  const factory AuthState.authenticated(AuthUser user) = AuthStateAuthenticated;

  /// No user is signed in.
  const factory AuthState.unauthenticated() = AuthStateUnauthenticated;
}

/// Owns the app-wide session.
///
/// A Cubit rather than a Bloc deliberately: there are no events worth naming —
/// the state is whatever the repository last reported.
class AuthCubit extends Cubit<AuthState> {
  /// Subscribes to [authRepository] and mirrors it into [AuthState].
  AuthCubit({required this._authRepository})
    : super(const AuthState.unknown()) {
    _authSubscription = _authRepository.authStateChanges.listen(
      (user) => emit(
        user == null
            ? const AuthState.unauthenticated()
            : AuthState.authenticated(user),
      ),
      // Without this, an error before the first value strands the cubit in
      // `unknown` and the router holds the app on splash forever. Treat an
      // unreadable session as no session — the user can sign in again.
      onError: (Object error, StackTrace stackTrace) {
        developer.log(
          'auth stream failed',
          error: error,
          stackTrace: stackTrace,
        );
        emit(const AuthState.unauthenticated());
      },
    );
  }

  final AuthRepository _authRepository;
  late final StreamSubscription<AuthUser?> _authSubscription;

  /// Signs the current user out.
  ///
  /// Never throws: callers fire this from a button and cannot handle a
  /// failure. A sign-out that fails leaves the session as it was, and the
  /// stream stays the source of truth.
  Future<void> logout() async {
    try {
      await _authRepository.logout();
    } catch (error, stackTrace) {
      developer.log('logout failed', error: error, stackTrace: stackTrace);
    }
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}
