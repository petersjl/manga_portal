/// Integration test for the reader flow.
///
/// Run via the host-side runner so the mock server is available:
///   dart run tool/run_integration_tests.dart
///
/// The runner injects --dart-define=MOCK_BASE_URL=http://<host>:<port> so the
/// app calls the mock server instead of the real MangaDex API. No Riverpod
/// overrides are needed — the app runs exactly as it would in production.

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:manga_portal/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Tapping "Open Reader (test)" navigates to ReaderPage',
      (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Confirm we are on the Library tab.
    expect(find.text('Open Reader (test)'), findsOneWidget);

    // Tap the button to open the reader.
    await tester.tap(find.text('Open Reader (test)'));
    await tester.pumpAndSettle();

    // The mock server returns 2 pages, so the counter should show "1 / 2".
    expect(find.text('1 / 2'), findsOneWidget);
  });
}
