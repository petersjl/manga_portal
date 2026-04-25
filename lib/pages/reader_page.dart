import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/chapter.dart';
import '../models/chapter_pages.dart';
import '../providers/api_providers.dart';
import '../providers/reader_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/reader_page_image.dart';

// ── Public widget ─────────────────────────────────────────────────────────────

class ReaderPage extends ConsumerStatefulWidget {
  const ReaderPage({
    super.key,
    required this.chapterId,
    this.mangaId,
  });

  final String chapterId;

  /// If provided, enables progress saving/restoring and chapter navigation.
  /// Null when opened via a deep-link that only contains a chapterId.
  final String? mangaId;

  @override
  ConsumerState<ReaderPage> createState() => _ReaderPageState();
}

// ── State ─────────────────────────────────────────────────────────────────────

class _ReaderPageState extends ConsumerState<ReaderPage> {
  // Currently displayed chapter (changes when user navigates chapters).
  late String _currentChapterId;

  // 0-based manga-page index (excludes the transition PageView slots).
  int _currentMangaPage = 0;

  // Whether the current PageView position is a transition slot (not a page).
  bool _isOnTransitionPage = false;

  // PageView controller. Slot layout: [prevTransition, page0…pageN, nextTransition]
  // Manga pages live at PageView indices 1…N; transitions at 0 and N+1.
  PageController _pageController = PageController(initialPage: 1);

  // Incremented every time we switch chapters, forcing the PageView to rebuild.
  int _pageViewKey = 0;

  // Incremented every time we kick off a new preload run; old runs abort when
  // they see the generation has changed.
  int _loadGeneration = 0;

  // Guards: ensure preload + progress-restore only run once per chapter load.
  bool _initialPreloadDone = false;
  bool _progressRestored = false;

  // Allows only one at-home server refresh per chapter load to prevent an
  // infinite failure → invalidate loop when images are consistently unavailable.
  bool _serverRefreshUsed = false;

  // Keeps the last known server so the PageView stays visible during a
  // brief at-home refresh (prevents scroll-position reset on reload).
  AtHomeServer? _lastServer;

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _currentChapterId = widget.chapterId;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // ── Chapter loading ────────────────────────────────────────────────────────

  void _loadChapter(String newChapterId, {int initialMangaPage = 0}) {
    _loadGeneration++;
    _pageController.dispose();
    _pageController = PageController(initialPage: 1 + initialMangaPage);
    setState(() {
      _currentChapterId = newChapterId;
      _currentMangaPage = initialMangaPage;
      _isOnTransitionPage = false;
      _initialPreloadDone = false;
      _serverRefreshUsed = false;
      _lastServer = null;
      // Do NOT reset _progressRestored — only restore progress for the entry
      // chapter; subsequent chapters load from the beginning.
      _pageViewKey++;
    });
  }

  // ── Reading progress ───────────────────────────────────────────────────────

  Future<void> _restoreProgress(List<String> pages) async {
    if (_progressRestored || widget.mangaId == null) {
      _progressRestored = true;
      return;
    }
    _progressRestored = true;

    final service = await ref.read(localProgressServiceProvider.future);
    if (!mounted) return;

    final progress = service.getProgress(widget.mangaId!);
    if (progress.chapterId == _currentChapterId && progress.pageIndex > 0) {
      final clamped = progress.pageIndex.clamp(0, pages.length - 1);
      if (clamped > 0 && _pageController.hasClients) {
        setState(() => _currentMangaPage = clamped);
        _pageController.jumpToPage(1 + clamped);
      }
    }
  }

  void _saveProgress(int pageIndex) {
    if (widget.mangaId == null) return;
    ref.read(localProgressServiceProvider.future).then((service) {
      if (mounted) {
        service.saveProgress(widget.mangaId!, _currentChapterId, pageIndex);
      }
    });
  }

  // ── Image preloading ───────────────────────────────────────────────────────

  void _onPageChanged(int viewIndex, AtHomeServer server) {
    final dataSaver = ref.read(imageQualityProvider) == 'data-saver';
    final pages = dataSaver ? server.chapter.dataSaver : server.chapter.data;
    final mangaPage = viewIndex - 1;

    if (mangaPage >= 0 && mangaPage < pages.length) {
      setState(() {
        _currentMangaPage = mangaPage;
        _isOnTransitionPage = false;
      });
      _saveProgress(mangaPage);
      _startPreload(mangaPage, server);
    } else {
      setState(() => _isOnTransitionPage = true);
    }
  }

  void _startPreload(int index, AtHomeServer server) {
    final gen = ++_loadGeneration;
    final dataSaver = ref.read(imageQualityProvider) == 'data-saver';
    final pages = dataSaver ? server.chapter.dataSaver : server.chapter.data;

    const immediateAhead = 3;
    const immediateBehind = 1;
    for (var i = index - immediateBehind; i <= index + immediateAhead; i++) {
      if (i < 0 || i >= pages.length || i == index) continue;
      precacheImage(
        CachedNetworkImageProvider(
            server.pageUrl(pages[i], dataSaver: dataSaver)),
        context,
        onError: (_, __) {},
      );
    }

    _preloadBackground(gen, index, server,
        skipStart: index - immediateBehind, skipEnd: index + immediateAhead);
  }

  Future<void> _preloadBackground(
    int gen,
    int startIndex,
    AtHomeServer server, {
    required int skipStart,
    required int skipEnd,
  }) async {
    final dataSaver = ref.read(imageQualityProvider) == 'data-saver';
    final pages = dataSaver ? server.chapter.dataSaver : server.chapter.data;

    final sorted = List.generate(pages.length, (i) => i)
        .where((i) => i != startIndex && (i < skipStart || i > skipEnd))
        .toList()
      ..sort(
        (a, b) => (a - startIndex).abs().compareTo((b - startIndex).abs()),
      );

    for (final i in sorted) {
      if (_loadGeneration != gen || !mounted) return;
      await precacheImage(
        CachedNetworkImageProvider(
            server.pageUrl(pages[i], dataSaver: dataSaver)),
        context,
        onError: (_, __) {},
      );
    }
  }

  void _onImageLoadFailure() {
    // Allow only one server refresh per chapter load to avoid an infinite
    // failure→invalidate loop (e.g. in tests or when the CDN node is down).
    if (_serverRefreshUsed) return;
    _serverRefreshUsed = true;
    ref.invalidate(atHomeServerProvider(_currentChapterId));
  }

  // ── Chapter navigation helpers ─────────────────────────────────────────────

  _ChapterNavResult _getAdjacentChapter(
    List<Chapter> allChapters,
    bool next,
    String preferredLanguage,
  ) {
    if (allChapters.isEmpty) return const _ChapterNavNone();

    final currentIndex =
        allChapters.indexWhere((c) => c.id == _currentChapterId);
    if (currentIndex < 0) return const _ChapterNavNone();

    final current = allChapters[currentIndex];
    final currentNum = current.attributes.chapterNumber;
    if (currentNum == null) return const _ChapterNavNone(); // Oneshot

    final sortedNums = allChapters
        .map((c) => c.attributes.chapterNumber)
        .toSet()
        .toList()
      ..sort(_compareChapterNums);

    final numIdx = sortedNums.indexOf(currentNum);
    final targetNumIdx = next ? numIdx + 1 : numIdx - 1;

    if (targetNumIdx < 0 || targetNumIdx >= sortedNums.length) {
      return const _ChapterNavNone();
    }

    final targetNum = sortedNums[targetNumIdx];
    final candidates = allChapters
        .where((c) => c.attributes.chapterNumber == targetNum)
        .toList();

    final inLanguage = candidates
        .where((c) => c.attributes.translatedLanguage == preferredLanguage)
        .toList();

    if (inLanguage.isEmpty) return const _ChapterNavLangUnavailable();
    if (inLanguage.length == 1) return _ChapterNavAvailable(inLanguage.first);

    // Multiple in preferred language: prefer same scanlation group.
    final sameGroup = inLanguage
        .where((c) => c.scanlationGroup?.id == current.scanlationGroup?.id)
        .toList();
    return _ChapterNavAvailable(
        sameGroup.isNotEmpty ? sameGroup.first : inLanguage.first);
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final serverAsync = ref.watch(atHomeServerProvider(_currentChapterId));
    final imageQuality = ref.watch(imageQualityProvider);
    final dataSaver = imageQuality == 'data-saver';

    final chaptersAsync = widget.mangaId != null
        ? ref.watch(chapterFeedProvider(widget.mangaId!))
        : const AsyncData<List<Chapter>>([]);

    final settings = ref.watch(settingsNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: serverAsync.maybeWhen(
          data: (server) {
            if (_isOnTransitionPage) return const SizedBox.shrink();
            final pages =
                dataSaver ? server.chapter.dataSaver : server.chapter.data;
            return Text('${_currentMangaPage + 1} / ${pages.length}');
          },
          orElse: () => const SizedBox.shrink(),
        ),
      ),
      body: serverAsync.when(
        loading: () {
          // Keep the PageView visible during a server URL refresh so the
          // scroll position isn't lost. Only show the spinner on first load.
          if (_lastServer case final server?) {
            return _buildPageViewContent(
                server, dataSaver, chaptersAsync, settings);
          }
          return const Center(
              child: CircularProgressIndicator(color: Colors.white));
        },
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off, size: 48, color: Colors.white54),
              const SizedBox(height: 16),
              Text(
                'Could not load chapter.\nPlease check your connection.',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.white70),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () =>
                    ref.invalidate(atHomeServerProvider(_currentChapterId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (server) {
          _lastServer = server;
          return _buildPageViewContent(
              server, dataSaver, chaptersAsync, settings);
        },
      ),
    );
  }

  Widget _buildPageViewContent(
    AtHomeServer server,
    bool dataSaver,
    AsyncValue<List<Chapter>> chaptersAsync,
    Settings settings,
  ) {
    final pages = dataSaver ? server.chapter.dataSaver : server.chapter.data;

    // Once per chapter load: restore saved progress then start preload.
    if (!_initialPreloadDone) {
      _initialPreloadDone = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;
        await _restoreProgress(pages);
        if (mounted) _startPreload(_currentMangaPage, server);
      });
    }

    return PageView.builder(
      key: ValueKey(_pageViewKey),
      controller: _pageController,
      itemCount: pages.length + 2, // prevSlot + pages + nextSlot
      onPageChanged: (index) => _onPageChanged(index, server),
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildTransitionSlot(
            isNext: false,
            chaptersAsync: chaptersAsync,
            preferredLanguage: settings.preferredLanguage,
          );
        } else if (index == pages.length + 1) {
          return _buildTransitionSlot(
            isNext: true,
            chaptersAsync: chaptersAsync,
            preferredLanguage: settings.preferredLanguage,
          );
        } else {
          final pageIndex = index - 1;
          return ReaderPageImage(
            key: ValueKey('${_currentChapterId}_${pages[pageIndex]}'),
            url: server.pageUrl(pages[pageIndex], dataSaver: dataSaver),
            isThirdParty: server.isThirdParty,
            apiService: ref.read(mangaDexApiServiceProvider),
            onLoadFailure: _onImageLoadFailure,
          );
        }
      },
    );
  }

  Widget _buildTransitionSlot({
    required bool isNext,
    required AsyncValue<List<Chapter>> chaptersAsync,
    required String preferredLanguage,
  }) {
    if (widget.mangaId == null) {
      return _TransitionPage(
        isNext: isNext,
        result: const _ChapterNavNone(),
        currentChapterId: _currentChapterId,
        onLoad: null,
        onBack: () => context.pop(),
      );
    }

    return chaptersAsync.when(
      loading: () =>
          const Center(child: CircularProgressIndicator(color: Colors.white)),
      error: (_, __) => Center(
        child: Text(
          'Could not load chapter list.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
        ),
      ),
      data: (chapters) {
        final result = _getAdjacentChapter(chapters, isNext, preferredLanguage);
        return _TransitionPage(
          isNext: isNext,
          result: result,
          currentChapterId: _currentChapterId,
          allChapters: chapters,
          onLoad: result is _ChapterNavAvailable
              ? () => _loadChapter(result.chapter.id)
              : null,
          onBack: () => context.pop(),
        );
      },
    );
  }
}

// ── Chapter navigation result ─────────────────────────────────────────────────

sealed class _ChapterNavResult {
  const _ChapterNavResult();
}

class _ChapterNavAvailable extends _ChapterNavResult {
  const _ChapterNavAvailable(this.chapter);
  final Chapter chapter;
}

class _ChapterNavLangUnavailable extends _ChapterNavResult {
  const _ChapterNavLangUnavailable();
}

class _ChapterNavNone extends _ChapterNavResult {
  const _ChapterNavNone();
}

// ── Transition page ───────────────────────────────────────────────────────────

class _TransitionPage extends StatelessWidget {
  const _TransitionPage({
    required this.isNext,
    required this.result,
    required this.currentChapterId,
    this.allChapters = const [],
    this.onLoad,
    this.onBack,
  });

  final bool isNext;
  final _ChapterNavResult result;
  final String currentChapterId;
  final List<Chapter> allChapters;
  final VoidCallback? onLoad;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final currentChapter =
        allChapters.where((c) => c.id == currentChapterId).firstOrNull;
    final numDisplay = currentChapter?.attributes.chapterNumber != null
        ? 'Ch. ${currentChapter!.attributes.chapterNumber}'
        : 'This chapter';

    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Center(
          child: switch (result) {
            _ChapterNavAvailable(:final chapter) => _AvailableTransition(
                isNext: isNext,
                currentNumDisplay: numDisplay,
                adjacentChapter: chapter,
                onLoad: onLoad!,
              ),
            _ChapterNavLangUnavailable() => _LangUnavailablePage(
                onBack: onBack ?? () {},
              ),
            _ChapterNavNone() =>
              _EndPage(isNext: isNext, onBack: onBack ?? () {}),
          },
        ),
      ),
    );
  }
}

class _AvailableTransition extends StatelessWidget {
  const _AvailableTransition({
    required this.isNext,
    required this.currentNumDisplay,
    required this.adjacentChapter,
    required this.onLoad,
  });

  final bool isNext;
  final String currentNumDisplay;
  final Chapter adjacentChapter;
  final VoidCallback onLoad;

  @override
  Widget build(BuildContext context) {
    final nextNum = adjacentChapter.attributes.chapterNumber;
    final nextDisplay = nextNum != null ? 'Ch. $nextNum' : 'Oneshot';
    final nextTitle = adjacentChapter.attributes.title;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isNext
                ? 'Finished $currentNumDisplay'
                : 'Start of $currentNumDisplay',
            style: const TextStyle(color: Colors.white54, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          const Divider(color: Colors.white24),
          const SizedBox(height: 32),
          Text(
            isNext ? 'Up next' : 'Previous chapter',
            style: const TextStyle(color: Colors.white54, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Text(
            nextDisplay,
            style: const TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          if (nextTitle != null && nextTitle.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              nextTitle,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 40),
          FilledButton.icon(
            icon: Icon(isNext ? Icons.arrow_forward : Icons.arrow_back),
            label: Text(isNext ? 'Start Reading' : 'Go to Previous'),
            onPressed: onLoad,
          ),
        ],
      ),
    );
  }
}

class _LangUnavailablePage extends StatelessWidget {
  const _LangUnavailablePage({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.language, size: 56, color: Colors.white54),
          const SizedBox(height: 24),
          const Text(
            'Not available in your language',
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'The next chapter has not been translated\ninto your preferred language.',
            style: TextStyle(color: Colors.white70, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          OutlinedButton.icon(
            icon: const Icon(Icons.list, color: Colors.white70),
            label: const Text('Back to Chapter List',
                style: TextStyle(color: Colors.white70)),
            onPressed: onBack,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white24),
            ),
          ),
        ],
      ),
    );
  }
}

class _EndPage extends StatelessWidget {
  const _EndPage({required this.isNext, required this.onBack});

  final bool isNext;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.menu_book_outlined, size: 56, color: Colors.white54),
          const SizedBox(height: 24),
          Text(
            isNext ? "You've reached the end!" : 'This is the first chapter.',
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            isNext
                ? 'No more chapters are available.'
                : 'There are no previous chapters.',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          OutlinedButton.icon(
            icon: const Icon(Icons.arrow_back, color: Colors.white70),
            label: const Text('Back to Chapter List',
                style: TextStyle(color: Colors.white70)),
            onPressed: onBack,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white24),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Utility ───────────────────────────────────────────────────────────────────

/// Comparator for chapter number strings. Null (oneshot) sorts before any
/// numbered chapter. Numeric strings compare numerically; others compare
/// lexicographically.
int _compareChapterNums(String? a, String? b) {
  if (a == null && b == null) return 0;
  if (a == null) return -1;
  if (b == null) return 1;
  final aNum = double.tryParse(a);
  final bNum = double.tryParse(b);
  if (aNum != null && bNum != null) return aNum.compareTo(bNum);
  return a.compareTo(b);
}
