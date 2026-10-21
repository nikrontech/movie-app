import 'package:movie_app/models/film.dart';

class Cinema {
  final String name;
  final List<Film> films;

  Cinema({this.name, this.films});

  factory Cinema.fromJson(Map<String, dynamic> json) {
    return Cinema(
      name: json['name'],
      films: json['films'].map<Film>((i) => Film.fromJson(i)).toList(),
    );
  }
}
