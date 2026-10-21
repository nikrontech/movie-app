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
    this.id,
    this.title,
    this.foreignTitle,
    this.synopsis,
    this.director,
    this.cast,
    this.runningTime,
    this.age,
    this.year,
    this.thumbnail,
    this.poster,
    this.trailer,
    this.genre,
    this.rating,
    this.showings,
  });

  factory Film.fromJson(Map<String, dynamic> json) {
    return Film(
      id: json['id'],
      title: json['title'],
      foreignTitle: json['foreignTitle'],
      synopsis: json['synopsis'],
      director: json['director'],
      cast: json['cast'],
      runningTime: json['runningTime'],
      age: json['age'],
      year: json['year'],
      thumbnail: json['thumbnail'],
      poster: json['poster'],
      trailer: json['trailer'],
      genre: json['genre'],
      rating: Rating.fromJson(json['rating']),
      showings: json['showings'].map<Showing>((i) => Showing.fromJson(i)).toList(),
    );
  }

  List getInfoList() {
    final List infoList = [];

    if (year != null) infoList.add(year);
    if (runningTime != null) infoList.add(runningTime);
    if (age != null) infoList.add(age);

    return infoList;
  }
}
