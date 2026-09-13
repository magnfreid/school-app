import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_app/app/cubit/calendar_config_cubit.dart';
import 'package:school_app/app/cubit/theme_cubit.dart';
import 'package:school_app/app/router/app_router.dart';
import 'package:school_app/l10n/app_localizations.dart';
import 'package:school_app/l10n/extensions/app_localizations_extension.dart';
import 'package:go_router/go_router.dart';

/// Root of the widget tree.
///
/// Wires:
/// - Light/dark [ThemeData] from `app_ui`.
/// - Localization delegates and supported locales.
/// - `go_router` via [MaterialApp.router] with a config-aware gate.
///
/// Expects [CalendarConfigCubit] and [ThemeCubit] to be provided above it —
/// see `bootstrap.dart`. [ThemeCubit] stays provided for other screens even
/// though this widget no longer reads it: `themeMode` is pinned to
/// [ThemeMode.dark] for the Week View kiosk (V1 is dark-only). Restore the
/// `BlocBuilder<ThemeCubit, ThemeMode>` here once a light-mode screen exists.
class App extends StatefulWidget {
  /// Creates the app root.
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  /// Built once, in [initState], so the router's subscription to the auth
  /// stream outlives theme rebuilds. Recreating it would reset the nav stack.
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = AppRouter.build(configCubit: context.read<CalendarConfigCubit>());
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      onGenerateTitle: (context) => context.l10n.appTitle,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      // V1 is a dark-only kiosk (docs/roadmap.md § Week View). See the class
      // doc for the exit condition.
      themeMode: ThemeMode.dark,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
