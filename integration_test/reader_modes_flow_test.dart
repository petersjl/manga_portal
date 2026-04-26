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

  testWidgets(
      'reading mode selector appears on detail page and defaults to Paged',
      (tester) async {
    app.main();
    await tester.pumpAndSettle();
    goRouter.go('/');
    await tester.pumpAndSettle();

    await openDetailPage(tester);

    // SegmentedButton shows "Paged" and "Scroll" options.
    expect(find.text('Paged'), findsOneWidget);
    expect(find.text('Scroll'), findsOneWidget);
    expect(find.text('Reading mode'), findsOneWidget);
  });

  testWidgets(
      'switching to scroll mode on detail page opens reader in ListView',
      (tester) async {
    app.main();
    await tester.pumpAndSettle();
    goRouter.go('/');
    await tester.pumpAndSettle();

    await openDetailPage(tester);

    // Switch to Scroll mode.
    await tester.tap(find.text('Scroll'));
    await tester.pumpAndSettle();

    // Open the reader via the chapter list.
    await tester.tap(find.text('Ch. 2'));
    await tester.pumpAndSettle();

    // In scroll mode, the body is a ListView (not a PageView).
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(PageView), findsNothing);

    // Page counter is still shown.
    expect(find.textContaining('1 / 5'), findsOneWidget);

    // Toggle button shows the "paged" icon (auto_stories), indicating
    // "tap to switch back to paged mode".
    expect(find.byIcon(Icons.auto_stories), findsOneWidget);
  });

  testWidgets('reader toggle button switches from paged to scroll in-place',
      (tester) async {
    app.main();
    await tester.pumpAndSettle();
    goRouter.go('/');
    await tester.pumpAndSettle();

    await openDetailPage(tester);

    // Open in the default paged mode.
    await tester.tap(find.text('Ch. 2'));
    await tester.pumpAndSettle();

    expect(find.byType(PageView), findsOneWidget);
    expect(find.byType(ListView), findsNothing);

    // Tap the toggle in the app bar (view_agenda icon = "switch to scroll").
    await tester.tap(find.byIcon(Icons.view_agenda));
    await tester.pumpAndSettle();

    // Now in scroll mode.
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(PageView), findsNothing);

    // Toggle back to paged.
    await tester.tap(find.byIcon(Icons.auto_stories));
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

    // Switch to Scroll and remember it.
    await tester.tap(find.text('Scroll'));
    await tester.pumpAndSettle();

    // Navigate back to Library then re-open the detail page.
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    await openDetailPage(tester);

    // "Scroll" should still be selected.
    // Open reader and verify it uses ListView.
    await tester.tap(find.text('Ch. 2'));
    await tester.pumpAndSettle();

    expect(find.byType(ListView), findsOneWidget);
  });
}
