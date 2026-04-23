import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:manga_portal/main.dart';

void main() {
  group('App smoke tests', () {
    testWidgets('renders without throwing', (tester) async {
      await tester.pumpWidget(const ProviderScope(child: MangaPortal()));
      await tester.pumpAndSettle();
      expect(find.byType(MangaPortal), findsOneWidget);
    });

    testWidgets('bottom navigation bar is present with three destinations',
        (tester) async {
      await tester.pumpWidget(const ProviderScope(child: MangaPortal()));
      await tester.pumpAndSettle();

      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.text('Library'), findsOneWidget);
      expect(find.text('Search'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('starts on Library tab', (tester) async {
      await tester.pumpWidget(const ProviderScope(child: MangaPortal()));
      await tester.pumpAndSettle();

      final navBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
      expect(navBar.selectedIndex, 0);
    });

    testWidgets('tapping Search tab navigates to Search', (tester) async {
      await tester.pumpWidget(const ProviderScope(child: MangaPortal()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Search'));
      await tester.pumpAndSettle();

      final navBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
      expect(navBar.selectedIndex, 1);
    });

    testWidgets('tapping Settings tab navigates to Settings', (tester) async {
      await tester.pumpWidget(const ProviderScope(child: MangaPortal()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      final navBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
      expect(navBar.selectedIndex, 2);
    });
  });
}
