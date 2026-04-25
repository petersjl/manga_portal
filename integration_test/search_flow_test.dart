/// Integration test for the search flow.
///
/// Requires the host-side mock server. Run via:
///   dart run tool/run_integration_tests.dart
///
/// That script starts the mock server, runs widget tests + integration tests,
/// and injects --dart-define=MOCK_BASE_URL so the app never calls the real
/// MangaDex API.

import 'package:flutter/material.dart';
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

  testWidgets('Search tab shows results and navigates to detail page',
      (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // ── Navigate to Search tab ───────────────────────────────────────────────
    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();

    // ── Type a query ─────────────────────────────────────────────────────────
    await tester.enterText(find.byType(SearchBar), 'mock');
    await tester.pump(const Duration(milliseconds: 400)); // Wait for debounce.
    await tester.pumpAndSettle();

    // ── Verify results ───────────────────────────────────────────────────────
    // Mock server returns 'Mock Manga One' and 'Mock Manga Two'.
    expect(find.text('Mock Manga One'), findsOneWidget);
    expect(find.text('Mock Manga Two'), findsOneWidget);

    // ── Tap a result card ────────────────────────────────────────────────────
    await tester.tap(find.text('Mock Manga One'));
    await tester.pumpAndSettle();

    // ── Verify we landed on the detail page ──────────────────────────────────
    // Mock server returns 'Mock Manga Title' for any /manga/:id request.
    expect(find.text('Mock Manga Title'), findsAtLeastNWidgets(1));
  });
}
