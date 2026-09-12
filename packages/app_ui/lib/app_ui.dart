/// Shared UI kit for the application.
///
/// The single import for everything themed: colors, typography, spacing and
/// radius tokens, their `BuildContext` extensions, and cross-cutting widgets.
/// Import this barrel — reaching into `package:app_ui/<dir>/<file>.dart`
/// bypasses it and leaves the app with two import styles for one package.
library;

export 'colors/app_colors.dart';
export 'extensions/colors_extension.dart';
export 'extensions/radius_extension.dart';
export 'extensions/sizes_extension.dart';
export 'extensions/spacing_extension.dart';
export 'extensions/text_extension.dart';
export 'extensions/theme_extension.dart';
export 'radius/app_radius.dart';
export 'sizes/app_sizes.dart';
export 'spacing/app_spacing.dart';
export 'themes/app_theme.dart';
export 'typography/app_typography.dart';
export 'widgets/theme_switcher_widget.dart';
