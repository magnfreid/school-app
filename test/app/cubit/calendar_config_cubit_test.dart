import 'package:bloc_test/bloc_test.dart';
import 'package:calendar_config_repository/calendar_config_repository.dart';
import 'package:school_app/app/cubit/calendar_config_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CalendarConfigCubit', () {
    late FakeCalendarConfigRepository repository;

    setUp(() {
      repository = FakeCalendarConfigRepository();
      addTearDown(repository.dispose);
    });

    test(
      'starts in CalendarConfigState.unknown before the repository reports',
      () {
        final cubit = CalendarConfigCubit(configRepository: repository);
        addTearDown(cubit.close);

        expect(cubit.state, const CalendarConfigState.unknown());
      },
    );

    blocTest<CalendarConfigCubit, CalendarConfigState>(
      'emits unconfigured when the repository reports no config',
      build: () => CalendarConfigCubit(configRepository: repository),
      wait: Duration.zero,
      expect: () => [const CalendarConfigState.unconfigured()],
    );

    blocTest<CalendarConfigCubit, CalendarConfigState>(
      'emits configured when the repository reports a config',
      setUp: () => repository.emit(const CalendarConfig(calendarId: 'cal-1')),
      build: () => CalendarConfigCubit(configRepository: repository),
      wait: Duration.zero,
      expect: () => [
        const CalendarConfigState.configured(
          CalendarConfig(calendarId: 'cal-1'),
        ),
      ],
    );

    blocTest<CalendarConfigCubit, CalendarConfigState>(
      'follows an out-of-band clear',
      setUp: () => repository.emit(const CalendarConfig(calendarId: 'cal-1')),
      build: () => CalendarConfigCubit(configRepository: repository),
      act: (_) async {
        // Let the seeded value land before changing it.
        await Future<void>.delayed(Duration.zero);
        repository.emit(null);
      },
      wait: Duration.zero,
      expect: () => [
        const CalendarConfigState.configured(
          CalendarConfig(calendarId: 'cal-1'),
        ),
        const CalendarConfigState.unconfigured(),
      ],
    );

    blocTest<CalendarConfigCubit, CalendarConfigState>(
      'falls back to unconfigured when the config stream errors',
      // Left in `unknown`, the router would hold the app on splash forever.
      build: () => CalendarConfigCubit(
        configRepository: _ErroringCalendarConfigRepository(),
      ),
      wait: Duration.zero,
      expect: () => [const CalendarConfigState.unconfigured()],
    );
  });
}

/// Repository whose stream fails.
class _ErroringCalendarConfigRepository implements CalendarConfigRepository {
  @override
  Stream<CalendarConfig?> get configChanges =>
      Stream<CalendarConfig?>.error(StateError('storage unreadable'));

  @override
  Future<void> save(CalendarConfig config) async {}

  @override
  Future<void> clear() async {}

  @override
  Future<void> dispose() async {}
}
