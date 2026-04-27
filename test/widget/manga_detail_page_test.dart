import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manga_portal/database/app_database.dart';
import 'package:manga_portal/models/chapter.dart';
import 'package:manga_portal/models/manga.dart';
import 'package:manga_portal/pages/manga_detail_page.dart';
import 'package:manga_portal/providers/api_providers.dart';
import 'package:manga_portal/services/local_progress.dart';

// ── Fake data ─────────────────────────────────────────────────────────────────

const _fakeManga = Manga(
  id: 'test-manga-id',
  attributes: MangaAttributes(
    titles: {'en': 'Test Manga'},
    descriptions: {'en': 'A test description.'},
    status: 'ongoing',
  ),
  coverArt: CoverArt(id: 'cover-1', fileName: 'cover.jpg'),
);

final _fakeChapters = [
  const Chapter(
    id: 'ch-1',
    attributes: ChapterAttributes(
      chapterNumber: '1',
      title: 'First Chapter',
      translatedLanguage: 'en',
      publishAt: '2020-01-01T00:00:00+00:00',
      pages: 10,
    ),
    scanlationGroup: ScanlationGroup(id: 'g-1', name: 'TestGroup'),
  ),
  const Chapter(
    id: 'ch-2',
    attributes: ChapterAttributes(
      chapterNumber: '2',
      title: 'Second Chapter',
      translatedLanguage: 'en',
      publishAt: '2020-02-01T00:00:00+00:00',
      pages: 12,
    ),
    scanlationGroup: ScanlationGroup(id: 'g-1', name: 'TestGroup'),
  ),
];

// ── Helpers ───────────────────────────────────────────────────────────────────

Widget _buildApp(List<Override> overrides) {
  final testDb = AppDatabase.forTesting();
  return ProviderScope(
    overrides: [
      // Provide a real (empty) LocalProgressService so progress tracking
      // works with the in-memory database.
      appDatabaseProvider.overrideWith((ref) => testDb),
      localProgressServiceProvider.overrideWith((ref) async {
        return LocalProgressService.create(testDb);
      }),
      ...overrides,
    ],
    child: const MaterialApp(
      home: MangaDetailPage(mangaId: 'test-manga-id'),
    ),
  );
}

/// Pumps enough frames for async providers to settle without using
/// pumpAndSettle (which hangs if image providers are in-flight).
Future<void> _pumpAfterLoad(WidgetTester tester) async {
  await tester.pump(); // Start provider futures.
  await tester.pump(const Duration(milliseconds: 100)); // Resolve futures.
  for (var i = 0; i < 4; i++) {
    await tester.pump(); // Process post-frame callbacks and rebuilds.
  }
}

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  group('MangaDetailPage', () {
    testWidgets('shows loading indicator while providers are loading',
        (tester) async {
      final completer = Completer<Manga>();

      await tester.pumpWidget(
        _buildApp([
          mangaProvider('test-manga-id')
              .overrideWith((ref) => completer.future),
          chapterFeedProvider('test-manga-id')
              .overrideWith((ref) async => <Chapter>[]),
        ]),
      );

      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows manga title and chapter list on data', (tester) async {
      await tester.pumpWidget(
        _buildApp([
          mangaProvider('test-manga-id')
              .overrideWith((ref) async => _fakeManga),
          chapterFeedProvider('test-manga-id')
              .overrideWith((ref) async => _fakeChapters),
        ]),
      );

      await _pumpAfterLoad(tester);

      expect(find.text('Test Manga'), findsAtLeastNWidgets(1));
      expect(find.text('A test description.'), findsOneWidget);
      // Chapters are displayed descending by number. Ch. 2 should be above the
      // fold; Ch. 1 may be just below — drag the scroll view to bring it in.
      expect(find.text('Ch. 2'), findsOneWidget);
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -200));
      await tester.pump();
      expect(find.text('Ch. 1'), findsOneWidget);
    });

    testWidgets('shows error + retry button when manga provider fails',
        (tester) async {
      await tester.pumpWidget(
        _buildApp([
          mangaProvider('test-manga-id').overrideWith(
            (ref) async => throw Exception('network error'),
          ),
          chapterFeedProvider('test-manga-id')
              .overrideWith((ref) async => <Chapter>[]),
        ]),
      );

      await _pumpAfterLoad(tester);

      expect(find.textContaining('Could not load manga'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('shows chapters error section when chapter feed fails',
        (tester) async {
      await tester.pumpWidget(
        _buildApp([
          mangaProvider('test-manga-id')
              .overrideWith((ref) async => _fakeManga),
          chapterFeedProvider('test-manga-id').overrideWith(
            (ref) async => throw Exception('network error'),
          ),
        ]),
      );

      await _pumpAfterLoad(tester);

      // Manga info should still render.
      expect(find.text('Test Manga'), findsAtLeastNWidgets(1));
      // Chapter error section.
      expect(find.textContaining('Could not load chapters'), findsOneWidget);
    });

    testWidgets('chapters unavailable in preferred language are subdued',
        (tester) async {
      final japaneseChapter = [
        const Chapter(
          id: 'ch-jp',
          attributes: ChapterAttributes(
            chapterNumber: '1',
            translatedLanguage: 'ja',
            publishAt: null,
            pages: 10,
          ),
        ),
      ];

      await tester.pumpWidget(
        _buildApp([
          mangaProvider('test-manga-id')
              .overrideWith((ref) async => _fakeManga),
          chapterFeedProvider('test-manga-id')
              .overrideWith((ref) async => japaneseChapter),
        ]),
      );

      await _pumpAfterLoad(tester);

      expect(find.textContaining('Not available in en'), findsOneWidget);
    });

    testWidgets('multi-group chapter expands to show group list',
        (tester) async {
      final multiGroupChapters = [
        const Chapter(
          id: 'ch-1a',
          attributes: ChapterAttributes(
            chapterNumber: '1',
            translatedLanguage: 'en',
            publishAt: '2020-01-01T00:00:00+00:00',
            pages: 10,
          ),
          scanlationGroup: ScanlationGroup(id: 'g-1', name: 'Group A'),
        ),
        const Chapter(
          id: 'ch-1b',
          attributes: ChapterAttributes(
            chapterNumber: '1',
            translatedLanguage: 'en',
            publishAt: '2020-01-02T00:00:00+00:00',
            pages: 10,
          ),
          scanlationGroup: ScanlationGroup(id: 'g-2', name: 'Group B'),
        ),
      ];

      await tester.pumpWidget(
        _buildApp([
          mangaProvider('test-manga-id')
              .overrideWith((ref) async => _fakeManga),
          chapterFeedProvider('test-manga-id')
              .overrideWith((ref) async => multiGroupChapters),
        ]),
      );

      await _pumpAfterLoad(tester);

      expect(find.textContaining('2 translations'), findsOneWidget);
      // Scroll to ensure the chip is in the visible viewport before tapping.
      await tester.ensureVisible(find.textContaining('2 translations'));
      await tester.pumpAndSettle();
      // Tap to expand.
      await tester.tap(find.textContaining('2 translations'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250)); // Animation.
      expect(find.text('Group A'), findsOneWidget);
      expect(find.text('Group B'), findsOneWidget);
    });
  });
}
