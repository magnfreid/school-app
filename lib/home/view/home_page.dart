import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter/app/cubit/theme_cubit.dart';
import 'package:flutter_starter/auth/cubit/auth_cubit.dart';
import 'package:flutter_starter/l10n/extensions/app_localizations_extension.dart';

/// Placeholder landing page for the starter template.
///
/// Replace this with a real feature. Keeps the widget tree bootable
/// so `fvm flutter run` works out of the box on a fresh clone.
class HomePage extends StatelessWidget {
  /// Creates the [HomePage].
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.appTitle),
        actions: [
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, mode) => ThemeSwitcherWidget(
              mode: mode,
              tooltip: context.l10n.themeSwitcherTooltip,
              onPressed: () => context.read<ThemeCubit>().cycle(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: context.l10n.signOutTooltip,
            onPressed: () => context.read<AuthCubit>().logout(),
          ),
        ],
      ),
      body: Center(
        child: Text(
          context.l10n.welcomeHeadline,
          style: context.text.headlineMedium,
        ),
      ),
    );
  }
}
