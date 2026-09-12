import 'package:auth_repository/auth_repository.dart';
import 'package:test/test.dart';

void main() {
  group('InMemoryAuthRepository', () {
    late InMemoryAuthRepository repository;

    setUp(() {
      repository = InMemoryAuthRepository();
      addTearDown(repository.dispose);
    });

    test('emits null to a subscriber that arrives before any sign-in', () {
      expect(repository.authStateChanges, emits(isNull));
    });

    test('emits the user after a successful login', () async {
      expect(
        repository.authStateChanges,
        emitsInOrder([isNull, isA<AuthUser>()]),
      );

      await repository.login(email: 'a@b.com', password: 'pw');
    });

    test('carries the email through onto the user', () async {
      await repository.login(email: 'a@b.com', password: 'pw');

      await expectLater(
        repository.authStateChanges,
        emits(const AuthUser(id: 'in-memory-user', email: 'a@b.com')),
      );
    });

    test('emits null again after logout', () async {
      await repository.login(email: 'a@b.com', password: 'pw');
      await repository.logout();

      await expectLater(repository.authStateChanges, emits(isNull));
    });

    test('replays the current user to a late subscriber', () async {
      await repository.login(email: 'a@b.com', password: 'pw');

      // A listener attaching after the fact still learns the session exists,
      // rather than waiting for a change that may never come.
      await expectLater(repository.authStateChanges, emits(isA<AuthUser>()));
    });

    test('a login resolving after dispose does not throw', () async {
      // The 300ms delay means dispose() can land mid-flight. Adding to a
      // closed StreamController throws "Cannot add new events after close".
      final login = repository.login(email: 'a@b.com', password: 'pw');
      await repository.dispose();

      await expectLater(login, completes);
    });

    test('does not drop a change emitted in the subscribing turn', () async {
      final seen = <AuthUser?>[];
      final subscription = repository.authStateChanges.listen(seen.add);
      addTearDown(subscription.cancel);

      await repository.logout();
      await pumpEventQueue();

      expect(seen, [null, null]);
    });

    group('rejects incomplete credentials', () {
      test('throws AuthException on an empty email', () {
        expect(
          () => repository.login(email: '', password: 'pw'),
          throwsA(isA<AuthException>()),
        );
      });

      test('throws AuthException on an empty password', () {
        expect(
          () => repository.login(email: 'a@b.com', password: ''),
          throwsA(isA<AuthException>()),
        );
      });

      test('leaves the session signed out after a rejected login', () async {
        await expectLater(
          () => repository.login(email: '', password: ''),
          throwsA(isA<AuthException>()),
        );

        await expectLater(repository.authStateChanges, emits(isNull));
      });
    });
  });
}
