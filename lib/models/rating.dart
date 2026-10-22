class Rating {
  final String? imdb;
  final String? metaScore;
  final String? rottenTomatoes;

  const Rating({this.imdb, this.metaScore, this.rottenTomatoes});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      imdb: json['imdb'] as String?,
      metaScore: json['metaScore'] as String?,
      rottenTomatoes: json['rottenTomatoes'] as String?,
    );
  }

  bool isEmpty() {
    return imdb == null && metaScore == null && rottenTomatoes == null;
  }
}
