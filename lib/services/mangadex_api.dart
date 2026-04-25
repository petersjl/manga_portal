import 'package:dio/dio.dart';

import '../models/chapter.dart';
import '../models/chapter_pages.dart';
import '../models/manga.dart';

class MangaDexApiService {
  MangaDexApiService({String? baseUrl})
      : _dio = _buildDio(baseUrl ?? 'https://api.mangadex.org');

  final Dio _dio;

  static Dio _buildDio(String baseUrl) {
    final dio = Dio(BaseOptions(baseUrl: baseUrl));
    dio.interceptors.add(_UserAgentInterceptor());
    return dio;
  }

  Future<AtHomeServer> fetchAtHomeServer(String chapterId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/at-home/server/$chapterId',
    );
    return AtHomeServer.fromJson(response.data!);
  }

  Future<Manga> fetchManga(String mangaId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/manga/$mangaId',
      queryParameters: {'includes[]': 'cover_art'},
    );
    return Manga.fromJson(response.data!);
  }

  /// Fetches one page of the chapter feed (up to 500 chapters).
  /// Pass [offset] for subsequent pages. The provider handles pagination.
  Future<List<Chapter>> fetchChapterFeed(
    String mangaId, {
    int offset = 0,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/manga/$mangaId/feed',
      queryParameters: {
        'includes[]': 'scanlation_group',
        'order[chapter]': 'asc',
        'limit': 500,
        'offset': offset,
      },
    );
    final data = response.data!;
    return (data['data'] as List)
        .map((e) => Chapter.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Searches manga by title. Returns up to [limit] results at [offset].
  Future<List<Manga>> searchManga(
    String query, {
    int offset = 0,
    int limit = 20,
    List<String> contentRating = const ['safe', 'suggestive'],
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/manga',
      queryParameters: {
        'title': query,
        'includes[]': 'cover_art',
        'limit': limit,
        'offset': offset,
        'contentRating[]': contentRating,
      },
    );
    final data = response.data!;
    return (data['data'] as List)
        .map((e) => Manga.fromListItem(e as Map<String, dynamic>))
        .toList();
  }

  /// Reports an image load outcome to the MangaDex@Home network.
  /// Only called when the [imageBaseUrl] does NOT contain 'mangadex.org'.
  Future<void> reportImageLoad({
    required String url,
    required bool success,
    required int bytes,
    required int duration,
    required bool cached,
  }) async {
    try {
      // Note: report endpoint is on api.mangadex.network, not api.mangadex.org.
      // Use a plain Dio instance (no auth headers) for this call.
      await Dio().post<void>(
        'https://api.mangadex.network/report',
        data: {
          'url': url,
          'success': success,
          'bytes': bytes,
          'duration': duration,
          'cached': cached,
        },
      );
    } catch (_) {
      // Reporting failures are non-fatal — do not propagate.
    }
  }
}

class _UserAgentInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['User-Agent'] = 'manga-portal/1.0';
    handler.next(options);
  }
}
