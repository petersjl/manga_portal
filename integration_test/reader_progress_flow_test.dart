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

  // Helper: Navigate from the library to the mock manga's detail page and
  // tap "Ch. 1" to open the reader.
  Future<void> openChapter1(WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Navigate to Search and find mock manga.
    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(SearchBar), 'mock');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Mock Manga One'));
    await tester.pumpAndSettle();

    // Tap "Ch. 1" in the chapter list.
    await tester.tap(find.textContaining('Ch. 1').first);
    await tester.pumpAndSettle();
  }

  testWidgets('reading progress is saved and restored', (tester) async {
    await openChapter1(tester);

    // Should be on page 1 of 5.
    expect(find.text('1 / 5'), findsOneWidget);

    // Swipe left twice to reach page 3.
    await tester.fling(find.byType(PageView), const Offset(-400, 0), 1000);
    await tester.pumpAndSettle();
    await tester.fling(find.byType(PageView), const Offset(-400, 0), 1000);
    await tester.pumpAndSettle();

    expect(find.text('3 / 5'), findsOneWidget);

    // Navigate back to the detail page.
    final backButton = find.byTooltip('Back');
    await tester.tap(backButton);
    await tester.pumpAndSettle();

    // Re-open chapter 1 — should restore at page 3.
    await tester.tap(find.textContaining('Ch. 1').first);
    await tester.pumpAndSettle();
    // Give the async progress restore time to complete.
    await tester.pumpAndSettle();

    expect(find.text('3 / 5'), findsOneWidget);
  });

  testWidgets('next-chapter transition page appears at end of chapter',
      (tester) async {
    await openChapter1(tester);

    // Swipe past all 5 pages to reach the next-chapter transition slot.
    for (var i = 0; i < 5; i++) {
      await tester.fling(find.byType(PageView), const Offset(-400, 0), 1000);
      await tester.pumpAndSettle();
    }

    // Mock server returns Ch. 2 as the next chapter.
    expect(find.textContaining('Ch. 2'), findsWidgets);
    expect(find.text('Start Reading'), findsOneWidget);
  });

  testWidgets('tapping Start Reading loads next chapter in place',
      (tester) async {
    await openChapter1(tester);

    // Swipe past all 5 pages.
    for (var i = 0; i < 5; i++) {
      await tester.fling(find.byType(PageView), const Offset(-400, 0), 1000);
      await tester.pumpAndSettle();
    }

    // Tap the "Start Reading" button on the transition page.
    await tester.tap(find.text('Start Reading'));
    await tester.pumpAndSettle();

    // Chapter 2 loads in the same reader — page counter restarts.
    expect(find.text('1 / 5'), findsOneWidget);
  });
}
