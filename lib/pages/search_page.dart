import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/api_providers.dart';
import '../widgets/manga_card.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      ref.read(mangaSearchProvider.notifier).search(value);
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 400) {
      ref.read(mangaSearchProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchAsync = ref.watch(mangaSearchProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: SearchBar(
                controller: _controller,
                hintText: 'Search manga…',
                leading: const Icon(Icons.search),
                trailing: [
                  if (_controller.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _controller.clear();
                        ref.read(mangaSearchProvider.notifier).search('');
                      },
                    ),
                ],
                onChanged: _onQueryChanged,
              ),
            ),
            Expanded(
              child: searchAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      'Something went wrong. Please try again.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
                data: (state) {
                  if (state.query.isEmpty) {
                    return const _EmptyPrompt(
                      icon: Icons.search,
                      message: 'Search for a manga title above.',
                    );
                  }
                  if (state.results.isEmpty) {
                    return _EmptyPrompt(
                      icon: Icons.sentiment_dissatisfied,
                      message: 'No results for "${state.query}".',
                    );
                  }
                  return GridView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount:
                        state.results.length + (state.isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= state.results.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      final manga = state.results[index];
                      return MangaCard(
                        manga: manga,
                        onTap: () => context.push('/manga/${manga.id}'),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyPrompt extends StatelessWidget {
  const _EmptyPrompt({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
