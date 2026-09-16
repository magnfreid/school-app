/// Display repository package.
///
/// Exposes the [DisplayRepository] interface and two implementations:
/// [DeviceDisplayRepository] for the real device, and [FakeDisplayRepository]
/// for tests.
library;

export 'src/device_display_repository.dart';
export 'src/display_exception.dart';
export 'src/display_repository.dart';
export 'src/fake_display_repository.dart';
