import 'dart:async';

import 'models/auth_user.dart';

/// Failure raised when an authentication call cannot be completed.
///
/// Implementations translate their backend's errors into this before they
/// cross the package boundary — a `FirebaseAuthException`, a `DioException`,
/// or any other vendor type must never reach the app layer.
class AuthException implements Exception {
  /// Creates an [AuthException] describing [message].
  const AuthException(this.message, {this.cause});

  /// Human-readable description of what went wrong.
  final String message;

  /// The underlying error, kept for logging. Never surfaced to the UI.
  final Object? cause;

  @override
  String toString() => 'AuthException: $message';
}

/// Provides authentication state and sign-in/out actions.
///
/// Depend on this interface, never on a concrete implementation. Wire the
/// implementation in `bootstrap.dart` and nowhere else.
abstract interface class AuthRepository {
  /// Stream of the current user, or `null` while signed out.
  ///
  /// Emits the current value on subscription so a late listener is not left
  /// waiting for the next change.
  Stream<AuthUser?> get authStateChanges;

  /// Signs the user in with [email] and [password].
  ///
  /// Throws an [AuthException] if the credentials are rejected.
  Future<void> login({required String email, required String password});

  /// Signs the current user out.
  Future<void> logout();

  /// Releases resources held by the implementation.
  Future<void> dispose();
}
