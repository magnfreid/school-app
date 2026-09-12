/// Component size tokens that are neither spacing nor radius.
class AppSizes {
  /// Creates an [AppSizes] instance, optionally overriding individual tokens.
  const AppSizes({
    this.inlineProgressIndicator = 20,
    this.inlineProgressStroke = 2,
  });

  /// Diameter of a progress indicator rendered inside a control.
  final double inlineProgressIndicator;

  /// Stroke width of a progress indicator rendered inside a control.
  final double inlineProgressStroke;
}
