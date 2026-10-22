import 'package:movie_app/models/cinema.dart';

class Schedule {
  final List<Cinema> cinemas;

  Schedule({this.cinemas = const []});

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      cinemas: (json['cinemas'] as List<dynamic>)
          .map<Cinema>((i) => Cinema.fromJson(i as Map<String, dynamic>))
          .toList(),
    );
  }
}
