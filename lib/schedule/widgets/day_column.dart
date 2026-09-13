import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:school_app/l10n/extensions/app_localizations_extension.dart';
import 'package:school_app/schedule/bloc/schedule_state.dart';
import 'package:school_app/schedule/extensions/schedule_text_extension.dart';
import 'package:school_app/schedule/widgets/crayon_today_ring.dart';
import 'package:school_app/schedule/widgets/event_card.dart';

/// One column of the week grid: a day header plus its event cards.
///
/// The header never clips — the crayon today-ring deliberately overhangs it.
/// Cards sit in a non-scrolling [SingleChildScrollView], which is the
/// overflow clip: it never scrolls and never paints overflow stripes if a
/// column ever exceeds its height.
class DayColumn extends StatelessWidget {
  /// Creates a [DayColumn] for [day].
  const DayColumn({required this.day, super.key});

  /// The day this column renders.
  final ScheduleDay day;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _DayHeader(day: day),
        SizedBox(height: spacing.step7),
        Expanded(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              spacing: spacing.step7,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final event in day.events) EventCard(event: event),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DayHeader extends StatelessWidget {
  const _DayHeader({required this.day});

  final ScheduleDay day;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final scheduleColors = context.scheduleColors;
    final scheduleText = context.scheduleText;
    final spacing = context.spacing;
    final sizes = context.sizes;
    final l10n = context.l10n;

    final header = SizedBox(
      height: sizes.dayHeaderHeight,
      child: Padding(
        padding: EdgeInsets.only(left: spacing.xsmall),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.dayNameShort(day.date),
              style: scheduleText.dayName.copyWith(
                color: day.isToday
                    ? scheduleColors.onSurfaceStrong
                    : scheduleColors.dayName,
              ),
            ),
            SizedBox(height: spacing.step5),
            Text(
              l10n.dayAndMonth(day.date),
              style: scheduleText.dayDate.copyWith(
                color: day.isToday
                    ? scheduleColors.onSurfaceMedium
                    : colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );

    if (day.isToday) return CrayonTodayRing(color: colors.error, child: header);

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colors.outlineVariant,
            width: sizes.hairline,
          ),
        ),
      ),
      child: header,
    );
  }
}
