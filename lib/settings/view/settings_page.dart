import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:school_app/l10n/extensions/app_localizations_extension.dart';

/// Placeholder for the settings feature.
///
/// Replaced by the settings chunk.
class SettingsPage extends StatelessWidget {
  /// Creates the [SettingsPage].
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(context.l10n.settingsTitle)),
    body: Center(
      child: Text(
        context.l10n.settingsPlaceholder,
        style: context.text.bodyLarge,
      ),
    ),
  );
}
