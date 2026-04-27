import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:manga_portal/app.dart' show goRouter;
import 'package:manga_portal/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const mockBaseUrl = String.fromEnvironment('MOCK_BASE_URL');
  if (mockBaseUrl.isEmpty) {
    throw StateError(
      'MOCK_BASE_URL is not set. '
      'Run integration tests via: dart run tool/run_integration_tests.dart',
    );
  }

  setUp(() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  });

  /// Navigate to Mock Manga One's detail page from Search.
  Future<void> openDetailPage(WidgetTester tester) async {
    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(SearchBar), 'mock');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mock Manga One'));
    await tester.pumpAndSettle();
  }

  /// Ensures the reader info bars are visible. If they are already visible
  /// (settings cog is in the tree) this is a no-op; otherwise taps the
  /// centre of the reader content to show them.
  Future<void> showBars(WidgetTester tester) async {
    if (find.byIcon(Icons.settings).evaluate().isEmpty) {
      await tester.tapAt(const Offset(200, 400));
      await tester.pump(const Duration(milliseconds: 350));
    }
  }

  testWidgets('bars are hidden by default; tap shows them with settings cog',
      (tester) async {
    app.main();
    await tester.pumpAndSettle();
    goRouter.go('/');
    await tester.pumpAndSettle();

    await openDetailPage(tester);
    await tester.tap(find.text('Ch. 2'));
    await tester.pumpAndSettle();

    // Bars hidden by default.
    expect(find.byIcon(Icons.arrow_back), findsNothing);
    expect(find.byIcon(Icons.settings), findsNothing);

    // Tap to reveal bars.
    await tester.tapAt(const Offset(200, 400));
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.byIcon(Icons.settings), findsOneWidget);
  });

  testWidgets(
      'switching to scroll mode via settings sheet opens reader in ListView',
      (tester) async {
    app.main();
    await tester.pumpAndSettle();
    goRouter.go('/');
    await tester.pumpAndSettle();

    await openDetailPage(tester);

    // Open the reader via the chapter list.
    await tester.tap(find.text('Ch. 2'));
    await tester.pumpAndSettle();

    // Default mode: PageView.
    expect(find.byType(PageView), findsOneWidget);
    expect(find.byType(ListView), findsNothing);

    // Show bars, then open settings.
    await showBars(tester);
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    // Bottom sheet is open — switch to Scroll.
    expect(find.text('Paged'), findsOneWidget);
    await tester.tap(find.text('Scroll'));
    await tester.pumpAndSettle();

    // Dismiss the sheet.
    await tester.tapAt(const Offset(200, 100));
    await tester.pumpAndSettle();

    // In scroll mode, the body is a ListView.
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(PageView), findsNothing);
  });

  testWidgets('settings sheet switches mode and reflects selection',
      (tester) async {
    app.main();
    await tester.pumpAndSettle();
    goRouter.go('/');
    await tester.pumpAndSettle();

    await openDetailPage(tester);

    // Open reader in default paged mode.
    await tester.tap(find.text('Ch. 2'));
    await tester.pumpAndSettle();

    expect(find.byType(PageView), findsOneWidget);

    // Open settings sheet and switch to Scroll.
    await showBars(tester);
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Scroll'));
    await tester.pumpAndSettle();

    // Close sheet and verify ListView.
    await tester.tapAt(const Offset(200, 100));
    await tester.pumpAndSettle();
    expect(find.byType(ListView), findsOneWidget);

    // Switch back to Paged via sheet.
    await showBars(tester);
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Paged'));
    await tester.pumpAndSettle();

    await tester.tapAt(const Offset(200, 100));
    await tester.pumpAndSettle();
    expect(find.byType(PageView), findsOneWidget);
    expect(find.byType(ListView), findsNothing);
  });

  testWidgets('reading mode preference persists after navigating back',
      (tester) async {
    app.main();
    await tester.pumpAndSettle();
    goRouter.go('/');
    await tester.pumpAndSettle();

    await openDetailPage(tester);

    // Open reader and switch to Scroll via the settings sheet.
    await tester.tap(find.text('Ch. 2'));
    await tester.pumpAndSettle();

    await showBars(tester);
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Scroll'));
    await tester.pumpAndSettle();
    // Dismiss sheet.
    await tester.tapAt(const Offset(200, 100));
    await tester.pumpAndSettle();

    // Navigate back to the manga detail page and re-open the same chapter.
    // context.pop() from the reader returns to MangaDetailPage (outside the
    // shell, so there is no bottom nav bar on that screen).
    await showBars(tester);
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    // Re-open the reader directly from the detail page.
    await tester.tap(find.text('Ch. 2'));
    await tester.pumpAndSettle();

    expect(find.byType(ListView), findsOneWidget);
  });
}
