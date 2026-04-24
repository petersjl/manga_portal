import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/chapter_pages.dart';
import '../providers/api_providers.dart';
import '../widgets/reader_page_image.dart';

class ReaderPage extends ConsumerStatefulWidget {
  const ReaderPage({super.key, required this.chapterId});

  final String chapterId;

  @override
  ConsumerState<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends ConsumerState<ReaderPage> {
  int _currentPage = 0;
  final PageController _pageController = PageController();
  // Incremented whenever the current page changes; background preload tasks
  // check this to self-cancel when they are no longer relevant.
  int _loadGeneration = 0;
  bool _initialPreloadDone = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index, AtHomeServer server) {
    setState(() => _currentPage = index);
    _startPreload(index, server);
  }

  /// Fires immediate neighbours concurrently, then loads all remaining pages
  /// in the background, closest-first. A new call cancels any in-flight
  /// background task from a previous call via the generation counter.
  void _startPreload(int index, AtHomeServer server) {
    final gen = ++_loadGeneration;
    final pages = server.chapter.data;

    // Immediate window — fired concurrently so they all start downloading now.
    const immediateAhead = 3;
    const immediateBehind = 1;
    for (var i = index - immediateBehind; i <= index + immediateAhead; i++) {
      if (i < 0 || i >= pages.length || i == index) continue;
      precacheImage(
        CachedNetworkImageProvider(server.pageUrl(pages[i])),
        context,
        onError: (_, __) {},
      );
    }

    // Background — load the rest sequentially, closest pages first.
    // Skips the immediate window since those are already in-flight above.
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
    final pages = server.chapter.data;
    final sorted = List.generate(pages.length, (i) => i)
        .where((i) => i != startIndex && (i < skipStart || i > skipEnd))
        .toList()
      ..sort(
        (a, b) => (a - startIndex).abs().compareTo((b - startIndex).abs()),
      );

    for (final i in sorted) {
      if (_loadGeneration != gen || !mounted) return;
      await precacheImage(
        CachedNetworkImageProvider(server.pageUrl(pages[i])),
        context,
        onError: (_, __) {},
      );
    }
  }

  void _onImageLoadFailure() {
    // Invalidate the provider so a fresh at-home server URL is fetched.
    ref.invalidate(atHomeServerProvider(widget.chapterId));
  }

  @override
  Widget build(BuildContext context) {
    final serverAsync = ref.watch(atHomeServerProvider(widget.chapterId));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: serverAsync.maybeWhen(
          data: (server) {
            final total = server.chapter.data.length;
            return Text('${_currentPage + 1} / $total');
          },
          orElse: () => const SizedBox.shrink(),
        ),
      ),
      body: serverAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
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
                    ref.invalidate(atHomeServerProvider(widget.chapterId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (server) {
          // Kick off preload once when data first arrives.
          if (!_initialPreloadDone) {
            _initialPreloadDone = true;
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => _startPreload(0, server),
            );
          }
          final pages = server.chapter.data;
          return PageView.builder(
            controller: _pageController,
            itemCount: pages.length,
            onPageChanged: (index) => _onPageChanged(index, server),
            itemBuilder: (context, index) {
              return ReaderPageImage(
                key: ValueKey(pages[index]),
                url: server.pageUrl(pages[index]),
                isThirdParty: server.isThirdParty,
                apiService: ref.read(mangaDexApiServiceProvider),
                onLoadFailure: _onImageLoadFailure,
              );
            },
          );
        },
      ),
    );
  }
}
