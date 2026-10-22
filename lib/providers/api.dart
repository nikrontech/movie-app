import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie_app/conf.dart';
import 'package:movie_app/models/film.dart';
import 'package:movie_app/models/schedule.dart';
import 'package:movie_app/models/showing.dart';
import 'package:movie_app/services/location_service.dart';
import 'package:movie_app/utils/date_util.dart';
import 'package:sprintf/sprintf.dart';

class Api {
  static String getScheduleUrl(
      DateTime dateFrom, DateTime dateTo, String title) {
    return sprintf(Conf.getScheduleUrl, [
      Conf.apiUrl,
      DateUtil.formatDateTime(dateFrom),
      DateUtil.formatDateTime(dateTo),
      title
    ]);
  }

  static String getImageUrl(String filename) {
    return sprintf(Conf.getImageUrl, [
      Conf.apiUrl,
      filename,
    ]);
  }

  static String getVideoUrl(String filename) {
    return sprintf(Conf.getVideoUrl, [
      Conf.apiUrl,
      filename,
    ]);
  }

  static Future<Schedule> fetchSchedule({
    required DateTime dateFrom,
    DateTime? dateTo,
    String? searchText,
    String? city,
  }) async {
    final effectiveDateFrom = _startOfRequestedDay(dateFrom);
    final effectiveDateTo = dateTo ??
        DateTime(
          effectiveDateFrom.year,
          effectiveDateFrom.month,
          effectiveDateFrom.day,
          23,
          59,
          59,
          999,
        );
    var url = getScheduleUrl(
      effectiveDateFrom,
      effectiveDateTo,
      searchText ?? '',
    );
    final selectedCity = city ?? LocationService.city;
    if (selectedCity != null && selectedCity.isNotEmpty) {
      url += '&city=${Uri.encodeQueryComponent(selectedCity)}';
    }
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final decoded = json.decode(utf8.decode(response.bodyBytes));
      final films = decoded is List
          ? decoded.whereType<Map<String, dynamic>>().toList()
          : <Map<String, dynamic>>[];
      return _toSchedule(films);
    }

    throw Exception('Failed to fetch schedule');
  }

  static DateTime _startOfRequestedDay(DateTime date) {
    final now = DateTime.now();
    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;

    return isToday ? date : DateTime(date.year, date.month, date.day);
  }

  static Future<Film> fetchFilm({
    required String id,
    String? city,
  }) async {
    var url = '${Conf.apiUrl}/api/films/${Uri.encodeComponent(id)}';
    final selectedCity = city ?? LocationService.city;
    if (selectedCity != null && selectedCity.isNotEmpty) {
      url += '?city=${Uri.encodeQueryComponent(selectedCity)}';
    }
    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch film');
    }

    final filmJson =
        json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    final screenings = (filmJson['screenings'] as List? ?? [])
        .whereType<Map<String, dynamic>>()
        .map((screening) => Showing.fromBackendJson(screening))
        .toList();
    return Film.fromBackendJson(filmJson, screenings);
  }

  static Schedule _toSchedule(List<Map<String, dynamic>> films) {
    final scheduleFilms = <Film>[];

    for (final filmJson in films) {
      final screenings = (filmJson['screenings'] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .toList();
      if (screenings.isNotEmpty) {
        scheduleFilms.add(Film.fromBackendJson(
          filmJson,
          screenings
              .map((screening) => Showing.fromBackendJson(screening))
              .toList(),
        ));
      }
    }

    return Schedule(
      films: scheduleFilms,
    );
  }
}
