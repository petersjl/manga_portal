import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../database/app_database.dart';

/// One-shot migration helper from legacy SharedPreferences storage to Drift.
///
/// This is intentionally idempotent: once migration succeeds it sets a marker
/// key and future runs become a no-op.
class StorageMigrationService {
  StorageMigrationService(this._db, this._prefs);

  final AppDatabase _db;
  final SharedPreferences _prefs;

  static const _migrationDoneKey = 'db_migration_v1_done';

  Future<void> migrateIfNeeded() async {
    if (_prefs.getBool(_migrationDoneKey) == true) return;

    // Settings
    final lang = _prefs.getString('settings_language');
    final maxRating = _prefs.getString('settings_max_content_rating');
    final quality = _prefs.getString('settings_image_quality');
    final theme = _prefs.getString('settings_theme_mode');

    if (lang != null) await _db.upsertSetting('settings_language', lang);
    if (maxRating != null) {
      await _db.upsertSetting('settings_max_content_rating', maxRating);
    }
    if (quality != null) {
      await _db.upsertSetting('settings_image_quality', quality);
    }
    if (theme != null) await _db.upsertSetting('settings_theme_mode', theme);

    // Library
    final rawLibrary = _prefs.getStringList('library_entries') ?? const [];
    for (final encoded in rawLibrary) {
      try {
        final json = jsonDecode(encoded) as Map<String, dynamic>;
        final id = json['id'] as String?;
        final title = json['title'] as String?;
        if (id == null || title == null) continue;
        await _db.upsertLibraryEntry(
          mangaId: id,
          title: title,
          coverFileName: json['coverFileName'] as String?,
        );
      } catch (_) {
        // Ignore malformed records.
      }
    }

    // Reading progress and chapter status.
    for (final key in _prefs.getKeys()) {
      if (key.startsWith('progress_') && key.endsWith('_chapter')) {
        final mangaId =
            key.substring('progress_'.length, key.length - '_chapter'.length);
        final chapterId = _prefs.getString(key);
        if (chapterId == null) continue;
        final page = _prefs.getInt('progress_${mangaId}_page') ?? 0;
        await _db.saveProgress(mangaId, chapterId, page);
      } else if (key.startsWith('read_chapters_')) {
        final mangaId = key.substring('read_chapters_'.length);
        final read = _prefs.getStringList(key) ?? const [];
        for (final chapterId in read) {
          await _db.markChapterRead(mangaId, chapterId);
        }
      } else if (key.startsWith('reading_mode_')) {
        final mangaId = key.substring('reading_mode_'.length);
        final mode = _prefs.getString(key);
        if (mode == null) continue;
        final migratedMode = mode == 'paged' ? 'ltr' : mode;
        await _db.saveReadingMode(mangaId, migratedMode);
      }
    }

    await _prefs.setBool(_migrationDoneKey, true);
  }
}
