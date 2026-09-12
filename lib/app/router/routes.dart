import 'package:flutter_starter/home/view/home_page.dart';
import 'package:flutter_starter/login/view/login_page.dart';
import 'package:flutter_starter/splash/view/splash_page.dart';
import 'package:go_router/go_router.dart';

/// Path and name constants for all app routes.
abstract final class AppRoutes {
  /// Loading screen shown while auth state is being determined.
  static const splash = (name: 'splash', path: '/splash');

  /// Login screen shown when the user is unauthenticated.
  static const login = (name: 'login', path: '/login');

  /// Root path for the home feature.
  static const home = (name: 'home', path: '/');
}

/// All top-level routes. Consumed by [AppRouter].
final List<RouteBase> routes = List.unmodifiable([
  GoRoute(
    path: AppRoutes.splash.path,
    name: AppRoutes.splash.name,
    builder: (context, state) => const SplashPage(),
  ),
  GoRoute(
    path: AppRoutes.login.path,
    name: AppRoutes.login.name,
    builder: (context, state) => const LoginPage(),
  ),
  GoRoute(
    path: AppRoutes.home.path,
    name: AppRoutes.home.name,
    builder: (context, state) => const HomePage(),
  ),
]);
