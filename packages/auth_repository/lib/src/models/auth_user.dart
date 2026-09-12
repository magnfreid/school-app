import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.freezed.dart';

/// A signed-in user.
///
/// Only ever represents an authenticated session — "signed out" is the absence
/// of an [AuthUser], not a sentinel instance of one. Callers model that with
/// `AuthUser?` so the type system carries the distinction.
@freezed
abstract class AuthUser with _$AuthUser {
  /// Creates an [AuthUser].
  const factory AuthUser({required String id, String? email}) = _AuthUser;
}
