import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_provider.g.dart';

class Settings {
  const Settings({
    this.preferredLanguage = 'en',
    this.contentRating = const ['safe', 'suggestive'],
    this.imageQuality = 'data',
  });

  final String preferredLanguage;

  /// Content rating filters used for manga search.
  final List<String> contentRating;

  /// Image quality: 'data' (full resolution) or 'data-saver' (compressed).
  final String imageQuality;

  Settings copyWith({
    String? preferredLanguage,
    List<String>? contentRating,
    String? imageQuality,
  }) {
    return Settings(
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      contentRating: contentRating ?? this.contentRating,
      imageQuality: imageQuality ?? this.imageQuality,
    );
  }
}

@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  @override
  Settings build() => const Settings();

  void setPreferredLanguage(String language) {
    state = state.copyWith(preferredLanguage: language);
  }

  /// Sets image quality to 'data' or 'data-saver'.
  void setImageQuality(String quality) {
    assert(quality == 'data' || quality == 'data-saver');
    state = state.copyWith(imageQuality: quality);
  }
}
