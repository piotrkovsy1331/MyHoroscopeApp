import 'package:integration_test/integration_test_driver.dart';

/// Host-side driver for `flutter drive`; writes the reported frame
/// timings to build/integration_response_data.json.
Future<void> main() => integrationDriver();
