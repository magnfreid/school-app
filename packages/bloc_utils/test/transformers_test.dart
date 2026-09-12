import 'package:bloc/bloc.dart';
import 'package:bloc_utils/bloc_utils.dart';
import 'package:test/test.dart';

const _window = Duration(milliseconds: 60);

sealed class _Event {
  const _Event(this.value);

  final String value;
}

class _Tapped extends _Event {
  const _Tapped(super.value);
}

class _Recorder extends Bloc<_Event, List<String>> {
  _Recorder(EventTransformer<_Event> transformer) : super(const []) {
    on<_Event>(
      (event, emit) => emit([...state, event.value]),
      transformer: transformer,
    );
  }
}

void main() {
  group('debounce', () {
    test('a burst yields only the last event', () async {
      final bloc = _Recorder(debounce(_window));
      addTearDown(bloc.close);

      bloc
        ..add(const _Tapped('a'))
        ..add(const _Tapped('b'))
        ..add(const _Tapped('c'));
      await Future<void>.delayed(_window * 2);

      expect(bloc.state, ['c']);
    });

    test('events separated by more than the window both process', () async {
      final bloc = _Recorder(debounce(_window));
      addTearDown(bloc.close);

      bloc.add(const _Tapped('a'));
      await Future<void>.delayed(_window * 3);
      bloc.add(const _Tapped('b'));
      await Future<void>.delayed(_window * 3);

      expect(bloc.state, ['a', 'b']);
    });
  });

  group('throttle', () {
    test('a burst yields only the first event', () async {
      final bloc = _Recorder(throttle(_window));
      addTearDown(bloc.close);

      bloc
        ..add(const _Tapped('a'))
        ..add(const _Tapped('b'))
        ..add(const _Tapped('c'));
      await Future<void>.delayed(_window * 2);

      expect(bloc.state, ['a']);
    });

    test('an event mid-window is dropped, not replayed', () async {
      // trailing: false — the dropped event does not fire once the window
      // ends, unlike rxdart's default trailing throttle behaviour.
      final bloc = _Recorder(throttle(_window));
      addTearDown(bloc.close);

      bloc.add(const _Tapped('a'));
      await Future<void>.delayed(_window ~/ 2);
      bloc.add(const _Tapped('b'));
      await Future<void>.delayed(_window * 2);

      expect(bloc.state, ['a']);
    });

    test('an event after the window elapses processes', () async {
      final bloc = _Recorder(throttle(_window));
      addTearDown(bloc.close);

      bloc.add(const _Tapped('a'));
      await Future<void>.delayed(_window * 2);
      bloc.add(const _Tapped('b'));
      await Future<void>.delayed(_window * 2);

      expect(bloc.state, ['a', 'b']);
    });
  });
}
