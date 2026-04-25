import 'package:shared_preferences/shared_preferences.dart';

/// Persists and retrieves per-manga reading progress.
///
/// Storage keys (per [mangaId]):
///   `progress_{mangaId}_chapter` → chapter ID string
///   `progress_{mangaId}_page`    → 0-based page index
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
}
