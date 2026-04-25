class CoverArt {
  const CoverArt({required this.id, this.fileName});

  final String id;
  final String? fileName;
}

class MangaAttributes {
  const MangaAttributes({
    required this.titles,
    required this.descriptions,
    this.status,
  });

  final Map<String, String> titles;
  final Map<String, String> descriptions;
  final String? status;

  factory MangaAttributes.fromJson(Map<String, dynamic> json) {
    return MangaAttributes(
      titles: _toStringMap(json['title']),
      descriptions: _toStringMap(json['description']),
      status: json['status'] as String?,
    );
  }

  static Map<String, String> _toStringMap(dynamic value) {
    if (value is! Map) return {};
    return Map<String, String>.fromEntries(
      value.entries
          .where((e) => e.value is String)
          .map((e) => MapEntry(e.key as String, e.value as String)),
    );
  }

  /// Returns the title for [locale], falling back to English, then any title.
  String titleFor(String locale) =>
      titles[locale] ?? titles['en'] ?? titles.values.firstOrNull ?? '';

  /// Returns the description for [locale], falling back to English, then any.
  String descriptionFor(String locale) =>
      descriptions[locale] ??
      descriptions['en'] ??
      descriptions.values.firstOrNull ??
      '';

  Map<String, dynamic> toJson() => {
        'title': titles,
        'description': descriptions,
        'status': status,
      };
}

class Manga {
  const Manga({required this.id, required this.attributes, this.coverArt});

  final String id;
  final MangaAttributes attributes;
  final CoverArt? coverArt;

  factory Manga.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return Manga._fromData(data);
  }

  /// Parses a single item from a collection response (no `data` envelope).
  factory Manga.fromListItem(Map<String, dynamic> item) =>
      Manga._fromData(item);

  factory Manga._fromData(Map<String, dynamic> data) {
    final relationships = (data['relationships'] as List<dynamic>?)
            ?.cast<Map<String, dynamic>>() ??
        [];

    CoverArt? coverArt;
    for (final rel in relationships) {
      if (rel['type'] == 'cover_art') {
        final attrs = rel['attributes'] as Map<String, dynamic>?;
        coverArt = CoverArt(
          id: rel['id'] as String,
          fileName: attrs?['fileName'] as String?,
        );
        break;
      }
    }

    return Manga(
      id: data['id'] as String,
      attributes:
          MangaAttributes.fromJson(data['attributes'] as Map<String, dynamic>),
      coverArt: coverArt,
    );
  }

  /// Returns a CDN cover URL at [size]px width, or null if no cover is attached.
  String? coverUrl(int size) {
    final f = coverArt?.fileName;
    if (f == null) return null;
    return 'https://uploads.mangadex.org/covers/$id/$f.$size.jpg';
  }

  Map<String, dynamic> toJson() => {
        'data': {
          'id': id,
          'type': 'manga',
          'attributes': attributes.toJson(),
          'relationships': coverArt != null
              ? [
                  {
                    'id': coverArt!.id,
                    'type': 'cover_art',
                    'attributes': {'fileName': coverArt!.fileName},
                  }
                ]
              : [],
        }
      };
}
