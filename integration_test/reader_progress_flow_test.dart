/// Integration test for reading progress and chapter transitions.
///
/// Requires the host-side mock server. Run via:
///   dart run tool/run_integration_tests.dart
///
/// The mock server returns 5 pages per chapter and 2 English chapters, so
/// this test can:
///   1. Open a chapter, scroll to page 3, go back, reopen — verify page 3 is restored.
///   2. Swipe past the last page — verify the next-chapter transition page appears.
///   3. Tap "Start Reading" — verify the next chapter loads in place.
///   4. Detail page shows correct read/in-progress chapter states.
///   5. "Continue" button resumes at the saved page.
///   6. Opening a chapter without paging doesn't steal in-progress state.
///   7. Clearing history from Settings resets all progress.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:manga_portal/app.dart' show goRouter;
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

  // Clear all reading progress before each test so SharedPreferences state
  // from one test never affects the starting conditions of the next.
  setUp(() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  });

  // ── Helpers ─────────────────────────────────────────────────────────────────

  /// Launches the app and navigates to the mock manga detail page.
  Future<void> openDetailPage(WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    // The goRouter is a top-level singleton that retains its navigation state
    // between runApp calls. Reset it to '/' so every test starts at Library.
    goRouter.go('/');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(SearchBar), 'mock');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mock Manga One'));
    await tester.pumpAndSettle();
  }

  /// Opens the reader for Ch. 1 from the detail page.
  Future<void> openChapter1(WidgetTester tester) async {
    await openDetailPage(tester);
    await tester.tap(find.textContaining('Ch. 1').first);
    await tester.pumpAndSettle();
  }

  /// Swipes [count] pages left in the PageView.
  Future<void> swipeLeft(WidgetTester tester, {int count = 1}) async {
    for (var i = 0; i < count; i++) {
      await tester.fling(find.byType(PageView), const Offset(-400, 0), 1000);
      await tester.pumpAndSettle();
    }
  }

  /// Ensures the reader info bars are visible. Idempotent — no-op if the
  /// settings cog is already in the tree.
  Future<void> showBars(WidgetTester tester) async {
    if (find.byIcon(Icons.settings).evaluate().isEmpty) {
      await tester.tapAt(const Offset(200, 400));
      await tester.pump(const Duration(milliseconds: 350));
    }
  }

  // ── Existing tests ──────────────────────────────────────────────────────────

  testWidgets('reading progress is saved and restored', (tester) async {
    await openChapter1(tester);
    await showBars(tester);
    expect(find.text('1 / 5'), findsOneWidget);

    // Swipe left twice to reach page 3 (page change hides bars).
    await swipeLeft(tester, count: 2);
    await showBars(tester);
    expect(find.text('3 / 5'), findsOneWidget);

    // Navigate back to the detail page (bars already visible from showBars).
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    // Re-open chapter 1 — should restore at page 3.
    await tester.tap(find.textContaining('Ch. 1').first);
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(); // extra pump for async progress restore
    await showBars(tester);
    expect(find.text('3 / 5'), findsOneWidget);
  });

  testWidgets('next-chapter transition page appears at end of chapter',
      (tester) async {
    await openChapter1(tester);
    await swipeLeft(tester, count: 5);

    expect(find.textContaining('Ch. 2'), findsWidgets);
    expect(find.text('Start Reading'), findsOneWidget);
  });

  testWidgets('tapping Start Reading loads next chapter in place',
      (tester) async {
    await openChapter1(tester);
    await swipeLeft(tester, count: 5);

    await tester.tap(find.text('Start Reading'));
    await tester.pumpAndSettle();
    await showBars(tester);
    expect(find.text('1 / 5'), findsOneWidget);
  });

  // ── New progress tests ──────────────────────────────────────────────────────

  testWidgets(
      'detail page shows Ch. 1 read and Ch. 2 in-progress after transition',
      (tester) async {
    await openChapter1(tester);

    // Read all 5 pages of Ch. 1 — marks it as read.
    await swipeLeft(tester, count: 5);

    // Tap "Start Reading" to transition into Ch. 2 — marks Ch. 2 as in-progress.
    await tester.tap(find.text('Start Reading'));
    await tester.pumpAndSettle();

    // Go back to the detail page (show bars first — hidden after chapter load).
    await showBars(tester);
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    // Ch. 1 should show a read indicator (check icon); Ch. 2 should show the
    // primary-coloured reading border. We verify by checking that the
    // check_circle_outline icon appears (only rendered for read chapters).
    expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);

    // The "Continue" button should now say "Continue Ch. 2".
    expect(find.textContaining('Continue Ch. 2'), findsOneWidget);
  });

  testWidgets('"Continue" button opens reader at saved page', (tester) async {
    await openChapter1(tester);

    // Read to page 3 (page change hides bars).
    await swipeLeft(tester, count: 2);
    await showBars(tester);
    expect(find.text('3 / 5'), findsOneWidget);

    // Go back (bars already visible from showBars).
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    // "Continue Ch. 1" button should be visible.
    expect(find.textContaining('Continue Ch. 1'), findsOneWidget);

    // Tap it.
    await tester.tap(find.textContaining('Continue Ch. 1'));
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(); // wait for progress restore
    await showBars(tester);
    // Should land on page 3.
    expect(find.text('3 / 5'), findsOneWidget);
  });

  testWidgets(
      'opening a chapter without paging leaves the in-progress chapter unchanged',
      (tester) async {
    // First, put Ch. 1 in-progress by reading to page 2 (page change hides bars).
    await openChapter1(tester);
    await swipeLeft(tester);
    await showBars(tester);
    expect(find.text('2 / 5'), findsOneWidget);

    // Go back (bars already visible).
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Continue Ch. 1'), findsOneWidget);

    // Open Ch. 2 directly from the chapter list without swiping any pages.
    await tester.tap(find.textContaining('Ch. 2').first);
    await tester.pumpAndSettle();
    await showBars(tester);
    expect(find.text('1 / 5'), findsOneWidget);

    // Immediately go back (bars already visible).
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    // Ch. 1 should still be in-progress.
    expect(find.textContaining('Continue Ch. 1'), findsOneWidget);
  });

  testWidgets('clearing history from Settings resets all progress',
      (tester) async {
    // Read to page 3 in Ch. 1 to establish some progress.
    await openChapter1(tester);
    await swipeLeft(tester, count: 2);
    // Show bars so the reader back button is in the tree.
    await showBars(tester);
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Continue Ch. 1'), findsOneWidget);

    // Go back to shell (search page) so the bottom nav bar is visible.
    // MangaDetailPage has its own AppBar back button — no showBars needed.
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    // Navigate to Settings via the bottom nav bar.
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    // Tap "Clear reading history".
    await tester.tap(find.text('Clear reading history'));
    await tester.pumpAndSettle();

    // Confirm the destructive dialog.
    await tester.tap(find.text('Clear'));
    await tester.pumpAndSettle();

    // Snackbar should confirm.
    expect(find.text('Reading history cleared.'), findsOneWidget);

    // Navigate back to the mock manga detail page.
    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(SearchBar), 'mock');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mock Manga One'));
    await tester.pumpAndSettle();

    // Progress cleared — button should say "Start Ch. 1" again.
    expect(find.textContaining('Start Ch. 1'), findsOneWidget);
  });
}
