import 'package:bloc_test/bloc_test.dart';
import 'package:calendar_config_repository/calendar_config_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_app/setup/bloc/setup_bloc.dart';
import 'package:school_app/setup/bloc/setup_event.dart';
import 'package:school_app/setup/bloc/setup_state.dart';

const _validKeyJson = '{"placeholder":"not-a-real-key"}';

void main() {
  group('SetupBloc', () {
    late FakeCalendarConfigRepository repository;

    setUp(() {
      repository = FakeCalendarConfigRepository();
      addTearDown(repository.dispose);
    });

    blocTest<SetupBloc, SetupState>(
      'calendarIdChanged carries the key field through and clears only its '
      'own error',
      build: () => SetupBloc(configRepository: repository),
      seed: () => const SetupState.editing(
        serviceAccountKey: ServiceAccountKey('not json'),
        calendarIdError: SetupFieldError.empty,
        serviceAccountKeyError: SetupFieldError.malformedJson,
      ),
      act: (bloc) => bloc.add(const SetupEvent.calendarIdChanged('cal-1')),
      expect: () => [
        const SetupState.editing(
          calendarId: 'cal-1',
          serviceAccountKey: ServiceAccountKey('not json'),
          serviceAccountKeyError: SetupFieldError.malformedJson,
        ),
      ],
    );

    blocTest<SetupBloc, SetupState>(
      'serviceAccountKeyChanged carries the calendar id through and clears '
      'only its own error',
      build: () => SetupBloc(configRepository: repository),
      seed: () => const SetupState.editing(
        calendarId: 'cal-1',
        calendarIdError: SetupFieldError.empty,
        serviceAccountKeyError: SetupFieldError.malformedJson,
      ),
      act: (bloc) =>
          bloc.add(const SetupEvent.serviceAccountKeyChanged('not json')),
      expect: () => [
        const SetupState.editing(
          calendarId: 'cal-1',
          serviceAccountKey: ServiceAccountKey('not json'),
          calendarIdError: SetupFieldError.empty,
        ),
      ],
    );

    blocTest<SetupBloc, SetupState>(
      'submit with an empty calendar id sets calendarIdError and does not '
      'save',
      build: () => SetupBloc(configRepository: repository),
      seed: () => const SetupState.editing(
        serviceAccountKey: ServiceAccountKey(_validKeyJson),
      ),
      act: (bloc) => bloc.add(const SetupEvent.submitted()),
      expect: () => [
        const SetupState.editing(
          serviceAccountKey: ServiceAccountKey(_validKeyJson),
          calendarIdError: SetupFieldError.empty,
        ),
      ],
      verify: (_) => expect(repository.saveCalls, isEmpty),
    );

    blocTest<SetupBloc, SetupState>(
      'submit with malformed JSON sets serviceAccountKeyError and does not '
      'save',
      build: () => SetupBloc(configRepository: repository),
      seed: () => const SetupState.editing(
        calendarId: 'cal-1',
        serviceAccountKey: ServiceAccountKey('not json'),
      ),
      act: (bloc) => bloc.add(const SetupEvent.submitted()),
      expect: () => [
        const SetupState.editing(
          calendarId: 'cal-1',
          serviceAccountKey: ServiceAccountKey('not json'),
          serviceAccountKeyError: SetupFieldError.malformedJson,
        ),
      ],
      verify: (_) => expect(repository.saveCalls, isEmpty),
    );

    blocTest<SetupBloc, SetupState>(
      'a valid submit trims both fields, saves once, and emits submitting '
      'then saved',
      build: () => SetupBloc(configRepository: repository),
      seed: () => const SetupState.editing(
        calendarId: '  cal-1  ',
        serviceAccountKey: ServiceAccountKey('  $_validKeyJson  '),
      ),
      act: (bloc) => bloc.add(const SetupEvent.submitted()),
      expect: () => [
        const SetupState.submitting(
          calendarId: 'cal-1',
          serviceAccountKey: ServiceAccountKey(_validKeyJson),
        ),
        const SetupState.saved(
          calendarId: 'cal-1',
          serviceAccountKey: ServiceAccountKey(_validKeyJson),
        ),
      ],
      verify: (_) {
        expect(repository.saveCalls, [
          const CalendarConfig(
            calendarId: 'cal-1',
            serviceAccountKey: ServiceAccountKey(_validKeyJson),
          ),
        ]);
      },
    );

    blocTest<SetupBloc, SetupState>(
      'a scripted saveError emits submitting then failure',
      build: () {
        repository.saveError = const CalendarConfigException('nope');
        return SetupBloc(configRepository: repository);
      },
      seed: () => const SetupState.editing(
        calendarId: 'cal-1',
        serviceAccountKey: ServiceAccountKey(_validKeyJson),
      ),
      act: (bloc) => bloc.add(const SetupEvent.submitted()),
      expect: () => [
        const SetupState.submitting(
          calendarId: 'cal-1',
          serviceAccountKey: ServiceAccountKey(_validKeyJson),
        ),
        const SetupState.failure(
          calendarId: 'cal-1',
          serviceAccountKey: ServiceAccountKey(_validKeyJson),
        ),
      ],
    );

    blocTest<SetupBloc, SetupState>(
      'a field change after failure returns to editing',
      build: () => SetupBloc(configRepository: repository),
      seed: () => const SetupState.failure(
        calendarId: 'cal-1',
        serviceAccountKey: ServiceAccountKey(_validKeyJson),
      ),
      act: (bloc) => bloc.add(const SetupEvent.calendarIdChanged('cal-2')),
      expect: () => [
        const SetupState.editing(
          calendarId: 'cal-2',
          serviceAccountKey: ServiceAccountKey(_validKeyJson),
        ),
      ],
    );

    group('droppable', () {
      late FakeCalendarConfigRepository delayedRepository;

      blocTest<SetupBloc, SetupState>(
        'two submitted events in the same turn produce one save',
        build: () {
          delayedRepository = FakeCalendarConfigRepository(
            saveDelay: const Duration(milliseconds: 10),
          );
          addTearDown(delayedRepository.dispose);
          return SetupBloc(configRepository: delayedRepository);
        },
        seed: () => const SetupState.editing(
          calendarId: 'cal-1',
          serviceAccountKey: ServiceAccountKey(_validKeyJson),
        ),
        act: (bloc) {
          bloc.add(const SetupEvent.submitted());
          bloc.add(const SetupEvent.submitted());
        },
        wait: const Duration(milliseconds: 50),
        expect: () => [
          const SetupState.submitting(
            calendarId: 'cal-1',
            serviceAccountKey: ServiceAccountKey(_validKeyJson),
          ),
          const SetupState.saved(
            calendarId: 'cal-1',
            serviceAccountKey: ServiceAccountKey(_validKeyJson),
          ),
        ],
        verify: (_) => expect(delayedRepository.saveCalls, hasLength(1)),
      );
    });
  });

  group('SetupState.editing toString', () {
    test('does not leak the raw service-account key payload', () {
      const state = SetupState.editing(
        serviceAccountKey: ServiceAccountKey(_validKeyJson),
      );

      expect(state.toString(), isNot(contains(_validKeyJson)));
      expect(state.toString(), contains('ServiceAccountKey(redacted)'));
    });
  });
}
