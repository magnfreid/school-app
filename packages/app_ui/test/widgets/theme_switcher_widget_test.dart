import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(WidgetTester tester, Widget child) =>
    tester.pumpWidget(MaterialApp(home: Scaffold(body: child)));

void main() {
  group('ThemeSwitcherWidget', () {
    for (final (mode, icon) in const [
      (ThemeMode.system, Icons.brightness_auto_outlined),
      (ThemeMode.light, Icons.light_mode_outlined),
      (ThemeMode.dark, Icons.dark_mode_outlined),
    ]) {
      testWidgets('shows the $mode icon', (tester) async {
        await _pump(tester, ThemeSwitcherWidget(mode: mode, onPressed: () {}));

        expect(find.byIcon(icon), findsOneWidget);
      });
    }

    testWidgets('tapping the button invokes onPressed once', (tester) async {
      var pressed = 0;
      await _pump(
        tester,
        ThemeSwitcherWidget(mode: ThemeMode.system, onPressed: () => pressed++),
      );

      await tester.tap(find.byType(IconButton));
      await tester.pump();

      expect(pressed, 1);
    });

    testWidgets('tooltip is reachable via find.byTooltip', (tester) async {
      await _pump(
        tester,
        ThemeSwitcherWidget(
          mode: ThemeMode.system,
          tooltip: 'Switch theme',
          onPressed: () {},
        ),
      );

      expect(find.byTooltip('Switch theme'), findsOneWidget);
    });
  });
}
