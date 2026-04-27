// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SettingsTableTable extends SettingsTable
    with TableInfo<$SettingsTableTable, SettingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings_table';
  @override
  VerificationContext validateIntegrity(Insertable<SettingsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SettingsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingsTableData(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $SettingsTableTable createAlias(String alias) {
    return $SettingsTableTable(attachedDatabase, alias);
  }
}

class SettingsTableData extends DataClass
    implements Insertable<SettingsTableData> {
  final String key;
  final String value;
  const SettingsTableData({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsTableCompanion toCompanion(bool nullToAbsent) {
    return SettingsTableCompanion(
      key: Value(key),
      value: Value(value),
    );
  }

  factory SettingsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingsTableData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  SettingsTableData copyWith({String? key, String? value}) => SettingsTableData(
        key: key ?? this.key,
        value: value ?? this.value,
      );
  SettingsTableData copyWithCompanion(SettingsTableCompanion data) {
    return SettingsTableData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingsTableData(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingsTableData &&
          other.key == this.key &&
          other.value == this.value);
}

class SettingsTableCompanion extends UpdateCompanion<SettingsTableData> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsTableCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsTableCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        value = Value(value);
  static Insertable<SettingsTableData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsTableCompanion copyWith(
      {Value<String>? key, Value<String>? value, Value<int>? rowid}) {
    return SettingsTableCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsTableCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LibraryEntriesTableTable extends LibraryEntriesTable
    with TableInfo<$LibraryEntriesTableTable, LibraryEntriesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LibraryEntriesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _mangaIdMeta =
      const VerificationMeta('mangaId');
  @override
  late final GeneratedColumn<String> mangaId = GeneratedColumn<String>(
      'manga_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _coverFileNameMeta =
      const VerificationMeta('coverFileName');
  @override
  late final GeneratedColumn<String> coverFileName = GeneratedColumn<String>(
      'cover_file_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [mangaId, title, coverFileName, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'library_entries_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<LibraryEntriesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('manga_id')) {
      context.handle(_mangaIdMeta,
          mangaId.isAcceptableOrUnknown(data['manga_id']!, _mangaIdMeta));
    } else if (isInserting) {
      context.missing(_mangaIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('cover_file_name')) {
      context.handle(
          _coverFileNameMeta,
          coverFileName.isAcceptableOrUnknown(
              data['cover_file_name']!, _coverFileNameMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {mangaId};
  @override
  LibraryEntriesTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LibraryEntriesTableData(
      mangaId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}manga_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      coverFileName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cover_file_name']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $LibraryEntriesTableTable createAlias(String alias) {
    return $LibraryEntriesTableTable(attachedDatabase, alias);
  }
}

class LibraryEntriesTableData extends DataClass
    implements Insertable<LibraryEntriesTableData> {
  final String mangaId;
  final String title;
  final String? coverFileName;
  final DateTime updatedAt;
  const LibraryEntriesTableData(
      {required this.mangaId,
      required this.title,
      this.coverFileName,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['manga_id'] = Variable<String>(mangaId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || coverFileName != null) {
      map['cover_file_name'] = Variable<String>(coverFileName);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LibraryEntriesTableCompanion toCompanion(bool nullToAbsent) {
    return LibraryEntriesTableCompanion(
      mangaId: Value(mangaId),
      title: Value(title),
      coverFileName: coverFileName == null && nullToAbsent
          ? const Value.absent()
          : Value(coverFileName),
      updatedAt: Value(updatedAt),
    );
  }

  factory LibraryEntriesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LibraryEntriesTableData(
      mangaId: serializer.fromJson<String>(json['mangaId']),
      title: serializer.fromJson<String>(json['title']),
      coverFileName: serializer.fromJson<String?>(json['coverFileName']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'mangaId': serializer.toJson<String>(mangaId),
      'title': serializer.toJson<String>(title),
      'coverFileName': serializer.toJson<String?>(coverFileName),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LibraryEntriesTableData copyWith(
          {String? mangaId,
          String? title,
          Value<String?> coverFileName = const Value.absent(),
          DateTime? updatedAt}) =>
      LibraryEntriesTableData(
        mangaId: mangaId ?? this.mangaId,
        title: title ?? this.title,
        coverFileName:
            coverFileName.present ? coverFileName.value : this.coverFileName,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  LibraryEntriesTableData copyWithCompanion(LibraryEntriesTableCompanion data) {
    return LibraryEntriesTableData(
      mangaId: data.mangaId.present ? data.mangaId.value : this.mangaId,
      title: data.title.present ? data.title.value : this.title,
      coverFileName: data.coverFileName.present
          ? data.coverFileName.value
          : this.coverFileName,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LibraryEntriesTableData(')
          ..write('mangaId: $mangaId, ')
          ..write('title: $title, ')
          ..write('coverFileName: $coverFileName, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(mangaId, title, coverFileName, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LibraryEntriesTableData &&
          other.mangaId == this.mangaId &&
          other.title == this.title &&
          other.coverFileName == this.coverFileName &&
          other.updatedAt == this.updatedAt);
}

class LibraryEntriesTableCompanion
    extends UpdateCompanion<LibraryEntriesTableData> {
  final Value<String> mangaId;
  final Value<String> title;
  final Value<String?> coverFileName;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LibraryEntriesTableCompanion({
    this.mangaId = const Value.absent(),
    this.title = const Value.absent(),
    this.coverFileName = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LibraryEntriesTableCompanion.insert({
    required String mangaId,
    required String title,
    this.coverFileName = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : mangaId = Value(mangaId),
        title = Value(title),
        updatedAt = Value(updatedAt);
  static Insertable<LibraryEntriesTableData> custom({
    Expression<String>? mangaId,
    Expression<String>? title,
    Expression<String>? coverFileName,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (mangaId != null) 'manga_id': mangaId,
      if (title != null) 'title': title,
      if (coverFileName != null) 'cover_file_name': coverFileName,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LibraryEntriesTableCompanion copyWith(
      {Value<String>? mangaId,
      Value<String>? title,
      Value<String?>? coverFileName,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return LibraryEntriesTableCompanion(
      mangaId: mangaId ?? this.mangaId,
      title: title ?? this.title,
      coverFileName: coverFileName ?? this.coverFileName,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (mangaId.present) {
      map['manga_id'] = Variable<String>(mangaId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (coverFileName.present) {
      map['cover_file_name'] = Variable<String>(coverFileName.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LibraryEntriesTableCompanion(')
          ..write('mangaId: $mangaId, ')
          ..write('title: $title, ')
          ..write('coverFileName: $coverFileName, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MangaProgressTableTable extends MangaProgressTable
    with TableInfo<$MangaProgressTableTable, MangaProgressTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MangaProgressTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _mangaIdMeta =
      const VerificationMeta('mangaId');
  @override
  late final GeneratedColumn<String> mangaId = GeneratedColumn<String>(
      'manga_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _chapterIdMeta =
      const VerificationMeta('chapterId');
  @override
  late final GeneratedColumn<String> chapterId = GeneratedColumn<String>(
      'chapter_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pageIndexMeta =
      const VerificationMeta('pageIndex');
  @override
  late final GeneratedColumn<int> pageIndex = GeneratedColumn<int>(
      'page_index', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [mangaId, chapterId, pageIndex, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'manga_progress_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<MangaProgressTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('manga_id')) {
      context.handle(_mangaIdMeta,
          mangaId.isAcceptableOrUnknown(data['manga_id']!, _mangaIdMeta));
    } else if (isInserting) {
      context.missing(_mangaIdMeta);
    }
    if (data.containsKey('chapter_id')) {
      context.handle(_chapterIdMeta,
          chapterId.isAcceptableOrUnknown(data['chapter_id']!, _chapterIdMeta));
    }
    if (data.containsKey('page_index')) {
      context.handle(_pageIndexMeta,
          pageIndex.isAcceptableOrUnknown(data['page_index']!, _pageIndexMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {mangaId};
  @override
  MangaProgressTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MangaProgressTableData(
      mangaId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}manga_id'])!,
      chapterId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}chapter_id']),
      pageIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}page_index'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $MangaProgressTableTable createAlias(String alias) {
    return $MangaProgressTableTable(attachedDatabase, alias);
  }
}

class MangaProgressTableData extends DataClass
    implements Insertable<MangaProgressTableData> {
  final String mangaId;
  final String? chapterId;
  final int pageIndex;
  final DateTime updatedAt;
  const MangaProgressTableData(
      {required this.mangaId,
      this.chapterId,
      required this.pageIndex,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['manga_id'] = Variable<String>(mangaId);
    if (!nullToAbsent || chapterId != null) {
      map['chapter_id'] = Variable<String>(chapterId);
    }
    map['page_index'] = Variable<int>(pageIndex);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MangaProgressTableCompanion toCompanion(bool nullToAbsent) {
    return MangaProgressTableCompanion(
      mangaId: Value(mangaId),
      chapterId: chapterId == null && nullToAbsent
          ? const Value.absent()
          : Value(chapterId),
      pageIndex: Value(pageIndex),
      updatedAt: Value(updatedAt),
    );
  }

  factory MangaProgressTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MangaProgressTableData(
      mangaId: serializer.fromJson<String>(json['mangaId']),
      chapterId: serializer.fromJson<String?>(json['chapterId']),
      pageIndex: serializer.fromJson<int>(json['pageIndex']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'mangaId': serializer.toJson<String>(mangaId),
      'chapterId': serializer.toJson<String?>(chapterId),
      'pageIndex': serializer.toJson<int>(pageIndex),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MangaProgressTableData copyWith(
          {String? mangaId,
          Value<String?> chapterId = const Value.absent(),
          int? pageIndex,
          DateTime? updatedAt}) =>
      MangaProgressTableData(
        mangaId: mangaId ?? this.mangaId,
        chapterId: chapterId.present ? chapterId.value : this.chapterId,
        pageIndex: pageIndex ?? this.pageIndex,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  MangaProgressTableData copyWithCompanion(MangaProgressTableCompanion data) {
    return MangaProgressTableData(
      mangaId: data.mangaId.present ? data.mangaId.value : this.mangaId,
      chapterId: data.chapterId.present ? data.chapterId.value : this.chapterId,
      pageIndex: data.pageIndex.present ? data.pageIndex.value : this.pageIndex,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MangaProgressTableData(')
          ..write('mangaId: $mangaId, ')
          ..write('chapterId: $chapterId, ')
          ..write('pageIndex: $pageIndex, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(mangaId, chapterId, pageIndex, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MangaProgressTableData &&
          other.mangaId == this.mangaId &&
          other.chapterId == this.chapterId &&
          other.pageIndex == this.pageIndex &&
          other.updatedAt == this.updatedAt);
}

class MangaProgressTableCompanion
    extends UpdateCompanion<MangaProgressTableData> {
  final Value<String> mangaId;
  final Value<String?> chapterId;
  final Value<int> pageIndex;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const MangaProgressTableCompanion({
    this.mangaId = const Value.absent(),
    this.chapterId = const Value.absent(),
    this.pageIndex = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MangaProgressTableCompanion.insert({
    required String mangaId,
    this.chapterId = const Value.absent(),
    this.pageIndex = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : mangaId = Value(mangaId),
        updatedAt = Value(updatedAt);
  static Insertable<MangaProgressTableData> custom({
    Expression<String>? mangaId,
    Expression<String>? chapterId,
    Expression<int>? pageIndex,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (mangaId != null) 'manga_id': mangaId,
      if (chapterId != null) 'chapter_id': chapterId,
      if (pageIndex != null) 'page_index': pageIndex,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MangaProgressTableCompanion copyWith(
      {Value<String>? mangaId,
      Value<String?>? chapterId,
      Value<int>? pageIndex,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return MangaProgressTableCompanion(
      mangaId: mangaId ?? this.mangaId,
      chapterId: chapterId ?? this.chapterId,
      pageIndex: pageIndex ?? this.pageIndex,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (mangaId.present) {
      map['manga_id'] = Variable<String>(mangaId.value);
    }
    if (chapterId.present) {
      map['chapter_id'] = Variable<String>(chapterId.value);
    }
    if (pageIndex.present) {
      map['page_index'] = Variable<int>(pageIndex.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MangaProgressTableCompanion(')
          ..write('mangaId: $mangaId, ')
          ..write('chapterId: $chapterId, ')
          ..write('pageIndex: $pageIndex, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReadChaptersTableTable extends ReadChaptersTable
    with TableInfo<$ReadChaptersTableTable, ReadChaptersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReadChaptersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _mangaIdMeta =
      const VerificationMeta('mangaId');
  @override
  late final GeneratedColumn<String> mangaId = GeneratedColumn<String>(
      'manga_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _chapterIdMeta =
      const VerificationMeta('chapterId');
  @override
  late final GeneratedColumn<String> chapterId = GeneratedColumn<String>(
      'chapter_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _readAtMeta = const VerificationMeta('readAt');
  @override
  late final GeneratedColumn<DateTime> readAt = GeneratedColumn<DateTime>(
      'read_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [mangaId, chapterId, readAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'read_chapters_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<ReadChaptersTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('manga_id')) {
      context.handle(_mangaIdMeta,
          mangaId.isAcceptableOrUnknown(data['manga_id']!, _mangaIdMeta));
    } else if (isInserting) {
      context.missing(_mangaIdMeta);
    }
    if (data.containsKey('chapter_id')) {
      context.handle(_chapterIdMeta,
          chapterId.isAcceptableOrUnknown(data['chapter_id']!, _chapterIdMeta));
    } else if (isInserting) {
      context.missing(_chapterIdMeta);
    }
    if (data.containsKey('read_at')) {
      context.handle(_readAtMeta,
          readAt.isAcceptableOrUnknown(data['read_at']!, _readAtMeta));
    } else if (isInserting) {
      context.missing(_readAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {mangaId, chapterId};
  @override
  ReadChaptersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReadChaptersTableData(
      mangaId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}manga_id'])!,
      chapterId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}chapter_id'])!,
      readAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}read_at'])!,
    );
  }

  @override
  $ReadChaptersTableTable createAlias(String alias) {
    return $ReadChaptersTableTable(attachedDatabase, alias);
  }
}

class ReadChaptersTableData extends DataClass
    implements Insertable<ReadChaptersTableData> {
  final String mangaId;
  final String chapterId;
  final DateTime readAt;
  const ReadChaptersTableData(
      {required this.mangaId, required this.chapterId, required this.readAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['manga_id'] = Variable<String>(mangaId);
    map['chapter_id'] = Variable<String>(chapterId);
    map['read_at'] = Variable<DateTime>(readAt);
    return map;
  }

  ReadChaptersTableCompanion toCompanion(bool nullToAbsent) {
    return ReadChaptersTableCompanion(
      mangaId: Value(mangaId),
      chapterId: Value(chapterId),
      readAt: Value(readAt),
    );
  }

  factory ReadChaptersTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReadChaptersTableData(
      mangaId: serializer.fromJson<String>(json['mangaId']),
      chapterId: serializer.fromJson<String>(json['chapterId']),
      readAt: serializer.fromJson<DateTime>(json['readAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'mangaId': serializer.toJson<String>(mangaId),
      'chapterId': serializer.toJson<String>(chapterId),
      'readAt': serializer.toJson<DateTime>(readAt),
    };
  }

  ReadChaptersTableData copyWith(
          {String? mangaId, String? chapterId, DateTime? readAt}) =>
      ReadChaptersTableData(
        mangaId: mangaId ?? this.mangaId,
        chapterId: chapterId ?? this.chapterId,
        readAt: readAt ?? this.readAt,
      );
  ReadChaptersTableData copyWithCompanion(ReadChaptersTableCompanion data) {
    return ReadChaptersTableData(
      mangaId: data.mangaId.present ? data.mangaId.value : this.mangaId,
      chapterId: data.chapterId.present ? data.chapterId.value : this.chapterId,
      readAt: data.readAt.present ? data.readAt.value : this.readAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReadChaptersTableData(')
          ..write('mangaId: $mangaId, ')
          ..write('chapterId: $chapterId, ')
          ..write('readAt: $readAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(mangaId, chapterId, readAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReadChaptersTableData &&
          other.mangaId == this.mangaId &&
          other.chapterId == this.chapterId &&
          other.readAt == this.readAt);
}

class ReadChaptersTableCompanion
    extends UpdateCompanion<ReadChaptersTableData> {
  final Value<String> mangaId;
  final Value<String> chapterId;
  final Value<DateTime> readAt;
  final Value<int> rowid;
  const ReadChaptersTableCompanion({
    this.mangaId = const Value.absent(),
    this.chapterId = const Value.absent(),
    this.readAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReadChaptersTableCompanion.insert({
    required String mangaId,
    required String chapterId,
    required DateTime readAt,
    this.rowid = const Value.absent(),
  })  : mangaId = Value(mangaId),
        chapterId = Value(chapterId),
        readAt = Value(readAt);
  static Insertable<ReadChaptersTableData> custom({
    Expression<String>? mangaId,
    Expression<String>? chapterId,
    Expression<DateTime>? readAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (mangaId != null) 'manga_id': mangaId,
      if (chapterId != null) 'chapter_id': chapterId,
      if (readAt != null) 'read_at': readAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReadChaptersTableCompanion copyWith(
      {Value<String>? mangaId,
      Value<String>? chapterId,
      Value<DateTime>? readAt,
      Value<int>? rowid}) {
    return ReadChaptersTableCompanion(
      mangaId: mangaId ?? this.mangaId,
      chapterId: chapterId ?? this.chapterId,
      readAt: readAt ?? this.readAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (mangaId.present) {
      map['manga_id'] = Variable<String>(mangaId.value);
    }
    if (chapterId.present) {
      map['chapter_id'] = Variable<String>(chapterId.value);
    }
    if (readAt.present) {
      map['read_at'] = Variable<DateTime>(readAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReadChaptersTableCompanion(')
          ..write('mangaId: $mangaId, ')
          ..write('chapterId: $chapterId, ')
          ..write('readAt: $readAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReadingModesTableTable extends ReadingModesTable
    with TableInfo<$ReadingModesTableTable, ReadingModesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReadingModesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _mangaIdMeta =
      const VerificationMeta('mangaId');
  @override
  late final GeneratedColumn<String> mangaId = GeneratedColumn<String>(
      'manga_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
      'mode', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [mangaId, mode, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reading_modes_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<ReadingModesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('manga_id')) {
      context.handle(_mangaIdMeta,
          mangaId.isAcceptableOrUnknown(data['manga_id']!, _mangaIdMeta));
    } else if (isInserting) {
      context.missing(_mangaIdMeta);
    }
    if (data.containsKey('mode')) {
      context.handle(
          _modeMeta, mode.isAcceptableOrUnknown(data['mode']!, _modeMeta));
    } else if (isInserting) {
      context.missing(_modeMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {mangaId};
  @override
  ReadingModesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReadingModesTableData(
      mangaId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}manga_id'])!,
      mode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mode'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ReadingModesTableTable createAlias(String alias) {
    return $ReadingModesTableTable(attachedDatabase, alias);
  }
}

class ReadingModesTableData extends DataClass
    implements Insertable<ReadingModesTableData> {
  final String mangaId;
  final String mode;
  final DateTime updatedAt;
  const ReadingModesTableData(
      {required this.mangaId, required this.mode, required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['manga_id'] = Variable<String>(mangaId);
    map['mode'] = Variable<String>(mode);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ReadingModesTableCompanion toCompanion(bool nullToAbsent) {
    return ReadingModesTableCompanion(
      mangaId: Value(mangaId),
      mode: Value(mode),
      updatedAt: Value(updatedAt),
    );
  }

  factory ReadingModesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReadingModesTableData(
      mangaId: serializer.fromJson<String>(json['mangaId']),
      mode: serializer.fromJson<String>(json['mode']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'mangaId': serializer.toJson<String>(mangaId),
      'mode': serializer.toJson<String>(mode),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ReadingModesTableData copyWith(
          {String? mangaId, String? mode, DateTime? updatedAt}) =>
      ReadingModesTableData(
        mangaId: mangaId ?? this.mangaId,
        mode: mode ?? this.mode,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  ReadingModesTableData copyWithCompanion(ReadingModesTableCompanion data) {
    return ReadingModesTableData(
      mangaId: data.mangaId.present ? data.mangaId.value : this.mangaId,
      mode: data.mode.present ? data.mode.value : this.mode,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReadingModesTableData(')
          ..write('mangaId: $mangaId, ')
          ..write('mode: $mode, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(mangaId, mode, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReadingModesTableData &&
          other.mangaId == this.mangaId &&
          other.mode == this.mode &&
          other.updatedAt == this.updatedAt);
}

class ReadingModesTableCompanion
    extends UpdateCompanion<ReadingModesTableData> {
  final Value<String> mangaId;
  final Value<String> mode;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ReadingModesTableCompanion({
    this.mangaId = const Value.absent(),
    this.mode = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReadingModesTableCompanion.insert({
    required String mangaId,
    required String mode,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : mangaId = Value(mangaId),
        mode = Value(mode),
        updatedAt = Value(updatedAt);
  static Insertable<ReadingModesTableData> custom({
    Expression<String>? mangaId,
    Expression<String>? mode,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (mangaId != null) 'manga_id': mangaId,
      if (mode != null) 'mode': mode,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReadingModesTableCompanion copyWith(
      {Value<String>? mangaId,
      Value<String>? mode,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return ReadingModesTableCompanion(
      mangaId: mangaId ?? this.mangaId,
      mode: mode ?? this.mode,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (mangaId.present) {
      map['manga_id'] = Variable<String>(mangaId.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReadingModesTableCompanion(')
          ..write('mangaId: $mangaId, ')
          ..write('mode: $mode, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MangaTableTable extends MangaTable
    with TableInfo<$MangaTableTable, MangaTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MangaTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _coverFileNameMeta =
      const VerificationMeta('coverFileName');
  @override
  late final GeneratedColumn<String> coverFileName = GeneratedColumn<String>(
      'cover_file_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, title, coverFileName, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'manga_table';
  @override
  VerificationContext validateIntegrity(Insertable<MangaTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('cover_file_name')) {
      context.handle(
          _coverFileNameMeta,
          coverFileName.isAcceptableOrUnknown(
              data['cover_file_name']!, _coverFileNameMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MangaTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MangaTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      coverFileName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cover_file_name']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $MangaTableTable createAlias(String alias) {
    return $MangaTableTable(attachedDatabase, alias);
  }
}

class MangaTableData extends DataClass implements Insertable<MangaTableData> {
  final String id;
  final String title;
  final String? coverFileName;
  final DateTime updatedAt;
  const MangaTableData(
      {required this.id,
      required this.title,
      this.coverFileName,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || coverFileName != null) {
      map['cover_file_name'] = Variable<String>(coverFileName);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MangaTableCompanion toCompanion(bool nullToAbsent) {
    return MangaTableCompanion(
      id: Value(id),
      title: Value(title),
      coverFileName: coverFileName == null && nullToAbsent
          ? const Value.absent()
          : Value(coverFileName),
      updatedAt: Value(updatedAt),
    );
  }

  factory MangaTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MangaTableData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      coverFileName: serializer.fromJson<String?>(json['coverFileName']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'coverFileName': serializer.toJson<String?>(coverFileName),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MangaTableData copyWith(
          {String? id,
          String? title,
          Value<String?> coverFileName = const Value.absent(),
          DateTime? updatedAt}) =>
      MangaTableData(
        id: id ?? this.id,
        title: title ?? this.title,
        coverFileName:
            coverFileName.present ? coverFileName.value : this.coverFileName,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  MangaTableData copyWithCompanion(MangaTableCompanion data) {
    return MangaTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      coverFileName: data.coverFileName.present
          ? data.coverFileName.value
          : this.coverFileName,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MangaTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('coverFileName: $coverFileName, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, coverFileName, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MangaTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.coverFileName == this.coverFileName &&
          other.updatedAt == this.updatedAt);
}

class MangaTableCompanion extends UpdateCompanion<MangaTableData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> coverFileName;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const MangaTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.coverFileName = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MangaTableCompanion.insert({
    required String id,
    required String title,
    this.coverFileName = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        updatedAt = Value(updatedAt);
  static Insertable<MangaTableData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? coverFileName,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (coverFileName != null) 'cover_file_name': coverFileName,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MangaTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String?>? coverFileName,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return MangaTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      coverFileName: coverFileName ?? this.coverFileName,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (coverFileName.present) {
      map['cover_file_name'] = Variable<String>(coverFileName.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MangaTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('coverFileName: $coverFileName, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChaptersTableTable extends ChaptersTable
    with TableInfo<$ChaptersTableTable, ChaptersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChaptersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _mangaIdMeta =
      const VerificationMeta('mangaId');
  @override
  late final GeneratedColumn<String> mangaId = GeneratedColumn<String>(
      'manga_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _chapterNumberMeta =
      const VerificationMeta('chapterNumber');
  @override
  late final GeneratedColumn<String> chapterNumber = GeneratedColumn<String>(
      'chapter_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _languageMeta =
      const VerificationMeta('language');
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
      'language', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _scanlationGroupIdMeta =
      const VerificationMeta('scanlationGroupId');
  @override
  late final GeneratedColumn<String> scanlationGroupId =
      GeneratedColumn<String>('scanlation_group_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _scanlationGroupNameMeta =
      const VerificationMeta('scanlationGroupName');
  @override
  late final GeneratedColumn<String> scanlationGroupName =
      GeneratedColumn<String>('scanlation_group_name', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        mangaId,
        chapterNumber,
        title,
        language,
        scanlationGroupId,
        scanlationGroupName,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chapters_table';
  @override
  VerificationContext validateIntegrity(Insertable<ChaptersTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('manga_id')) {
      context.handle(_mangaIdMeta,
          mangaId.isAcceptableOrUnknown(data['manga_id']!, _mangaIdMeta));
    } else if (isInserting) {
      context.missing(_mangaIdMeta);
    }
    if (data.containsKey('chapter_number')) {
      context.handle(
          _chapterNumberMeta,
          chapterNumber.isAcceptableOrUnknown(
              data['chapter_number']!, _chapterNumberMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('language')) {
      context.handle(_languageMeta,
          language.isAcceptableOrUnknown(data['language']!, _languageMeta));
    }
    if (data.containsKey('scanlation_group_id')) {
      context.handle(
          _scanlationGroupIdMeta,
          scanlationGroupId.isAcceptableOrUnknown(
              data['scanlation_group_id']!, _scanlationGroupIdMeta));
    }
    if (data.containsKey('scanlation_group_name')) {
      context.handle(
          _scanlationGroupNameMeta,
          scanlationGroupName.isAcceptableOrUnknown(
              data['scanlation_group_name']!, _scanlationGroupNameMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChaptersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChaptersTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      mangaId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}manga_id'])!,
      chapterNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}chapter_number']),
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title']),
      language: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language']),
      scanlationGroupId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}scanlation_group_id']),
      scanlationGroupName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}scanlation_group_name']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ChaptersTableTable createAlias(String alias) {
    return $ChaptersTableTable(attachedDatabase, alias);
  }
}

class ChaptersTableData extends DataClass
    implements Insertable<ChaptersTableData> {
  final String id;
  final String mangaId;
  final String? chapterNumber;
  final String? title;
  final String? language;
  final String? scanlationGroupId;
  final String? scanlationGroupName;
  final DateTime updatedAt;
  const ChaptersTableData(
      {required this.id,
      required this.mangaId,
      this.chapterNumber,
      this.title,
      this.language,
      this.scanlationGroupId,
      this.scanlationGroupName,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['manga_id'] = Variable<String>(mangaId);
    if (!nullToAbsent || chapterNumber != null) {
      map['chapter_number'] = Variable<String>(chapterNumber);
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || language != null) {
      map['language'] = Variable<String>(language);
    }
    if (!nullToAbsent || scanlationGroupId != null) {
      map['scanlation_group_id'] = Variable<String>(scanlationGroupId);
    }
    if (!nullToAbsent || scanlationGroupName != null) {
      map['scanlation_group_name'] = Variable<String>(scanlationGroupName);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ChaptersTableCompanion toCompanion(bool nullToAbsent) {
    return ChaptersTableCompanion(
      id: Value(id),
      mangaId: Value(mangaId),
      chapterNumber: chapterNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(chapterNumber),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      language: language == null && nullToAbsent
          ? const Value.absent()
          : Value(language),
      scanlationGroupId: scanlationGroupId == null && nullToAbsent
          ? const Value.absent()
          : Value(scanlationGroupId),
      scanlationGroupName: scanlationGroupName == null && nullToAbsent
          ? const Value.absent()
          : Value(scanlationGroupName),
      updatedAt: Value(updatedAt),
    );
  }

  factory ChaptersTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChaptersTableData(
      id: serializer.fromJson<String>(json['id']),
      mangaId: serializer.fromJson<String>(json['mangaId']),
      chapterNumber: serializer.fromJson<String?>(json['chapterNumber']),
      title: serializer.fromJson<String?>(json['title']),
      language: serializer.fromJson<String?>(json['language']),
      scanlationGroupId:
          serializer.fromJson<String?>(json['scanlationGroupId']),
      scanlationGroupName:
          serializer.fromJson<String?>(json['scanlationGroupName']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'mangaId': serializer.toJson<String>(mangaId),
      'chapterNumber': serializer.toJson<String?>(chapterNumber),
      'title': serializer.toJson<String?>(title),
      'language': serializer.toJson<String?>(language),
      'scanlationGroupId': serializer.toJson<String?>(scanlationGroupId),
      'scanlationGroupName': serializer.toJson<String?>(scanlationGroupName),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ChaptersTableData copyWith(
          {String? id,
          String? mangaId,
          Value<String?> chapterNumber = const Value.absent(),
          Value<String?> title = const Value.absent(),
          Value<String?> language = const Value.absent(),
          Value<String?> scanlationGroupId = const Value.absent(),
          Value<String?> scanlationGroupName = const Value.absent(),
          DateTime? updatedAt}) =>
      ChaptersTableData(
        id: id ?? this.id,
        mangaId: mangaId ?? this.mangaId,
        chapterNumber:
            chapterNumber.present ? chapterNumber.value : this.chapterNumber,
        title: title.present ? title.value : this.title,
        language: language.present ? language.value : this.language,
        scanlationGroupId: scanlationGroupId.present
            ? scanlationGroupId.value
            : this.scanlationGroupId,
        scanlationGroupName: scanlationGroupName.present
            ? scanlationGroupName.value
            : this.scanlationGroupName,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  ChaptersTableData copyWithCompanion(ChaptersTableCompanion data) {
    return ChaptersTableData(
      id: data.id.present ? data.id.value : this.id,
      mangaId: data.mangaId.present ? data.mangaId.value : this.mangaId,
      chapterNumber: data.chapterNumber.present
          ? data.chapterNumber.value
          : this.chapterNumber,
      title: data.title.present ? data.title.value : this.title,
      language: data.language.present ? data.language.value : this.language,
      scanlationGroupId: data.scanlationGroupId.present
          ? data.scanlationGroupId.value
          : this.scanlationGroupId,
      scanlationGroupName: data.scanlationGroupName.present
          ? data.scanlationGroupName.value
          : this.scanlationGroupName,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChaptersTableData(')
          ..write('id: $id, ')
          ..write('mangaId: $mangaId, ')
          ..write('chapterNumber: $chapterNumber, ')
          ..write('title: $title, ')
          ..write('language: $language, ')
          ..write('scanlationGroupId: $scanlationGroupId, ')
          ..write('scanlationGroupName: $scanlationGroupName, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, mangaId, chapterNumber, title, language,
      scanlationGroupId, scanlationGroupName, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChaptersTableData &&
          other.id == this.id &&
          other.mangaId == this.mangaId &&
          other.chapterNumber == this.chapterNumber &&
          other.title == this.title &&
          other.language == this.language &&
          other.scanlationGroupId == this.scanlationGroupId &&
          other.scanlationGroupName == this.scanlationGroupName &&
          other.updatedAt == this.updatedAt);
}

class ChaptersTableCompanion extends UpdateCompanion<ChaptersTableData> {
  final Value<String> id;
  final Value<String> mangaId;
  final Value<String?> chapterNumber;
  final Value<String?> title;
  final Value<String?> language;
  final Value<String?> scanlationGroupId;
  final Value<String?> scanlationGroupName;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ChaptersTableCompanion({
    this.id = const Value.absent(),
    this.mangaId = const Value.absent(),
    this.chapterNumber = const Value.absent(),
    this.title = const Value.absent(),
    this.language = const Value.absent(),
    this.scanlationGroupId = const Value.absent(),
    this.scanlationGroupName = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChaptersTableCompanion.insert({
    required String id,
    required String mangaId,
    this.chapterNumber = const Value.absent(),
    this.title = const Value.absent(),
    this.language = const Value.absent(),
    this.scanlationGroupId = const Value.absent(),
    this.scanlationGroupName = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        mangaId = Value(mangaId),
        updatedAt = Value(updatedAt);
  static Insertable<ChaptersTableData> custom({
    Expression<String>? id,
    Expression<String>? mangaId,
    Expression<String>? chapterNumber,
    Expression<String>? title,
    Expression<String>? language,
    Expression<String>? scanlationGroupId,
    Expression<String>? scanlationGroupName,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mangaId != null) 'manga_id': mangaId,
      if (chapterNumber != null) 'chapter_number': chapterNumber,
      if (title != null) 'title': title,
      if (language != null) 'language': language,
      if (scanlationGroupId != null) 'scanlation_group_id': scanlationGroupId,
      if (scanlationGroupName != null)
        'scanlation_group_name': scanlationGroupName,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChaptersTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? mangaId,
      Value<String?>? chapterNumber,
      Value<String?>? title,
      Value<String?>? language,
      Value<String?>? scanlationGroupId,
      Value<String?>? scanlationGroupName,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return ChaptersTableCompanion(
      id: id ?? this.id,
      mangaId: mangaId ?? this.mangaId,
      chapterNumber: chapterNumber ?? this.chapterNumber,
      title: title ?? this.title,
      language: language ?? this.language,
      scanlationGroupId: scanlationGroupId ?? this.scanlationGroupId,
      scanlationGroupName: scanlationGroupName ?? this.scanlationGroupName,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (mangaId.present) {
      map['manga_id'] = Variable<String>(mangaId.value);
    }
    if (chapterNumber.present) {
      map['chapter_number'] = Variable<String>(chapterNumber.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (scanlationGroupId.present) {
      map['scanlation_group_id'] = Variable<String>(scanlationGroupId.value);
    }
    if (scanlationGroupName.present) {
      map['scanlation_group_name'] =
          Variable<String>(scanlationGroupName.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChaptersTableCompanion(')
          ..write('id: $id, ')
          ..write('mangaId: $mangaId, ')
          ..write('chapterNumber: $chapterNumber, ')
          ..write('title: $title, ')
          ..write('language: $language, ')
          ..write('scanlationGroupId: $scanlationGroupId, ')
          ..write('scanlationGroupName: $scanlationGroupName, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DownloadJobsTableTable extends DownloadJobsTable
    with TableInfo<$DownloadJobsTableTable, DownloadJobsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DownloadJobsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _chapterIdMeta =
      const VerificationMeta('chapterId');
  @override
  late final GeneratedColumn<String> chapterId = GeneratedColumn<String>(
      'chapter_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _mangaIdMeta =
      const VerificationMeta('mangaId');
  @override
  late final GeneratedColumn<String> mangaId = GeneratedColumn<String>(
      'manga_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _progressMeta =
      const VerificationMeta('progress');
  @override
  late final GeneratedColumn<int> progress = GeneratedColumn<int>(
      'progress', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _downloadedBytesMeta =
      const VerificationMeta('downloadedBytes');
  @override
  late final GeneratedColumn<int> downloadedBytes = GeneratedColumn<int>(
      'downloaded_bytes', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _totalBytesMeta =
      const VerificationMeta('totalBytes');
  @override
  late final GeneratedColumn<int> totalBytes = GeneratedColumn<int>(
      'total_bytes', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _errorMessageMeta =
      const VerificationMeta('errorMessage');
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
      'error_message', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        chapterId,
        mangaId,
        status,
        progress,
        downloadedBytes,
        totalBytes,
        errorMessage,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'download_jobs_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<DownloadJobsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('chapter_id')) {
      context.handle(_chapterIdMeta,
          chapterId.isAcceptableOrUnknown(data['chapter_id']!, _chapterIdMeta));
    } else if (isInserting) {
      context.missing(_chapterIdMeta);
    }
    if (data.containsKey('manga_id')) {
      context.handle(_mangaIdMeta,
          mangaId.isAcceptableOrUnknown(data['manga_id']!, _mangaIdMeta));
    } else if (isInserting) {
      context.missing(_mangaIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('progress')) {
      context.handle(_progressMeta,
          progress.isAcceptableOrUnknown(data['progress']!, _progressMeta));
    }
    if (data.containsKey('downloaded_bytes')) {
      context.handle(
          _downloadedBytesMeta,
          downloadedBytes.isAcceptableOrUnknown(
              data['downloaded_bytes']!, _downloadedBytesMeta));
    }
    if (data.containsKey('total_bytes')) {
      context.handle(
          _totalBytesMeta,
          totalBytes.isAcceptableOrUnknown(
              data['total_bytes']!, _totalBytesMeta));
    }
    if (data.containsKey('error_message')) {
      context.handle(
          _errorMessageMeta,
          errorMessage.isAcceptableOrUnknown(
              data['error_message']!, _errorMessageMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {chapterId};
  @override
  DownloadJobsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DownloadJobsTableData(
      chapterId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}chapter_id'])!,
      mangaId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}manga_id'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      progress: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}progress'])!,
      downloadedBytes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}downloaded_bytes'])!,
      totalBytes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_bytes']),
      errorMessage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}error_message']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $DownloadJobsTableTable createAlias(String alias) {
    return $DownloadJobsTableTable(attachedDatabase, alias);
  }
}

class DownloadJobsTableData extends DataClass
    implements Insertable<DownloadJobsTableData> {
  final String chapterId;
  final String mangaId;
  final String status;
  final int progress;
  final int downloadedBytes;
  final int? totalBytes;
  final String? errorMessage;
  final DateTime createdAt;
  final DateTime updatedAt;
  const DownloadJobsTableData(
      {required this.chapterId,
      required this.mangaId,
      required this.status,
      required this.progress,
      required this.downloadedBytes,
      this.totalBytes,
      this.errorMessage,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['chapter_id'] = Variable<String>(chapterId);
    map['manga_id'] = Variable<String>(mangaId);
    map['status'] = Variable<String>(status);
    map['progress'] = Variable<int>(progress);
    map['downloaded_bytes'] = Variable<int>(downloadedBytes);
    if (!nullToAbsent || totalBytes != null) {
      map['total_bytes'] = Variable<int>(totalBytes);
    }
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DownloadJobsTableCompanion toCompanion(bool nullToAbsent) {
    return DownloadJobsTableCompanion(
      chapterId: Value(chapterId),
      mangaId: Value(mangaId),
      status: Value(status),
      progress: Value(progress),
      downloadedBytes: Value(downloadedBytes),
      totalBytes: totalBytes == null && nullToAbsent
          ? const Value.absent()
          : Value(totalBytes),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DownloadJobsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DownloadJobsTableData(
      chapterId: serializer.fromJson<String>(json['chapterId']),
      mangaId: serializer.fromJson<String>(json['mangaId']),
      status: serializer.fromJson<String>(json['status']),
      progress: serializer.fromJson<int>(json['progress']),
      downloadedBytes: serializer.fromJson<int>(json['downloadedBytes']),
      totalBytes: serializer.fromJson<int?>(json['totalBytes']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'chapterId': serializer.toJson<String>(chapterId),
      'mangaId': serializer.toJson<String>(mangaId),
      'status': serializer.toJson<String>(status),
      'progress': serializer.toJson<int>(progress),
      'downloadedBytes': serializer.toJson<int>(downloadedBytes),
      'totalBytes': serializer.toJson<int?>(totalBytes),
      'errorMessage': serializer.toJson<String?>(errorMessage),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DownloadJobsTableData copyWith(
          {String? chapterId,
          String? mangaId,
          String? status,
          int? progress,
          int? downloadedBytes,
          Value<int?> totalBytes = const Value.absent(),
          Value<String?> errorMessage = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      DownloadJobsTableData(
        chapterId: chapterId ?? this.chapterId,
        mangaId: mangaId ?? this.mangaId,
        status: status ?? this.status,
        progress: progress ?? this.progress,
        downloadedBytes: downloadedBytes ?? this.downloadedBytes,
        totalBytes: totalBytes.present ? totalBytes.value : this.totalBytes,
        errorMessage:
            errorMessage.present ? errorMessage.value : this.errorMessage,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  DownloadJobsTableData copyWithCompanion(DownloadJobsTableCompanion data) {
    return DownloadJobsTableData(
      chapterId: data.chapterId.present ? data.chapterId.value : this.chapterId,
      mangaId: data.mangaId.present ? data.mangaId.value : this.mangaId,
      status: data.status.present ? data.status.value : this.status,
      progress: data.progress.present ? data.progress.value : this.progress,
      downloadedBytes: data.downloadedBytes.present
          ? data.downloadedBytes.value
          : this.downloadedBytes,
      totalBytes:
          data.totalBytes.present ? data.totalBytes.value : this.totalBytes,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DownloadJobsTableData(')
          ..write('chapterId: $chapterId, ')
          ..write('mangaId: $mangaId, ')
          ..write('status: $status, ')
          ..write('progress: $progress, ')
          ..write('downloadedBytes: $downloadedBytes, ')
          ..write('totalBytes: $totalBytes, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(chapterId, mangaId, status, progress,
      downloadedBytes, totalBytes, errorMessage, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DownloadJobsTableData &&
          other.chapterId == this.chapterId &&
          other.mangaId == this.mangaId &&
          other.status == this.status &&
          other.progress == this.progress &&
          other.downloadedBytes == this.downloadedBytes &&
          other.totalBytes == this.totalBytes &&
          other.errorMessage == this.errorMessage &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DownloadJobsTableCompanion
    extends UpdateCompanion<DownloadJobsTableData> {
  final Value<String> chapterId;
  final Value<String> mangaId;
  final Value<String> status;
  final Value<int> progress;
  final Value<int> downloadedBytes;
  final Value<int?> totalBytes;
  final Value<String?> errorMessage;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DownloadJobsTableCompanion({
    this.chapterId = const Value.absent(),
    this.mangaId = const Value.absent(),
    this.status = const Value.absent(),
    this.progress = const Value.absent(),
    this.downloadedBytes = const Value.absent(),
    this.totalBytes = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DownloadJobsTableCompanion.insert({
    required String chapterId,
    required String mangaId,
    required String status,
    this.progress = const Value.absent(),
    this.downloadedBytes = const Value.absent(),
    this.totalBytes = const Value.absent(),
    this.errorMessage = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : chapterId = Value(chapterId),
        mangaId = Value(mangaId),
        status = Value(status),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<DownloadJobsTableData> custom({
    Expression<String>? chapterId,
    Expression<String>? mangaId,
    Expression<String>? status,
    Expression<int>? progress,
    Expression<int>? downloadedBytes,
    Expression<int>? totalBytes,
    Expression<String>? errorMessage,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (chapterId != null) 'chapter_id': chapterId,
      if (mangaId != null) 'manga_id': mangaId,
      if (status != null) 'status': status,
      if (progress != null) 'progress': progress,
      if (downloadedBytes != null) 'downloaded_bytes': downloadedBytes,
      if (totalBytes != null) 'total_bytes': totalBytes,
      if (errorMessage != null) 'error_message': errorMessage,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DownloadJobsTableCompanion copyWith(
      {Value<String>? chapterId,
      Value<String>? mangaId,
      Value<String>? status,
      Value<int>? progress,
      Value<int>? downloadedBytes,
      Value<int?>? totalBytes,
      Value<String?>? errorMessage,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return DownloadJobsTableCompanion(
      chapterId: chapterId ?? this.chapterId,
      mangaId: mangaId ?? this.mangaId,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      downloadedBytes: downloadedBytes ?? this.downloadedBytes,
      totalBytes: totalBytes ?? this.totalBytes,
      errorMessage: errorMessage ?? this.errorMessage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (chapterId.present) {
      map['chapter_id'] = Variable<String>(chapterId.value);
    }
    if (mangaId.present) {
      map['manga_id'] = Variable<String>(mangaId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (progress.present) {
      map['progress'] = Variable<int>(progress.value);
    }
    if (downloadedBytes.present) {
      map['downloaded_bytes'] = Variable<int>(downloadedBytes.value);
    }
    if (totalBytes.present) {
      map['total_bytes'] = Variable<int>(totalBytes.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DownloadJobsTableCompanion(')
          ..write('chapterId: $chapterId, ')
          ..write('mangaId: $mangaId, ')
          ..write('status: $status, ')
          ..write('progress: $progress, ')
          ..write('downloadedBytes: $downloadedBytes, ')
          ..write('totalBytes: $totalBytes, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DownloadedPagesTableTable extends DownloadedPagesTable
    with TableInfo<$DownloadedPagesTableTable, DownloadedPagesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DownloadedPagesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _chapterIdMeta =
      const VerificationMeta('chapterId');
  @override
  late final GeneratedColumn<String> chapterId = GeneratedColumn<String>(
      'chapter_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pageIndexMeta =
      const VerificationMeta('pageIndex');
  @override
  late final GeneratedColumn<int> pageIndex = GeneratedColumn<int>(
      'page_index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _localPathMeta =
      const VerificationMeta('localPath');
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
      'local_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sizeBytesMeta =
      const VerificationMeta('sizeBytes');
  @override
  late final GeneratedColumn<int> sizeBytes = GeneratedColumn<int>(
      'size_bytes', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _checksumMeta =
      const VerificationMeta('checksum');
  @override
  late final GeneratedColumn<String> checksum = GeneratedColumn<String>(
      'checksum', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [chapterId, pageIndex, localPath, sizeBytes, checksum, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'downloaded_pages_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<DownloadedPagesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('chapter_id')) {
      context.handle(_chapterIdMeta,
          chapterId.isAcceptableOrUnknown(data['chapter_id']!, _chapterIdMeta));
    } else if (isInserting) {
      context.missing(_chapterIdMeta);
    }
    if (data.containsKey('page_index')) {
      context.handle(_pageIndexMeta,
          pageIndex.isAcceptableOrUnknown(data['page_index']!, _pageIndexMeta));
    } else if (isInserting) {
      context.missing(_pageIndexMeta);
    }
    if (data.containsKey('local_path')) {
      context.handle(_localPathMeta,
          localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta));
    } else if (isInserting) {
      context.missing(_localPathMeta);
    }
    if (data.containsKey('size_bytes')) {
      context.handle(_sizeBytesMeta,
          sizeBytes.isAcceptableOrUnknown(data['size_bytes']!, _sizeBytesMeta));
    }
    if (data.containsKey('checksum')) {
      context.handle(_checksumMeta,
          checksum.isAcceptableOrUnknown(data['checksum']!, _checksumMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {chapterId, pageIndex};
  @override
  DownloadedPagesTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DownloadedPagesTableData(
      chapterId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}chapter_id'])!,
      pageIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}page_index'])!,
      localPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}local_path'])!,
      sizeBytes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}size_bytes']),
      checksum: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}checksum']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $DownloadedPagesTableTable createAlias(String alias) {
    return $DownloadedPagesTableTable(attachedDatabase, alias);
  }
}

class DownloadedPagesTableData extends DataClass
    implements Insertable<DownloadedPagesTableData> {
  final String chapterId;
  final int pageIndex;
  final String localPath;
  final int? sizeBytes;
  final String? checksum;
  final DateTime updatedAt;
  const DownloadedPagesTableData(
      {required this.chapterId,
      required this.pageIndex,
      required this.localPath,
      this.sizeBytes,
      this.checksum,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['chapter_id'] = Variable<String>(chapterId);
    map['page_index'] = Variable<int>(pageIndex);
    map['local_path'] = Variable<String>(localPath);
    if (!nullToAbsent || sizeBytes != null) {
      map['size_bytes'] = Variable<int>(sizeBytes);
    }
    if (!nullToAbsent || checksum != null) {
      map['checksum'] = Variable<String>(checksum);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DownloadedPagesTableCompanion toCompanion(bool nullToAbsent) {
    return DownloadedPagesTableCompanion(
      chapterId: Value(chapterId),
      pageIndex: Value(pageIndex),
      localPath: Value(localPath),
      sizeBytes: sizeBytes == null && nullToAbsent
          ? const Value.absent()
          : Value(sizeBytes),
      checksum: checksum == null && nullToAbsent
          ? const Value.absent()
          : Value(checksum),
      updatedAt: Value(updatedAt),
    );
  }

  factory DownloadedPagesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DownloadedPagesTableData(
      chapterId: serializer.fromJson<String>(json['chapterId']),
      pageIndex: serializer.fromJson<int>(json['pageIndex']),
      localPath: serializer.fromJson<String>(json['localPath']),
      sizeBytes: serializer.fromJson<int?>(json['sizeBytes']),
      checksum: serializer.fromJson<String?>(json['checksum']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'chapterId': serializer.toJson<String>(chapterId),
      'pageIndex': serializer.toJson<int>(pageIndex),
      'localPath': serializer.toJson<String>(localPath),
      'sizeBytes': serializer.toJson<int?>(sizeBytes),
      'checksum': serializer.toJson<String?>(checksum),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DownloadedPagesTableData copyWith(
          {String? chapterId,
          int? pageIndex,
          String? localPath,
          Value<int?> sizeBytes = const Value.absent(),
          Value<String?> checksum = const Value.absent(),
          DateTime? updatedAt}) =>
      DownloadedPagesTableData(
        chapterId: chapterId ?? this.chapterId,
        pageIndex: pageIndex ?? this.pageIndex,
        localPath: localPath ?? this.localPath,
        sizeBytes: sizeBytes.present ? sizeBytes.value : this.sizeBytes,
        checksum: checksum.present ? checksum.value : this.checksum,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  DownloadedPagesTableData copyWithCompanion(
      DownloadedPagesTableCompanion data) {
    return DownloadedPagesTableData(
      chapterId: data.chapterId.present ? data.chapterId.value : this.chapterId,
      pageIndex: data.pageIndex.present ? data.pageIndex.value : this.pageIndex,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      sizeBytes: data.sizeBytes.present ? data.sizeBytes.value : this.sizeBytes,
      checksum: data.checksum.present ? data.checksum.value : this.checksum,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DownloadedPagesTableData(')
          ..write('chapterId: $chapterId, ')
          ..write('pageIndex: $pageIndex, ')
          ..write('localPath: $localPath, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('checksum: $checksum, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      chapterId, pageIndex, localPath, sizeBytes, checksum, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DownloadedPagesTableData &&
          other.chapterId == this.chapterId &&
          other.pageIndex == this.pageIndex &&
          other.localPath == this.localPath &&
          other.sizeBytes == this.sizeBytes &&
          other.checksum == this.checksum &&
          other.updatedAt == this.updatedAt);
}

class DownloadedPagesTableCompanion
    extends UpdateCompanion<DownloadedPagesTableData> {
  final Value<String> chapterId;
  final Value<int> pageIndex;
  final Value<String> localPath;
  final Value<int?> sizeBytes;
  final Value<String?> checksum;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DownloadedPagesTableCompanion({
    this.chapterId = const Value.absent(),
    this.pageIndex = const Value.absent(),
    this.localPath = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.checksum = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DownloadedPagesTableCompanion.insert({
    required String chapterId,
    required int pageIndex,
    required String localPath,
    this.sizeBytes = const Value.absent(),
    this.checksum = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : chapterId = Value(chapterId),
        pageIndex = Value(pageIndex),
        localPath = Value(localPath),
        updatedAt = Value(updatedAt);
  static Insertable<DownloadedPagesTableData> custom({
    Expression<String>? chapterId,
    Expression<int>? pageIndex,
    Expression<String>? localPath,
    Expression<int>? sizeBytes,
    Expression<String>? checksum,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (chapterId != null) 'chapter_id': chapterId,
      if (pageIndex != null) 'page_index': pageIndex,
      if (localPath != null) 'local_path': localPath,
      if (sizeBytes != null) 'size_bytes': sizeBytes,
      if (checksum != null) 'checksum': checksum,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DownloadedPagesTableCompanion copyWith(
      {Value<String>? chapterId,
      Value<int>? pageIndex,
      Value<String>? localPath,
      Value<int?>? sizeBytes,
      Value<String?>? checksum,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return DownloadedPagesTableCompanion(
      chapterId: chapterId ?? this.chapterId,
      pageIndex: pageIndex ?? this.pageIndex,
      localPath: localPath ?? this.localPath,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      checksum: checksum ?? this.checksum,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (chapterId.present) {
      map['chapter_id'] = Variable<String>(chapterId.value);
    }
    if (pageIndex.present) {
      map['page_index'] = Variable<int>(pageIndex.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (sizeBytes.present) {
      map['size_bytes'] = Variable<int>(sizeBytes.value);
    }
    if (checksum.present) {
      map['checksum'] = Variable<String>(checksum.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DownloadedPagesTableCompanion(')
          ..write('chapterId: $chapterId, ')
          ..write('pageIndex: $pageIndex, ')
          ..write('localPath: $localPath, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('checksum: $checksum, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SettingsTableTable settingsTable = $SettingsTableTable(this);
  late final $LibraryEntriesTableTable libraryEntriesTable =
      $LibraryEntriesTableTable(this);
  late final $MangaProgressTableTable mangaProgressTable =
      $MangaProgressTableTable(this);
  late final $ReadChaptersTableTable readChaptersTable =
      $ReadChaptersTableTable(this);
  late final $ReadingModesTableTable readingModesTable =
      $ReadingModesTableTable(this);
  late final $MangaTableTable mangaTable = $MangaTableTable(this);
  late final $ChaptersTableTable chaptersTable = $ChaptersTableTable(this);
  late final $DownloadJobsTableTable downloadJobsTable =
      $DownloadJobsTableTable(this);
  late final $DownloadedPagesTableTable downloadedPagesTable =
      $DownloadedPagesTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        settingsTable,
        libraryEntriesTable,
        mangaProgressTable,
        readChaptersTable,
        readingModesTable,
        mangaTable,
        chaptersTable,
        downloadJobsTable,
        downloadedPagesTable
      ];
}

typedef $$SettingsTableTableCreateCompanionBuilder = SettingsTableCompanion
    Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$SettingsTableTableUpdateCompanionBuilder = SettingsTableCompanion
    Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$SettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTableTable> {
  $$SettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));
}

class $$SettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTableTable> {
  $$SettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$SettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTableTable> {
  $$SettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SettingsTableTable,
    SettingsTableData,
    $$SettingsTableTableFilterComposer,
    $$SettingsTableTableOrderingComposer,
    $$SettingsTableTableAnnotationComposer,
    $$SettingsTableTableCreateCompanionBuilder,
    $$SettingsTableTableUpdateCompanionBuilder,
    (
      SettingsTableData,
      BaseReferences<_$AppDatabase, $SettingsTableTable, SettingsTableData>
    ),
    SettingsTableData,
    PrefetchHooks Function()> {
  $$SettingsTableTableTableManager(_$AppDatabase db, $SettingsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SettingsTableCompanion(
            key: key,
            value: value,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) =>
              SettingsTableCompanion.insert(
            key: key,
            value: value,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SettingsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SettingsTableTable,
    SettingsTableData,
    $$SettingsTableTableFilterComposer,
    $$SettingsTableTableOrderingComposer,
    $$SettingsTableTableAnnotationComposer,
    $$SettingsTableTableCreateCompanionBuilder,
    $$SettingsTableTableUpdateCompanionBuilder,
    (
      SettingsTableData,
      BaseReferences<_$AppDatabase, $SettingsTableTable, SettingsTableData>
    ),
    SettingsTableData,
    PrefetchHooks Function()>;
typedef $$LibraryEntriesTableTableCreateCompanionBuilder
    = LibraryEntriesTableCompanion Function({
  required String mangaId,
  required String title,
  Value<String?> coverFileName,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$LibraryEntriesTableTableUpdateCompanionBuilder
    = LibraryEntriesTableCompanion Function({
  Value<String> mangaId,
  Value<String> title,
  Value<String?> coverFileName,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$LibraryEntriesTableTableFilterComposer
    extends Composer<_$AppDatabase, $LibraryEntriesTableTable> {
  $$LibraryEntriesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get mangaId => $composableBuilder(
      column: $table.mangaId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get coverFileName => $composableBuilder(
      column: $table.coverFileName, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$LibraryEntriesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $LibraryEntriesTableTable> {
  $$LibraryEntriesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get mangaId => $composableBuilder(
      column: $table.mangaId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get coverFileName => $composableBuilder(
      column: $table.coverFileName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$LibraryEntriesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $LibraryEntriesTableTable> {
  $$LibraryEntriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get mangaId =>
      $composableBuilder(column: $table.mangaId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get coverFileName => $composableBuilder(
      column: $table.coverFileName, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LibraryEntriesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LibraryEntriesTableTable,
    LibraryEntriesTableData,
    $$LibraryEntriesTableTableFilterComposer,
    $$LibraryEntriesTableTableOrderingComposer,
    $$LibraryEntriesTableTableAnnotationComposer,
    $$LibraryEntriesTableTableCreateCompanionBuilder,
    $$LibraryEntriesTableTableUpdateCompanionBuilder,
    (
      LibraryEntriesTableData,
      BaseReferences<_$AppDatabase, $LibraryEntriesTableTable,
          LibraryEntriesTableData>
    ),
    LibraryEntriesTableData,
    PrefetchHooks Function()> {
  $$LibraryEntriesTableTableTableManager(
      _$AppDatabase db, $LibraryEntriesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LibraryEntriesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LibraryEntriesTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LibraryEntriesTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> mangaId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> coverFileName = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LibraryEntriesTableCompanion(
            mangaId: mangaId,
            title: title,
            coverFileName: coverFileName,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String mangaId,
            required String title,
            Value<String?> coverFileName = const Value.absent(),
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              LibraryEntriesTableCompanion.insert(
            mangaId: mangaId,
            title: title,
            coverFileName: coverFileName,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LibraryEntriesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LibraryEntriesTableTable,
    LibraryEntriesTableData,
    $$LibraryEntriesTableTableFilterComposer,
    $$LibraryEntriesTableTableOrderingComposer,
    $$LibraryEntriesTableTableAnnotationComposer,
    $$LibraryEntriesTableTableCreateCompanionBuilder,
    $$LibraryEntriesTableTableUpdateCompanionBuilder,
    (
      LibraryEntriesTableData,
      BaseReferences<_$AppDatabase, $LibraryEntriesTableTable,
          LibraryEntriesTableData>
    ),
    LibraryEntriesTableData,
    PrefetchHooks Function()>;
typedef $$MangaProgressTableTableCreateCompanionBuilder
    = MangaProgressTableCompanion Function({
  required String mangaId,
  Value<String?> chapterId,
  Value<int> pageIndex,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$MangaProgressTableTableUpdateCompanionBuilder
    = MangaProgressTableCompanion Function({
  Value<String> mangaId,
  Value<String?> chapterId,
  Value<int> pageIndex,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$MangaProgressTableTableFilterComposer
    extends Composer<_$AppDatabase, $MangaProgressTableTable> {
  $$MangaProgressTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get mangaId => $composableBuilder(
      column: $table.mangaId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get chapterId => $composableBuilder(
      column: $table.chapterId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get pageIndex => $composableBuilder(
      column: $table.pageIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$MangaProgressTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MangaProgressTableTable> {
  $$MangaProgressTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get mangaId => $composableBuilder(
      column: $table.mangaId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get chapterId => $composableBuilder(
      column: $table.chapterId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get pageIndex => $composableBuilder(
      column: $table.pageIndex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$MangaProgressTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MangaProgressTableTable> {
  $$MangaProgressTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get mangaId =>
      $composableBuilder(column: $table.mangaId, builder: (column) => column);

  GeneratedColumn<String> get chapterId =>
      $composableBuilder(column: $table.chapterId, builder: (column) => column);

  GeneratedColumn<int> get pageIndex =>
      $composableBuilder(column: $table.pageIndex, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$MangaProgressTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MangaProgressTableTable,
    MangaProgressTableData,
    $$MangaProgressTableTableFilterComposer,
    $$MangaProgressTableTableOrderingComposer,
    $$MangaProgressTableTableAnnotationComposer,
    $$MangaProgressTableTableCreateCompanionBuilder,
    $$MangaProgressTableTableUpdateCompanionBuilder,
    (
      MangaProgressTableData,
      BaseReferences<_$AppDatabase, $MangaProgressTableTable,
          MangaProgressTableData>
    ),
    MangaProgressTableData,
    PrefetchHooks Function()> {
  $$MangaProgressTableTableTableManager(
      _$AppDatabase db, $MangaProgressTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MangaProgressTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MangaProgressTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MangaProgressTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> mangaId = const Value.absent(),
            Value<String?> chapterId = const Value.absent(),
            Value<int> pageIndex = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MangaProgressTableCompanion(
            mangaId: mangaId,
            chapterId: chapterId,
            pageIndex: pageIndex,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String mangaId,
            Value<String?> chapterId = const Value.absent(),
            Value<int> pageIndex = const Value.absent(),
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              MangaProgressTableCompanion.insert(
            mangaId: mangaId,
            chapterId: chapterId,
            pageIndex: pageIndex,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MangaProgressTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MangaProgressTableTable,
    MangaProgressTableData,
    $$MangaProgressTableTableFilterComposer,
    $$MangaProgressTableTableOrderingComposer,
    $$MangaProgressTableTableAnnotationComposer,
    $$MangaProgressTableTableCreateCompanionBuilder,
    $$MangaProgressTableTableUpdateCompanionBuilder,
    (
      MangaProgressTableData,
      BaseReferences<_$AppDatabase, $MangaProgressTableTable,
          MangaProgressTableData>
    ),
    MangaProgressTableData,
    PrefetchHooks Function()>;
typedef $$ReadChaptersTableTableCreateCompanionBuilder
    = ReadChaptersTableCompanion Function({
  required String mangaId,
  required String chapterId,
  required DateTime readAt,
  Value<int> rowid,
});
typedef $$ReadChaptersTableTableUpdateCompanionBuilder
    = ReadChaptersTableCompanion Function({
  Value<String> mangaId,
  Value<String> chapterId,
  Value<DateTime> readAt,
  Value<int> rowid,
});

class $$ReadChaptersTableTableFilterComposer
    extends Composer<_$AppDatabase, $ReadChaptersTableTable> {
  $$ReadChaptersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get mangaId => $composableBuilder(
      column: $table.mangaId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get chapterId => $composableBuilder(
      column: $table.chapterId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get readAt => $composableBuilder(
      column: $table.readAt, builder: (column) => ColumnFilters(column));
}

class $$ReadChaptersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ReadChaptersTableTable> {
  $$ReadChaptersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get mangaId => $composableBuilder(
      column: $table.mangaId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get chapterId => $composableBuilder(
      column: $table.chapterId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get readAt => $composableBuilder(
      column: $table.readAt, builder: (column) => ColumnOrderings(column));
}

class $$ReadChaptersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReadChaptersTableTable> {
  $$ReadChaptersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get mangaId =>
      $composableBuilder(column: $table.mangaId, builder: (column) => column);

  GeneratedColumn<String> get chapterId =>
      $composableBuilder(column: $table.chapterId, builder: (column) => column);

  GeneratedColumn<DateTime> get readAt =>
      $composableBuilder(column: $table.readAt, builder: (column) => column);
}

class $$ReadChaptersTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ReadChaptersTableTable,
    ReadChaptersTableData,
    $$ReadChaptersTableTableFilterComposer,
    $$ReadChaptersTableTableOrderingComposer,
    $$ReadChaptersTableTableAnnotationComposer,
    $$ReadChaptersTableTableCreateCompanionBuilder,
    $$ReadChaptersTableTableUpdateCompanionBuilder,
    (
      ReadChaptersTableData,
      BaseReferences<_$AppDatabase, $ReadChaptersTableTable,
          ReadChaptersTableData>
    ),
    ReadChaptersTableData,
    PrefetchHooks Function()> {
  $$ReadChaptersTableTableTableManager(
      _$AppDatabase db, $ReadChaptersTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReadChaptersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReadChaptersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReadChaptersTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> mangaId = const Value.absent(),
            Value<String> chapterId = const Value.absent(),
            Value<DateTime> readAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReadChaptersTableCompanion(
            mangaId: mangaId,
            chapterId: chapterId,
            readAt: readAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String mangaId,
            required String chapterId,
            required DateTime readAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ReadChaptersTableCompanion.insert(
            mangaId: mangaId,
            chapterId: chapterId,
            readAt: readAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ReadChaptersTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ReadChaptersTableTable,
    ReadChaptersTableData,
    $$ReadChaptersTableTableFilterComposer,
    $$ReadChaptersTableTableOrderingComposer,
    $$ReadChaptersTableTableAnnotationComposer,
    $$ReadChaptersTableTableCreateCompanionBuilder,
    $$ReadChaptersTableTableUpdateCompanionBuilder,
    (
      ReadChaptersTableData,
      BaseReferences<_$AppDatabase, $ReadChaptersTableTable,
          ReadChaptersTableData>
    ),
    ReadChaptersTableData,
    PrefetchHooks Function()>;
typedef $$ReadingModesTableTableCreateCompanionBuilder
    = ReadingModesTableCompanion Function({
  required String mangaId,
  required String mode,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$ReadingModesTableTableUpdateCompanionBuilder
    = ReadingModesTableCompanion Function({
  Value<String> mangaId,
  Value<String> mode,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$ReadingModesTableTableFilterComposer
    extends Composer<_$AppDatabase, $ReadingModesTableTable> {
  $$ReadingModesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get mangaId => $composableBuilder(
      column: $table.mangaId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mode => $composableBuilder(
      column: $table.mode, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$ReadingModesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ReadingModesTableTable> {
  $$ReadingModesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get mangaId => $composableBuilder(
      column: $table.mangaId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mode => $composableBuilder(
      column: $table.mode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ReadingModesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReadingModesTableTable> {
  $$ReadingModesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get mangaId =>
      $composableBuilder(column: $table.mangaId, builder: (column) => column);

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ReadingModesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ReadingModesTableTable,
    ReadingModesTableData,
    $$ReadingModesTableTableFilterComposer,
    $$ReadingModesTableTableOrderingComposer,
    $$ReadingModesTableTableAnnotationComposer,
    $$ReadingModesTableTableCreateCompanionBuilder,
    $$ReadingModesTableTableUpdateCompanionBuilder,
    (
      ReadingModesTableData,
      BaseReferences<_$AppDatabase, $ReadingModesTableTable,
          ReadingModesTableData>
    ),
    ReadingModesTableData,
    PrefetchHooks Function()> {
  $$ReadingModesTableTableTableManager(
      _$AppDatabase db, $ReadingModesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReadingModesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReadingModesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReadingModesTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> mangaId = const Value.absent(),
            Value<String> mode = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReadingModesTableCompanion(
            mangaId: mangaId,
            mode: mode,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String mangaId,
            required String mode,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ReadingModesTableCompanion.insert(
            mangaId: mangaId,
            mode: mode,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ReadingModesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ReadingModesTableTable,
    ReadingModesTableData,
    $$ReadingModesTableTableFilterComposer,
    $$ReadingModesTableTableOrderingComposer,
    $$ReadingModesTableTableAnnotationComposer,
    $$ReadingModesTableTableCreateCompanionBuilder,
    $$ReadingModesTableTableUpdateCompanionBuilder,
    (
      ReadingModesTableData,
      BaseReferences<_$AppDatabase, $ReadingModesTableTable,
          ReadingModesTableData>
    ),
    ReadingModesTableData,
    PrefetchHooks Function()>;
typedef $$MangaTableTableCreateCompanionBuilder = MangaTableCompanion Function({
  required String id,
  required String title,
  Value<String?> coverFileName,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$MangaTableTableUpdateCompanionBuilder = MangaTableCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String?> coverFileName,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$MangaTableTableFilterComposer
    extends Composer<_$AppDatabase, $MangaTableTable> {
  $$MangaTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get coverFileName => $composableBuilder(
      column: $table.coverFileName, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$MangaTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MangaTableTable> {
  $$MangaTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get coverFileName => $composableBuilder(
      column: $table.coverFileName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$MangaTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MangaTableTable> {
  $$MangaTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get coverFileName => $composableBuilder(
      column: $table.coverFileName, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$MangaTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MangaTableTable,
    MangaTableData,
    $$MangaTableTableFilterComposer,
    $$MangaTableTableOrderingComposer,
    $$MangaTableTableAnnotationComposer,
    $$MangaTableTableCreateCompanionBuilder,
    $$MangaTableTableUpdateCompanionBuilder,
    (
      MangaTableData,
      BaseReferences<_$AppDatabase, $MangaTableTable, MangaTableData>
    ),
    MangaTableData,
    PrefetchHooks Function()> {
  $$MangaTableTableTableManager(_$AppDatabase db, $MangaTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MangaTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MangaTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MangaTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> coverFileName = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MangaTableCompanion(
            id: id,
            title: title,
            coverFileName: coverFileName,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            Value<String?> coverFileName = const Value.absent(),
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              MangaTableCompanion.insert(
            id: id,
            title: title,
            coverFileName: coverFileName,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MangaTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MangaTableTable,
    MangaTableData,
    $$MangaTableTableFilterComposer,
    $$MangaTableTableOrderingComposer,
    $$MangaTableTableAnnotationComposer,
    $$MangaTableTableCreateCompanionBuilder,
    $$MangaTableTableUpdateCompanionBuilder,
    (
      MangaTableData,
      BaseReferences<_$AppDatabase, $MangaTableTable, MangaTableData>
    ),
    MangaTableData,
    PrefetchHooks Function()>;
typedef $$ChaptersTableTableCreateCompanionBuilder = ChaptersTableCompanion
    Function({
  required String id,
  required String mangaId,
  Value<String?> chapterNumber,
  Value<String?> title,
  Value<String?> language,
  Value<String?> scanlationGroupId,
  Value<String?> scanlationGroupName,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$ChaptersTableTableUpdateCompanionBuilder = ChaptersTableCompanion
    Function({
  Value<String> id,
  Value<String> mangaId,
  Value<String?> chapterNumber,
  Value<String?> title,
  Value<String?> language,
  Value<String?> scanlationGroupId,
  Value<String?> scanlationGroupName,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$ChaptersTableTableFilterComposer
    extends Composer<_$AppDatabase, $ChaptersTableTable> {
  $$ChaptersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mangaId => $composableBuilder(
      column: $table.mangaId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get chapterNumber => $composableBuilder(
      column: $table.chapterNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scanlationGroupId => $composableBuilder(
      column: $table.scanlationGroupId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scanlationGroupName => $composableBuilder(
      column: $table.scanlationGroupName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$ChaptersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ChaptersTableTable> {
  $$ChaptersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mangaId => $composableBuilder(
      column: $table.mangaId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get chapterNumber => $composableBuilder(
      column: $table.chapterNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scanlationGroupId => $composableBuilder(
      column: $table.scanlationGroupId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scanlationGroupName => $composableBuilder(
      column: $table.scanlationGroupName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ChaptersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChaptersTableTable> {
  $$ChaptersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get mangaId =>
      $composableBuilder(column: $table.mangaId, builder: (column) => column);

  GeneratedColumn<String> get chapterNumber => $composableBuilder(
      column: $table.chapterNumber, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get scanlationGroupId => $composableBuilder(
      column: $table.scanlationGroupId, builder: (column) => column);

  GeneratedColumn<String> get scanlationGroupName => $composableBuilder(
      column: $table.scanlationGroupName, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ChaptersTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChaptersTableTable,
    ChaptersTableData,
    $$ChaptersTableTableFilterComposer,
    $$ChaptersTableTableOrderingComposer,
    $$ChaptersTableTableAnnotationComposer,
    $$ChaptersTableTableCreateCompanionBuilder,
    $$ChaptersTableTableUpdateCompanionBuilder,
    (
      ChaptersTableData,
      BaseReferences<_$AppDatabase, $ChaptersTableTable, ChaptersTableData>
    ),
    ChaptersTableData,
    PrefetchHooks Function()> {
  $$ChaptersTableTableTableManager(_$AppDatabase db, $ChaptersTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChaptersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChaptersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChaptersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> mangaId = const Value.absent(),
            Value<String?> chapterNumber = const Value.absent(),
            Value<String?> title = const Value.absent(),
            Value<String?> language = const Value.absent(),
            Value<String?> scanlationGroupId = const Value.absent(),
            Value<String?> scanlationGroupName = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChaptersTableCompanion(
            id: id,
            mangaId: mangaId,
            chapterNumber: chapterNumber,
            title: title,
            language: language,
            scanlationGroupId: scanlationGroupId,
            scanlationGroupName: scanlationGroupName,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String mangaId,
            Value<String?> chapterNumber = const Value.absent(),
            Value<String?> title = const Value.absent(),
            Value<String?> language = const Value.absent(),
            Value<String?> scanlationGroupId = const Value.absent(),
            Value<String?> scanlationGroupName = const Value.absent(),
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ChaptersTableCompanion.insert(
            id: id,
            mangaId: mangaId,
            chapterNumber: chapterNumber,
            title: title,
            language: language,
            scanlationGroupId: scanlationGroupId,
            scanlationGroupName: scanlationGroupName,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ChaptersTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ChaptersTableTable,
    ChaptersTableData,
    $$ChaptersTableTableFilterComposer,
    $$ChaptersTableTableOrderingComposer,
    $$ChaptersTableTableAnnotationComposer,
    $$ChaptersTableTableCreateCompanionBuilder,
    $$ChaptersTableTableUpdateCompanionBuilder,
    (
      ChaptersTableData,
      BaseReferences<_$AppDatabase, $ChaptersTableTable, ChaptersTableData>
    ),
    ChaptersTableData,
    PrefetchHooks Function()>;
typedef $$DownloadJobsTableTableCreateCompanionBuilder
    = DownloadJobsTableCompanion Function({
  required String chapterId,
  required String mangaId,
  required String status,
  Value<int> progress,
  Value<int> downloadedBytes,
  Value<int?> totalBytes,
  Value<String?> errorMessage,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$DownloadJobsTableTableUpdateCompanionBuilder
    = DownloadJobsTableCompanion Function({
  Value<String> chapterId,
  Value<String> mangaId,
  Value<String> status,
  Value<int> progress,
  Value<int> downloadedBytes,
  Value<int?> totalBytes,
  Value<String?> errorMessage,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$DownloadJobsTableTableFilterComposer
    extends Composer<_$AppDatabase, $DownloadJobsTableTable> {
  $$DownloadJobsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get chapterId => $composableBuilder(
      column: $table.chapterId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mangaId => $composableBuilder(
      column: $table.mangaId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get progress => $composableBuilder(
      column: $table.progress, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get downloadedBytes => $composableBuilder(
      column: $table.downloadedBytes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalBytes => $composableBuilder(
      column: $table.totalBytes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get errorMessage => $composableBuilder(
      column: $table.errorMessage, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$DownloadJobsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DownloadJobsTableTable> {
  $$DownloadJobsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get chapterId => $composableBuilder(
      column: $table.chapterId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mangaId => $composableBuilder(
      column: $table.mangaId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get progress => $composableBuilder(
      column: $table.progress, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get downloadedBytes => $composableBuilder(
      column: $table.downloadedBytes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalBytes => $composableBuilder(
      column: $table.totalBytes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get errorMessage => $composableBuilder(
      column: $table.errorMessage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$DownloadJobsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DownloadJobsTableTable> {
  $$DownloadJobsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get chapterId =>
      $composableBuilder(column: $table.chapterId, builder: (column) => column);

  GeneratedColumn<String> get mangaId =>
      $composableBuilder(column: $table.mangaId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => column);

  GeneratedColumn<int> get downloadedBytes => $composableBuilder(
      column: $table.downloadedBytes, builder: (column) => column);

  GeneratedColumn<int> get totalBytes => $composableBuilder(
      column: $table.totalBytes, builder: (column) => column);

  GeneratedColumn<String> get errorMessage => $composableBuilder(
      column: $table.errorMessage, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DownloadJobsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DownloadJobsTableTable,
    DownloadJobsTableData,
    $$DownloadJobsTableTableFilterComposer,
    $$DownloadJobsTableTableOrderingComposer,
    $$DownloadJobsTableTableAnnotationComposer,
    $$DownloadJobsTableTableCreateCompanionBuilder,
    $$DownloadJobsTableTableUpdateCompanionBuilder,
    (
      DownloadJobsTableData,
      BaseReferences<_$AppDatabase, $DownloadJobsTableTable,
          DownloadJobsTableData>
    ),
    DownloadJobsTableData,
    PrefetchHooks Function()> {
  $$DownloadJobsTableTableTableManager(
      _$AppDatabase db, $DownloadJobsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DownloadJobsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DownloadJobsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DownloadJobsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> chapterId = const Value.absent(),
            Value<String> mangaId = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> progress = const Value.absent(),
            Value<int> downloadedBytes = const Value.absent(),
            Value<int?> totalBytes = const Value.absent(),
            Value<String?> errorMessage = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DownloadJobsTableCompanion(
            chapterId: chapterId,
            mangaId: mangaId,
            status: status,
            progress: progress,
            downloadedBytes: downloadedBytes,
            totalBytes: totalBytes,
            errorMessage: errorMessage,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String chapterId,
            required String mangaId,
            required String status,
            Value<int> progress = const Value.absent(),
            Value<int> downloadedBytes = const Value.absent(),
            Value<int?> totalBytes = const Value.absent(),
            Value<String?> errorMessage = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              DownloadJobsTableCompanion.insert(
            chapterId: chapterId,
            mangaId: mangaId,
            status: status,
            progress: progress,
            downloadedBytes: downloadedBytes,
            totalBytes: totalBytes,
            errorMessage: errorMessage,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DownloadJobsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DownloadJobsTableTable,
    DownloadJobsTableData,
    $$DownloadJobsTableTableFilterComposer,
    $$DownloadJobsTableTableOrderingComposer,
    $$DownloadJobsTableTableAnnotationComposer,
    $$DownloadJobsTableTableCreateCompanionBuilder,
    $$DownloadJobsTableTableUpdateCompanionBuilder,
    (
      DownloadJobsTableData,
      BaseReferences<_$AppDatabase, $DownloadJobsTableTable,
          DownloadJobsTableData>
    ),
    DownloadJobsTableData,
    PrefetchHooks Function()>;
typedef $$DownloadedPagesTableTableCreateCompanionBuilder
    = DownloadedPagesTableCompanion Function({
  required String chapterId,
  required int pageIndex,
  required String localPath,
  Value<int?> sizeBytes,
  Value<String?> checksum,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$DownloadedPagesTableTableUpdateCompanionBuilder
    = DownloadedPagesTableCompanion Function({
  Value<String> chapterId,
  Value<int> pageIndex,
  Value<String> localPath,
  Value<int?> sizeBytes,
  Value<String?> checksum,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$DownloadedPagesTableTableFilterComposer
    extends Composer<_$AppDatabase, $DownloadedPagesTableTable> {
  $$DownloadedPagesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get chapterId => $composableBuilder(
      column: $table.chapterId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get pageIndex => $composableBuilder(
      column: $table.pageIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get localPath => $composableBuilder(
      column: $table.localPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sizeBytes => $composableBuilder(
      column: $table.sizeBytes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get checksum => $composableBuilder(
      column: $table.checksum, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$DownloadedPagesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DownloadedPagesTableTable> {
  $$DownloadedPagesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get chapterId => $composableBuilder(
      column: $table.chapterId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get pageIndex => $composableBuilder(
      column: $table.pageIndex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localPath => $composableBuilder(
      column: $table.localPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sizeBytes => $composableBuilder(
      column: $table.sizeBytes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get checksum => $composableBuilder(
      column: $table.checksum, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$DownloadedPagesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DownloadedPagesTableTable> {
  $$DownloadedPagesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get chapterId =>
      $composableBuilder(column: $table.chapterId, builder: (column) => column);

  GeneratedColumn<int> get pageIndex =>
      $composableBuilder(column: $table.pageIndex, builder: (column) => column);

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<int> get sizeBytes =>
      $composableBuilder(column: $table.sizeBytes, builder: (column) => column);

  GeneratedColumn<String> get checksum =>
      $composableBuilder(column: $table.checksum, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DownloadedPagesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DownloadedPagesTableTable,
    DownloadedPagesTableData,
    $$DownloadedPagesTableTableFilterComposer,
    $$DownloadedPagesTableTableOrderingComposer,
    $$DownloadedPagesTableTableAnnotationComposer,
    $$DownloadedPagesTableTableCreateCompanionBuilder,
    $$DownloadedPagesTableTableUpdateCompanionBuilder,
    (
      DownloadedPagesTableData,
      BaseReferences<_$AppDatabase, $DownloadedPagesTableTable,
          DownloadedPagesTableData>
    ),
    DownloadedPagesTableData,
    PrefetchHooks Function()> {
  $$DownloadedPagesTableTableTableManager(
      _$AppDatabase db, $DownloadedPagesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DownloadedPagesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DownloadedPagesTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DownloadedPagesTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> chapterId = const Value.absent(),
            Value<int> pageIndex = const Value.absent(),
            Value<String> localPath = const Value.absent(),
            Value<int?> sizeBytes = const Value.absent(),
            Value<String?> checksum = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DownloadedPagesTableCompanion(
            chapterId: chapterId,
            pageIndex: pageIndex,
            localPath: localPath,
            sizeBytes: sizeBytes,
            checksum: checksum,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String chapterId,
            required int pageIndex,
            required String localPath,
            Value<int?> sizeBytes = const Value.absent(),
            Value<String?> checksum = const Value.absent(),
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              DownloadedPagesTableCompanion.insert(
            chapterId: chapterId,
            pageIndex: pageIndex,
            localPath: localPath,
            sizeBytes: sizeBytes,
            checksum: checksum,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DownloadedPagesTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $DownloadedPagesTableTable,
        DownloadedPagesTableData,
        $$DownloadedPagesTableTableFilterComposer,
        $$DownloadedPagesTableTableOrderingComposer,
        $$DownloadedPagesTableTableAnnotationComposer,
        $$DownloadedPagesTableTableCreateCompanionBuilder,
        $$DownloadedPagesTableTableUpdateCompanionBuilder,
        (
          DownloadedPagesTableData,
          BaseReferences<_$AppDatabase, $DownloadedPagesTableTable,
              DownloadedPagesTableData>
        ),
        DownloadedPagesTableData,
        PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SettingsTableTableTableManager get settingsTable =>
      $$SettingsTableTableTableManager(_db, _db.settingsTable);
  $$LibraryEntriesTableTableTableManager get libraryEntriesTable =>
      $$LibraryEntriesTableTableTableManager(_db, _db.libraryEntriesTable);
  $$MangaProgressTableTableTableManager get mangaProgressTable =>
      $$MangaProgressTableTableTableManager(_db, _db.mangaProgressTable);
  $$ReadChaptersTableTableTableManager get readChaptersTable =>
      $$ReadChaptersTableTableTableManager(_db, _db.readChaptersTable);
  $$ReadingModesTableTableTableManager get readingModesTable =>
      $$ReadingModesTableTableTableManager(_db, _db.readingModesTable);
  $$MangaTableTableTableManager get mangaTable =>
      $$MangaTableTableTableManager(_db, _db.mangaTable);
  $$ChaptersTableTableTableManager get chaptersTable =>
      $$ChaptersTableTableTableManager(_db, _db.chaptersTable);
  $$DownloadJobsTableTableTableManager get downloadJobsTable =>
      $$DownloadJobsTableTableTableManager(_db, _db.downloadJobsTable);
  $$DownloadedPagesTableTableTableManager get downloadedPagesTable =>
      $$DownloadedPagesTableTableTableManager(_db, _db.downloadedPagesTable);
}
