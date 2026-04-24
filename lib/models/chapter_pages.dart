class ChapterPages {
  const ChapterPages({
    required this.hash,
    required this.data,
    required this.dataSaver,
  });

  final String hash;
  final List<String> data;
  final List<String> dataSaver;

  factory ChapterPages.fromJson(Map<String, dynamic> json) {
    return ChapterPages(
      hash: json['hash'] as String,
      data: List<String>.from(json['data'] as List),
      dataSaver: List<String>.from(json['dataSaver'] as List),
    );
  }
}

class AtHomeServer {
  const AtHomeServer({
    required this.baseUrl,
    required this.chapter,
  });

  final String baseUrl;
  final ChapterPages chapter;

  factory AtHomeServer.fromJson(Map<String, dynamic> json) {
    return AtHomeServer(
      baseUrl: json['baseUrl'] as String,
      chapter: ChapterPages.fromJson(json['chapter'] as Map<String, dynamic>),
    );
  }

  String pageUrl(String filename, {bool dataSaver = false}) {
    final quality = dataSaver ? 'data-saver' : 'data';
    return '$baseUrl/$quality/${chapter.hash}/$filename';
  }

  bool get isThirdParty => !baseUrl.contains('mangadex.org');
}
