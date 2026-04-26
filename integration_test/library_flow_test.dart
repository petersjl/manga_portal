import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:manga_portal/app.dart' show goRouter;
import 'package:manga_portal/widgets/manga_card.dart';
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

  testWidgets('add manga from detail page then tap card in library',
      (tester) async {
    app.main();
    await tester.pumpAndSettle();
    goRouter.go('/');
    await tester.pumpAndSettle();

    // Library tab is empty at start.
    expect(find.text('Your library is empty'), findsOneWidget);

    // Navigate to Search tab.
    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();

    // Search for a manga.
    await tester.enterText(find.byType(SearchBar), 'mock');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    // Tap the first result to open its detail page.
    await tester.tap(find.text('Mock Manga One'));
    await tester.pumpAndSettle();

    // The bookmark icon should be unfilled (not in library yet).
    expect(find.byIcon(Icons.bookmark_border), findsOneWidget);

    // Tap the bookmark icon to add to library.
    await tester.tap(find.byIcon(Icons.bookmark_border));
    await tester.pumpAndSettle();

    // Icon should now be filled (confirmed as in-library).
    expect(find.byIcon(Icons.bookmark), findsOneWidget);

    // Go back to the shell (search page) then tap Library tab.
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Library'));
    await tester.pumpAndSettle();

    // The added manga appears as a card in the grid.
    expect(find.byType(MangaCard), findsOneWidget);
    expect(find.text('Mock Manga Title'), findsOneWidget);

    // Tap the card to navigate to the detail page.
    await tester.tap(find.byType(MangaCard));
    await tester.pumpAndSettle();

    // We're on the detail page — bookmark is filled and title is present.
    expect(find.text('Mock Manga Title'), findsOneWidget);
    expect(find.byIcon(Icons.bookmark), findsOneWidget);
  });

  testWidgets('remove manga from library via detail page bookmark',
      (tester) async {
    app.main();
    await tester.pumpAndSettle();
    goRouter.go('/');
    await tester.pumpAndSettle();

    // Add manga via search → detail.
    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(SearchBar), 'mock');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mock Manga One'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.bookmark_border));
    await tester.pumpAndSettle();

    // Bookmark should be filled after adding.
    expect(find.byIcon(Icons.bookmark), findsOneWidget);

    // Now remove it.
    await tester.tap(find.byIcon(Icons.bookmark));
    await tester.pumpAndSettle();

    // Bookmark should be unfilled again.
    expect(find.byIcon(Icons.bookmark_border), findsOneWidget);

    // Navigate to Library tab — should be empty again.
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Library'));
    await tester.pumpAndSettle();

    expect(find.byType(MangaCard), findsNothing);
    expect(find.text('Your library is empty'), findsOneWidget);
  });
}
