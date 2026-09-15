import 'package:bloc_utils/bloc_utils.dart';
import 'package:calendar_config_repository/calendar_config_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'settings_event.dart';
import 'settings_state.dart';

/// Owns the settings screen's unsubscribe flow.
///
/// A Bloc, not a Cubit: the confirmed unsubscribe is a user-triggered event
/// with a real concurrency requirement — `droppable()` so a double-tap can't
/// fire two clears.
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  /// Creates a [SettingsBloc] backed by [configRepository].
  SettingsBloc({required CalendarConfigRepository configRepository})
    : // An initializing formal would make the named parameter private
      // (`this._configRepository`), which breaks the public
      // `configRepository:` constructor argument callers use.
      // ignore: prefer_initializing_formals
      _configRepository = configRepository,
      super(const SettingsState.idle()) {
    on<SettingsUnsubscribeConfirmed>(
      _onUnsubscribeConfirmed,
      transformer: droppable(),
    );
  }

  final CalendarConfigRepository _configRepository;

  Future<void> _onUnsubscribeConfirmed(
    SettingsUnsubscribeConfirmed event,
    Emitter<SettingsState> emit,
  ) async {
    emit(const SettingsState.unsubscribing());

    try {
      await _configRepository.clear();
      emit(const SettingsState.unsubscribed());
    } on CalendarConfigException {
      emit(const SettingsState.failure());
    } catch (_) {
      // Nothing about the storage error is safe or useful to show, so both
      // catch clauses reach the same state — there is no order-dependent
      // behaviour beyond both paths reaching `failure`. The typed clause
      // must stay first: reversing them is `dead_code_on_catch_subtype`.
      // Mirrors `SetupBloc._onSubmitted`.
      emit(const SettingsState.failure());
    }
  }
}
