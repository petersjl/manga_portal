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
    await tester.pumpWidget(_buildReader(tester, mode: 'ltr'));
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

  testWidgets('bars are hidden by default', (tester) async {
    await tester.pumpWidget(_buildReader(tester, mode: 'ltr'));
    await _settle(tester);

    // Back button and settings cog should not be visible (bars are hidden).
    expect(find.byIcon(Icons.arrow_back), findsNothing);
    expect(find.byIcon(Icons.settings), findsNothing);
    // Page counter text is also not shown yet.
    expect(find.text('1 / 3'), findsNothing);
  });

  testWidgets('tapping content area shows bars', (tester) async {
    await tester.pumpWidget(_buildReader(tester, mode: 'ltr'));
    await _settle(tester);

    // Tap the centre of the screen to toggle bars on.
    await tester.tapAt(const Offset(400, 300));
    await tester.pump(); // process tap + start animation
    await tester.pump(const Duration(milliseconds: 300)); // complete animation
    await tester.pump(); // cleanup frame

    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.byIcon(Icons.settings), findsOneWidget);
    expect(find.text('1 / 3'), findsOneWidget);
  });

  testWidgets('tapping content area again hides bars', (tester) async {
    await tester.pumpWidget(_buildReader(tester, mode: 'ltr'));
    await _settle(tester);

    // Show bars.
    await tester.tapAt(const Offset(400, 300));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);

    // Hide bars.
    await tester.tapAt(const Offset(400, 300));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();
    expect(find.byIcon(Icons.arrow_back), findsNothing);
  });

  testWidgets('settings cog opens bottom sheet with mode selector',
      (tester) async {
    await tester.pumpWidget(_buildReader(tester, mode: 'ltr'));
    await _settle(tester);

    // Show bars first.
    await tester.tapAt(const Offset(400, 300));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();

    // Tap the settings icon.
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();

    // Bottom sheet should contain the mode selector and label.
    expect(find.text('Reader settings'), findsOneWidget);
    expect(find.text('Reading mode'), findsOneWidget);
    expect(find.text('L->R'), findsOneWidget);
    expect(find.text('R->L'), findsOneWidget);
    expect(find.text('Vertical/Scroll'), findsOneWidget);
  });

  testWidgets('rtl mode shows Next on left and Prev on right', (tester) async {
    await tester.pumpWidget(_buildReader(tester, mode: 'rtl'));
    await _settle(tester);

    // Show bars first.
    await tester.tapAt(const Offset(400, 300));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();

    final nextX = tester.getCenter(find.text('Next')).dx;
    final prevX = tester.getCenter(find.text('Prev')).dx;
    expect(nextX, lessThan(prevX));
  });
}
