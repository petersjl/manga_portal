import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  setUp(() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  });

  testWidgets('navigates from Search to MangaDetailPage then to ReaderPage',
      (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // ── Search tab ───────────────────────────────────────────────────────────
    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(SearchBar), 'mock');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    // Tap the first search result to navigate to the detail page.
    await tester.tap(find.text('Mock Manga One'));
    await tester.pumpAndSettle();

    // ── Manga detail page ────────────────────────────────────────────────────
    // The mock server returns a manga named "Mock Manga Title".
    expect(find.text('Mock Manga Title'), findsAtLeastNWidgets(1));

    // The mock server returns 2 chapters (Ch.2 is listed first, descending).
    expect(find.text('Ch. 2'), findsOneWidget);
    expect(find.text('Ch. 1'), findsOneWidget);

    // Tap the first visible chapter (Ch.2 at top of descending list).
    await tester.tap(find.text('Ch. 2'));
    await tester.pumpAndSettle();

    // ── Reader page ──────────────────────────────────────────────────────────
    // Verify we're on the reader page showing a PageView with images.
    expect(find.byType(PageView), findsOneWidget);

    // Tap the screen to show info bars, then check the page counter.
    await tester.tapAt(const Offset(200, 400));
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.text('1 / 5'), findsOneWidget);
  });
}
