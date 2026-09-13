import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:school_app/l10n/extensions/app_localizations_extension.dart';
import 'package:school_app/schedule/extensions/schedule_text_extension.dart';
import 'package:schedule_repository/schedule_repository.dart';

/// One event card inside a [DayColumn].
///
/// Two variants only, per the handoff's severity system: `prov` (test) gets
/// the accent edge and warm colours, everything else is neutral.
class EventCard extends StatelessWidget {
  /// Creates an [EventCard] for [event].
  const EventCard({required this.event, super.key});

  /// The event this card renders.
  final ScheduleEvent event;

  @override
  Widget build(BuildContext context) {
    final isProv = event.severity == EventSeverity.prov;
    final colors = context.colors;
    final scheduleColors = context.scheduleColors;
    final scheduleText = context.scheduleText;
    final spacing = context.spacing;
    final sizes = context.sizes;

    final background = isProv
        ? colors.errorContainer
        : colors.surfaceContainerHigh;
    final labelColor = isProv
        ? scheduleColors.provLabel
        : colors.onSurfaceVariant;
    final titleColor = isProv ? colors.onErrorContainer : colors.onSurface;

    final content = Padding(
      padding: EdgeInsets.symmetric(
        vertical: spacing.step9,
        horizontal: spacing.step12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.l10n.eventCardLabel(event),
            style: scheduleText.eventLabel.copyWith(color: labelColor),
          ),
          SizedBox(height: spacing.step5),
          Text(
            event.title,
            style: scheduleText.eventTitle.copyWith(color: titleColor),
          ),
        ],
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(context.radius.xsmall),
      child: ColoredBox(
        color: background,
        child: isProv
            ? IntrinsicHeight(
                child: Row(
                  children: [
                    SizedBox(
                      width: sizes.cardAccentWidth,
                      height: double.infinity,
                      child: ColoredBox(color: colors.error),
                    ),
                    Expanded(child: content),
                  ],
                ),
              )
            : content,
      ),
    );
  }
}
