import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:display_repository/display_repository.dart';
import 'package:display_repository/src/display_platform.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Hand-written stub of [DisplayPlatform] — this package has no mocktail.
class _StubDisplayPlatform implements DisplayPlatform {
  _StubDisplayPlatform({
    this.batteryStateResult,
    this.batteryStateError,
    Stream<BatteryState>? batteryStateChangesStream,
    this.systemBrightnessError,
    this.resetApplicationBrightnessError,
    this.toggleWakelockError,
  }) : batteryStateChanges = batteryStateChangesStream ?? const Stream.empty();

  BatteryState? batteryStateResult;
  Object? batteryStateError;

  @override
  final Stream<BatteryState> batteryStateChanges;

  @override
  Future<BatteryState> batteryState() async {
    final error = batteryStateError;
    if (error != null) throw error;
    return batteryStateResult!;
  }

  double systemBrightnessResult = 1.0;
  Object? systemBrightnessError;

  @override
  Future<double> systemBrightness() async {
    final error = systemBrightnessError;
    if (error != null) throw error;
    return systemBrightnessResult;
  }

  final setApplicationBrightnessCalls = <double>[];
  Object? setApplicationBrightnessError;

  @override
  Future<void> setApplicationBrightness(double brightness) async {
    setApplicationBrightnessCalls.add(brightness);
    final error = setApplicationBrightnessError;
    if (error != null) throw error;
  }

  int resetApplicationBrightnessCalls = 0;
  Object? resetApplicationBrightnessError;

  @override
  Future<void> resetApplicationBrightness() async {
    resetApplicationBrightnessCalls++;
    callOrder.add('reset');
    final error = resetApplicationBrightnessError;
    if (error != null) throw error;
  }

  final toggleWakelockCalls = <bool>[];
  Object? toggleWakelockError;

  @override
  Future<void> toggleWakelock({required bool enable}) async {
    toggleWakelockCalls.add(enable);
    callOrder.add('toggle:$enable');
    final error = toggleWakelockError;
    if (error != null) throw error;
  }

  /// Records the order `resetApplicationBrightness`/`toggleWakelock` calls
  /// land in, so `dispose()`'s ordering can be pinned.
  final callOrder = <String>[];
}

void main() {
  group('DeviceDisplayRepository.powerChanges', () {
    test(
      'emits the current state on subscription, then subsequent ones',
      () async {
        final controller = StreamController<BatteryState>();
        addTearDown(controller.close);
        final stub = _StubDisplayPlatform(
          batteryStateResult: BatteryState.discharging,
          batteryStateChangesStream: controller.stream,
        );
        final repository = DeviceDisplayRepository(platform: stub);

        final values = <bool>[];
        final subscription = repository.powerChanges.listen(values.add);
        addTearDown(subscription.cancel);
        await pumpEventQueue();
        expect(values, [false]);

        controller.add(BatteryState.charging);
        await pumpEventQueue();
        expect(values, [false, true]);
      },
    );

    test('charging, full, connectedNotCharging map to true; discharging, '
        'unknown map to false', () async {
      final cases = {
        BatteryState.charging: true,
        BatteryState.full: true,
        BatteryState.connectedNotCharging: true,
        BatteryState.discharging: false,
        BatteryState.unknown: false,
      };

      for (final entry in cases.entries) {
        final stub = _StubDisplayPlatform(batteryStateResult: entry.key);
        final repository = DeviceDisplayRepository(platform: stub);
        await expectLater(repository.powerChanges, emits(entry.value));
      }
    });

    test('charging then full emits true once (distinct())', () async {
      final controller = StreamController<BatteryState>();
      addTearDown(controller.close);
      final stub = _StubDisplayPlatform(
        batteryStateResult: BatteryState.charging,
        batteryStateChangesStream: controller.stream,
      );
      final repository = DeviceDisplayRepository(platform: stub);

      final values = <bool>[];
      final subscription = repository.powerChanges.listen(values.add);
      addTearDown(subscription.cancel);
      await pumpEventQueue();

      controller.add(BatteryState.full);
      await pumpEventQueue();

      expect(values, [true]);
    });

    test('a throwing batteryState() yields false and the stream stays open for '
        'later values', () async {
      final controller = StreamController<BatteryState>();
      addTearDown(controller.close);
      final stub = _StubDisplayPlatform(
        batteryStateError: StateError('boom'),
        batteryStateChangesStream: controller.stream,
      );
      final repository = DeviceDisplayRepository(platform: stub);

      final values = <bool>[];
      final subscription = repository.powerChanges.listen(values.add);
      addTearDown(subscription.cancel);
      await pumpEventQueue();
      expect(values, [false]);

      controller.add(BatteryState.charging);
      await pumpEventQueue();
      expect(values, [false, true]);
    });

    test('an error on the platform stream is dropped and the last value '
        'stands', () async {
      final controller = StreamController<BatteryState>();
      addTearDown(controller.close);
      final stub = _StubDisplayPlatform(
        batteryStateResult: BatteryState.charging,
        batteryStateChangesStream: controller.stream,
      );
      final repository = DeviceDisplayRepository(platform: stub);

      final values = <bool>[];
      final subscription = repository.powerChanges.listen(values.add);
      addTearDown(subscription.cancel);
      await pumpEventQueue();
      expect(values, [true]);

      controller.addError(StateError('boom'));
      controller.add(BatteryState.discharging);
      await pumpEventQueue();

      expect(values, [true, false]);
    });
  });

  group('DeviceDisplayRepository.setBrightness', () {
    test(
      'setBrightness(1.4) forwards 1.0; setBrightness(-0.2) forwards 0.0',
      () async {
        final stub = _StubDisplayPlatform();
        final repository = DeviceDisplayRepository(platform: stub);

        await repository.setBrightness(1.4);
        await repository.setBrightness(-0.2);

        expect(stub.setApplicationBrightnessCalls, [1.0, 0.0]);
      },
    );
  });

  group('DeviceDisplayRepository failure mapping', () {
    test('MissingPluginException maps to the missing-plugin message', () async {
      final stub = _StubDisplayPlatform(
        systemBrightnessError: MissingPluginException('nope'),
      );
      final repository = DeviceDisplayRepository(platform: stub);

      await expectLater(
        repository.normalBrightness(),
        throwsA(
          isA<DisplayException>()
              .having(
                (e) => e.message,
                'message',
                'Display control is not available on this device.',
              )
              .having((e) => e.cause, 'cause', isA<MissingPluginException>()),
        ),
      );
    });

    test('PlatformException maps to the rejected-command message', () async {
      final stub = _StubDisplayPlatform(
        systemBrightnessError: PlatformException(code: 'nope'),
      );
      final repository = DeviceDisplayRepository(platform: stub);

      await expectLater(
        repository.normalBrightness(),
        throwsA(
          isA<DisplayException>()
              .having(
                (e) => e.message,
                'message',
                'The device rejected a display command.',
              )
              .having((e) => e.cause, 'cause', isA<PlatformException>()),
        ),
      );
    });

    test('an unexpected error maps to the catch-all message', () async {
      final stub = _StubDisplayPlatform(
        systemBrightnessError: StateError('boom'),
      );
      final repository = DeviceDisplayRepository(platform: stub);

      await expectLater(
        repository.normalBrightness(),
        throwsA(
          isA<DisplayException>()
              .having(
                (e) => e.message,
                'message',
                'Could not control the display.',
              )
              .having((e) => e.cause, 'cause', isA<StateError>()),
        ),
      );
    });
  });

  group('DeviceDisplayRepository.dispose', () {
    test('calls resetApplicationBrightness then toggleWakelock(enable: false), '
        'and completes even when both throw', () async {
      final stub = _StubDisplayPlatform(
        resetApplicationBrightnessError: StateError('boom'),
        toggleWakelockError: StateError('boom'),
      );
      final repository = DeviceDisplayRepository(platform: stub);

      await repository.dispose();

      expect(stub.resetApplicationBrightnessCalls, 1);
      expect(stub.toggleWakelockCalls, [false]);
      expect(stub.callOrder, ['reset', 'toggle:false']);
    });
  });
}
