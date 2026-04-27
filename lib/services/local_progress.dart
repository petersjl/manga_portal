import 'dart:async';

import '../database/app_database.dart';

/// Persists and retrieves per-manga reading progress.
///
/// Backed by [AppDatabase], with an in-memory cache to preserve the existing
/// synchronous read API used by providers/widgets.
class LocalProgressService {
  LocalProgressService._(
    this._db,
    this._progressByManga,
    this._readByManga,
    this._modeByManga,
  );

  final AppDatabase _db;

  final Map<String, ({String? chapterId, int pageIndex})> _progressByManga;
  final Map<String, Set<String>> _readByManga;
  final Map<String, String> _modeByManga;

  static Future<LocalProgressService> create(AppDatabase db) async {
    final progressRows = await db.allProgressRows();
    final readRows = await db.allReadChaptersRows();
    final modeRows = await db.allReadingModesRows();

    final progress = <String, ({String? chapterId, int pageIndex})>{
      for (final row in progressRows)
        row.mangaId: (chapterId: row.chapterId, pageIndex: row.pageIndex),
    };

    final read = <String, Set<String>>{};
    for (final row in readRows) {
      (read[row.mangaId] ??= <String>{}).add(row.chapterId);
    }

    final modes = <String, String>{
      for (final row in modeRows)
        row.mangaId: (row.mode == 'paged') ? 'ltr' : row.mode,
    };

    return LocalProgressService._(db, progress, read, modes);
  }

  /// Saves the current reading position for [mangaId].
  void saveProgress(String mangaId, String chapterId, int pageIndex) {
    _progressByManga[mangaId] = (chapterId: chapterId, pageIndex: pageIndex);
    unawaited(_db.saveProgress(mangaId, chapterId, pageIndex));
  }

  /// Returns the saved reading position for [mangaId].
  /// Returns `(chapterId: null, pageIndex: 0)` if nothing has been saved.
  ({String? chapterId, int pageIndex}) getProgress(String mangaId) {
    return _progressByManga[mangaId] ?? (chapterId: null, pageIndex: 0);
  }

  /// Records [chapterId] as fully read for [mangaId].
  /// Safe to call multiple times for the same chapter.
  void markChapterRead(String mangaId, String chapterId) {
    final read = (_readByManga[mangaId] ??= <String>{});
    if (read.add(chapterId)) {
      unawaited(_db.markChapterRead(mangaId, chapterId));
    }
  }

  /// Returns the set of chapter IDs the user has explicitly completed for
  /// [mangaId]. An empty set means no chapters have been fully read yet.
  Set<String> getReadChapterIds(String mangaId) {
    return {...(_readByManga[mangaId] ?? const <String>{})};
  }

  /// Saves the preferred reading mode for [mangaId].
  /// [mode] must be one of: 'ltr', 'rtl', or 'scroll'.
  void saveReadingMode(String mangaId, String mode) {
    _modeByManga[mangaId] = mode;
    unawaited(_db.saveReadingMode(mangaId, mode));
  }

  /// Returns the saved reading mode for [mangaId], defaulting to 'ltr'.
  ///
  /// Also migrates legacy values:
  ///   'paged' -> 'ltr'
  String getReadingMode(String mangaId) {
    final mode = _modeByManga[mangaId];
    if (mode == 'paged') return 'ltr';
    if (mode == 'ltr' || mode == 'rtl' || mode == 'scroll') return mode!;
    return 'ltr';
  }

  /// Removes all reading progress and read-chapter history from the device.
  /// Reading modes are intentionally preserved (they are a preference, not history).
  Future<void> clearAllProgress() async {
    _progressByManga.clear();
    _readByManga.clear();
    await _db.clearProgressData();
  }
}
