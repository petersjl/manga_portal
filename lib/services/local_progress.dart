import 'package:shared_preferences/shared_preferences.dart';

/// Persists and retrieves per-manga reading progress.
///
/// Storage keys (per [mangaId]):
///   `progress_{mangaId}_chapter`      → chapter ID string (current position)
///   `progress_{mangaId}_page`         → 0-based page index
///   `read_chapters_{mangaId}`         → list of explicitly-completed chapter IDs
///
/// This service sits behind a clean interface so it can be swapped for a
/// drift/sqflite implementation later without touching providers or UI.
/// SharedPreferences calls must never appear outside this class.
class LocalProgressService {
  const LocalProgressService(this._prefs);

  final SharedPreferences _prefs;

  /// Saves the current reading position for [mangaId].
  void saveProgress(String mangaId, String chapterId, int pageIndex) {
    _prefs.setString('progress_${mangaId}_chapter', chapterId);
    _prefs.setInt('progress_${mangaId}_page', pageIndex);
  }

  /// Returns the saved reading position for [mangaId].
  /// Returns `(chapterId: null, pageIndex: 0)` if nothing has been saved.
  ({String? chapterId, int pageIndex}) getProgress(String mangaId) {
    return (
      chapterId: _prefs.getString('progress_${mangaId}_chapter'),
      pageIndex: _prefs.getInt('progress_${mangaId}_page') ?? 0,
    );
  }

  /// Records [chapterId] as fully read for [mangaId].
  /// Safe to call multiple times for the same chapter.
  void markChapterRead(String mangaId, String chapterId) {
    final key = 'read_chapters_$mangaId';
    final existing = _prefs.getStringList(key) ?? [];
    if (!existing.contains(chapterId)) {
      _prefs.setStringList(key, [...existing, chapterId]);
    }
  }

  /// Returns the set of chapter IDs the user has explicitly completed for
  /// [mangaId]. An empty set means no chapters have been fully read yet.
  Set<String> getReadChapterIds(String mangaId) {
    return (_prefs.getStringList('read_chapters_$mangaId') ?? []).toSet();
  }

  /// Removes all reading progress and read-chapter history from the device.
  Future<void> clearAllProgress() async {
    final keys = _prefs.getKeys().where(
          (k) => k.startsWith('progress_') || k.startsWith('read_chapters_'),
        );
    for (final key in keys) {
      await _prefs.remove(key);
    }
  }
}
