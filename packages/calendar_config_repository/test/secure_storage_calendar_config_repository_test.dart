import 'package:calendar_config_repository/calendar_config_repository.dart';
// ignore: implementation_imports
import 'package:calendar_config_repository/src/secure_store.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const _testKey = ServiceAccountKey('{"test":"not-a-real-key"}');

/// Scriptable [SecureStore] double. Every field is thrown from the matching
/// method when non-null.
class _FakeSecureStore implements SecureStore {
  final Map<String, String> data = {};
  int readCount = 0;
  Object? readError;
  Object? writeError;
  Object? deleteError;
  final Map<String, Object> deleteErrorsByKey = {};
  final List<String> deletedKeys = [];

  @override
  Future<String?> read(String key) async {
    readCount++;
    final error = readError;
    if (error != null) throw error;
    return data[key];
  }

  @override
  Future<void> write(String key, String value) async {
    final error = writeError;
    if (error != null) throw error;
    data[key] = value;
  }

  @override
  Future<void> delete(String key) async {
    deletedKeys.add(key);
    final keyError = deleteErrorsByKey[key];
    if (keyError != null) throw keyError;
    final error = deleteError;
    if (error != null) throw error;
    data.remove(key);
  }
}

void main() {
  group('SecureStorageCalendarConfigRepository', () {
    test('empty storage: configChanges emits null', () async {
      final store = _FakeSecureStore();
      final repository = SecureStorageCalendarConfigRepository(store: store);
      addTearDown(repository.dispose);

      await expectLater(repository.configChanges, emits(isNull));
    });

    test(
      'both keys present: configChanges emits the matching config',
      () async {
        final store = _FakeSecureStore()
          ..data[SecureStorageCalendarConfigRepository.calendarIdKey] = 'cal-1'
          ..data[SecureStorageCalendarConfigRepository.serviceAccountKeyKey] =
              _testKey.json;
        final repository = SecureStorageCalendarConfigRepository(store: store);
        addTearDown(repository.dispose);

        await expectLater(
          repository.configChanges,
          emits(
            const CalendarConfig(
              calendarId: 'cal-1',
              serviceAccountKey: _testKey,
            ),
          ),
        );
      },
    );

    test('only the calendar id present: configChanges emits null', () async {
      final store = _FakeSecureStore()
        ..data[SecureStorageCalendarConfigRepository.calendarIdKey] = 'cal-1';
      final repository = SecureStorageCalendarConfigRepository(store: store);
      addTearDown(repository.dispose);

      await expectLater(repository.configChanges, emits(isNull));
    });

    test('only the key present: configChanges emits null', () async {
      final store = _FakeSecureStore()
        ..data[SecureStorageCalendarConfigRepository.serviceAccountKeyKey] =
            _testKey.json;
      final repository = SecureStorageCalendarConfigRepository(store: store);
      addTearDown(repository.dispose);

      await expectLater(repository.configChanges, emits(isNull));
    });

    test('save writes both keys, trims both, and emits the config', () async {
      final store = _FakeSecureStore();
      final repository = SecureStorageCalendarConfigRepository(store: store);
      addTearDown(repository.dispose);

      final expectation = expectLater(
        repository.configChanges,
        emitsInOrder([
          isNull,
          const CalendarConfig(
            calendarId: 'cal-1',
            serviceAccountKey: _testKey,
          ),
        ]),
      );

      await repository.save(
        CalendarConfig(
          calendarId: '  cal-1  ',
          serviceAccountKey: ServiceAccountKey('  ${_testKey.json}  '),
        ),
      );
      await expectation;

      expect(
        store.data[SecureStorageCalendarConfigRepository.calendarIdKey],
        'cal-1',
      );
      expect(
        store.data[SecureStorageCalendarConfigRepository.serviceAccountKeyKey],
        _testKey.json,
      );
    });

    test('save rejects an empty calendar id and writes nothing', () async {
      final store = _FakeSecureStore();
      final repository = SecureStorageCalendarConfigRepository(store: store);
      addTearDown(repository.dispose);

      await expectLater(
        () => repository.save(
          const CalendarConfig(calendarId: '', serviceAccountKey: _testKey),
        ),
        throwsA(
          isA<CalendarConfigException>().having(
            (e) => e.message,
            'message',
            'A calendar id is required.',
          ),
        ),
      );
      expect(store.data, isEmpty);
    });

    test('save rejects an empty key and writes nothing', () async {
      final store = _FakeSecureStore();
      final repository = SecureStorageCalendarConfigRepository(store: store);
      addTearDown(repository.dispose);

      await expectLater(
        () => repository.save(
          const CalendarConfig(
            calendarId: 'cal-1',
            serviceAccountKey: ServiceAccountKey(''),
          ),
        ),
        throwsA(
          isA<CalendarConfigException>().having(
            (e) => e.message,
            'message',
            'A service account key is required.',
          ),
        ),
      );
      expect(store.data, isEmpty);
    });

    test('save rejects malformed JSON and writes nothing', () async {
      final store = _FakeSecureStore();
      final repository = SecureStorageCalendarConfigRepository(store: store);
      addTearDown(repository.dispose);

      await expectLater(
        () => repository.save(
          const CalendarConfig(
            calendarId: 'cal-1',
            serviceAccountKey: ServiceAccountKey('not json'),
          ),
        ),
        throwsA(
          isA<CalendarConfigException>().having(
            (e) => e.message,
            'message',
            'The service account key is not valid JSON.',
          ),
        ),
      );
      expect(store.data, isEmpty);
    });

    test('save rejects a JSON array (valid JSON, not an object) and writes '
        'nothing', () async {
      final store = _FakeSecureStore();
      final repository = SecureStorageCalendarConfigRepository(store: store);
      addTearDown(repository.dispose);

      await expectLater(
        () => repository.save(
          const CalendarConfig(
            calendarId: 'cal-1',
            serviceAccountKey: ServiceAccountKey('[]'),
          ),
        ),
        throwsA(
          isA<CalendarConfigException>().having(
            (e) => e.message,
            'message',
            'The service account key is not valid JSON.',
          ),
        ),
      );
      expect(store.data, isEmpty);
    });

    test('writeError: throws CalendarConfigException carrying the '
        'PlatformException as cause, and deletes both keys', () async {
      final platformException = PlatformException(code: 'Exception');
      final store = _FakeSecureStore()..writeError = platformException;
      final repository = SecureStorageCalendarConfigRepository(store: store);
      addTearDown(repository.dispose);

      await expectLater(
        () => repository.save(
          const CalendarConfig(
            calendarId: 'cal-1',
            serviceAccountKey: _testKey,
          ),
        ),
        throwsA(
          isA<CalendarConfigException>()
              .having(
                (e) => e.message,
                'message',
                'Could not save the calendar configuration.',
              )
              .having((e) => e.cause, 'cause', same(platformException)),
        ),
      );
      expect(
        store.deletedKeys,
        containsAll([
          SecureStorageCalendarConfigRepository.calendarIdKey,
          SecureStorageCalendarConfigRepository.serviceAccountKeyKey,
        ]),
      );
    });

    test(
      'readError: configChanges emits a CalendarConfigException (not the '
      'PlatformException), and a later subscriber retries the read',
      () async {
        final store = _FakeSecureStore()
          ..readError = PlatformException(code: 'Exception');
        final repository = SecureStorageCalendarConfigRepository(store: store);
        addTearDown(repository.dispose);

        await expectLater(
          repository.configChanges,
          emitsError(isA<CalendarConfigException>()),
        );
        final firstReadCount = store.readCount;
        expect(firstReadCount, greaterThan(0));

        await expectLater(
          repository.configChanges,
          emitsError(isA<CalendarConfigException>()),
        );
        expect(store.readCount, greaterThan(firstReadCount));
      },
    );

    test('a late subscriber after a successful hydrate replays the current '
        'config without re-reading', () async {
      final store = _FakeSecureStore()
        ..data[SecureStorageCalendarConfigRepository.calendarIdKey] = 'cal-1'
        ..data[SecureStorageCalendarConfigRepository.serviceAccountKeyKey] =
            _testKey.json;
      final repository = SecureStorageCalendarConfigRepository(store: store);
      addTearDown(repository.dispose);

      await expectLater(
        repository.configChanges,
        emits(
          const CalendarConfig(
            calendarId: 'cal-1',
            serviceAccountKey: _testKey,
          ),
        ),
      );
      final readCountAfterHydrate = store.readCount;

      await expectLater(
        repository.configChanges,
        emits(
          const CalendarConfig(
            calendarId: 'cal-1',
            serviceAccountKey: _testKey,
          ),
        ),
      );
      expect(store.readCount, readCountAfterHydrate);
    });

    test('clear deletes both keys and emits null', () async {
      final store = _FakeSecureStore()
        ..data[SecureStorageCalendarConfigRepository.calendarIdKey] = 'cal-1'
        ..data[SecureStorageCalendarConfigRepository.serviceAccountKeyKey] =
            _testKey.json;
      final repository = SecureStorageCalendarConfigRepository(store: store);
      addTearDown(repository.dispose);

      final expectation = expectLater(
        repository.configChanges,
        emitsInOrder([
          const CalendarConfig(
            calendarId: 'cal-1',
            serviceAccountKey: _testKey,
          ),
          isNull,
        ]),
      );

      await repository.clear();
      await expectation;

      expect(
        store.deletedKeys,
        containsAll([
          SecureStorageCalendarConfigRepository.calendarIdKey,
          SecureStorageCalendarConfigRepository.serviceAccountKeyKey,
        ]),
      );
    });

    test('clear with deleteError set throws CalendarConfigException', () async {
      final store = _FakeSecureStore()
        ..deleteError = PlatformException(code: 'Exception');
      final repository = SecureStorageCalendarConfigRepository(store: store);
      addTearDown(repository.dispose);

      await expectLater(
        () => repository.clear(),
        throwsA(
          isA<CalendarConfigException>().having(
            (e) => e.message,
            'message',
            'Could not clear the calendar configuration.',
          ),
        ),
      );
    });

    test('clear with the second delete failing still attempts both deletes '
        'and leaves the config unchanged', () async {
      final platformException = PlatformException(code: 'Exception');
      final store = _FakeSecureStore()
        ..data[SecureStorageCalendarConfigRepository.calendarIdKey] = 'cal-1'
        ..data[SecureStorageCalendarConfigRepository.serviceAccountKeyKey] =
            _testKey.json
        ..deleteErrorsByKey[SecureStorageCalendarConfigRepository
                .serviceAccountKeyKey] =
            platformException;
      final repository = SecureStorageCalendarConfigRepository(store: store);
      addTearDown(repository.dispose);

      // Hydrate first so a later subscription proves the config, not
      // just the failed clear(), drives the assertion below.
      await expectLater(
        repository.configChanges,
        emits(
          const CalendarConfig(
            calendarId: 'cal-1',
            serviceAccountKey: _testKey,
          ),
        ),
      );

      await expectLater(
        () => repository.clear(),
        throwsA(
          isA<CalendarConfigException>()
              .having(
                (e) => e.message,
                'message',
                'Could not clear the calendar configuration.',
              )
              .having((e) => e.cause, 'cause', same(platformException)),
        ),
      );

      // Both deletes must be attempted even though the first succeeded
      // and the second failed.
      expect(
        store.deletedKeys,
        containsAll([
          SecureStorageCalendarConfigRepository.calendarIdKey,
          SecureStorageCalendarConfigRepository.serviceAccountKeyKey,
        ]),
      );

      // _current must not flip to cleared until both deletes succeed: a
      // later subscriber still sees the pre-clear config, not null.
      await expectLater(
        repository.configChanges,
        emits(
          const CalendarConfig(
            calendarId: 'cal-1',
            serviceAccountKey: _testKey,
          ),
        ),
      );
    });

    test('a save resolving after dispose() does not throw', () async {
      final store = _FakeSecureStore();
      final repository = SecureStorageCalendarConfigRepository(store: store);

      final save = repository.save(
        const CalendarConfig(calendarId: 'cal-1', serviceAccountKey: _testKey),
      );
      await repository.dispose();

      await expectLater(save, completes);
    });

    test(
      'no stored key material appears in the thrown exception toString()',
      () async {
        final store = _FakeSecureStore()
          ..writeError = PlatformException(code: 'Exception');
        final repository = SecureStorageCalendarConfigRepository(store: store);
        addTearDown(repository.dispose);

        const secretKey = ServiceAccountKey('{"private_key":"not-a-real-key"}');

        try {
          await repository.save(
            const CalendarConfig(
              calendarId: 'cal-1',
              serviceAccountKey: secretKey,
            ),
          );
          fail('expected save to throw');
        } catch (error) {
          expect(error.toString(), isNot(contains('private_key')));
          expect(error.toString(), isNot(contains('not-a-real-key')));
        }
      },
    );
  });
}
