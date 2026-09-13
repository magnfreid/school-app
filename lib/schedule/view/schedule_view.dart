import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_app/l10n/extensions/app_localizations_extension.dart';
import 'package:school_app/schedule/bloc/schedule_bloc.dart';
import 'package:school_app/schedule/bloc/schedule_event.dart';
import 'package:school_app/schedule/bloc/schedule_state.dart';
import 'package:school_app/schedule/extensions/schedule_text_extension.dart';
import 'package:school_app/schedule/widgets/next_event_hero.dart';
import 'package:school_app/schedule/widgets/schedule_app_bar.dart';
import 'package:school_app/schedule/widgets/special_event_lane.dart';
import 'package:school_app/schedule/widgets/week_grid.dart';

/// Renders the four bands of the Week View from [ScheduleBloc]'s state.
///
/// Public (not `_ScheduleView`) so a view-level test can inject a scripted
/// bloc via `BlocProvider.value` without going through [SchedulePage]'s own
/// wiring.
class ScheduleView extends StatelessWidget {
  /// Creates the [ScheduleView].
  const ScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, state) {
        final l10n = context.l10n;
        final bloc = context.read<ScheduleBloc>();

        final days = switch (state) {
          ScheduleLoaded(:final days) => days,
          _ => const <ScheduleDay>[],
        };

        final weekLabel = switch (state) {
          ScheduleLoaded(:final week) => l10n.scheduleWeekLabel(
            week.weekNumber,
          ),
          _ => '',
        };
        final weekRange = days.isEmpty
            ? ''
            : l10n.weekRange(days.first.date, days.last.date);

        final syncLabel = switch (state) {
          ScheduleLoaded(:final lastSyncedAt) => l10n.scheduleLastSynced(
            l10n.timeOfDay(lastSyncedAt),
          ),
          ScheduleFailure() => l10n.scheduleSyncFailed,
          _ => l10n.scheduleSyncing,
        };

        final emptyMessage = switch (state) {
          ScheduleFailure() => l10n.scheduleUnavailable,
          ScheduleLoaded() => l10n.scheduleNoUpcoming,
          _ => l10n.scheduleLoading,
        };

        final nextEvent = switch (state) {
          ScheduleLoaded(:final nextEvent) => nextEvent,
          _ => null,
        };

        final weekSpecial = switch (state) {
          ScheduleLoaded(:final weekSpecial) => weekSpecial,
          _ => null,
        };

        final gridKey = switch (state) {
          ScheduleLoaded(:final week) => ValueKey(week.weekStart),
          _ => const ValueKey('empty'),
        };

        return Scaffold(
          backgroundColor: context.colors.surface,
          body: MediaQuery.withNoTextScaling(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ScheduleAppBar(
                  weekLabel: weekLabel,
                  weekRange: weekRange,
                  syncLabel: syncLabel,
                  syncHealthy: state is ScheduleLoaded,
                  onPreviousWeek: () => bloc.add(
                    ScheduleBlocEvent.weekChanged(state.weekOffset - 1),
                  ),
                  onNextWeek: () => bloc.add(
                    ScheduleBlocEvent.weekChanged(state.weekOffset + 1),
                  ),
                ),
                NextEventHero(nextEvent: nextEvent, emptyMessage: emptyMessage),
                SpecialEventLane(days: days, weekSpecial: weekSpecial),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: Durations.short3,
                    child: KeyedSubtree(
                      key: gridKey,
                      child: WeekGrid(days: days),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
