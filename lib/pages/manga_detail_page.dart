import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/chapter.dart';
import '../models/manga.dart';
import '../providers/api_providers.dart';
import '../providers/settings_provider.dart';
import '../widgets/chapter_list_tile.dart';

class MangaDetailPage extends ConsumerWidget {
  const MangaDetailPage({super.key, required this.mangaId});

  final String mangaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mangaAsync = ref.watch(mangaProvider(mangaId));
    final chaptersAsync = ref.watch(chapterFeedProvider(mangaId));
    final settings = ref.watch(settingsNotifierProvider);

    return Scaffold(
      body: mangaAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorBody(
          message: 'Could not load manga.\nPlease check your connection.',
          onRetry: () {
            ref.invalidate(mangaProvider(mangaId));
            ref.invalidate(chapterFeedProvider(mangaId));
          },
        ),
        data: (manga) => CustomScrollView(
          slivers: [
            _MangaAppBar(manga: manga),
            _MangaInfo(manga: manga, locale: settings.preferredLanguage),
            chaptersAsync.when(
              loading: () => const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
              error: (error, _) => SliverToBoxAdapter(
                child: _ErrorBody(
                  message: 'Could not load chapters.',
                  onRetry: () => ref.invalidate(chapterFeedProvider(mangaId)),
                ),
              ),
              data: (chapters) => _ChapterList(
                chapters: chapters,
                preferredLanguage: settings.preferredLanguage,
                onChapterSelected: (chapterId) =>
                    context.push('/reader/$chapterId?mangaId=$mangaId'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── App bar with cover image ─────────────────────────────────────────────────

class _MangaAppBar extends StatelessWidget {
  const _MangaAppBar({required this.manga});

  final Manga manga;

  @override
  Widget build(BuildContext context) {
    final coverUrl = manga.coverUrl(512);

    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: coverUrl != null
            ? Image(
                image: CachedNetworkImageProvider(coverUrl),
                fit: BoxFit.cover,
                frameBuilder: (context, child, frame, sync) =>
                    sync || frame != null ? child : const SizedBox.expand(),
                errorBuilder: (_, __, ___) => const SizedBox.expand(),
              )
            : null,
        title: Text(
          manga.attributes.titleFor('en'),
          style: const TextStyle(shadows: [
            Shadow(color: Colors.black54, blurRadius: 4),
          ]),
        ),
      ),
    );
  }
}

// ── Description section ──────────────────────────────────────────────────────

class _MangaInfo extends StatefulWidget {
  const _MangaInfo({required this.manga, required this.locale});

  final Manga manga;
  final String locale;

  @override
  State<_MangaInfo> createState() => _MangaInfoState();
}

class _MangaInfoState extends State<_MangaInfo> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final description = widget.manga.attributes.descriptionFor(widget.locale);
    final style = Theme.of(context).textTheme.bodyMedium!;
    final lineHeight = (style.fontSize ?? 14) * (style.height ?? 1.43);
    final collapsedHeight = lineHeight * 2;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (description.isNotEmpty) ...[
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => setState(() => _expanded = !_expanded),
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  alignment: Alignment.topCenter,
                  child: _expanded
                      ? MarkdownBody(
                          data: description,
                          styleSheet:
                              MarkdownStyleSheet.fromTheme(Theme.of(context)),
                          shrinkWrap: true,
                        )
                      : SizedBox(
                          height: collapsedHeight,
                          child: ClipRect(
                            child: OverflowBox(
                              alignment: Alignment.topCenter,
                              maxHeight: double.infinity,
                              child: MarkdownBody(
                                data: description,
                                styleSheet: MarkdownStyleSheet.fromTheme(
                                    Theme.of(context)),
                                shrinkWrap: true,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  const Divider(),
                  IconButton(
                    icon: Icon(
                      _expanded ? Icons.expand_less : Icons.expand_more,
                      size: 28,
                    ),
                    onPressed: () => setState(() => _expanded = !_expanded),
                    tooltip: _expanded ? 'Collapse' : 'Expand',
                    style: IconButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Chapter list ─────────────────────────────────────────────────────────────

class _ChapterList extends StatelessWidget {
  const _ChapterList({
    required this.chapters,
    required this.preferredLanguage,
    required this.onChapterSelected,
  });

  final List<Chapter> chapters;
  final String preferredLanguage;
  final void Function(String chapterId) onChapterSelected;

  @override
  Widget build(BuildContext context) {
    if (chapters.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Center(child: Text('No chapters available.')),
        ),
      );
    }

    final groups = _groupAndSort(chapters);

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final entry = groups[index];
          return ChapterListTile(
            key: ValueKey(entry.key),
            chapters: entry.value,
            preferredLanguage: preferredLanguage,
            onChapterSelected: onChapterSelected,
          );
        },
        childCount: groups.length,
      ),
    );
  }

  /// Groups chapters by their chapter number and sorts descending.
  /// Oneshots (null chapter number) sort to the top.
  static List<MapEntry<String?, List<Chapter>>> _groupAndSort(
    List<Chapter> chapters,
  ) {
    final groups = <String?, List<Chapter>>{};
    for (final c in chapters) {
      groups.putIfAbsent(c.attributes.chapterNumber, () => []).add(c);
    }

    final entries = groups.entries.toList()
      ..sort((a, b) {
        if (a.key == null && b.key == null) return 0;
        if (a.key == null) return -1; // Oneshots → top
        if (b.key == null) return 1;
        final aNum = double.tryParse(a.key!);
        final bNum = double.tryParse(b.key!);
        if (aNum != null && bNum != null) return bNum.compareTo(aNum);
        return b.key!.compareTo(a.key!);
      });

    return entries;
  }
}

// ── Shared error widget ───────────────────────────────────────────────────────

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off, size: 48),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          FilledButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
