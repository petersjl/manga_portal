import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:manga_portal/database/app_database.dart';
import 'package:manga_portal/models/chapter.dart';
import 'package:manga_portal/models/chapter_pages.dart';
import 'package:manga_portal/pages/reader_page.dart';
import 'package:manga_portal/providers/api_providers.dart';
import 'package:manga_portal/services/local_progress.dart';

// ── Fake data ─────────────────────────────────────────────────────────────────

const _testMangaId = 'test-manga';
const _ch1Id = 'test-chapter-1';
const _ch2Id = 'test-chapter-2';

AtHomeServer _fakeServer({int pageCount = 3, String chapterId = _ch1Id}) {
  final pages = List.generate(pageCount, (i) => 'page${i + 1}.jpg');
  return AtHomeServer(
    // Use mangadex.org in the base URL so isThirdParty=false and no MD@Home
    // reporting is triggered (which would also make real network calls).
    baseUrl: 'https://mangadex.org/fake',
    chapter:
        ChapterPages(hash: 'hash-$chapterId', data: pages, dataSaver: pages),
  );
}

List<Chapter> _fakeChapters() => [
      const Chapter(
        id: _ch1Id,
        attributes: ChapterAttributes(
          chapterNumber: '1',
          translatedLanguage: 'en',
          pages: 3,
        ),
      ),
      const Chapter(
        id: _ch2Id,
        attributes: ChapterAttributes(
          chapterNumber: '2',
          translatedLanguage: 'en',
          pages: 3,
        ),
      ),
    ];

// Chapter 2 only available in Japanese
List<Chapter> _fakeChaptersLangUnavailable() => [
      const Chapter(
        id: _ch1Id,
        attributes: ChapterAttributes(
          chapterNumber: '1',
          translatedLanguage: 'en',
          pages: 3,
        ),
      ),
      const Chapter(
        id: 'ch2-ja',
        attributes: ChapterAttributes(
          chapterNumber: '2',
          translatedLanguage: 'ja',
          pages: 3,
        ),
      ),
    ];

// ── Helpers ───────────────────────────────────────────────────────────────────

/// Populate an in-memory test database with data from prefsValues.
/// Handles legacy format: 'progress_<mangaId>_chapter' and 'progress_<mangaId>_page'.
Future<void> _populateTestDb(
  AppDatabase db,
  Map<String, Object> prefsValues,
) async {
  for (final entry in prefsValues.entries) {
    if (entry.key.startsWith('progress_') && entry.key.endsWith('_chapter')) {
      final mangaId = entry.key
          .substring('progress_'.length, entry.key.length - '_chapter'.length);
      final chapterId = entry.value as String?;
      final pageKey = 'progress_${mangaId}_page';
      final page = prefsValues[pageKey] as int? ?? 0;
      if (chapterId != null) {
        await db.saveProgress(mangaId, chapterId, page);
      }
    }
  }
}

Widget _buildReader({
  String chapterId = _ch1Id,
  String? mangaId = _testMangaId,
  AtHomeServer? server,
  List<Chapter>? chapters,
  Map<String, Object> prefsValues = const {},
}) {
  final resolvedServer = server ?? _fakeServer(chapterId: chapterId);

  return ProviderScope(
    overrides: [
      atHomeServerProvider(chapterId).overrideWith(
        (ref) async => resolvedServer,
      ),
      if (mangaId != null)
        chapterFeedProvider(mangaId).overrideWith(
          (ref) async => chapters ?? _fakeChapters(),
        ),
      appDatabaseProvider.overrideWith((ref) {
        return AppDatabase.forTesting();
      }),
      localProgressServiceProvider.overrideWith((ref) async {
        final db = ref.watch(appDatabaseProvider);
        await _populateTestDb(db, prefsValues);
        return LocalProgressService.create(db);
      }),
    ],
    child: MaterialApp(
      home: ReaderPage(chapterId: chapterId, mangaId: mangaId),
    ),
  );
}

/// Pump enough frames for async Riverpod providers to fully resolve and
/// post-frame callbacks to fire.
///
/// Uses a small `pump(Duration)` to advance the virtual clock past any
/// Timer-based futures (e.g. SharedPreferences mock, Riverpod internals)
/// without triggering long-running timers from flutter_cache_manager.
Future<void> settle(WidgetTester tester) async {
  await tester.pump(); // Start initial build.
  await tester.pump(const Duration(
      milliseconds: 100)); // Advance clock; resolve Timer-based futures.
  for (var i = 0; i < 8; i++)
    await tester.pump(); // Process post-frame callbacks.
}

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  group('ReaderPage — progress', () {
    testWidgets('starts at page 1 when no progress saved', (tester) async {
      await tester.pumpWidget(_buildReader());
      await settle(tester);

      // Bars are hidden by default — tap to show them.
      await tester.tapAt(const Offset(400, 300));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump();

      expect(find.text('1 / 3'), findsOneWidget);
    });

    testWidgets('restores saved page index on open', (tester) async {
      await tester.pumpWidget(_buildReader(
        prefsValues: {
          'progress_${_testMangaId}_chapter': _ch1Id,
          'progress_${_testMangaId}_page': 2,
        },
      ));
      await settle(tester);

      // Bars are hidden by default — tap to show them.
      await tester.tapAt(const Offset(400, 300));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump();

      // Progress restore is async: jump happens after all the above pumps.
      expect(find.text('3 / 3'), findsOneWidget);
    });

    testWidgets('saves progress after page change', (tester) async {
      final testDb = AppDatabase.forTesting();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            atHomeServerProvider(_ch1Id).overrideWith(
              (ref) async => _fakeServer(pageCount: 5),
            ),
            chapterFeedProvider(_testMangaId).overrideWith(
              (ref) async => _fakeChapters(),
            ),
            appDatabaseProvider.overrideWith((ref) => testDb),
            localProgressServiceProvider.overrideWith((ref) async {
              return LocalProgressService.create(testDb);
            }),
          ],
          child: const MaterialApp(
            home: ReaderPage(chapterId: _ch1Id, mangaId: _testMangaId),
          ),
        ),
      );
      await settle(tester);

      // Fling the PageView left to go to the next manga page.
      await tester.fling(find.byType(PageView), const Offset(-400, 0), 1000);
      // Advance time enough for the scroll animation and async DB write to
      // complete.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      for (var i = 0; i < 10; i++) await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      for (var i = 0; i < 5; i++) await tester.pump();

      // Verify database was written (progress saved).
      final progress = await testDb.getProgress(_testMangaId);
      expect(progress.chapterId, _ch1Id);
      expect(progress.pageIndex, greaterThan(0));
    });
  });

  group('ReaderPage — chapter transitions', () {
    testWidgets('swiping past last page shows next chapter transition',
        (tester) async {
      // Use a 1-page chapter so the next-transition slot is PageView index 2 —
      // reachable in a single left-fling from the initial position (index 1).
      // (Two consecutive flings on the same PageView can be unreliable in
      //  widget tests, so we remove the need for a second swipe.)
      await tester.pumpWidget(_buildReader(
        server: _fakeServer(pageCount: 1),
      ));
      await settle(tester);

      // Single left-fling: index 1 (only manga page) → index 2 (next-chapter slot).
      await tester.fling(find.byType(PageView), const Offset(-400, 0), 1000);
      await tester.pump(const Duration(milliseconds: 400));
      for (var i = 0; i < 5; i++) await tester.pump();

      // 'Up next' is unique to _AvailableTransition — confirms we're on the
      // next-chapter transition page, not just pre-rendering slot 2.
      expect(find.text('Up next'), findsOneWidget);
      expect(find.textContaining('Ch. 2'), findsWidgets);
    });

    testWidgets('swiping back from first page shows prev chapter transition',
        (tester) async {
      // Start on chapter 2 so there is a chapter 1 to go back to.
      final testDb = AppDatabase.forTesting();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            atHomeServerProvider(_ch2Id).overrideWith(
              (ref) async => _fakeServer(pageCount: 2, chapterId: _ch2Id),
            ),
            chapterFeedProvider(_testMangaId).overrideWith(
              (ref) async => _fakeChapters(),
            ),
            appDatabaseProvider.overrideWith((ref) => testDb),
            localProgressServiceProvider.overrideWith((ref) async {
              return LocalProgressService.create(testDb);
            }),
          ],
          child: const MaterialApp(
            home: ReaderPage(chapterId: _ch2Id, mangaId: _testMangaId),
          ),
        ),
      );
      await settle(tester);

      // We start at PageView index 1 (first manga page). Swipe right to
      // reach index 0 (prev-chapter transition slot).
      await tester.fling(find.byType(PageView), const Offset(400, 0), 1000);
      await tester.pump(const Duration(milliseconds: 400));
      for (var i = 0; i < 5; i++) await tester.pump();

      // Previous chapter's number should appear.
      expect(find.textContaining('Ch. 1'), findsWidgets);
    });

    testWidgets(
        'shows language unavailability page when next chapter not in preferred language',
        (tester) async {
      // Same single-fling setup as the "next chapter" test above.
      await tester.pumpWidget(_buildReader(
        server: _fakeServer(pageCount: 1),
        chapters: _fakeChaptersLangUnavailable(),
      ));
      await settle(tester);

      await tester.fling(find.byType(PageView), const Offset(-400, 0), 1000);
      await tester.pump(const Duration(milliseconds: 400));
      for (var i = 0; i < 5; i++) await tester.pump();

      expect(find.textContaining('Not available in your language'),
          findsOneWidget);
      // The _LangUnavailablePage shows a language icon.
      expect(find.byIcon(Icons.language), findsOneWidget);
    });
  });
}
