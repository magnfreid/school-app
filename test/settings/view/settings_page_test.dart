import 'package:app_ui/app_ui.dart';
import 'package:calendar_config_repository/calendar_config_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_app/app/cubit/calendar_config_cubit.dart';
import 'package:school_app/l10n/app_localizations.dart';
import 'package:school_app/l10n/extensions/app_localizations_extension.dart';
import 'package:school_app/settings/view/settings_page.dart';
import 'package:schedule_repository/schedule_repository.dart';

import '../../helpers/app_harness.dart';

const _unsubscribeButtonKey = Key('settingsUnsubscribeButton');
const _dialogCancelButtonKey = Key('settingsUnsubscribeDialogCancelButton');
const _dialogConfirmButtonKey = Key('settingsUnsubscribeDialogConfirmButton');

Future<void> _pumpSettingsPage(
  WidgetTester tester,
  FakeCalendarConfigRepository configRepository,
) async {
  final configCubit = CalendarConfigCubit(configRepository: configRepository);
  addTearDown(configCubit.close);

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.darkTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: wrapWithAppProviders(
        configRepository: configRepository,
        scheduleRepository: FakeScheduleRepository(),
        configCubit: configCubit,
        child: const SettingsPage(),
      ),
    ),
  );
}

void main() {
  testWidgets('renders the description and the unsubscribe button', (
    tester,
  ) async {
    final repository = FakeCalendarConfigRepository();
    addTearDown(repository.dispose);
    await _pumpSettingsPage(tester, repository);
    await tester.pumpAndSettle();

    final l10n = tester.element(find.byType(SettingsPage)).l10n;

    expect(find.text(l10n.settingsUnsubscribeDescription), findsOneWidget);
    expect(find.text(l10n.settingsUnsubscribeButton), findsOneWidget);
  });

  testWidgets(
    'tapping unsubscribe opens the confirmation dialog and clears nothing '
    'yet',
    (tester) async {
      final repository = FakeCalendarConfigRepository();
      addTearDown(repository.dispose);
      await _pumpSettingsPage(tester, repository);
      await tester.pumpAndSettle();

      final l10n = tester.element(find.byType(SettingsPage)).l10n;
      await tester.tap(find.byKey(_unsubscribeButtonKey));
      await tester.pumpAndSettle();

      expect(find.text(l10n.settingsUnsubscribeDialogTitle), findsOneWidget);
      expect(repository.clearCount, 0);
    },
  );

  testWidgets('cancelling the dialog dismisses it and clears nothing', (
    tester,
  ) async {
    final repository = FakeCalendarConfigRepository();
    addTearDown(repository.dispose);
    await _pumpSettingsPage(tester, repository);
    await tester.pumpAndSettle();

    final l10n = tester.element(find.byType(SettingsPage)).l10n;
    await tester.tap(find.byKey(_unsubscribeButtonKey));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(_dialogCancelButtonKey));
    await tester.pumpAndSettle();

    expect(find.text(l10n.settingsUnsubscribeDialogTitle), findsNothing);
    expect(repository.clearCount, 0);
  });

  testWidgets('confirming the dialog clears exactly once', (tester) async {
    final repository = FakeCalendarConfigRepository();
    addTearDown(repository.dispose);
    await _pumpSettingsPage(tester, repository);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(_unsubscribeButtonKey));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(_dialogConfirmButtonKey));
    // The unsubscribe button intentionally keeps its indeterminate spinner
    // running after a successful clear — the config-gate redirect, not this
    // screen, navigates away — so pumpAndSettle would hang forever here.
    // Pump enough frames for the dialog to close and the bloc's undelayed
    // clear to resolve instead.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(repository.clearCount, 1);
  });

  testWidgets('a scripted clearError shows the failure SnackBar and leaves the '
      'button tappable', (tester) async {
    final repository = FakeCalendarConfigRepository(
      initialConfig: const CalendarConfig(
        calendarId: 'cal-1',
        serviceAccountKey: ServiceAccountKey(
          '{"placeholder":"not-a-real-key"}',
        ),
      ),
      clearError: const CalendarConfigException('nope'),
    );
    addTearDown(repository.dispose);
    await _pumpSettingsPage(tester, repository);
    await tester.pumpAndSettle();

    final l10n = tester.element(find.byType(SettingsPage)).l10n;
    await tester.tap(find.byKey(_unsubscribeButtonKey));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(_dialogConfirmButtonKey));
    await tester.pumpAndSettle();

    expect(find.text(l10n.settingsUnsubscribeFailed), findsOneWidget);

    final button = tester.widget<FilledButton>(
      find.byKey(_unsubscribeButtonKey),
    );
    expect(button.onPressed, isNotNull);
  });
}
