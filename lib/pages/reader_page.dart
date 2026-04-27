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

  // True once the user has scrolled past the first page in the current chapter
  // load. Prevents opening a chapter from immediately writing it as the
  // in-progress chapter before the user has read anything.
  bool _hasUserPaged = false;

  // Allows only one at-home server refresh per chapter load to prevent an
  // infinite failure → invalidate loop when images are consistently unavailable.
  bool _serverRefreshUsed = false;

  // Keeps the last known server so the PageView stays visible during a
  // brief at-home refresh (prevents scroll-position reset on reload).
  AtHomeServer? _lastServer;

  // ── Scroll mode (vertical / webtoon) ──────────────────────────────────────

  // ScrollController for vertical scroll mode.
  ScrollController _scrollController = ScrollController();

  // Set to true once the chapter has been marked as fully read in scroll mode.
  bool _scrollModeChapterRead = false;

  // Whether the top/bottom info bars are currently visible.
  bool _barsVisible = false;

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _currentChapterId = widget.chapterId;
    _scrollController.addListener(_onScrollChanged);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  // ── Chapter loading ────────────────────────────────────────────────────────

  void _loadChapter(
    String newChapterId, {
    int initialMangaPage = 0,
    bool fromTransition = false,
  }) {
    _loadGeneration++;
    _pageController.dispose();
    _pageController = PageController(initialPage: 1 + initialMangaPage);
    // Reset scroll controller for scroll mode chapter transitions.
    _scrollController.removeListener(_onScrollChanged);
    _scrollController.dispose();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScrollChanged);
    _scrollModeChapterRead = false;
    // Pressing a transition button is an explicit intent to start reading the
    // new chapter, so immediately record it as in-progress without waiting for
    // the user to swipe past page 0.
    if (fromTransition) _saveProgressFor(newChapterId, initialMangaPage);
    setState(() {
      _currentChapterId = newChapterId;
      _currentMangaPage = initialMangaPage;
      _isOnTransitionPage = false;
      _initialPreloadDone = false;
      _serverRefreshUsed = false;
      _hasUserPaged = fromTransition; // already counts as having paged
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

  void _saveProgressFor(String chapterId, int pageIndex) {
    if (widget.mangaId == null) return;
    ref.read(localProgressServiceProvider.future).then((service) {
      if (mounted) {
        service.saveProgress(widget.mangaId!, chapterId, pageIndex);
      }
    });
  }

  void _saveProgress(int pageIndex) =>
      _saveProgressFor(_currentChapterId, pageIndex);

  void _markCurrentChapterRead() {
    if (widget.mangaId == null) return;
    ref.read(localProgressServiceProvider.future).then((service) {
      if (mounted) {
        service.markChapterRead(widget.mangaId!, _currentChapterId);
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
        _barsVisible = false;
      });
      // Only record progress once the user has moved past the first page.
      // This prevents opening a chapter (which parks at page 0) from
      // immediately overwriting the tracked in-progress chapter.
      if (mangaPage > 0) _hasUserPaged = true;
      if (_hasUserPaged) _saveProgress(mangaPage);
      _startPreload(mangaPage, server);
    } else {
      setState(() {
        _isOnTransitionPage = true;
        _barsVisible = false;
      });
      // User swiped past the last page — chapter is complete.
      if (viewIndex == pages.length + 1) _markCurrentChapterRead();
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

  // ── Scroll mode progress tracking ──────────────────────────────────────────

  void _onScrollChanged() {
    if (!_scrollController.hasClients) return;

    // Hide bars whenever the user scrolls.
    if (_barsVisible) setState(() => _barsVisible = false);

    final maxExtent = _scrollController.position.maxScrollExtent;
    if (maxExtent <= 0) return;

    final server = _lastServer;
    if (server == null) return;
    final dataSaver = ref.read(imageQualityProvider) == 'data-saver';
    final pages = dataSaver ? server.chapter.dataSaver : server.chapter.data;
    if (pages.isEmpty) return;

    final fraction = _scrollController.offset / maxExtent;
    final estimatedPage =
        (fraction * (pages.length - 1)).round().clamp(0, pages.length - 1);

    if (estimatedPage != _currentMangaPage) {
      setState(() => _currentMangaPage = estimatedPage);
      if (estimatedPage > 0) _hasUserPaged = true;
      if (_hasUserPaged) _saveProgress(estimatedPage);
    }

    // Mark chapter as read when the user has scrolled through ~95% of it.
    if (!_scrollModeChapterRead && fraction >= 0.95) {
      _scrollModeChapterRead = true;
      _markCurrentChapterRead();
    }
  }

  void _onImageLoadFailure() {
    // Allow only one server refresh per chapter load to avoid an infinite
    // failure→invalidate loop (e.g. in tests or when the CDN node is down).
    if (_serverRefreshUsed) return;
    _serverRefreshUsed = true;
    ref.invalidate(atHomeServerProvider(_currentChapterId));
  }

  // ── Bar visibility ──────────────────────────────────────────────────────────

  void _toggleBars() => setState(() => _barsVisible = !_barsVisible);

  // ── Chapter navigation helpers ─────────────────────────────────────────────

  void _navigateAdjacentChapter(
    bool next,
    List<Chapter> allChapters,
    String preferredLanguage,
  ) {
    final result = _getAdjacentChapter(allChapters, next, preferredLanguage);
    if (result is _ChapterNavAvailable) {
      _loadChapter(result.chapter.id, fromTransition: true);
    }
  }

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

  // ── Settings sheet ─────────────────────────────────────────────────────────

  void _openSettingsSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) {
        return Consumer(
          builder: (ctx, ref, _) {
            final mangaId = widget.mangaId;
            final mode = mangaId != null
                ? ref.watch(readingModeNotifierProvider(mangaId))
                : 'paged';
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reader settings',
                      style: Theme.of(ctx).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          'Reading mode',
                          style: Theme.of(ctx).textTheme.bodyMedium,
                        ),
                        const Spacer(),
                        SegmentedButton<String>(
                          segments: const [
                            ButtonSegment(
                              value: 'paged',
                              icon: Icon(Icons.auto_stories, size: 18),
                              label: Text('Paged'),
                            ),
                            ButtonSegment(
                              value: 'scroll',
                              icon: Icon(Icons.view_agenda, size: 18),
                              label: Text('Scroll'),
                            ),
                          ],
                          selected: {mode},
                          onSelectionChanged: mangaId != null
                              ? (s) => ref
                                  .read(readingModeNotifierProvider(mangaId)
                                      .notifier)
                                  .setMode(s.first)
                              : null,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ── Info bars ──────────────────────────────────────────────────────────────

  Widget _buildTopBar(BuildContext context, Chapter? currentChapter) {
    final chapterNum = currentChapter?.attributes.chapterNumber;
    final chapterTitle = currentChapter?.attributes.title;
    final String titleText;
    if (chapterNum != null && chapterTitle != null && chapterTitle.isNotEmpty) {
      titleText = 'Ch. $chapterNum: $chapterTitle';
    } else if (chapterNum != null) {
      titleText = 'Chapter $chapterNum';
    } else {
      titleText = 'Oneshot';
    }

    return Container(
      color: Colors.black87,
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              tooltip: 'Back',
              onPressed: () => context.pop(),
            ),
            Expanded(
              child: Text(
                titleText,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              tooltip: 'Reader settings',
              onPressed: () => _openSettingsSheet(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(
    BuildContext context,
    int totalPages,
    AsyncValue<List<Chapter>> chaptersAsync,
    Settings settings,
  ) {
    final chapters = chaptersAsync.valueOrNull ?? [];
    final preferredLanguage = settings.preferredLanguage;

    VoidCallback? onPrev;
    VoidCallback? onNext;
    if (chapters.isNotEmpty) {
      final prevResult =
          _getAdjacentChapter(chapters, false, preferredLanguage);
      final nextResult = _getAdjacentChapter(chapters, true, preferredLanguage);
      onPrev = prevResult is _ChapterNavAvailable
          ? () => _navigateAdjacentChapter(false, chapters, preferredLanguage)
          : null;
      onNext = nextResult is _ChapterNavAvailable
          ? () => _navigateAdjacentChapter(true, chapters, preferredLanguage)
          : null;
    }

    final pageText = (_isOnTransitionPage || totalPages == 0)
        ? '–'
        : '${_currentMangaPage + 1} / $totalPages';

    return Container(
      color: Colors.black87,
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            TextButton(
              onPressed: onPrev,
              child: Text(
                'Prev',
                style: TextStyle(
                  color: onPrev != null ? Colors.white : Colors.white38,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  pageText,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),
            TextButton(
              onPressed: onNext,
              child: Text(
                'Next',
                style: TextStyle(
                  color: onNext != null ? Colors.white : Colors.white38,
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

    // Read the per-manga reading mode; fall back to 'paged' when no mangaId.
    final readingMode = widget.mangaId != null
        ? ref.watch(readingModeNotifierProvider(widget.mangaId!))
        : 'paged';
    final isScrollMode = readingMode == 'scroll';

    // Chapter title for the top bar.
    final currentChapter = chaptersAsync.valueOrNull
        ?.where((c) => c.id == _currentChapterId)
        .firstOrNull;

    // Total pages from the live or last-known server.
    final effectiveServer = serverAsync.valueOrNull ?? _lastServer;
    final totalPages = effectiveServer != null
        ? (dataSaver
                ? effectiveServer.chapter.dataSaver
                : effectiveServer.chapter.data)
            .length
        : 0;

    // Reader content (PageView / ListView / loading / error).
    final Widget readerContent = serverAsync.when(
      loading: () {
        // Keep the reader content visible during a server URL refresh so the
        // scroll/page position isn't lost. Only show the spinner on first load.
        if (_lastServer case final server?) {
          return isScrollMode
              ? _buildScrollContent(server, dataSaver, chaptersAsync, settings)
              : _buildPageViewContent(
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
        return isScrollMode
            ? _buildScrollContent(server, dataSaver, chaptersAsync, settings)
            : _buildPageViewContent(server, dataSaver, chaptersAsync, settings);
      },
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Content layer (PageView / ListView / loading / error).
          readerContent,
          // ── Top bar ────────────────────────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              ignoring: !_barsVisible,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, -1),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOut,
                    )),
                    child: child,
                  ),
                ),
                child: _barsVisible
                    ? SizedBox(
                        key: const ValueKey('topBar'),
                        child: _buildTopBar(context, currentChapter),
                      )
                    : const SizedBox.shrink(key: ValueKey('topBarEmpty')),
              ),
            ),
          ),
          // ── Bottom bar ─────────────────────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              ignoring: !_barsVisible,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 1),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOut,
                    )),
                    child: child,
                  ),
                ),
                child: _barsVisible
                    ? SizedBox(
                        key: const ValueKey('bottomBar'),
                        child: _buildBottomBar(
                          context,
                          totalPages,
                          chaptersAsync,
                          settings,
                        ),
                      )
                    : const SizedBox.shrink(key: ValueKey('bottomBarEmpty')),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Scroll (webtoon) mode ──────────────────────────────────────────────────

  Widget _buildScrollContent(
    AtHomeServer server,
    bool dataSaver,
    AsyncValue<List<Chapter>> chaptersAsync,
    Settings settings,
  ) {
    final pages = dataSaver ? server.chapter.dataSaver : server.chapter.data;

    // Once per chapter load: kick off background preloading from page 0.
    if (!_initialPreloadDone) {
      _initialPreloadDone = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _startPreload(0, server);
      });
    }

    return ListView.builder(
      controller: _scrollController,
      // Preload 4 screen-heights worth of content so the user never sees a
      // loading spinner during normal scroll speed.
      cacheExtent: MediaQuery.of(context).size.height * 4,
      itemCount: pages.length + 1, // +1 for the end-of-chapter footer
      itemBuilder: (context, index) {
        if (index < pages.length) {
          return ReaderPageImage(
            key: ValueKey('${_currentChapterId}_scroll_$index'),
            url: server.pageUrl(pages[index], dataSaver: dataSaver),
            isThirdParty: server.isThirdParty,
            apiService: ref.read(mangaDexApiServiceProvider),
            onLoadFailure: _onImageLoadFailure,
            onTap: _toggleBars,
          );
        }
        // Footer: end-of-chapter navigation (same content as paged transitions).
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: _buildTransitionSlot(
            isNext: true,
            chaptersAsync: chaptersAsync,
            preferredLanguage: settings.preferredLanguage,
          ),
        );
      },
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
            onTap: _toggleBars,
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
              ? () => _loadChapter(result.chapter.id, fromTransition: true)
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
