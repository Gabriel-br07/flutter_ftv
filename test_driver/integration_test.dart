import 'package:integration_test/integration_test_driver.dart';

/// Driver entrypoint required by `flutter drive` to run the integration tests
/// on web (Chrome/Edge/web-server). The device-side tests live in
/// `integration_test/app_e2e_test.dart`.
Future<void> main() => integrationDriver();
