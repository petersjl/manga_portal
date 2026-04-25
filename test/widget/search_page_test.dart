import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manga_portal/models/manga.dart';
import 'package:manga_portal/pages/search_page.dart';
import 'package:manga_portal/providers/api_providers.dart';

// ── Fake data ─────────────────────────────────────────────────────────────────

List<Manga> _fakeResults(int count) => List.generate(
      count,
      (i) => Manga(
        id: 'manga-$i',
        attributes: MangaAttributes(
          titles: {'en': 'Manga $i'},
          descriptions: {},
          status: 'ongoing',
        ),
      ),
    );

// ── Helpers ───────────────────────────────────────────────────────────────────

Widget _buildApp({required MangaSearchState initialState}) {
  return ProviderScope(
    overrides: [
      mangaSearchProvider.overrideWith(
        () => _FakeMangaSearch(initialState),
      ),
    ],
    child: const MaterialApp(
      home: SearchPage(),
    ),
  );
}

/// A fake notifier that returns a preset state without hitting the network.
class _FakeMangaSearch extends MangaSearch {
  _FakeMangaSearch(this._preset);
  final MangaSearchState _preset;

  @override
  Future<MangaSearchState> build() async => _preset;
}

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  group('SearchPage', () {
    testWidgets('shows empty prompt when query is empty', (tester) async {
      await tester
          .pumpWidget(_buildApp(initialState: const MangaSearchState()));
      await tester.pump();

      expect(find.text('Search for a manga title above.'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('shows results grid when search returns manga', (tester) async {
      await tester.pumpWidget(_buildApp(
        initialState: MangaSearchState(
          query: 'test',
          results: _fakeResults(3),
          hasMore: false,
        ),
      ));
      await tester.pump();

      // At least the first card is visible; the grid rendered.
      expect(find.text('Manga 0'), findsOneWidget);
      expect(find.text('Manga 1'), findsOneWidget);
      // Manga 2 may be off-screen in the test viewport — just confirm the grid exists.
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('shows no-results message for empty result set',
        (tester) async {
      await tester.pumpWidget(_buildApp(
        initialState: const MangaSearchState(
          query: 'xyzzy',
          results: [],
          hasMore: false,
        ),
      ));
      await tester.pump();

      expect(find.textContaining('No results for'), findsOneWidget);
    });

    testWidgets('shows error message when provider throws', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            mangaSearchProvider.overrideWith(() => _ErrorMangaSearch()),
          ],
          child: const MaterialApp(home: SearchPage()),
        ),
      );
      await tester.pump();

      expect(find.textContaining('Something went wrong'), findsOneWidget);
    });
  });
}

class _ErrorMangaSearch extends MangaSearch {
  @override
  Future<MangaSearchState> build() async => throw Exception('network failure');
}
