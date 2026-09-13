/// Failure raised when a calendar configuration cannot be saved.
///
/// Implementations translate their backend's errors into this before they
/// cross the package boundary — a vendor type must never reach the app
/// layer.
class CalendarConfigException implements Exception {
  /// Creates a [CalendarConfigException] describing [message].
  const CalendarConfigException(this.message, {this.cause});

  /// Human-readable description of what went wrong.
  final String message;

  /// The underlying error, kept for logging. Never surfaced to the UI.
  final Object? cause;

  @override
  String toString() => 'CalendarConfigException: $message';
}
