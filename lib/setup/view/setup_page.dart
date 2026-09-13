import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:school_app/l10n/extensions/app_localizations_extension.dart';

/// Placeholder for the setup feature.
///
/// Replaced by the config-storage chunk.
class SetupPage extends StatelessWidget {
  /// Creates the [SetupPage].
  const SetupPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(context.l10n.setupTitle)),
    body: Center(
      child: Text(context.l10n.setupPlaceholder, style: context.text.bodyLarge),
    ),
  );
}
