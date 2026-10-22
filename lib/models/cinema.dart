import 'package:movie_app/models/film.dart';

class Cinema {
  final String name;
  final List<Film> films;

  Cinema({this.name = '', this.films = const []});

  factory Cinema.fromJson(Map<String, dynamic> json) {
    return Cinema(
      name: json['name'] as String? ?? '',
      films: (json['films'] as List<dynamic>)
          .map<Film>((i) => Film.fromJson(i as Map<String, dynamic>))
          .toList(),
    );
  }
}
