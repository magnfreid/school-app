import 'dart:async';
import 'dart:convert';

import 'calendar_config_exception.dart';
import 'calendar_config_repository.dart';
import 'models/calendar_config.dart';
import 'models/service_account_key.dart';
import 'secure_store.dart';

/// [CalendarConfigRepository] backed by `flutter_secure_storage`.
///
/// `flutter_secure_storage` v11 reports every backend failure (Keystore
/// unavailable, decrypt failure, channel error) as a `PlatformException` and
/// nothing else, so a single untyped `catch` per operation is deliberate: the
/// vendor layer has exactly one failure channel and both clauses of a
/// typed/catch-all pair would map identically, so there is no ordering to get
/// wrong.
class SecureStorageCalendarConfigRepository
    implements CalendarConfigRepository {
  /// Creates a [SecureStorageCalendarConfigRepository] over [store].
  SecureStorageCalendarConfigRepository({
    SecureStore store = const FlutterSecureStore(),
  }) : _store = store;

  /// Storage key holding the calendar id.
  static const calendarIdKey = 'calendar_config.calendar_id';

  /// Storage key holding the service-account JSON key.
  static const serviceAccountKeyKey = 'calendar_config.service_account_key';

  final SecureStore _store;
  final _controller = StreamController<CalendarConfig?>.broadcast();
  CalendarConfig? _current;
  bool _loaded = false;
  Future<void>? _loading;

  @override
  Stream<CalendarConfig?> get configChanges => Stream.multi((controller) {
    final subscription = _controller.stream.listen(
      controller.add,
      onError: controller.addError,
      onDone: controller.close,
    );
    controller
      ..onPause = subscription.pause
      ..onResume = subscription.resume
      ..onCancel = subscription.cancel;

    if (_loaded) {
      controller.add(_current);
    } else {
      unawaited(_hydrate());
    }
  });

  Future<void> _hydrate() => _loading ??= _read();

  Future<void> _read() async {
    try {
      final calendarId = await _store.read(calendarIdKey);
      final serviceAccountKeyJson = await _store.read(serviceAccountKeyKey);
      final hasCalendarId = calendarId != null && calendarId.isNotEmpty;
      final hasKey =
          serviceAccountKeyJson != null && serviceAccountKeyJson.isNotEmpty;

      _current = (hasCalendarId && hasKey)
          ? CalendarConfig(
              calendarId: calendarId,
              serviceAccountKey: ServiceAccountKey(serviceAccountKeyJson),
            )
          : null;
      _loaded = true;
      if (!_controller.isClosed) _controller.add(_current);
    } catch (error) {
      // Left unloaded so a later subscriber retries the read; treated as
      // unconfigured by CalendarConfigCubit, which already recovers from a
      // stream error that way.
      _loading = null;
      if (!_controller.isClosed) {
        _controller.addError(
          CalendarConfigException(
            'Could not read the stored calendar configuration.',
            cause: error,
          ),
        );
      }
    }
  }

  @override
  Future<void> save(CalendarConfig config) async {
    final calendarId = config.calendarId.trim();
    final serviceAccountKeyJson = config.serviceAccountKey.json.trim();

    if (calendarId.isEmpty) {
      throw const CalendarConfigException('A calendar id is required.');
    }
    if (serviceAccountKeyJson.isEmpty) {
      throw const CalendarConfigException('A service account key is required.');
    }

    Object? decoded;
    try {
      decoded = jsonDecode(serviceAccountKeyJson);
    } on FormatException {
      throw const CalendarConfigException(
        'The service account key is not valid JSON.',
      );
    }
    if (decoded is! Map<String, dynamic>) {
      throw const CalendarConfigException(
        'The service account key is not valid JSON.',
      );
    }

    try {
      await _store.write(calendarIdKey, calendarId);
      await _store.write(serviceAccountKeyKey, serviceAccountKeyJson);
    } catch (error) {
      // Best-effort: a failing delete must not mask the original error.
      try {
        await _store.delete(calendarIdKey);
      } catch (_) {
        // Ignored — see above.
      }
      try {
        await _store.delete(serviceAccountKeyKey);
      } catch (_) {
        // Ignored — see above.
      }
      throw CalendarConfigException(
        'Could not save the calendar configuration.',
        cause: error,
      );
    }

    _current = CalendarConfig(
      calendarId: calendarId,
      serviceAccountKey: ServiceAccountKey(serviceAccountKeyJson),
    );
    _loaded = true;
    if (!_controller.isClosed) _controller.add(_current);
  }

  @override
  Future<void> clear() async {
    // Best-effort: attempt both deletes so a failure on one key never
    // strands the other — see the same pattern in save()'s catch above.
    Object? firstError;
    try {
      await _store.delete(calendarIdKey);
    } catch (error) {
      firstError = error;
    }
    try {
      await _store.delete(serviceAccountKeyKey);
    } catch (error) {
      firstError ??= error;
    }

    if (firstError != null) {
      throw CalendarConfigException(
        'Could not clear the calendar configuration.',
        cause: firstError,
      );
    }

    _current = null;
    _loaded = true;
    if (!_controller.isClosed) _controller.add(null);
  }

  @override
  Future<void> dispose() => _controller.close();
}
