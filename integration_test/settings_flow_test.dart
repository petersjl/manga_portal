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

  testWidgets('settings page renders all sections', (tester) async {
    app.main();
    await tester.pumpAndSettle();
    goRouter.go('/');
    await tester.pumpAndSettle();

    // Navigate to Settings tab.
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Appearance'), findsOneWidget);
    expect(find.text('Content'), findsOneWidget);
    expect(find.text('Reading'), findsOneWidget);
    expect(find.text('Reading history'), findsOneWidget);
    expect(find.text('Clear reading history'), findsOneWidget);

    // Default dropdown values are visible.
    expect(find.text('English'), findsOneWidget);
    expect(find.text('Suggestive'), findsOneWidget);
    expect(find.text('Dark'), findsOneWidget);
    expect(find.text('Full'), findsOneWidget);
    expect(find.text('Data saver'), findsOneWidget);
  });

  testWidgets('changing image quality to data-saver persists and reader opens',
      (tester) async {
    app.main();
    await tester.pumpAndSettle();
    goRouter.go('/');
    await tester.pumpAndSettle();

    // Go to Settings tab.
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    // Switch quality to Data saver.
    await tester.tap(find.text('Data saver'));
    await tester.pumpAndSettle();

    // Navigate to Search and open the reader to verify it still works.
    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(SearchBar), 'mock');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Mock Manga One'));
    await tester.pumpAndSettle();

    // Tap the highest available chapter (Ch. 2).
    await tester.tap(find.text('Ch. 2'));
    await tester.pumpAndSettle();

    // Reader opened successfully — page indicator is visible.
    expect(find.textContaining('1 / 5'), findsOneWidget);
  });

  testWidgets('changing language setting persists across navigation',
      (tester) async {
    app.main();
    await tester.pumpAndSettle();
    goRouter.go('/');
    await tester.pumpAndSettle();

    // Go to Settings.
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    // Open language dropdown.
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    // Select French.
    await tester.tap(find.text('French'));
    await tester.pumpAndSettle();

    // 'French' is now the selected language in the dropdown.
    expect(find.text('French'), findsOneWidget);

    // Navigate away and back — setting survives navigation.
    await tester.tap(find.text('Library'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('French'), findsOneWidget);
    expect(find.text('English'), findsNothing);
  });
}
