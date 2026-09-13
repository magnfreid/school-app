import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:school_app/l10n/extensions/app_localizations_extension.dart';
import 'package:school_app/schedule/bloc/schedule_state.dart';
import 'package:schedule_repository/schedule_repository.dart';

/// Band 3: two rows, always present — a week-spanning banner and a 5-to-7
/// column single-day banner row that lines up with the week grid below.
///
/// Deliberately not generalized to partial-week spans — the partial-week
/// treatment is unsigned-off design.
class SpecialEventLane extends StatelessWidget {
  /// Creates a [SpecialEventLane].
  const SpecialEventLane({
    required this.days,
    required this.weekSpecial,
    super.key,
  });

  /// The same day list the week grid renders, so a single-day banner sits
  /// directly above its own column. Empty in non-loaded states.
  final List<ScheduleDay> days;

  /// The week-spanning special, if any.
  final SpecialEventWholeWeek? weekSpecial;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final sizes = context.sizes;
    final weekSpecial = this.weekSpecial;

    return Padding(
      padding: EdgeInsets.only(
        left: spacing.step18,
        right: spacing.step18,
        top: spacing.step12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: spacing.step6,
        children: [
          SizedBox(
            height: sizes.weekBannerHeight,
            child: weekSpecial == null
                ? null
                : _WeekBanner(special: weekSpecial),
          ),
          SizedBox(
            height: sizes.dayBannerHeight,
            child: Row(
              spacing: spacing.step9,
              children: [
                for (final day in days) Expanded(child: _DayBanner(day: day)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

SpecialBannerColors _bannerColorsFor(
  SpecialEventColorPreset preset,
  ScheduleColors colors,
) {
  return switch (preset) {
    SpecialEventColorPreset.teal => colors.bannerTeal,
    SpecialEventColorPreset.amber => colors.bannerAmber,
    SpecialEventColorPreset.purple => colors.bannerPurple,
    SpecialEventColorPreset.green => colors.bannerGreen,
    SpecialEventColorPreset.pink => colors.bannerPink,
  };
}

class _WeekBanner extends StatelessWidget {
  const _WeekBanner({required this.special});

  final SpecialEventWholeWeek special;

  @override
  Widget build(BuildContext context) {
    final scheduleText = context.scheduleText;
    final spacing = context.spacing;
    final preset = _bannerColorsFor(
      special.colorPreset,
      context.scheduleColors,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(context.radius.step3),
      child: ColoredBox(
        color: preset.background,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing.step18),
          child: Row(
            spacing: spacing.step13,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                context.l10n.scheduleSpecialWeekLabel,
                style: scheduleText.bannerLabelWeek.copyWith(
                  color: preset.label,
                ),
              ),
              Flexible(
                child: Text(
                  special.title,
                  style: scheduleText.bannerTitleWeek.copyWith(
                    color: preset.title,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DayBanner extends StatelessWidget {
  const _DayBanner({required this.day});

  final ScheduleDay day;

  @override
  Widget build(BuildContext context) {
    final special = day.special;
    if (special == null) return const SizedBox.shrink();

    final scheduleText = context.scheduleText;
    final spacing = context.spacing;
    final preset = _bannerColorsFor(
      special.colorPreset,
      context.scheduleColors,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(context.radius.step3),
      child: ColoredBox(
        color: preset.background,
        child: Center(
          child: Row(
            spacing: spacing.small,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.l10n.scheduleSpecialDayLabel,
                style: scheduleText.bannerLabelDay.copyWith(
                  color: preset.label,
                ),
              ),
              Flexible(
                child: Text(
                  special.title,
                  style: scheduleText.bannerTitleDay.copyWith(
                    color: preset.title,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
