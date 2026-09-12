import 'package:auth_repository/auth_repository.dart';
import 'package:test/test.dart';

void main() {
  test(
    'FakeAuthRepository: delayed login resolving after dispose is safe',
    () async {
      final repo = FakeAuthRepository(
        loginDelay: const Duration(milliseconds: 30),
      );
      final login = repo.login(email: 'a@b.com', password: 'pw');
      await repo.dispose();

      await expectLater(login, completes);
    },
  );

  group('FakeAuthRepository', () {
    late FakeAuthRepository repository;

    setUp(() {
      repository = FakeAuthRepository();
      addTearDown(repository.dispose);
    });

    test('seeds null when no initialUser is given', () {
      expect(repository.authStateChanges, emits(isNull));
    });

    test('initialUser seeds a user', () {
      final seeded = FakeAuthRepository(initialUser: const AuthUser(id: 'u1'));
      addTearDown(seeded.dispose);

      expect(seeded.authStateChanges, emits(const AuthUser(id: 'u1')));
    });

    test('loginCalls records both calls in order', () async {
      await repository.login(email: 'a@b.com', password: 'pw1');
      await repository.login(email: 'c@d.com', password: 'pw2');

      expect(repository.loginCalls, [
        (email: 'a@b.com', password: 'pw1'),
        (email: 'c@d.com', password: 'pw2'),
      ]);
    });

    test('login emits the user', () async {
      expect(
        repository.authStateChanges,
        emitsInOrder([isNull, isA<AuthUser>()]),
      );

      await repository.login(email: 'a@b.com', password: 'pw');
    });

    test('loginError makes login throw, still records the call, and leaves '
        'the stream at null', () async {
      repository.loginError = const AuthException('nope');

      await expectLater(
        () => repository.login(email: 'a@b.com', password: 'pw'),
        throwsA(isA<AuthException>()),
      );

      expect(repository.loginCalls, [(email: 'a@b.com', password: 'pw')]);
      await expectLater(repository.authStateChanges, emits(isNull));
    });

    test('loginError can be cleared mid-run', () async {
      repository.loginError = const AuthException('nope');
      await expectLater(
        () => repository.login(email: 'a@b.com', password: 'pw'),
        throwsA(isA<AuthException>()),
      );

      repository.loginError = null;
      await repository.login(email: 'a@b.com', password: 'pw');

      expect(repository.loginCalls, hasLength(2));
    });

    test('loginDelay holds the call open', () async {
      final delayedRepository = FakeAuthRepository(
        loginDelay: const Duration(milliseconds: 50),
      );
      addTearDown(delayedRepository.dispose);

      final stopwatch = Stopwatch()..start();
      await delayedRepository.login(email: 'a@b.com', password: 'pw');
      stopwatch.stop();

      expect(stopwatch.elapsedMilliseconds, greaterThanOrEqualTo(50));
    });

    test('logout increments logoutCount and emits null', () async {
      await repository.login(email: 'a@b.com', password: 'pw');
      await expectLater(repository.authStateChanges, emits(isA<AuthUser>()));

      await repository.logout();

      expect(repository.logoutCount, 1);
      await expectLater(repository.authStateChanges, emits(isNull));
    });

    test('emit pushes out-of-band changes', () {
      expect(
        repository.authStateChanges,
        emitsInOrder([isNull, const AuthUser(id: 'external')]),
      );

      repository.emit(const AuthUser(id: 'external'));
    });

    test('does not drop a change emitted in the subscribing turn', () async {
      final seen = <AuthUser?>[];
      final subscription = repository.authStateChanges.listen(seen.add);
      addTearDown(subscription.cancel);

      repository.emit(const AuthUser(id: 'u1'));
      await pumpEventQueue();

      expect(seen, [null, const AuthUser(id: 'u1')]);
    });
  });
}
