import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_app/l10n/extensions/app_localizations_extension.dart';
import 'package:school_app/settings/bloc/settings_bloc.dart';
import 'package:school_app/settings/bloc/settings_event.dart';
import 'package:school_app/settings/bloc/settings_state.dart';

/// Renders the settings screen from [SettingsBloc]'s state.
///
/// Public (not `_SettingsView`) so a view-level test can inject a scripted
/// bloc via `BlocProvider.value` without going through [SettingsPage]'s own
/// wiring.
class SettingsView extends StatelessWidget {
  /// Creates the [SettingsView].
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: BlocConsumer<SettingsBloc, SettingsState>(
        listener: (context, state) {
          switch (state) {
            case SettingsFailure():
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.settingsUnsubscribeFailed)),
              );
            case SettingsIdle():
            case SettingsUnsubscribing():
            case SettingsUnsubscribed():
          }
        },
        builder: (context, state) {
          final busy =
              state is SettingsUnsubscribing || state is SettingsUnsubscribed;

          return SingleChildScrollView(
            padding: EdgeInsets.all(context.spacing.large),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.settingsUnsubscribeDescription,
                  style: context.text.bodyMedium,
                ),
                SizedBox(height: context.spacing.large),
                FilledButton(
                  key: const Key('settingsUnsubscribeButton'),
                  style: FilledButton.styleFrom(
                    backgroundColor: context.colors.error,
                    foregroundColor: context.colors.onError,
                  ),
                  onPressed: busy
                      ? null
                      : () => _confirmAndUnsubscribe(context),
                  child: busy
                      ? SizedBox(
                          width: context.sizes.inlineProgressIndicator,
                          height: context.sizes.inlineProgressIndicator,
                          child: CircularProgressIndicator(
                            strokeWidth: context.sizes.inlineProgressStroke,
                            color: context.colors.onError,
                          ),
                        )
                      : Text(l10n.settingsUnsubscribeButton),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Shows the destructive-action confirmation dialog and, only on a `true`
/// result, dispatches [SettingsEvent.unsubscribeConfirmed] to [context]'s
/// [SettingsBloc].
Future<void> _confirmAndUnsubscribe(BuildContext context) async {
  final l10n = context.l10n;
  final bloc = context.read<SettingsBloc>();

  final confirmed =
      await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(l10n.settingsUnsubscribeDialogTitle),
          content: Text(l10n.settingsUnsubscribeDialogBody),
          actions: [
            TextButton(
              key: const Key('settingsUnsubscribeDialogCancelButton'),
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.settingsUnsubscribeDialogCancel),
            ),
            TextButton(
              key: const Key('settingsUnsubscribeDialogConfirmButton'),
              style: TextButton.styleFrom(
                foregroundColor: context.colors.error,
              ),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.settingsUnsubscribeDialogConfirm),
            ),
          ],
        ),
      ) ??
      false;

  if (!confirmed || !context.mounted) return;
  bloc.add(const SettingsEvent.unsubscribeConfirmed());
}
