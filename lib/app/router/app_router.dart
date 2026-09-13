import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:school_app/app/cubit/calendar_config_cubit.dart';
import 'package:school_app/app/router/routes.dart';
import 'package:go_router/go_router.dart';

/// App-level router composition.
///
/// Route definitions live in [routes.dart] and are merged here into a single
/// [GoRouter]. Keep imperative navigation out of feature code — use
/// `context.go()` / `context.push()` against named routes from [AppRoutes].
abstract final class AppRouter {
  /// Route names reachable while unconfigured.
  ///
  /// Everything not listed here redirects to [AppRoutes.setup] for an
  /// unconfigured user. Add pre-config route names here as they arrive —
  /// that is the only change a new unconfigured-reachable route needs. A
  /// route with no `name` is treated as non-reachable under this guard, so
  /// any future pre-config route (subscribe, help) must carry a `name` or an
  /// unconfigured user will be bounced to setup.
  static final Set<String> _unconfiguredRouteNames = {AppRoutes.setup.name};

  /// Builds the app-wide [GoRouter] with config-gate-aware redirects.
  ///
  /// The router listens to [configCubit]'s stream via
  /// [_GoRouterRefreshStream] and re-evaluates the redirect whenever config
  /// state changes.
  ///
  /// [routeOverride] lets a test compose its own route list without mutating
  /// the shared [routes] global.
  static GoRouter build({
    required CalendarConfigCubit configCubit,
    List<RouteBase>? routeOverride,
  }) => GoRouter(
    initialLocation: AppRoutes.splash.path,
    refreshListenable: _GoRouterRefreshStream(configCubit.stream),
    redirect: (context, state) => _redirect(state, configCubit.state),
    routes: routeOverride ?? routes,
  );

  /// Resolves the redirect target for [state], or `null` to allow it through.
  ///
  /// Deliberately a *guard*, not a router: it names the locations each gate
  /// state may not be at and lets everything else pass. A redirect that
  /// instead pins each state to one location makes every route added later
  /// unreachable.
  ///
  /// Note: a deep link that arrives before config resolves is dropped in
  /// favour of splash. To preserve it, stash `state.uri` here and replay it
  /// once the state leaves [CalendarConfigStateUnknown].
  static String? _redirect(
    GoRouterState state,
    CalendarConfigState configState,
  ) {
    final name = state.topRoute?.name;
    final isSplash = name == AppRoutes.splash.name;
    final isSetupRoute = _unconfiguredRouteNames.contains(name);

    return switch (configState) {
      // Config not resolved yet — hold on splash regardless of destination.
      CalendarConfigStateUnknown() => isSplash ? null : AppRoutes.splash.path,
      // Configured: splash and the setup routes have nothing left to do.
      // Everything else passes, including routes added after this was written.
      CalendarConfigStateConfigured() =>
        isSplash || isSetupRoute ? AppRoutes.schedule.path : null,
      // Unconfigured: only setup routes are reachable.
      CalendarConfigStateUnconfigured() =>
        isSetupRoute ? null : AppRoutes.setup.path,
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
