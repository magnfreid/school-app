import 'package:calendar_config_repository/calendar_config_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_app/settings/bloc/settings_bloc.dart';
import 'package:school_app/settings/view/settings_view.dart';

/// Provides [SettingsBloc] from the app's [CalendarConfigRepository] and
/// renders [SettingsView].
class SettingsPage extends StatelessWidget {
  /// Creates the [SettingsPage].
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsBloc(
        configRepository: context.read<CalendarConfigRepository>(),
      ),
      child: const SettingsView(),
    );
  }
}
