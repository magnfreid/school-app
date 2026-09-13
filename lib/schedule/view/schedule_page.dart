import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:school_app/l10n/extensions/app_localizations_extension.dart';

/// Placeholder for the schedule feature.
///
/// Replaced by the Week View chunk.
class SchedulePage extends StatelessWidget {
  /// Creates the [SchedulePage].
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(context.l10n.scheduleTitle)),
    body: Center(
      child: Text(
        context.l10n.schedulePlaceholder,
        style: context.text.bodyLarge,
      ),
    ),
  );
}
