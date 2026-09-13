import 'package:app_ui/colors/schedule_colors.dart';
import 'package:flutter/material.dart';

/// Extension on [BuildContext] to provide easy access to [ScheduleColors].
extension ScheduleColorsExtensionX on BuildContext {
  /// Returns the [ScheduleColors] theme extension.
  ///
  /// Never null — [ScheduleColors.dark] is registered on both app themes in
  /// `AppTheme`.
  ///
  /// Example: `context.scheduleColors.provLabel`
  ScheduleColors get scheduleColors =>
      Theme.of(this).extension<ScheduleColors>()!;
}
