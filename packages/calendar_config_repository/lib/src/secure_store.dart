import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// The slice of secure storage this package uses.
///
/// Not exported from the barrel: internal to the package, injected so the
/// repository's tests need no plugin and no platform-channel binding.
abstract interface class SecureStore {
  /// Reads the value stored under [key], or `null` when absent.
  Future<String?> read(String key);

  /// Writes [value] under [key].
  Future<void> write(String key, String value);

  /// Deletes the value stored under [key].
  Future<void> delete(String key);
}

/// [SecureStore] backed by `flutter_secure_storage`.
///
/// A pass-through: it catches nothing and maps nothing. Failures surface as
/// whatever the plugin threw and are mapped one level up, in
/// [SecureStorageCalendarConfigRepository].
class FlutterSecureStore implements SecureStore {
  /// Creates a [FlutterSecureStore] over [storage].
  const FlutterSecureStore({
    FlutterSecureStorage storage = const FlutterSecureStorage(),
  }) : _storage = storage;

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);
}
