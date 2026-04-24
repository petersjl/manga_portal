import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/chapter_pages.dart';
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
