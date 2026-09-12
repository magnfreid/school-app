import 'package:auth_repository/auth_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_starter/auth/cubit/auth_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthCubit', () {
    late FakeAuthRepository repository;

    setUp(() {
      repository = FakeAuthRepository();
      addTearDown(repository.dispose);
    });

    test('starts in AuthState.unknown before the repository reports', () {
      final cubit = AuthCubit(authRepository: repository);
      addTearDown(cubit.close);

      expect(cubit.state, const AuthState.unknown());
    });

    blocTest<AuthCubit, AuthState>(
      'emits unauthenticated when the repository reports no user',
      build: () => AuthCubit(authRepository: repository),
      wait: Duration.zero,
      expect: () => [const AuthState.unauthenticated()],
    );

    blocTest<AuthCubit, AuthState>(
      'emits authenticated when the repository reports a user',
      setUp: () => repository.emit(const AuthUser(id: 'u1')),
      build: () => AuthCubit(authRepository: repository),
      wait: Duration.zero,
      expect: () => [const AuthState.authenticated(AuthUser(id: 'u1'))],
    );

    blocTest<AuthCubit, AuthState>(
      'follows an out-of-band sign-out, such as an expired token',
      setUp: () => repository.emit(const AuthUser(id: 'u1')),
      build: () => AuthCubit(authRepository: repository),
      act: (_) async {
        // Let the seeded value land before changing it.
        await Future<void>.delayed(Duration.zero);
        repository.emit(null);
      },
      wait: Duration.zero,
      expect: () => [
        const AuthState.authenticated(AuthUser(id: 'u1')),
        const AuthState.unauthenticated(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'falls back to unauthenticated when the auth stream errors',
      // Left in `unknown`, the router would hold the app on splash forever.
      build: () => AuthCubit(authRepository: _ErroringAuthRepository()),
      wait: Duration.zero,
      expect: () => [const AuthState.unauthenticated()],
    );

    test('logout survives a repository that throws', () async {
      final cubit = AuthCubit(authRepository: _ErroringAuthRepository());
      addTearDown(cubit.close);

      await expectLater(cubit.logout(), completes);
    });

    test('logout delegates to the repository', () async {
      repository.emit(const AuthUser(id: 'u1'));
      final cubit = AuthCubit(authRepository: repository);
      addTearDown(cubit.close);

      await cubit.logout();

      expect(repository.logoutCount, 1);
    });
  });
}

/// Repository whose stream fails and whose logout throws.
class _ErroringAuthRepository implements AuthRepository {
  @override
  Stream<AuthUser?> get authStateChanges =>
      Stream<AuthUser?>.error(StateError('backend unreachable'));

  @override
  Future<void> login({required String email, required String password}) async {}

  @override
  Future<void> logout() async => throw StateError('backend unreachable');

  @override
  Future<void> dispose() async {}
}
