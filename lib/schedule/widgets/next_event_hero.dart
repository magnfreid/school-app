import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:school_app/l10n/extensions/app_localizations_extension.dart';
import 'package:school_app/schedule/bloc/schedule_state.dart';
import 'package:school_app/schedule/extensions/schedule_text_extension.dart';

/// Band 2: the next upcoming event in the displayed week, or [emptyMessage]
/// when there is none.
///
/// Always renders the full 138dp container and its accent edge — the band
/// never collapses, so nothing else on the screen ever jumps.
class NextEventHero extends StatelessWidget {
  /// Creates a [NextEventHero].
  const NextEventHero({
    required this.nextEvent,
    required this.emptyMessage,
    super.key,
  });

  /// The next upcoming event, or `null` to show [emptyMessage] instead.
  final NextEvent? nextEvent;

  /// Shown on the title line when [nextEvent] is `null`.
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final scheduleColors = context.scheduleColors;
    final scheduleText = context.scheduleText;
    final spacing = context.spacing;
    final sizes = context.sizes;
    final radius = context.radius;
    final l10n = context.l10n;
    final next = nextEvent;

    final Widget content = next == null
        ? Text(
            emptyMessage,
            style: scheduleText.heroSubject.copyWith(
              color: colors.onSurfaceVariant,
            ),
          )
        : Row(
            spacing: spacing.step22,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: sizes.heroEyebrowHeight,
                      child: Row(
                        spacing: spacing.step12,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            l10n.heroEyebrow(next.event),
                            style: scheduleText.heroEyebrow.copyWith(
                              color: scheduleColors.provLabel,
                            ),
                          ),
                          if (next.daysUntil > 1)
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: spacing.xsmall,
                                horizontal: spacing.step10,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  radius.step12,
                                ),
                                border: Border.all(
                                  color: colors.outline,
                                  width: sizes.hairline,
                                ),
                              ),
                              child: Text(
                                l10n.scheduleDaysUntil(next.daysUntil),
                                style: scheduleText.countdownPill.copyWith(
                                  color: scheduleColors.onSurfaceMedium,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: spacing.small),
                    Text(
                      next.event.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: scheduleText.heroTitle.copyWith(
                        color: scheduleColors.onSurfaceStrong,
                      ),
                    ),
                    SizedBox(height: spacing.step9),
                    Text(
                      next.event.subjectCode,
                      style: scheduleText.heroSubject.copyWith(
                        color: scheduleColors.onSurfaceMedium,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    switch (next.relativeDay) {
                      RelativeDay.today => l10n.scheduleRelativeToday,
                      RelativeDay.tomorrow => l10n.scheduleRelativeTomorrow,
                      RelativeDay.later => l10n.dayNameLong(next.event.date),
                    },
                    style: scheduleText.heroDate.copyWith(
                      color: scheduleColors.onSurfaceStrong,
                    ),
                  ),
                  SizedBox(height: spacing.small),
                  Text(
                    l10n.heroDateLine(next.event),
                    style: scheduleText.heroDateSub.copyWith(
                      color: scheduleColors.onSurfaceMedium,
                    ),
                  ),
                ],
              ),
            ],
          );

    return Padding(
      padding: EdgeInsets.only(
        left: spacing.step18,
        right: spacing.step18,
        top: spacing.xsmall,
      ),
      child: SizedBox(
        height: sizes.heroHeight,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius.xsmall),
          child: ColoredBox(
            color: colors.surfaceContainer,
            child: Row(
              children: [
                SizedBox(
                  width: sizes.heroAccentWidth,
                  height: double.infinity,
                  child: ColoredBox(color: colors.error),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: spacing.step22,
                      right: spacing.large,
                    ),
                    child: content,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
