import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'settings_provider.dart';

part 'reader_provider.g.dart';

/// Current image quality mode, derived from the user's settings.
/// Returns 'data' (full resolution) or 'data-saver' (compressed).
@riverpod
String imageQuality(Ref ref) {
  return ref.watch(settingsNotifierProvider).imageQuality;
}

/// Reading mode for a specific manga — 'paged' or 'scroll'.
/// Vertical scroll mode is implemented in Feature 7; this always returns
/// 'paged' until then. The provider is parameterised per-manga now so
/// Feature 7 can persist per-manga preferences without an API change.
@riverpod
String readerMode(Ref ref, String mangaId) {
  return 'paged';
}
