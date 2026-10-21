class Rating {
  final String imdb;
  final String metaScore;
  final String rottenTomatoes;

  Rating({this.imdb, this.metaScore, this.rottenTomatoes});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      imdb: json['imdb'],
      metaScore: json['metaScore'],
      rottenTomatoes: json['rottenTomatoes'],
    );
  }

  bool isEmpty() {
    return imdb == null && metaScore == null && rottenTomatoes == null;
  }
}
