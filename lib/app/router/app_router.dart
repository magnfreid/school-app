import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:school_app/app/router/routes.dart';
import 'package:school_app/auth/cubit/auth_cubit.dart';
import 'package:go_router/go_router.dart';

/// App-level router composition.
///
/// Route definitions live in [routes.dart] and are merged here into a single
/// [GoRouter]. Keep imperative navigation out of feature code — use
/// `context.go()` / `context.push()` against named routes from [AppRoutes].
abstract final class AppRouter {
  /// Route names reachable while signed out.
  ///
  /// Everything not listed here redirects to [AppRoutes.login] for an
  /// unauthenticated user. Add sign-up / password-reset route names here as
  /// they arrive — that is the only change a new public route needs. A route with
  /// no `name` is treated as non-public under this guard, so any future
  /// public route must carry a `name` or a signed-out user will be bounced
  /// to login.
  static final Set<String> _publicRouteNames = {AppRoutes.login.name};

  /// Builds the app-wide [GoRouter] with auth-aware redirects.
  ///
  /// The router listens to [authCubit]'s stream via [_GoRouterRefreshStream]
  /// and re-evaluates the redirect whenever auth state changes.
  ///
  /// [routeOverride] lets a test compose its own route list without mutating
  /// the shared [routes] global.
  static GoRouter build({
    required AuthCubit authCubit,
    List<RouteBase>? routeOverride,
  }) => GoRouter(
    initialLocation: AppRoutes.splash.path,
    refreshListenable: _GoRouterRefreshStream(authCubit.stream),
    redirect: (context, state) => _redirect(state, authCubit.state),
    routes: routeOverride ?? routes,
  );

  /// Resolves the redirect target for [state], or `null` to allow it through.
  ///
  /// Deliberately a *guard*, not a router: it names the locations each auth
  /// state may not be at and lets everything else pass. A redirect that
  /// instead pins each state to one location makes every route added later
  /// unreachable.
  ///
  /// Note: a deep link that arrives before auth resolves is dropped in favour
  /// of splash. To preserve it, stash `state.uri` here and replay it once the
  /// state leaves [AuthStateUnknown].
  static String? _redirect(GoRouterState state, AuthState authState) {
    final name = state.topRoute?.name;
    final isSplash = name == AppRoutes.splash.name;
    final isPublic = _publicRouteNames.contains(name);

    return switch (authState) {
      // Auth not resolved yet — hold on splash regardless of destination.
      AuthStateUnknown() => isSplash ? null : AppRoutes.splash.path,
      // Signed in: splash and the public routes have nothing left to do.
      // Everything else passes, including routes added after this was written.
      AuthStateAuthenticated() =>
        isSplash || isPublic ? AppRoutes.home.path : null,
      // Signed out: only public routes are reachable.
      AuthStateUnauthenticated() => isPublic ? null : AppRoutes.login.path,
    };
  }
}

/// Converts a [Stream] into a [ChangeNotifier] so [GoRouter.refreshListenable]
/// can trigger a redirect evaluation on every emission.
///
/// Hand-rolled deliberately: `go_router` shipped a `GoRouterRefreshStream` for
/// exactly this and then removed it, so there is nothing to import.
class _GoRouterRefreshStream extends ChangeNotifier {
  _GoRouterRefreshStream(Stream<dynamic> stream) {
    _sub = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _sub;

  /// `GoRouter.dispose()` disposes its route information provider, which
  /// *removes* its listener from this notifier but never disposes it — so
  /// [dispose] alone would never run and the subscription would leak.
  /// Losing the last listener is therefore the signal to stand down. This
  /// relies on `GoRouter` disposing its route information provider — an
  /// implementation detail worth re-checking on a go_router major.
  @override
  void removeListener(VoidCallback listener) {
    super.removeListener(listener);
    if (!hasListeners) _sub.cancel();
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
