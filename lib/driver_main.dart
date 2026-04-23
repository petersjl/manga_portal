// Driver entrypoint — only used when launched via flutter_driver for automated
// UI verification. Not part of the production app.
import 'package:flutter_driver/driver_extension.dart';
import 'main.dart' as app;

void main() {
  enableFlutterDriverExtension();
  app.main();
}
