import 'package:display_repository/display_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FakeDisplayRepository', () {
    late FakeDisplayRepository repository;

    setUp(() {
      repository = FakeDisplayRepository();
      addTearDown(repository.dispose);
    });

    test('defaults to not powered', () {
      expect(repository.powerChanges, emits(false));
    });

    test('initialExternallyPowered: true seeds true', () {
      final poweredRepository = FakeDisplayRepository(
        initialExternallyPowered: true,
      );
      addTearDown(poweredRepository.dispose);

      expect(poweredRepository.powerChanges, emits(true));
    });

    test('emitPower reaches a live subscriber', () async {
      expect(repository.powerChanges, emitsInOrder([false, true]));

      repository.emitPower(isExternallyPowered: true);
      await pumpEventQueue();
    });

    test('normalBrightnessError makes normalBrightness throw, and the call is '
        'still recorded', () async {
      repository.normalBrightnessError = const DisplayException('nope');

      await expectLater(
        repository.normalBrightness(),
        throwsA(isA<DisplayException>()),
      );

      expect(repository.calls, ['normal']);
    });

    test('setBrightnessError makes setBrightness throw, and the call is still '
        'recorded', () async {
      repository.setBrightnessError = const DisplayException('nope');

      await expectLater(
        repository.setBrightness(0.5),
        throwsA(isA<DisplayException>()),
      );

      expect(repository.calls, ['brightness:0.50']);
      expect(repository.brightnessCalls, [0.5]);
    });

    test(
      'restoreBrightnessError makes restoreBrightness throw, and the call is '
      'still recorded',
      () async {
        repository.restoreBrightnessError = const DisplayException('nope');

        await expectLater(
          repository.restoreBrightness(),
          throwsA(isA<DisplayException>()),
        );

        expect(repository.calls, ['restore']);
        expect(repository.restoreCount, 1);
      },
    );

    test('setWakelockError makes setWakelock throw, and the call is still '
        'recorded', () async {
      repository.setWakelockError = const DisplayException('nope');

      await expectLater(
        repository.setWakelock(enabled: true),
        throwsA(isA<DisplayException>()),
      );

      expect(repository.calls, ['wakelock:true']);
      expect(repository.wakelockCalls, [true]);
    });

    test('emitPower after dispose() does not throw', () async {
      await repository.dispose();

      expect(
        () => repository.emitPower(isExternallyPowered: true),
        returnsNormally,
      );
    });
  });
}
