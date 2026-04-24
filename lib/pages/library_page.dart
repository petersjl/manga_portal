import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// TODO(feature-5): Replace with real manga library grid.
// Hardcoded manga ID used for Feature 2 steel thread verification.
// "Dungeon Meshi" (Delicious in Dungeon) — popular, safe, many chapters.
const _hardcodedMangaId = 'a96676e5-8ae2-425e-b549-7f15dd34a6d8';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Library',
            style: TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => context.push('/manga/$_hardcodedMangaId'),
            icon: const Icon(Icons.menu_book),
            label: const Text('Open Manga Detail (test)'),
          ),
        ],
      ),
    );
  }
}
