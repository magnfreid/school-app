import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

/// State of the sign-in form.
///
/// [LoginStateFailure] and [LoginStateUnexpectedFailure] carry no message
/// deliberately: the UI resolves its text from the l10n delegate.
/// [LoginStateFailure] versus [LoginStateUnexpectedFailure] is a variant per
/// cause — a rejected sign-in versus an off-contract error. When the backend
/// distinguishes further causes, add another variant and map each to its own
/// key rather than passing an unlocalized string through state.
@freezed
sealed class LoginState with _$LoginState {
  /// Nothing submitted yet.
  const factory LoginState.initial() = LoginStateInitial;

  /// A submission is in flight.
  const factory LoginState.loading() = LoginStateLoading;

  /// Credentials accepted. The router redirects on the auth state change.
  const factory LoginState.success() = LoginStateSuccess;

  /// The repository rejected the credentials — an [AuthException].
  const factory LoginState.failure() = LoginStateFailure;

  /// The repository threw something off-contract.
  const factory LoginState.unexpectedFailure() = LoginStateUnexpectedFailure;
}
