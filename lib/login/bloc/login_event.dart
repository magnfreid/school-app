import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_event.freezed.dart';

/// Events accepted by [LoginBloc].
@freezed
sealed class LoginEvent with _$LoginEvent {
  /// The user submitted the sign-in form with [email] and [password].
  const factory LoginEvent.submitted({
    required String email,
    required String password,
  }) = LoginSubmitted;
}
