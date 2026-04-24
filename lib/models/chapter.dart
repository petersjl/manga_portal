class ScanlationGroup {
  const ScanlationGroup({required this.id, required this.name});

  final String id;
  final String name;
}

class ChapterAttributes {
  const ChapterAttributes({
    this.volume,
    this.chapterNumber,
    this.title,
    required this.translatedLanguage,
    this.publishAt,
    required this.pages,
  });

  final String? volume;

  /// The chapter number. MUST be String? — can be null (oneshots), a decimal
  /// string like "1.5" (bonus chapters), or absent. Never parsed as a number.
  final String? chapterNumber;

  final String? title;
  final String translatedLanguage;
  final String? publishAt;
  final int pages;

  factory ChapterAttributes.fromJson(Map<String, dynamic> json) {
    return ChapterAttributes(
      volume: json['volume'] as String?,
      chapterNumber: json['chapter'] as String?,
      title: json['title'] as String?,
      translatedLanguage: json['translatedLanguage'] as String,
      publishAt: json['publishAt'] as String?,
      pages: json['pages'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'volume': volume,
        'chapter': chapterNumber,
        'title': title,
        'translatedLanguage': translatedLanguage,
        'publishAt': publishAt,
        'pages': pages,
      };
}

class Chapter {
  const Chapter({
    required this.id,
    required this.attributes,
    this.scanlationGroup,
  });

  final String id;
  final ChapterAttributes attributes;
  final ScanlationGroup? scanlationGroup;

  factory Chapter.fromJson(Map<String, dynamic> json) {
    final relationships = (json['relationships'] as List<dynamic>?)
            ?.cast<Map<String, dynamic>>() ??
        [];

    ScanlationGroup? group;
    for (final rel in relationships) {
      if (rel['type'] == 'scanlation_group') {
        final attrs = rel['attributes'] as Map<String, dynamic>?;
        group = ScanlationGroup(
          id: rel['id'] as String,
          name: attrs?['name'] as String? ?? 'Unknown Group',
        );
        break;
      }
    }

    return Chapter(
      id: json['id'] as String,
      attributes: ChapterAttributes.fromJson(
          json['attributes'] as Map<String, dynamic>),
      scanlationGroup: group,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': 'chapter',
        'attributes': attributes.toJson(),
        'relationships': scanlationGroup != null
            ? [
                {
                  'id': scanlationGroup!.id,
                  'type': 'scanlation_group',
                  'attributes': {'name': scanlationGroup!.name},
                }
              ]
            : [],
      };
}
