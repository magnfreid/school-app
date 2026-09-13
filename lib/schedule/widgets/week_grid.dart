import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:school_app/schedule/bloc/schedule_state.dart';
import 'package:school_app/schedule/widgets/day_column.dart';

/// Band 4: the week grid — one [DayColumn] per entry in [days], equal
/// widths, with gaps between them.
///
/// Renders nothing when [days] is empty (the non-loaded states); the caller
/// is responsible for reserving band 4's remaining vertical space regardless.
class WeekGrid extends StatelessWidget {
  /// Creates a [WeekGrid] for [days].
  const WeekGrid({required this.days, super.key});

  /// The days to render, one column each. Empty in non-loaded states.
  final List<ScheduleDay> days;

  @override
  Widget build(BuildContext context) {
    if (days.isEmpty) return const SizedBox.shrink();

    final spacing = context.spacing;

    return Padding(
      padding: EdgeInsets.only(
        left: spacing.step18,
        right: spacing.step18,
        bottom: spacing.step18,
        top: spacing.step14,
      ),
      child: Row(
        spacing: spacing.step9,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final day in days) Expanded(child: DayColumn(day: day)),
        ],
      ),
    );
  }
}
