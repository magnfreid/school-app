import 'package:bloc_test/bloc_test.dart';
import 'package:calendar_config_repository/calendar_config_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_app/settings/bloc/settings_bloc.dart';
import 'package:school_app/settings/bloc/settings_event.dart';
import 'package:school_app/settings/bloc/settings_state.dart';

const _testKey = ServiceAccountKey('{"placeholder":"not-a-real-key"}');
const _seededConfig = CalendarConfig(
  calendarId: 'cal-1',
  serviceAccountKey: _testKey,
);

/// Throws a non-[CalendarConfigException] from [clear] so the bloc's
/// catch-all clause is exercised rather than only the typed one.
class _ThrowingCalendarConfigRepository implements CalendarConfigRepository {
  @override
  Stream<CalendarConfig?> get configChanges =>
      Stream.value(_seededConfig).asBroadcastStream();

  @override
  Future<void> save(CalendarConfig config) async {}

  @override
  Future<void> clear() async {
    throw StateError('boom');
  }

  @override
  Future<void> dispose() async {}
}

void main() {
  group('SettingsBloc', () {
    late FakeCalendarConfigRepository repository;

    setUp(() {
      repository = FakeCalendarConfigRepository();
      addTearDown(repository.dispose);
    });

    blocTest<SettingsBloc, SettingsState>(
      'a confirmed unsubscribe emits unsubscribing then unsubscribed and '
      'clears once',
      build: () => SettingsBloc(configRepository: repository),
      act: (bloc) => bloc.add(const SettingsEvent.unsubscribeConfirmed()),
      expect: () => [
        const SettingsState.unsubscribing(),
        const SettingsState.unsubscribed(),
      ],
      verify: (_) => expect(repository.clearCount, 1),
    );

    blocTest<SettingsBloc, SettingsState>(
      'a scripted clearError emits unsubscribing then failure and leaves '
      'the config stored',
      build: () {
        repository = FakeCalendarConfigRepository(
          initialConfig: _seededConfig,
          clearError: const CalendarConfigException('nope'),
        );
        return SettingsBloc(configRepository: repository);
      },
      act: (bloc) => bloc.add(const SettingsEvent.unsubscribeConfirmed()),
      expect: () => [
        const SettingsState.unsubscribing(),
        const SettingsState.failure(),
      ],
      verify: (_) async {
        expect(repository.clearCount, 1);
        expect(await repository.configChanges.first, _seededConfig);
      },
    );

    blocTest<SettingsBloc, SettingsState>(
      'an unexpected error also emits failure',
      build: () =>
          SettingsBloc(configRepository: _ThrowingCalendarConfigRepository()),
      act: (bloc) => bloc.add(const SettingsEvent.unsubscribeConfirmed()),
      expect: () => [
        const SettingsState.unsubscribing(),
        const SettingsState.failure(),
      ],
    );

    group('droppable', () {
      late FakeCalendarConfigRepository delayedRepository;

      blocTest<SettingsBloc, SettingsState>(
        'two confirmed events in the same turn produce one clear',
        build: () {
          delayedRepository = FakeCalendarConfigRepository(
            clearDelay: const Duration(milliseconds: 10),
          );
          addTearDown(delayedRepository.dispose);
          return SettingsBloc(configRepository: delayedRepository);
        },
        act: (bloc) {
          bloc.add(const SettingsEvent.unsubscribeConfirmed());
          bloc.add(const SettingsEvent.unsubscribeConfirmed());
        },
        wait: const Duration(milliseconds: 50),
        expect: () => [
          const SettingsState.unsubscribing(),
          const SettingsState.unsubscribed(),
        ],
        verify: (_) => expect(delayedRepository.clearCount, 1),
      );
    });
  });
}
