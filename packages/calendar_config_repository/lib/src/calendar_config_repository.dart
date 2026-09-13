import 'dart:async';

import 'models/calendar_config.dart';

/// Provides the app's calendar configuration and lets it be changed.
///
/// Depend on this interface, never on a concrete implementation. Wire the
/// implementation in `bootstrap.dart` and nowhere else.
abstract interface class CalendarConfigRepository {
  /// The current configuration, or `null` while unconfigured. Emits the
  /// current value on subscription.
  ///
  /// The later config-gate redirect reads `null` exactly as the auth
  /// redirect reads `AuthUser?`.
  Stream<CalendarConfig?> get configChanges;

  /// Saves [config] as the current configuration.
  ///
  /// Throws a [CalendarConfigException] when the configuration is rejected.
  Future<void> save(CalendarConfig config);

  /// Clears the current configuration, returning to unconfigured.
  Future<void> clear();

  /// Releases resources held by the implementation.
  Future<void> dispose();
}
