import 'dart:async';

import 'auth_repository.dart';
import 'models/auth_user.dart';

/// [AuthRepository] backed by nothing but a stream held in memory.
///
/// The starter's default so a fresh clone runs end-to-end without a backend.
/// Accepts any non-empty credentials and forgets the session on restart.
/// Replace it in `bootstrap.dart` with a real implementation — the app layer
/// depends on [AuthRepository] and does not change.
class InMemoryAuthRepository implements AuthRepository {
  /// Creates an [InMemoryAuthRepository] in the signed-out state.
  InMemoryAuthRepository();

  final _controller = StreamController<AuthUser?>.broadcast();
  AuthUser? _current;

  @override
  Stream<AuthUser?> get authStateChanges => Stream.multi((controller) {
    controller.add(_current);
    final subscription = _controller.stream.listen(
      controller.add,
      onError: controller.addError,
      onDone: controller.close,
    );
    controller
      ..onPause = subscription.pause
      ..onResume = subscription.resume
      ..onCancel = subscription.cancel;
  });

  @override
  Future<void> login({required String email, required String password}) async {
    // Stand-in for network latency so loading states are visible while
    // developing against this implementation.
    await Future<void>.delayed(const Duration(milliseconds: 300));

    if (email.isEmpty || password.isEmpty) {
      throw const AuthException('Email and password are required.');
    }

    _current = AuthUser(id: 'in-memory-user', email: email);
    // The delay above means dispose() can land mid-flight; adding to a closed
    // controller throws.
    if (!_controller.isClosed) _controller.add(_current);
  }

  @override
  Future<void> logout() async {
    _current = null;
    if (!_controller.isClosed) _controller.add(null);
  }

  @override
  Future<void> dispose() => _controller.close();
}
