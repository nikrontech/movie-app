import 'package:movie_app/models/cinema.dart';
import 'package:movie_app/models/film.dart';

class Schedule {
  final List<Cinema> cinemas;
  final List<Film> films;

  Schedule({this.cinemas = const [], this.films = const []});

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      cinemas: (json['cinemas'] as List<dynamic>)
          .map<Cinema>((i) => Cinema.fromJson(i as Map<String, dynamic>))
          .toList(),
    );
  }
}
