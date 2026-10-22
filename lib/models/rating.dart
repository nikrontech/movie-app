class Rating {
  final String? imdb;
  final String? metaScore;
  final String? rottenTomatoes;

  const Rating({this.imdb, this.metaScore, this.rottenTomatoes});

  factory Rating.fromJson(Map<String, dynamic> json) {
    final sources = json['sources'];
    String? rottenTomatoes = json['rottenTomatoes']?.toString();

    if (rottenTomatoes == null && sources is List) {
      for (final source in sources) {
        if (source is Map<String, dynamic> &&
            source['source']?.toString().toLowerCase().contains('rotten tomatoes') ==
                true) {
          rottenTomatoes = source['value']?.toString();
          break;
        }
      }
    }

    return Rating(
      imdb: (json['imdb'] ?? json['imdbRating'])?.toString(),
      metaScore: (json['metaScore'] ?? json['metascore'])?.toString(),
      rottenTomatoes: rottenTomatoes,
    );
  }

  bool isEmpty() {
    return imdb == null && metaScore == null && rottenTomatoes == null;
  }
}
