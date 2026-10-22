class Rating {
  final String? imdb;
  final String? metaScore;
  final String? rottenTomatoes;

  const Rating({this.imdb, this.metaScore, this.rottenTomatoes});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      imdb: (json['imdb'] ?? json['imdbRating'])?.toString(),
      metaScore: (json['metaScore'] ?? json['metascore'])?.toString(),
      rottenTomatoes: json['rottenTomatoes']?.toString(),
    );
  }

  bool isEmpty() {
    return imdb == null && metaScore == null && rottenTomatoes == null;
  }
}
