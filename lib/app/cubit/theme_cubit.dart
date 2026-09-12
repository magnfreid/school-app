import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit that owns the active [ThemeMode] and exposes [cycle] to rotate it.
class ThemeCubit extends Cubit<ThemeMode> {
  /// Creates a [ThemeCubit] seeded with [ThemeMode.system].
  ThemeCubit() : super(ThemeMode.system);

  /// Cycles system → light → dark → system.
  void cycle() => emit(switch (state) {
    ThemeMode.system => ThemeMode.light,
    ThemeMode.light => ThemeMode.dark,
    ThemeMode.dark => ThemeMode.system,
  });
}
