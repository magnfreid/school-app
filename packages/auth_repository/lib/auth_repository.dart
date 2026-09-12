/// Authentication repository package.
///
/// Exposes the [AuthRepository] interface, the domain types that cross its
/// boundary, and two implementations: [InMemoryAuthRepository] for running the
/// app without a backend and [FakeAuthRepository] for tests.
library;

export 'src/auth_repository.dart';
export 'src/fake_auth_repository.dart';
export 'src/in_memory_auth_repository.dart';
export 'src/models/auth_user.dart';
