import 'dart:convert';

import 'package:bloc_utils/bloc_utils.dart';
import 'package:calendar_config_repository/calendar_config_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'setup_event.dart';
import 'setup_state.dart';

/// Owns the setup form: field edits and the submit/save flow.
///
/// A Bloc, not a Cubit: submit is a user-triggered event with a real
/// concurrency requirement — `droppable()` on submit so a double-tap can't
/// fire two saves.
class SetupBloc extends Bloc<SetupEvent, SetupState> {
  /// Creates a [SetupBloc] backed by [configRepository].
  SetupBloc({required CalendarConfigRepository configRepository})
    : // An initializing formal would make the named parameter private
      // (`this._configRepository`), which breaks the public
      // `configRepository:` constructor argument callers use.
      // ignore: prefer_initializing_formals
      _configRepository = configRepository,
      super(const SetupState.editing()) {
    on<SetupCalendarIdChanged>(_onCalendarIdChanged);
    on<SetupServiceAccountKeyChanged>(_onServiceAccountKeyChanged);
    on<SetupSubmitted>(_onSubmitted, transformer: droppable());
  }

  final CalendarConfigRepository _configRepository;

  void _onCalendarIdChanged(
    SetupCalendarIdChanged event,
    Emitter<SetupState> emit,
  ) {
    final current = state;
    emit(
      SetupState.editing(
        calendarId: event.value,
        serviceAccountKey: current.serviceAccountKey,
        serviceAccountKeyError: current is SetupEditing
            ? current.serviceAccountKeyError
            : null,
      ),
    );
  }

  void _onServiceAccountKeyChanged(
    SetupServiceAccountKeyChanged event,
    Emitter<SetupState> emit,
  ) {
    final current = state;
    emit(
      SetupState.editing(
        calendarId: current.calendarId,
        serviceAccountKey: ServiceAccountKey(event.value),
        calendarIdError: current is SetupEditing
            ? current.calendarIdError
            : null,
      ),
    );
  }

  Future<void> _onSubmitted(
    SetupSubmitted event,
    Emitter<SetupState> emit,
  ) async {
    final calendarId = state.calendarId.trim();
    final keyJson = state.serviceAccountKey.json.trim();
    final serviceAccountKey = ServiceAccountKey(keyJson);

    final calendarIdError = calendarId.isEmpty ? SetupFieldError.empty : null;
    final serviceAccountKeyError = _serviceAccountKeyError(keyJson);

    if (calendarIdError != null || serviceAccountKeyError != null) {
      emit(
        SetupState.editing(
          calendarId: state.calendarId,
          serviceAccountKey: state.serviceAccountKey,
          calendarIdError: calendarIdError,
          serviceAccountKeyError: serviceAccountKeyError,
        ),
      );
      return;
    }

    emit(
      SetupState.submitting(
        calendarId: calendarId,
        serviceAccountKey: serviceAccountKey,
      ),
    );

    try {
      await _configRepository.save(
        CalendarConfig(
          calendarId: calendarId,
          serviceAccountKey: serviceAccountKey,
        ),
      );
      emit(
        SetupState.saved(
          calendarId: calendarId,
          serviceAccountKey: serviceAccountKey,
        ),
      );
    } on CalendarConfigException {
      emit(
        SetupState.failure(
          calendarId: calendarId,
          serviceAccountKey: serviceAccountKey,
        ),
      );
    } catch (_) {
      // Nothing about the storage error is safe or useful to show, so both
      // catch clauses reach the same state — there is no order-dependent
      // behaviour beyond both paths reaching `failure`. The typed clause
      // must stay first: reversing them is `dead_code_on_catch_subtype`.
      // Mirrors `ScheduleBloc._load`.
      emit(
        SetupState.failure(
          calendarId: calendarId,
          serviceAccountKey: serviceAccountKey,
        ),
      );
    }
  }

  SetupFieldError? _serviceAccountKeyError(String keyJson) {
    if (keyJson.isEmpty) return SetupFieldError.empty;
    Object? decoded;
    try {
      decoded = jsonDecode(keyJson);
    } on FormatException {
      return SetupFieldError.malformedJson;
    }
    return decoded is Map<String, dynamic>
        ? null
        : SetupFieldError.malformedJson;
  }
}
