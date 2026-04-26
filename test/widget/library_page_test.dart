import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:manga_portal/pages/library_page.dart';
import 'package:manga_portal/providers/library_provider.dart';
import 'package:manga_portal/widgets/manga_card.dart';

// ── Fake notifier ─────────────────────────────────────────────────────────────

class _FakeLibraryNotifier extends LibraryNotifier {
  _FakeLibraryNotifier(this._entries);
  final List<LibraryEntry> _entries;

  @override
  Future<List<LibraryEntry>> build() async => _entries;
}

// ── Helpers ───────────────────────────────────────────────────────────────────

Widget _buildApp(List<LibraryEntry> entries) {
  return ProviderScope(
    overrides: [
      libraryNotifierProvider.overrideWith(
        () => _FakeLibraryNotifier(entries),
      ),
    ],
    child: const MaterialApp(home: LibraryPage()),
  );
}

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  group('LibraryPage', () {
    testWidgets('renders a MangaCard for each saved manga', (tester) async {
      final entries = [
        const LibraryEntry(id: 'manga-1', title: 'Test Manga'),
        const LibraryEntry(id: 'manga-2', title: 'Another Manga'),
      ];

      await tester.pumpWidget(_buildApp(entries));
      await tester.pumpAndSettle();

      expect(find.byType(MangaCard), findsNWidgets(2));
      expect(find.text('Test Manga'), findsOneWidget);
      expect(find.text('Another Manga'), findsOneWidget);
    });

    testWidgets('shows empty state when library is empty', (tester) async {
      await tester.pumpWidget(_buildApp([]));
      await tester.pumpAndSettle();

      expect(find.byType(MangaCard), findsNothing);
      expect(find.text('Your library is empty'), findsOneWidget);
      expect(find.text('Search for manga to add them here.'), findsOneWidget);
    });

    testWidgets('shows loading indicator while provider is loading',
        (tester) async {
      // Build without pumpAndSettle so the Future hasn't resolved yet.
      await tester.pumpWidget(_buildApp([]));
      // pumpAndSettle is intentionally omitted — only one frame pumped.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
