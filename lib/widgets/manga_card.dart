import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/manga.dart';

/// A card showing a manga's cover thumbnail and title.
/// Used in the library grid and search results.
class MangaCard extends StatelessWidget {
  const MangaCard({
    super.key,
    required this.manga,
    this.onTap,
  });

  final Manga manga;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final coverUrl = manga.coverUrl(256);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: coverUrl != null
                  ? Image(
                      image: CachedNetworkImageProvider(coverUrl),
                      fit: BoxFit.cover,
                      frameBuilder: (context, child, frame, sync) {
                        if (sync || frame != null) return child;
                        return const ColoredBox(
                          color: Colors.black26,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      },
                      errorBuilder: (_, __, ___) => const _PlaceholderCover(),
                    )
                  : const _PlaceholderCover(),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                manga.attributes.titleFor('en'),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderCover extends StatelessWidget {
  const _PlaceholderCover();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Colors.black26,
      child: Center(child: Icon(Icons.image_not_supported_outlined)),
    );
  }
}
