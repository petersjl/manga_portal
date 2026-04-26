import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/manga.dart';

part 'library_provider.g.dart';

/// A lightweight record of a manga saved to the local library.
/// Stores only what is needed to render a cover grid without a network call.
class LibraryEntry {
  const LibraryEntry({
    required this.id,
    required this.title,
    this.coverFileName,
  });

  final String id;
  final String title;

  /// The cover filename used to reconstruct the CDN cover URL.
  final String? coverFileName;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'coverFileName': coverFileName,
      };

  factory LibraryEntry.fromJson(Map<String, dynamic> json) => LibraryEntry(
        id: json['id'] as String,
        title: json['title'] as String,
        coverFileName: json['coverFileName'] as String?,
      );

  factory LibraryEntry.fromManga(Manga manga) => LibraryEntry(
        id: manga.id,
        title: manga.attributes.titleFor('en'),
        coverFileName: manga.coverArt?.fileName,
      );

  /// Reconstructs a minimal [Manga] suitable for display in a [MangaCard].
  Manga toManga() => Manga(
        id: id,
        attributes: MangaAttributes(
          titles: {'en': title},
          descriptions: {},
        ),
        coverArt: coverFileName != null
            ? CoverArt(id: '', fileName: coverFileName)
            : null,
      );
}

@riverpod
class LibraryNotifier extends _$LibraryNotifier {
  static const _prefsKey = 'library_entries';

  @override
  Future<List<LibraryEntry>> build() async {
    final prefs = await SharedPreferences.getInstance();
    return _decode(prefs.getStringList(_prefsKey) ?? []);
  }

  /// Adds [manga] to the library. No-ops if already present.
  Future<void> addManga(Manga manga) async {
    final entries = await future;
    if (entries.any((e) => e.id == manga.id)) return;
    final updated = [...entries, LibraryEntry.fromManga(manga)];
    await _persist(updated);
    state = AsyncData(updated);
  }

  /// Removes the manga with [mangaId] from the library.
  Future<void> removeManga(String mangaId) async {
    final entries = await future;
    final updated = entries.where((e) => e.id != mangaId).toList();
    await _persist(updated);
    state = AsyncData(updated);
  }

  /// Returns true if [mangaId] is currently saved in the library.
  /// Reads synchronously from the current state; returns false while loading.
  bool isInLibrary(String mangaId) =>
      state.valueOrNull?.any((e) => e.id == mangaId) ?? false;

  static List<LibraryEntry> _decode(List<String> raw) => raw
      .map((s) => LibraryEntry.fromJson(jsonDecode(s) as Map<String, dynamic>))
      .toList();

  Future<void> _persist(List<LibraryEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _prefsKey,
      entries.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }
}
