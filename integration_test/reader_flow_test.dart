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
    // The mock server returns 2 pages, so the counter should show "1 / 2".
    expect(find.text('1 / 2'), findsOneWidget);
  });
}
