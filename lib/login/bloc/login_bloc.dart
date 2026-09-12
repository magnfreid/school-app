import 'dart:developer' as developer;

import 'package:auth_repository/auth_repository.dart';
import 'package:bloc_utils/bloc_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter/login/bloc/login_event.dart';
import 'package:flutter_starter/login/bloc/login_state.dart';

export 'login_event.dart';
export 'login_state.dart';

/// Drives the sign-in form.
///
/// Emitting [LoginStateSuccess] is not what navigates — the repository pushes
/// the new user onto its stream, [AuthCubit] mirrors it, and the router's
/// redirect reacts. This bloc only owns the form.
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  /// Creates a [LoginBloc] backed by [authRepository].
  LoginBloc({required this._authRepository})
    : super(const LoginState.initial()) {
    // droppable: a second tap while a request is in flight is ignored rather
    // than queued, so an impatient double-tap cannot fire two sign-ins.
    on<LoginSubmitted>(_onSubmitted, transformer: droppable());
  }

  final AuthRepository _authRepository;

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginState.loading());
    try {
      await _authRepository.login(email: event.email, password: event.password);
      emit(const LoginState.success());
    } on AuthException catch (error, stackTrace) {
      developer.log('login rejected', error: error, stackTrace: stackTrace);
      emit(const LoginState.failure());
    } catch (error, stackTrace) {
      // A repository is only contracted to throw AuthException, but an
      // implementation can still leak a TimeoutException or a bug. Without
      // this the bloc would sit in `loading` forever and the button — disabled
      // while loading — would never come back.
      developer.log('login errored', error: error, stackTrace: stackTrace);
      emit(const LoginState.unexpectedFailure());
    }
  }
}
