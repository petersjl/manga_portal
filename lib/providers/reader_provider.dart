import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'api_providers.dart';
import 'settings_provider.dart';

part 'reader_provider.g.dart';

/// Current image quality mode, derived from the user's settings.
/// Returns 'data' (full resolution) or 'data-saver' (compressed).
@riverpod
String imageQuality(Ref ref) {
  return ref.watch(settingsNotifierProvider).imageQuality;
}

/// Persists and exposes the reading mode ('paged' or 'scroll') for a specific
/// manga. Defaults to 'paged' on first use. Persisted to LocalProgressService
/// so the preference survives app restarts.
@riverpod
class ReadingModeNotifier extends _$ReadingModeNotifier {
  @override
  String build(String mangaId) {
    // Load persisted mode asynchronously and update state when ready.
    ref.read(localProgressServiceProvider.future).then((service) {
      try {
        final mode = service.getReadingMode(mangaId);
        if (mode != state) state = mode;
      } catch (_) {
        // Provider disposed before load completed — ignore.
      }
    });
    return 'paged';
  }

  /// Persists and applies [mode] ('paged' or 'scroll').
  Future<void> setMode(String mode) async {
    assert(mode == 'paged' || mode == 'scroll');
    state = mode;
    final service = await ref.read(localProgressServiceProvider.future);
    service.saveReadingMode(mangaId, mode);
  }

  /// Toggles between 'paged' and 'scroll'.
  Future<void> toggle() => setMode(state == 'paged' ? 'scroll' : 'paged');
}
