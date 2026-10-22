import 'package:movie_app/models/rating.dart';
import 'package:movie_app/models/showing.dart';

class Film {
  final String id;
  final String title;
  final String foreignTitle;
  final String synopsis;
  final String director;
  final String cast;
  final String runningTime;
  final String age;
  final String year;
  final String thumbnail;
  final String poster;
  final String trailer;
  final String genre;
  final Rating rating;
  final List<Showing> showings;

  Film({
    this.id = '',
    this.title = '',
    this.foreignTitle = '',
    this.synopsis = '',
    this.director = '',
    this.cast = '',
    this.runningTime = '',
    this.age = '',
    this.year = '',
    this.thumbnail = '',
    this.poster = '',
    this.trailer = '',
    this.genre = '',
    this.rating = const Rating(),
    this.showings = const [],
  });

  factory Film.fromJson(Map<String, dynamic> json) {
    return Film(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      foreignTitle: json['foreignTitle'] as String? ?? '',
      synopsis: json['synopsis'] as String? ?? '',
      director: json['director'] as String? ?? '',
      cast: json['cast'] as String? ?? '',
      runningTime: json['runningTime'] as String? ?? '',
      age: json['age'] as String? ?? '',
      year: json['year'] as String? ?? '',
      thumbnail: json['thumbnail'] as String? ?? '',
      poster: json['poster'] as String? ?? '',
      trailer: json['trailer'] as String? ?? '',
      genre: json['genre'] as String? ?? '',
      rating: Rating.fromJson(json['rating'] as Map<String, dynamic>),
      showings: (json['showings'] as List<dynamic>)
          .map<Showing>((i) => Showing.fromJson(i as Map<String, dynamic>))
          .toList(),
    );
  }

  factory Film.fromBackendJson(
    Map<String, dynamic> json,
    List<Showing> showings,
  ) {
    final rating = json['rating'];
    final ageRating = json['ageRating'];
    final genres = json['genres'];
    final shortDescription = json['shortDescription']?.toString() ?? '';
    final description = json['description']?.toString() ?? '';

    return Film(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      foreignTitle: json['originalTitle'] as String? ?? '',
      synopsis: shortDescription.isNotEmpty ? shortDescription : description,
      director: json['director'] as String? ?? '',
      cast: json['cast'] as String? ?? '',
      runningTime: json['durationMinutes']?.toString() ?? '',
      age: ageRating is Map<String, dynamic>
          ? (ageRating['code'] ?? ageRating['name'])?.toString() ?? ''
          : ageRating?.toString() ?? '',
      year: json['releaseYear']?.toString() ?? '',
      genre: genres is List
          ? genres
              .map((genre) {
                if (genre is Map<String, dynamic>) {
                  return genre['name']?.toString() ?? '';
                }
                return genre.toString();
              })
              .where((genre) => genre.isNotEmpty)
              .join(', ')
          : '',
      thumbnail: json['thumbnailPath'] as String? ?? '',
      poster: json['posterPath'] as String? ?? '',
      trailer: json['trailerPath'] as String? ?? '',
      rating: rating is Map<String, dynamic>
          ? Rating.fromJson(rating)
          : const Rating(),
      showings: showings,
    );
  }

  List<String> getInfoList() {
    final List<String> infoList = [];

    if (year != null) infoList.add(year);
    if (runningTime != null) infoList.add(runningTime);
    if (age != null) infoList.add(age);

    return infoList;
  }
}
