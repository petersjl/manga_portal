/// Integration test for the reader flow.
///
/// Requires the host-side mock server. Run via:
///   dart run tool/run_integration_tests.dart
///
/// That script starts the mock server, runs widget tests + integration tests,
/// and injects --dart-define=MOCK_BASE_URL so the app never calls the real
/// MangaDex API.

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:manga_portal/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    const url = String.fromEnvironment('MOCK_BASE_URL');
    if (url.isEmpty) {
      fail(
        'Integration tests require a running mock server.\n'
        'Run all tests with: dart run tool/run_integration_tests.dart',
      );
    }
  });

  testWidgets('Library stub navigates to MangaDetailPage then to ReaderPage',
      (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // ── Library page ────────────────────────────────────────────────────────
    expect(find.text('Open Manga Detail (test)'), findsOneWidget);

    // Navigate to manga detail page.
    await tester.tap(find.text('Open Manga Detail (test)'));
    await tester.pumpAndSettle();

    // ── Manga detail page ───────────────────────────────────────────────────
    // The mock server returns a manga named "Mock Manga Title".
    expect(find.text('Mock Manga Title'), findsAtLeastNWidgets(1));

    // The mock server returns 2 chapters (Ch.2 is listed first, descending).
    expect(find.text('Ch. 2'), findsOneWidget);
    expect(find.text('Ch. 1'), findsOneWidget);

    // Tap the first visible chapter (Ch.2 at top of descending list).
    await tester.tap(find.text('Ch. 2'));
    await tester.pumpAndSettle();

    // ── Reader page ─────────────────────────────────────────────────────────
    // The mock server returns 5 pages, so the counter should show "1 / 5".
    expect(find.text('1 / 5'), findsOneWidget);
  });
}
