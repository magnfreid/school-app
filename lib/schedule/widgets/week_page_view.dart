import 'package:flutter/material.dart';
import 'package:school_app/schedule/bloc/schedule_state.dart';
import 'package:school_app/schedule/widgets/week_grid.dart';
import 'package:schedule_repository/schedule_repository.dart';

/// Band 4, made swipeable: a [PageView] of [WeekGrid]s across the ±radius
/// window `ScheduleRepository.fetchWindow` serves, so a swipe drives the
/// same `weekChanged` event the arrows fire.
///
/// Remembers the days it has been given per page index, so a page already
/// visited renders its last-known grid instead of blanking while a new page
/// is off screen and not yet loaded. Programmatic moves of more than one
/// page (an idle or anchor reset) jump instead of animate: an animated
/// multi-page move fires `onPageChanged` for every intermediate index, which
/// would drive the bloc through weeks the user never asked for.
class WeekPageView extends StatefulWidget {
  /// Creates a [WeekPageView].
  const WeekPageView({
    required this.days,
    required this.weekOffset,
    required this.onWeekChanged,
    super.key,
  });

  /// Day columns of the currently loaded week. Empty in non-loaded states.
  final List<ScheduleDay> days;

  /// Offset of the currently loaded week, -radius..radius.
  final int weekOffset;

  /// Invoked with the offset of the page the user swiped to.
  final ValueChanged<int> onWeekChanged;

  @override
  State<WeekPageView> createState() => _WeekPageViewState();
}

class _WeekPageViewState extends State<WeekPageView> {
  static const _radius = ScheduleRepository.windowRadiusInWeeks;

  final Map<int, List<ScheduleDay>> _weeks = {};
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _rememberDays();
    _controller = PageController(initialPage: _radius + widget.weekOffset);
  }

  @override
  void didUpdateWidget(WeekPageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _rememberDays();

    if (widget.weekOffset == oldWidget.weekOffset) return;
    if (!_controller.hasClients) return;
    final target = _radius + widget.weekOffset;
    final current = _controller.page?.round() ?? _controller.initialPage;
    if (current == target) return; // the swipe that caused this
    if ((target - current).abs() == 1) {
      _controller.animateToPage(
        target,
        duration: Durations.short3,
        curve: Curves.easeOut,
      );
    } else {
      _controller.jumpToPage(target); // multi-page: idle/anchor reset
    }
  }

  // Assigned unconditionally so a `failure`'s empty list clears that page
  // rather than leaving stale content.
  void _rememberDays() {
    _weeks[_radius + widget.weekOffset] = widget.days;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _controller,
      onPageChanged: (i) => widget.onWeekChanged(i - _radius),
      itemCount: _radius * 2 + 1,
      itemBuilder: (context, i) =>
          WeekGrid(days: _weeks[i] ?? const <ScheduleDay>[]),
    );
  }
}
