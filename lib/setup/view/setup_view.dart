import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_app/l10n/app_localizations.dart';
import 'package:school_app/l10n/extensions/app_localizations_extension.dart';
import 'package:school_app/setup/bloc/setup_bloc.dart';
import 'package:school_app/setup/bloc/setup_event.dart';
import 'package:school_app/setup/bloc/setup_state.dart';

/// Renders the setup form from [SetupBloc]'s state.
///
/// Public (not `_SetupView`) so a view-level test can inject a scripted bloc
/// via `BlocProvider.value` without going through [SetupPage]'s own wiring.
class SetupView extends StatefulWidget {
  /// Creates the [SetupView].
  const SetupView({super.key});

  @override
  State<SetupView> createState() => _SetupViewState();
}

class _SetupViewState extends State<SetupView> {
  late final TextEditingController _calendarIdController;
  late final TextEditingController _serviceAccountKeyController;

  @override
  void initState() {
    super.initState();
    _calendarIdController = TextEditingController();
    _serviceAccountKeyController = TextEditingController();
  }

  @override
  void dispose() {
    _calendarIdController.dispose();
    _serviceAccountKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.setupTitle)),
      body: BlocConsumer<SetupBloc, SetupState>(
        listener: (context, state) {
          switch (state) {
            case SetupFailure():
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(l10n.setupSaveFailed)));
            case SetupSaved():
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(l10n.setupSaveSucceeded)));
            case SetupEditing():
            case SetupSubmitting():
          }
        },
        builder: (context, state) {
          final bloc = context.read<SetupBloc>();
          final submitting = state is SetupSubmitting;
          final calendarIdError = state is SetupEditing
              ? state.calendarIdError
              : null;
          final serviceAccountKeyError = state is SetupEditing
              ? state.serviceAccountKeyError
              : null;

          return SingleChildScrollView(
            padding: EdgeInsets.all(context.spacing.large),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.setupIntro, style: context.text.bodyMedium),
                SizedBox(height: context.spacing.large),
                TextField(
                  key: const Key('setupCalendarIdField'),
                  controller: _calendarIdController,
                  enabled: !submitting,
                  autocorrect: false,
                  enableSuggestions: false,
                  enableIMEPersonalizedLearning: false,
                  decoration: InputDecoration(
                    labelText: l10n.setupCalendarIdLabel,
                    hintText: l10n.setupCalendarIdHint,
                    border: const OutlineInputBorder(),
                    errorText: _fieldErrorText(
                      l10n,
                      calendarIdError,
                      isKeyField: false,
                    ),
                  ),
                  onChanged: (value) =>
                      bloc.add(SetupEvent.calendarIdChanged(value)),
                ),
                SizedBox(height: context.spacing.medium),
                TextField(
                  key: const Key('setupServiceAccountKeyField'),
                  controller: _serviceAccountKeyController,
                  enabled: !submitting,
                  autocorrect: false,
                  enableSuggestions: false,
                  enableIMEPersonalizedLearning: false,
                  minLines: 4,
                  maxLines: 8,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    labelText: l10n.setupServiceAccountKeyLabel,
                    hintText: l10n.setupServiceAccountKeyHint,
                    border: const OutlineInputBorder(),
                    errorText: _fieldErrorText(
                      l10n,
                      serviceAccountKeyError,
                      isKeyField: true,
                    ),
                  ),
                  onChanged: (value) =>
                      bloc.add(SetupEvent.serviceAccountKeyChanged(value)),
                ),
                SizedBox(height: context.spacing.large),
                FilledButton(
                  onPressed: submitting
                      ? null
                      : () => bloc.add(const SetupEvent.submitted()),
                  child: submitting
                      ? SizedBox(
                          width: context.sizes.inlineProgressIndicator,
                          height: context.sizes.inlineProgressIndicator,
                          child: CircularProgressIndicator(
                            strokeWidth: context.sizes.inlineProgressStroke,
                            color: context.colors.onPrimary,
                          ),
                        )
                      : Text(l10n.setupSaveButton),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Maps [error] to its copy, or `null` when there is no error.
///
/// [isKeyField] picks between the two possible "empty" messages — the
/// calendar-id field and the service-account-key field read differently even
/// though both share [SetupFieldError.empty].
String? _fieldErrorText(
  AppLocalizations l10n,
  SetupFieldError? error, {
  required bool isKeyField,
}) {
  return switch (error) {
    null => null,
    SetupFieldError.empty =>
      isKeyField ? l10n.setupErrorKeyEmpty : l10n.setupErrorCalendarIdEmpty,
    SetupFieldError.malformedJson => l10n.setupErrorKeyMalformed,
  };
}
