import 'package:movie_app/models/cinema.dart';

class Schedule {
  final List<Cinema> cinemas;

  Schedule({this.cinemas});

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      cinemas: json['cinemas'].map<Cinema>((i) => Cinema.fromJson(i)).toList(),
    );
  }
}
