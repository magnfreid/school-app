import 'dart:async';

import 'auth_repository.dart';
import 'models/auth_user.dart';

/// Scriptable [AuthRepository] for tests and for UI work that should not touch
/// a backend.
///
/// Unlike [InMemoryAuthRepository] this adds no latency by default and lets a
/// test decide the outcome up front:
///
/// ```dart
/// final repo = FakeAuthRepository(
///   initialUser: const AuthUser(id: 'u1'),
///   loginError: const AuthException('nope'),
/// );
/// ```
class FakeAuthRepository implements AuthRepository {
  /// Creates a [FakeAuthRepository].
  ///
  /// [initialUser] seeds the signed-in state; leave it `null` for signed out.
  /// When [loginError] is set, [login] throws it instead of succeeding.
  /// [loginDelay] holds each [login] call open, which is what lets a test
  /// observe behaviour that only exists while a request is in flight.
  FakeAuthRepository({
    AuthUser? initialUser,
    this.loginError,
    this.loginDelay = Duration.zero,
  }) : _current = initialUser;

  /// How long each [login] call takes before resolving.
  final Duration loginDelay;

  /// Error [login] throws when set. Mutable so a test can change it mid-run.
  AuthException? loginError;

  /// Credentials passed to each [login] call, in order.
  final List<({String email, String password})> loginCalls = [];

  /// Number of times [logout] has been called.
  int logoutCount = 0;

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

  /// Pushes [user] onto the stream, simulating an out-of-band auth change
  /// such as a token expiring or a sign-in on another device.
  void emit(AuthUser? user) {
    _current = user;
    // A login held open by loginDelay can resolve after a test's tearDown has
    // disposed this fake; adding to a closed controller throws.
    if (!_controller.isClosed) _controller.add(user);
  }

  @override
  Future<void> login({required String email, required String password}) async {
    loginCalls.add((email: email, password: password));
    if (loginDelay > Duration.zero) await Future<void>.delayed(loginDelay);
    final error = loginError;
    if (error != null) throw error;
    emit(AuthUser(id: 'fake-user', email: email));
  }

  @override
  Future<void> logout() async {
    logoutCount++;
    emit(null);
  }

  @override
  Future<void> dispose() => _controller.close();
}
