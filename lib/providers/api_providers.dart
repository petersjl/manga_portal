import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/chapter.dart';
import '../models/chapter_pages.dart';
import '../models/manga.dart';
import '../services/mangadex_api.dart';

part 'api_providers.g.dart';

@riverpod
MangaDexApiService mangaDexApiService(Ref ref) {
  // MOCK_BASE_URL is injected via --dart-define by run_integration_tests.dart.
  // Empty string (the default) means use the real MangaDex API.
  const mockBaseUrl = String.fromEnvironment('MOCK_BASE_URL');
  return MangaDexApiService(
    baseUrl: mockBaseUrl.isEmpty ? null : mockBaseUrl,
  );
}

@riverpod
Future<AtHomeServer> atHomeServer(Ref ref, String chapterId) {
  return ref.watch(mangaDexApiServiceProvider).fetchAtHomeServer(chapterId);
}

@riverpod
Future<Manga> manga(Ref ref, String mangaId) {
  return ref.watch(mangaDexApiServiceProvider).fetchManga(mangaId);
}

/// Fetches all chapters for [mangaId], paginating internally (max 500/request).
/// Chapters are returned in API order (ascending by chapter number).
@riverpod
Future<List<Chapter>> chapterFeed(Ref ref, String mangaId) async {
  final service = ref.watch(mangaDexApiServiceProvider);
  final allChapters = <Chapter>[];
  var offset = 0;

  while (true) {
    final batch = await service.fetchChapterFeed(mangaId, offset: offset);
    allChapters.addAll(batch);
    if (batch.length < 500) break; // Received last page.
    offset += batch.length;
    if (offset >= 9500)
      break; // Stay within API limit (offset + limit ≤ 10000).
  }

  return allChapters;
}
