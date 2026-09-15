import 'package:app_ui/app_ui.dart';
import 'package:calendar_config_repository/calendar_config_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_app/app/cubit/calendar_config_cubit.dart';
import 'package:school_app/l10n/app_localizations.dart';
import 'package:school_app/l10n/extensions/app_localizations_extension.dart';
import 'package:school_app/setup/view/setup_page.dart';
import 'package:schedule_repository/schedule_repository.dart';

import '../../helpers/app_harness.dart';

const _calendarIdFieldKey = Key('setupCalendarIdField');
const _serviceAccountKeyFieldKey = Key('setupServiceAccountKeyField');
const _validKeyJson = '{"placeholder":"not-a-real-key"}';

Future<void> _pumpSetupPage(
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
        child: const SetupPage(),
      ),
    ),
  );
}

void main() {
  testWidgets('renders both field labels and the save button', (tester) async {
    final repository = FakeCalendarConfigRepository();
    addTearDown(repository.dispose);
    await _pumpSetupPage(tester, repository);
    await tester.pumpAndSettle();

    final l10n = tester.element(find.byType(SetupPage)).l10n;

    expect(find.text(l10n.setupCalendarIdLabel), findsOneWidget);
    expect(find.text(l10n.setupServiceAccountKeyLabel), findsOneWidget);
    expect(find.text(l10n.setupSaveButton), findsOneWidget);
  });

  testWidgets(
    'entering both values and tapping save puts exactly one config in '
    'saveCalls',
    (tester) async {
      final repository = FakeCalendarConfigRepository();
      addTearDown(repository.dispose);
      await _pumpSetupPage(tester, repository);
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(_calendarIdFieldKey), 'cal-1');
      await tester.enterText(
        find.byKey(_serviceAccountKeyFieldKey),
        _validKeyJson,
      );
      await tester.pump();

      final l10n = tester.element(find.byType(SetupPage)).l10n;
      await tester.tap(find.text(l10n.setupSaveButton));
      await tester.pumpAndSettle();

      expect(repository.saveCalls, [
        const CalendarConfig(
          calendarId: 'cal-1',
          serviceAccountKey: ServiceAccountKey(_validKeyJson),
        ),
      ]);
    },
  );

  testWidgets(
    'entering malformed JSON shows the malformed-JSON error and leaves '
    'saveCalls empty',
    (tester) async {
      final repository = FakeCalendarConfigRepository();
      addTearDown(repository.dispose);
      await _pumpSetupPage(tester, repository);
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(_calendarIdFieldKey), 'cal-1');
      await tester.enterText(
        find.byKey(_serviceAccountKeyFieldKey),
        'not json',
      );
      await tester.pump();

      final l10n = tester.element(find.byType(SetupPage)).l10n;
      await tester.tap(find.text(l10n.setupSaveButton));
      await tester.pumpAndSettle();

      expect(find.text(l10n.setupErrorKeyMalformed), findsOneWidget);
      expect(repository.saveCalls, isEmpty);
    },
  );

  testWidgets(
    'a scripted saveError shows the failure SnackBar and leaves the button '
    'tappable again',
    (tester) async {
      final repository = FakeCalendarConfigRepository(
        saveError: const CalendarConfigException('nope'),
      );
      addTearDown(repository.dispose);
      await _pumpSetupPage(tester, repository);
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(_calendarIdFieldKey), 'cal-1');
      await tester.enterText(
        find.byKey(_serviceAccountKeyFieldKey),
        _validKeyJson,
      );
      await tester.pump();

      final l10n = tester.element(find.byType(SetupPage)).l10n;
      await tester.tap(find.text(l10n.setupSaveButton));
      await tester.pumpAndSettle();

      expect(find.text(l10n.setupSaveFailed), findsOneWidget);

      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNotNull);
    },
  );
}
