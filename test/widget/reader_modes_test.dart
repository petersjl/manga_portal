import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:manga_portal/models/chapter.dart';
import 'package:manga_portal/models/chapter_pages.dart';
import 'package:manga_portal/pages/reader_page.dart';
import 'package:manga_portal/providers/api_providers.dart';
import 'package:manga_portal/providers/reader_provider.dart';
import 'package:manga_portal/services/local_progress.dart';

// ── Fake data ─────────────────────────────────────────────────────────────────

const _testMangaId = 'test-manga';
const _chId = 'test-chapter-1';

AtHomeServer _fakeServer() {
  const pages = ['page1.jpg', 'page2.jpg', 'page3.jpg'];
  return const AtHomeServer(
    baseUrl: 'https://mangadex.org/fake',
    chapter: ChapterPages(hash: 'hash', data: pages, dataSaver: pages),
  );
}

List<Chapter> _fakeChapters() => [
      const Chapter(
        id: _chId,
        attributes: ChapterAttributes(
          chapterNumber: '1',
          translatedLanguage: 'en',
          pages: 3,
        ),
      ),
    ];

// ── Fake ReadingModeNotifier ──────────────────────────────────────────────────

class _FakeModeNotifier extends ReadingModeNotifier {
  _FakeModeNotifier(this._fixedMode);

  final String _fixedMode;

  @override
  String build(String mangaId) => _fixedMode;
}

// ── Helper ────────────────────────────────────────────────────────────────────

/// Pumps enough frames for async providers and post-frame callbacks to
/// resolve without blocking on long-running network timers from
/// flutter_cache_manager.
Future<void> _settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
  for (var i = 0; i < 8; i++) {
    await tester.pump();
  }
}

Widget _buildReader(WidgetTester tester, {required String mode}) {
  SharedPreferences.setMockInitialValues({});

  return ProviderScope(
    overrides: [
      atHomeServerProvider(_chId).overrideWith((ref) async => _fakeServer()),
      chapterFeedProvider(_testMangaId)
          .overrideWith((ref) async => _fakeChapters()),
      localProgressServiceProvider.overrideWith((ref) async {
        return LocalProgressService(await SharedPreferences.getInstance());
      }),
      readingModeNotifierProvider(_testMangaId).overrideWith(
        () => _FakeModeNotifier(mode),
      ),
    ],
    child: const MaterialApp(
      home: ReaderPage(chapterId: _chId, mangaId: _testMangaId),
    ),
  );
}

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  testWidgets('paged mode renders PageView', (tester) async {
    await tester.pumpWidget(_buildReader(tester, mode: 'paged'));
    await _settle(tester);

    expect(find.byType(PageView), findsOneWidget);
    expect(find.byType(ListView), findsNothing);
  });

  testWidgets('scroll mode renders ListView', (tester) async {
    await tester.pumpWidget(_buildReader(tester, mode: 'scroll'));
    await _settle(tester);

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(PageView), findsNothing);
  });

  testWidgets('mode toggle button appears in app bar when mangaId is set',
      (tester) async {
    await tester.pumpWidget(_buildReader(tester, mode: 'paged'));
    await _settle(tester);

    // In paged mode the toggle shows the scroll-mode icon (view_agenda),
    // indicating "tap to switch to scroll".
    expect(find.byIcon(Icons.view_agenda), findsOneWidget);
  });

  testWidgets('paged mode shows page number indicator in app bar',
      (tester) async {
    await tester.pumpWidget(_buildReader(tester, mode: 'paged'));
    await _settle(tester);

    expect(find.text('1 / 3'), findsOneWidget);
  });

  testWidgets('scroll mode shows page number indicator in app bar',
      (tester) async {
    await tester.pumpWidget(_buildReader(tester, mode: 'scroll'));
    await _settle(tester);

    expect(find.text('1 / 3'), findsOneWidget);
  });
}
