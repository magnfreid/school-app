/// Failure raised when the display cannot be controlled.
///
/// Implementations translate their backend's errors into this before they
/// cross the package boundary — a vendor type must never reach the app
/// layer.
class DisplayException implements Exception {
  /// Creates a [DisplayException] describing [message].
  const DisplayException(this.message, {this.cause});

  /// Human-readable description of what went wrong.
  final String message;

  /// The underlying error, kept for logging. Never surfaced to the UI.
  final Object? cause;

  @override
  String toString() => 'DisplayException: $message';
}
