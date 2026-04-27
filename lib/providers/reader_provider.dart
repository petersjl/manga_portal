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

/// Persists and exposes the reading mode ('ltr', 'rtl', or 'scroll') for a
/// specific manga. Defaults to 'ltr' on first use. Persisted to
/// LocalProgressService
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
    return 'ltr';
  }

  /// Persists and applies [mode] ('ltr', 'rtl', or 'scroll').
  Future<void> setMode(String mode) async {
    assert(mode == 'ltr' || mode == 'rtl' || mode == 'scroll');
    state = mode;
    final service = await ref.read(localProgressServiceProvider.future);
    service.saveReadingMode(mangaId, mode);
  }

  /// Toggles between 'ltr' and 'scroll'.
  Future<void> toggle() => setMode(state == 'scroll' ? 'ltr' : 'scroll');
}
