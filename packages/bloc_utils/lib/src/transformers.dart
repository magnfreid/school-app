import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

/// Debounces events by [duration]. Only the last event in a burst is processed.
///
/// Typical use: search fields, where you want to wait until the user
/// stops typing before firing a request.
///
/// ```dart
/// on<SearchChanged>(_onSearchChanged, transformer: debounce(Durations.medium4));
/// ```
EventTransformer<E> debounce<E>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
}

/// Throttles events by [duration]. The first event in a burst is processed;
/// subsequent events within [duration] are dropped.
///
/// Typical use: buttons or taps where you want to prevent double-firing.
///
/// ```dart
/// on<ButtonTapped>(_onButtonTapped, transformer: throttle(Durations.medium4));
/// ```
EventTransformer<E> throttle<E>(Duration duration) {
  return (events, mapper) =>
      events.throttleTime(duration, trailing: false).switchMap(mapper);
}
