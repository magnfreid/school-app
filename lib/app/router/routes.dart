import 'package:school_app/schedule/view/schedule_page.dart';
import 'package:school_app/settings/view/settings_page.dart';
import 'package:school_app/setup/view/setup_page.dart';
import 'package:school_app/splash/view/splash_page.dart';
import 'package:go_router/go_router.dart';

/// Path and name constants for all app routes.
abstract final class AppRoutes {
  /// Loading screen shown while calendar-config state is being determined.
  static const splash = (name: 'splash', path: '/splash');

  /// Setup screen shown when no calendar is configured.
  static const setup = (name: 'setup', path: '/setup');

  /// Root path for the schedule feature.
  static const schedule = (name: 'schedule', path: '/');

  /// Path for the settings feature.
  static const settings = (name: 'settings', path: '/settings');
}

/// All top-level routes. Consumed by [AppRouter].
final List<RouteBase> routes = List.unmodifiable([
  GoRoute(
    path: AppRoutes.splash.path,
    name: AppRoutes.splash.name,
    builder: (context, state) => const SplashPage(),
  ),
  GoRoute(
    path: AppRoutes.setup.path,
    name: AppRoutes.setup.name,
    builder: (context, state) => const SetupPage(),
  ),
  GoRoute(
    path: AppRoutes.schedule.path,
    name: AppRoutes.schedule.name,
    builder: (context, state) => const SchedulePage(),
  ),
  GoRoute(
    path: AppRoutes.settings.path,
    name: AppRoutes.settings.name,
    builder: (context, state) => const SettingsPage(),
  ),
]);
