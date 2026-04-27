import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class SettingsTable extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

class LibraryEntriesTable extends Table {
  TextColumn get mangaId => text()();
  TextColumn get title => text()();
  TextColumn get coverFileName => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {mangaId};
}

class MangaProgressTable extends Table {
  TextColumn get mangaId => text()();
  TextColumn get chapterId => text().nullable()();
  IntColumn get pageIndex => integer().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {mangaId};
}

class ReadChaptersTable extends Table {
  TextColumn get mangaId => text()();
  TextColumn get chapterId => text()();
  DateTimeColumn get readAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {mangaId, chapterId};
}

class ReadingModesTable extends Table {
  TextColumn get mangaId => text()();
  TextColumn get mode => text()(); // ltr | rtl | scroll
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {mangaId};
}

class MangaTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get coverFileName => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class ChaptersTable extends Table {
  TextColumn get id => text()();
  TextColumn get mangaId => text()();
  TextColumn get chapterNumber => text().nullable()();
  TextColumn get title => text().nullable()();
  TextColumn get language => text().nullable()();
  TextColumn get scanlationGroupId => text().nullable()();
  TextColumn get scanlationGroupName => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class DownloadJobsTable extends Table {
  TextColumn get chapterId => text()();
  TextColumn get mangaId => text()();
  TextColumn get status =>
      text()(); // queued | downloading | completed | failed
  IntColumn get progress => integer().withDefault(const Constant(0))();
  IntColumn get downloadedBytes => integer().withDefault(const Constant(0))();
  IntColumn get totalBytes => integer().nullable()();
  TextColumn get errorMessage => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {chapterId};
}

class DownloadedPagesTable extends Table {
  TextColumn get chapterId => text()();
  IntColumn get pageIndex => integer()();
  TextColumn get localPath => text()();
  IntColumn get sizeBytes => integer().nullable()();
  TextColumn get checksum => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {chapterId, pageIndex};
}

@DriftDatabase(
  tables: [
    SettingsTable,
    LibraryEntriesTable,
    MangaProgressTable,
    ReadChaptersTable,
    ReadingModesTable,
    MangaTable,
    ChaptersTable,
    DownloadJobsTable,
    DownloadedPagesTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Test constructor for in-memory database.
  ///
  /// Each test creates its own isolated in-memory database, so Drift warnings
  /// about multiple database instances can be safely ignored in test contexts.
  AppDatabase.forTesting() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => 1;

  Future<void> upsertSetting(String key, String value) {
    return into(settingsTable).insertOnConflictUpdate(
      SettingsTableCompanion.insert(key: key, value: value),
    );
  }

  Future<String?> getSetting(String key) async {
    final row = await (select(settingsTable)..where((t) => t.key.equals(key)))
        .getSingleOrNull();
    return row?.value;
  }

  Future<void> upsertLibraryEntry({
    required String mangaId,
    required String title,
    String? coverFileName,
  }) {
    return into(libraryEntriesTable).insertOnConflictUpdate(
      LibraryEntriesTableCompanion.insert(
        mangaId: mangaId,
        title: title,
        coverFileName: Value(coverFileName),
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<List<LibraryEntriesTableData>> allLibraryEntries() {
    return (select(libraryEntriesTable)
          ..orderBy([
            (t) => OrderingTerm.desc(t.updatedAt),
          ]))
        .get();
  }

  Future<void> removeLibraryEntry(String mangaId) {
    return (delete(libraryEntriesTable)
          ..where((t) => t.mangaId.equals(mangaId)))
        .go();
  }

  Future<void> saveProgress(
      String mangaId, String chapterId, int pageIndex) async {
    await into(mangaProgressTable).insertOnConflictUpdate(
      MangaProgressTableCompanion.insert(
        mangaId: mangaId,
        chapterId: Value(chapterId),
        pageIndex: Value(pageIndex),
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<({String? chapterId, int pageIndex})> getProgress(
      String mangaId) async {
    final row = await (select(mangaProgressTable)
          ..where((t) => t.mangaId.equals(mangaId)))
        .getSingleOrNull();
    return (chapterId: row?.chapterId, pageIndex: row?.pageIndex ?? 0);
  }

  Future<List<MangaProgressTableData>> allProgressRows() {
    return select(mangaProgressTable).get();
  }

  Future<void> markChapterRead(String mangaId, String chapterId) {
    return into(readChaptersTable).insertOnConflictUpdate(
      ReadChaptersTableCompanion.insert(
        mangaId: mangaId,
        chapterId: chapterId,
        readAt: DateTime.now(),
      ),
    );
  }

  Future<Set<String>> getReadChapterIds(String mangaId) async {
    final rows = await (select(readChaptersTable)
          ..where((t) => t.mangaId.equals(mangaId)))
        .get();
    return rows.map((r) => r.chapterId).toSet();
  }

  Future<List<ReadChaptersTableData>> allReadChaptersRows() {
    return select(readChaptersTable).get();
  }

  Future<void> saveReadingMode(String mangaId, String mode) {
    return into(readingModesTable).insertOnConflictUpdate(
      ReadingModesTableCompanion.insert(
        mangaId: mangaId,
        mode: mode,
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<String> getReadingMode(String mangaId) async {
    final row = await (select(readingModesTable)
          ..where((t) => t.mangaId.equals(mangaId)))
        .getSingleOrNull();
    final mode = row?.mode;
    if (mode == 'paged') return 'ltr';
    if (mode == 'ltr' || mode == 'rtl' || mode == 'scroll') return mode!;
    return 'ltr';
  }

  Future<List<ReadingModesTableData>> allReadingModesRows() {
    return select(readingModesTable).get();
  }

  Future<void> clearProgressData() async {
    await delete(mangaProgressTable).go();
    await delete(readChaptersTable).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'manga_portal.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
