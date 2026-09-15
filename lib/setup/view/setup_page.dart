import 'package:calendar_config_repository/calendar_config_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_app/setup/bloc/setup_bloc.dart';
import 'package:school_app/setup/view/setup_view.dart';

/// Provides [SetupBloc] from the app's [CalendarConfigRepository] and
/// renders [SetupView].
class SetupPage extends StatelessWidget {
  /// Creates the [SetupPage].
  const SetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SetupBloc(configRepository: context.read<CalendarConfigRepository>()),
      child: const SetupView(),
    );
  }
}
