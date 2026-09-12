import 'dart:async';

import 'package:auth_repository/auth_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_starter/login/bloc/login_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginBloc', () {
    late FakeAuthRepository repository;

    setUp(() {
      repository = FakeAuthRepository();
      addTearDown(repository.dispose);
    });

    test('initial state is LoginState.initial', () {
      final bloc = LoginBloc(authRepository: repository);
      addTearDown(bloc.close);

      expect(bloc.state, const LoginState.initial());
    });

    blocTest<LoginBloc, LoginState>(
      'emits [loading, success] and forwards the credentials',
      build: () => LoginBloc(authRepository: repository),
      act: (bloc) => bloc.add(
        const LoginEvent.submitted(email: 'a@b.com', password: 'pw'),
      ),
      expect: () => [const LoginState.loading(), const LoginState.success()],
      verify: (_) {
        expect(repository.loginCalls, [(email: 'a@b.com', password: 'pw')]);
      },
    );

    blocTest<LoginBloc, LoginState>(
      'emits [loading, failure] when the repository rejects the credentials',
      setUp: () => repository.loginError = const AuthException('rejected'),
      build: () => LoginBloc(authRepository: repository),
      act: (bloc) => bloc.add(
        const LoginEvent.submitted(email: 'a@b.com', password: 'wrong'),
      ),
      expect: () => [const LoginState.loading(), const LoginState.failure()],
    );

    blocTest<LoginBloc, LoginState>(
      'emits [loading, unexpectedFailure] when the repository throws '
      'off-contract',
      // A repository is only contracted to throw AuthException. If an
      // implementation leaks something else, the form must still recover —
      // stranded in `loading`, the disabled button never comes back.
      build: () => LoginBloc(authRepository: _ThrowingAuthRepository()),
      act: (bloc) => bloc.add(
        const LoginEvent.submitted(email: 'a@b.com', password: 'pw'),
      ),
      expect: () => [
        const LoginState.loading(),
        const LoginState.unexpectedFailure(),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'drops a second submit while the first is still in flight',
      setUp: () {
        repository = FakeAuthRepository(
          loginDelay: const Duration(milliseconds: 50),
        );
        addTearDown(repository.dispose);
      },
      build: () => LoginBloc(authRepository: repository),
      act: (bloc) => bloc
        ..add(const LoginEvent.submitted(email: 'a@b.com', password: 'pw'))
        ..add(const LoginEvent.submitted(email: 'a@b.com', password: 'pw')),
      wait: const Duration(milliseconds: 100),
      expect: () => [const LoginState.loading(), const LoginState.success()],
      verify: (_) {
        // droppable() — the second tap is discarded, not queued.
        expect(repository.loginCalls, hasLength(1));
      },
    );
  });
}

/// Repository that violates the [AuthRepository] contract by throwing
/// something other than an [AuthException].
class _ThrowingAuthRepository implements AuthRepository {
  @override
  Stream<AuthUser?> get authStateChanges => const Stream.empty();

  @override
  Future<void> login({required String email, required String password}) async {
    throw TimeoutException('backend went away');
  }

  @override
  Future<void> logout() async {}

  @override
  Future<void> dispose() async {}
}
