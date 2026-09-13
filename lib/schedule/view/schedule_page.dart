import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_app/schedule/bloc/schedule_bloc.dart';
import 'package:school_app/schedule/bloc/schedule_event.dart';
import 'package:school_app/schedule/view/schedule_view.dart';
import 'package:schedule_repository/schedule_repository.dart';

/// Provides [ScheduleBloc] from the app's [ScheduleRepository] and renders
/// [ScheduleView].
class SchedulePage extends StatelessWidget {
  /// Creates the [SchedulePage].
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ScheduleBloc(scheduleRepository: context.read<ScheduleRepository>())
            ..add(const ScheduleBlocEvent.started()),
      child: const ScheduleView(),
    );
  }
}
