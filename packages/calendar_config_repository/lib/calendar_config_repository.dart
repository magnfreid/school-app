/// Calendar configuration repository package.
///
/// Exposes the [CalendarConfigRepository] interface, the domain types that
/// cross its boundary, and three implementations:
/// [SecureStorageCalendarConfigRepository] for the real backend,
/// [InMemoryCalendarConfigRepository] for running the app without a backend,
/// and [FakeCalendarConfigRepository] for tests.
library;

export 'src/calendar_config_exception.dart';
export 'src/calendar_config_repository.dart';
export 'src/fake_calendar_config_repository.dart';
export 'src/in_memory_calendar_config_repository.dart';
export 'src/models/calendar_config.dart';
export 'src/models/service_account_key.dart';
export 'src/secure_storage_calendar_config_repository.dart';
