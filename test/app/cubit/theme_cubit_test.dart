import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_starter/app/cubit/theme_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ThemeCubit', () {
    test('starts seeded on ThemeMode.system', () {
      final cubit = ThemeCubit();
      addTearDown(cubit.close);

      expect(cubit.state, ThemeMode.system);
    });

    blocTest<ThemeCubit, ThemeMode>(
      'cycles system -> light -> dark -> system',
      build: ThemeCubit.new,
      act: (cubit) => cubit
        ..cycle()
        ..cycle()
        ..cycle(),
      expect: () => [ThemeMode.light, ThemeMode.dark, ThemeMode.system],
    );
  });
}
