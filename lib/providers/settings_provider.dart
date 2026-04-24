import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_provider.g.dart';

class Settings {
  const Settings({
    this.preferredLanguage = 'en',
    this.contentRating = const ['safe', 'suggestive'],
  });

  final String preferredLanguage;

  /// Content rating filters used for manga search (expanded in Feature 3).
  final List<String> contentRating;

  Settings copyWith({String? preferredLanguage, List<String>? contentRating}) {
    return Settings(
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      contentRating: contentRating ?? this.contentRating,
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
}
