import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_starter/l10n/extensions/app_localizations_extension.dart';

/// Loading screen shown while auth state is being determined.
///
/// The router holds the app here until auth state leaves
/// `AuthState.unknown` — see `AppRouter._redirect`.
class SplashPage extends StatelessWidget {
  /// Creates the [SplashPage].
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            SizedBox(height: context.spacing.medium),
            Text(context.l10n.splashLabel),
          ],
        ),
      ),
    );
  }
}
