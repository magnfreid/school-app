/// Failure raised when the schedule cannot be read.
///
/// Implementations translate their backend's errors into this before they
/// cross the package boundary — a vendor type must never reach the app
/// layer.
class ScheduleException implements Exception {
  /// Creates a [ScheduleException] describing [message].
  const ScheduleException(this.message, {this.cause});

  /// Human-readable description of what went wrong.
  final String message;

  /// The underlying error, kept for logging. Never surfaced to the UI.
  final Object? cause;

  @override
  String toString() => 'ScheduleException: $message';
}
