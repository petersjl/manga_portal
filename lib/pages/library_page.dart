import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// TODO(feature-2): Replace with real manga library grid.
// Hardcoded chapter ID used for Feature 1 steel thread verification.
// Chapter 28 of "Precious Family" (safe, EN, 21 pages) — fetched 2026-04-23.
const _hardcodedChapterId = 'b72b1477-ba35-4115-afd7-09e83240048d';

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
            onPressed: () => context.push('/reader/$_hardcodedChapterId'),
            icon: const Icon(Icons.menu_book),
            label: const Text('Open Reader (test)'),
          ),
        ],
      ),
    );
  }
}
