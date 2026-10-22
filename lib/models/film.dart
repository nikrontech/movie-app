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
    this.id = '', this.title = '', this.foreignTitle = '', this.synopsis = '',
    this.director = '', this.cast = '', this.runningTime = '', this.age = '',
    this.year = '', this.thumbnail = '', this.poster = '', this.trailer = '',
    this.genre = '', this.rating = const Rating(), this.showings = const [],
  });

  factory Film.fromJson(Map<String, dynamic> json) {
    return Film(
      id: json['id'] as String? ?? '', title: json['title'] as String? ?? '',
      foreignTitle: json['foreignTitle'] as String? ?? '',
      synopsis: json['synopsis'] as String? ?? '',
      director: json['director'] as String? ?? '', cast: json['cast'] as String? ?? '',
      runningTime: json['runningTime'] as String? ?? '', age: json['age'] as String? ?? '',
      year: json['year'] as String? ?? '', thumbnail: json['thumbnail'] as String? ?? '',
      poster: json['poster'] as String? ?? '', trailer: json['trailer'] as String? ?? '',
      genre: json['genre'] as String? ?? '',
      rating: Rating.fromJson(json['rating'] as Map<String, dynamic>),
      showings: (json['showings'] as List<dynamic>)
          .map<Showing>((i) => Showing.fromJson(i as Map<String, dynamic>)).toList(),
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
