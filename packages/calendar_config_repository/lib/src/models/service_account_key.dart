/// Redacting wrapper around a service-account JSON key.
///
/// The payload is the raw JSON text a user pastes in during setup. The
/// wrapper exists only for its [toString] override — Freezed generates a
/// `toString()` on both the mixin and the concrete class of every `@freezed`
/// type, which means it cannot be overridden on `CalendarConfig` itself, and
/// `_AppBlocObserver.onChange` logs every bloc/cubit state change verbatim in
/// debug builds. Wrapping the key here makes "never logged" mechanical
/// instead of a standing rule nobody can enforce.
///
/// Deliberately does not validate [json] — the JSON check lives in
/// `SetupBloc` and in `SecureStorageCalendarConfigRepository.save`.
final class ServiceAccountKey {
  /// Creates a [ServiceAccountKey] wrapping the raw [json] text.
  const ServiceAccountKey(this.json);

  /// The raw contents of the service-account JSON key file.
  final String json;

  @override
  bool operator ==(Object other) =>
      other is ServiceAccountKey && other.json == json;

  @override
  int get hashCode => json.hashCode;

  @override
  String toString() => 'ServiceAccountKey(redacted)';
}
