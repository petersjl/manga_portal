import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manga_portal/models/chapter_pages.dart';
import 'package:manga_portal/pages/reader_page.dart';
import 'package:manga_portal/providers/api_providers.dart';
import 'package:manga_portal/widgets/reader_page_image.dart';

// A minimal fake AtHomeServer with 3 pages from MangaDex's own CDN
// (isThirdParty == false so no MD@Home reporting is triggered).
const _fakeServer = AtHomeServer(
  baseUrl: 'https://uploads.mangadex.org',
  chapter: ChapterPages(
    hash: 'testhash',
    data: ['page1.jpg', 'page2.jpg', 'page3.jpg'],
    dataSaver: ['page1_small.jpg', 'page2_small.jpg', 'page3_small.jpg'],
  ),
);

Widget _buildTestApp(List<Override> overrides) {
  return ProviderScope(
    overrides: overrides,
    child: const MaterialApp(
      home: ReaderPage(chapterId: 'test-chapter-id'),
    ),
  );
}

/// Pumps enough frames for a FutureProvider to resolve and the widget to
/// rebuild. Does NOT use pumpAndSettle because image preloading schedules
/// may schedule retry timers in the test environment, preventing settlement.
Future<void> _pumpAfterLoad(WidgetTester tester) async {
  // Frame 1: FutureProvider schedules microtask.
  await tester.pump();
  // Frame 2: FutureProvider resolves, widget rebuilds.
  await tester.pump();
  // Frame 3: addPostFrameCallback (_precacheAdjacentPages) fires.
  await tester.pump();
}

void main() {
  group('ReaderPage', () {
    testWidgets('shows loading indicator while provider is loading',
        (tester) async {
      // Use a Completer (no timer) so fake_async doesn't complain about pending
      // timers at test teardown.
      final completer = Completer<AtHomeServer>();

      await tester.pumpWidget(
        _buildTestApp([
          atHomeServerProvider('test-chapter-id').overrideWith(
            (ref) => completer.future,
          ),
        ]),
      );

      // After the first pump the FutureProvider is in loading state.
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Complete the future so the widget tree can be cleanly disposed.
      completer.complete(_fakeServer);
      await _pumpAfterLoad(tester);
    });

    testWidgets('shows PageView with pages on success', (tester) async {
      await tester.pumpWidget(
        _buildTestApp([
          atHomeServerProvider('test-chapter-id').overrideWith(
            (ref) async => _fakeServer,
          ),
        ]),
      );

      await _pumpAfterLoad(tester);

      expect(find.byType(PageView), findsOneWidget);
      expect(find.byType(ReaderPageImage), findsWidgets);
    });

    testWidgets('shows page counter in app bar', (tester) async {
      await tester.pumpWidget(
        _buildTestApp([
          atHomeServerProvider('test-chapter-id').overrideWith(
            (ref) async => _fakeServer,
          ),
        ]),
      );

      await _pumpAfterLoad(tester);

      // Should show "1 / 3" for the first page of a 3-page chapter.
      expect(find.text('1 / 3'), findsOneWidget);
    });

    testWidgets('shows error message and retry button on failure',
        (tester) async {
      await tester.pumpWidget(
        _buildTestApp([
          atHomeServerProvider('test-chapter-id').overrideWith(
            (ref) async => throw Exception('Network error'),
          ),
        ]),
      );

      // Error state has no images so pumpAndSettle is safe here.
      await tester.pumpAndSettle();

      expect(
          find.text('Could not load chapter.\nPlease check your connection.'),
          findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('retry button invalidates provider', (tester) async {
      var callCount = 0;

      await tester.pumpWidget(
        _buildTestApp([
          atHomeServerProvider('test-chapter-id').overrideWith(
            (ref) async {
              callCount++;
              if (callCount == 1) throw Exception('First attempt fails');
              return _fakeServer;
            },
          ),
        ]),
      );

      await tester.pumpAndSettle(); // Error state — no images, safe to settle.
      expect(find.text('Retry'), findsOneWidget);

      await tester.tap(find.text('Retry'));
      await _pumpAfterLoad(tester); // Success state — use explicit pumps.

      // After retry the pages should load.
      expect(find.byType(PageView), findsOneWidget);
    });
  });
}
