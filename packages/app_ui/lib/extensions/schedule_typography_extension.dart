import 'package:app_ui/typography/schedule_typography.dart';
import 'package:flutter/widgets.dart';

/// Extension on [BuildContext] to provide easy access to
/// [ScheduleTypography] tokens.
extension ScheduleTypographyExtensionX on BuildContext {
  /// Returns a [ScheduleTypography] instance for accessing Week View text
  /// roles.
  ///
  /// Example: `context.scheduleText.heroTitle`
  ScheduleTypography get scheduleText => const ScheduleTypography();
}
