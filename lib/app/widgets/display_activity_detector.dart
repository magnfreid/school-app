import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_app/app/bloc/display_bloc.dart';
import 'package:school_app/app/bloc/display_event.dart';

/// Feeds every pointer-down and every foreground transition into
/// [DisplayBloc].
///
/// A [Listener], not a [GestureDetector]: `Listener` observes pointer events
/// during hit-testing and never enters the gesture arena, so week-view
/// paging, the FAB and the app-bar buttons behave exactly as before.
class DisplayActivityDetector extends StatefulWidget {
  /// Creates a [DisplayActivityDetector] wrapping [child].
  const DisplayActivityDetector({required this.child, super.key});

  /// The subtree below the detector.
  final Widget child;

  @override
  State<DisplayActivityDetector> createState() =>
      _DisplayActivityDetectorState();
}

class _DisplayActivityDetectorState extends State<DisplayActivityDetector> {
  late final AppLifecycleListener _lifecycleListener;

  @override
  void initState() {
    super.initState();
    _lifecycleListener = AppLifecycleListener(onStateChange: _onLifecycle);
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    super.dispose();
  }

  void _onLifecycle(AppLifecycleState state) {
    context.read<DisplayBloc>().add(
      DisplayEvent.foregroundChanged(
        isForeground: state == AppLifecycleState.resumed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // context.read only — never watch; this widget must never rebuild the
    // app subtree on a display-state change.
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) =>
          context.read<DisplayBloc>().add(const DisplayEvent.userInteracted()),
      child: widget.child,
    );
  }
}
