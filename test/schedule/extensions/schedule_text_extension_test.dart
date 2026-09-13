import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:school_app/l10n/app_localizations.dart';
import 'package:school_app/schedule/extensions/schedule_text_extension.dart';
import 'package:schedule_repository/schedule_repository.dart';

void main() {
  group('ScheduleTextX', () {
    late AppLocalizations en;
    late AppLocalizations sv;

    setUpAll(() async {
      // DateFormat needs intl's own locale symbol data loaded; a plain unit
      // test (unlike a widget test) never triggers this via
      // GlobalMaterialLocalizations, so it's done explicitly here.
      await initializeDateFormatting('en');
      await initializeDateFormatting('sv');
      en = await AppLocalizations.delegate.load(const Locale('en'));
      sv = await AppLocalizations.delegate.load(const Locale('sv'));
    });

    ScheduleEvent event({
      required EventSeverity severity,
      String? kindLabel,
      DateTime? time,
    }) => ScheduleEvent(
      id: 'e1',
      title: 'Title',
      subjectCode: 'MA',
      date: DateTime(2024, 1, 11),
      severity: severity,
      kindLabel: kindLabel,
      time: time,
    );

    group('kindWord', () {
      test('prov always returns the test word', () {
        expect(
          en.kindWord(event(severity: EventSeverity.prov)),
          en.scheduleSeverityProv,
        );
      });

      test('laxa always returns the homework word', () {
        expect(
          en.kindWord(event(severity: EventSeverity.laxa)),
          en.scheduleSeverityLaxa,
        );
      });

      test('other with no kindLabel returns null', () {
        expect(en.kindWord(event(severity: EventSeverity.other)), isNull);
      });

      test('other with the raw Swedish INLÄMNING maps to the l10n word', () {
        expect(
          en.kindWord(
            event(severity: EventSeverity.other, kindLabel: 'INLÄMNING'),
          ),
          en.scheduleSeverityInlamning,
        );
      });

      test('other with any other label is upper-cased verbatim', () {
        expect(
          en.kindWord(event(severity: EventSeverity.other, kindLabel: 'Extra')),
          'EXTRA',
        );
      });
    });

    group('eventCardLabel', () {
      test('with a kind and a time joins all three', () {
        final e = event(
          severity: EventSeverity.other,
          kindLabel: 'INLÄMNING',
          time: DateTime(2024, 1, 11, 23, 59),
        );
        expect(
          en.eventCardLabel(e),
          'MA · ${en.scheduleSeverityInlamning} · 23:59',
        );
      });

      test('without a kind or a time is just the subject code', () {
        final e = event(severity: EventSeverity.other);
        expect(en.eventCardLabel(e), 'MA');
      });
    });

    group('weekRange', () {
      test('same month', () {
        final result = en.weekRange(
          DateTime(2024, 9, 9),
          DateTime(2024, 9, 13),
        );
        expect(result, en.scheduleWeekRange('9', '13', 'September'));
      });

      test('cross month', () {
        final result = en.weekRange(
          DateTime(2024, 9, 30),
          DateTime(2024, 10, 4),
        );
        expect(
          result,
          en.scheduleWeekRangeCrossMonth('30', 'September', '4', 'October'),
        );
      });

      test('same month in Swedish', () {
        final result = sv.weekRange(
          DateTime(2024, 9, 9),
          DateTime(2024, 9, 13),
        );
        expect(result, sv.scheduleWeekRange('9', '13', 'september'));
      });

      test('cross month in Swedish', () {
        final result = sv.weekRange(
          DateTime(2024, 9, 30),
          DateTime(2024, 10, 4),
        );
        expect(
          result,
          sv.scheduleWeekRangeCrossMonth('30', 'september', '4', 'oktober'),
        );
      });
    });
  });
}
