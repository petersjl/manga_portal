import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/app_database.dart';
import '../models/chapter.dart';
import '../models/chapter_pages.dart';
import '../models/manga.dart';
import '../services/local_progress.dart';
import '../services/mangadex_api.dart';
import '../services/storage_migration_service.dart';
import 'settings_provider.dart';

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
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}

@riverpod
Future<void> storageMigration(Ref ref) async {
  final prefs = await SharedPreferences.getInstance();
  final db = ref.watch(appDatabaseProvider);
  final migration = StorageMigrationService(db, prefs);
  await migration.migrateIfNeeded();
}

@riverpod
Future<LocalProgressService> localProgressService(Ref ref) async {
  final prefs = await SharedPreferences.getInstance();
  return LocalProgressService(prefs);
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
    if (offset >= 9500) {
      break; // Stay within API limit (offset + limit ≤ 10000).
    }
  }

  return allChapters;
}

/// Search state — holds the query and paginated results.
class MangaSearchState {
  const MangaSearchState({
    this.query = '',
    this.results = const [],
    this.isLoadingMore = false,
    this.hasMore = true,
  });

  final String query;
  final List<Manga> results;
  final bool isLoadingMore;
  final bool hasMore;

  MangaSearchState copyWith({
    String? query,
    List<Manga>? results,
    bool? isLoadingMore,
    bool? hasMore,
  }) =>
      MangaSearchState(
        query: query ?? this.query,
        results: results ?? this.results,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        hasMore: hasMore ?? this.hasMore,
      );
}

@riverpod
class MangaSearch extends _$MangaSearch {
  static const _pageSize = 20;

  @override
  Future<MangaSearchState> build() async => const MangaSearchState();

  Future<void> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      state = const AsyncData(MangaSearchState());
      return;
    }

    state = const AsyncLoading();

    final settings = ref.read(settingsNotifierProvider);
    try {
      final results = await ref.read(mangaDexApiServiceProvider).searchManga(
            trimmed,
            contentRating: settings.contentRating,
          );
      state = AsyncData(MangaSearchState(
        query: trimmed,
        results: results,
        hasMore: results.length == _pageSize,
      ));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || current.isLoadingMore || !current.hasMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));

    final settings = ref.read(settingsNotifierProvider);
    try {
      final more = await ref.read(mangaDexApiServiceProvider).searchManga(
            current.query,
            offset: current.results.length,
            contentRating: settings.contentRating,
          );
      state = AsyncData(current.copyWith(
        results: [...current.results, ...more],
        isLoadingMore: false,
        hasMore: more.length == _pageSize,
      ));
    } catch (_) {
      state = AsyncData(current.copyWith(isLoadingMore: false));
    }
  }
}
