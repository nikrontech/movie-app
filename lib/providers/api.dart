import 'dart:convert';

import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/conf.dart';
import 'package:movie_app/models/schedule.dart';
import 'package:movie_app/models/cinema.dart';
import 'package:movie_app/models/film.dart';
import 'package:movie_app/models/showing.dart';
import 'package:movie_app/utils/date_util.dart';
import 'package:sprintf/sprintf.dart';

class Api {
  static String getScheduleUrl(
      DateTime dateFrom, DateTime dateTo, String title) {
    return sprintf(Conf.getScheduleUrl, [
      Conf.apiUrl,
      DateUtil.formatDate(dateFrom),
      DateUtil.formatDate(dateTo),
      title ?? ''
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
  }) async {
    final response = await http.get(Uri.parse(getScheduleUrl(
      dateFrom,
      dateTo ?? dateFrom.addDays(1),
      searchText ?? '',
    )));

    if (response.statusCode == 200) {
      final decoded = json.decode(utf8.decode(response.bodyBytes));
      final films = decoded is List
          ? decoded.whereType<Map<String, dynamic>>().toList()
          : <Map<String, dynamic>>[];
      return _toSchedule(films);
    }

    throw Exception('Failed to fetch schedule');
  }

  static Schedule _toSchedule(List<Map<String, dynamic>> films) {
    final grouped = <String, List<Film>>{};
    final cinemaNames = <String, String>{};

    for (final filmJson in films) {
      final screenings = (filmJson['screenings'] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .toList();
      final byCinema = <String, List<Showing>>{};

      for (final screening in screenings) {
        final cinema = screening['cinema'];
        if (cinema is! Map<String, dynamic>) continue;
        final key = (cinema['id'] ?? cinema['name'] ?? '').toString();
        if (key.isEmpty) continue;
        cinemaNames[key] = cinema['name']?.toString() ?? key;
        byCinema.putIfAbsent(key, () => []).add(
              Showing.fromBackendJson(screening),
            );
      }

      for (final entry in byCinema.entries) {
        grouped.putIfAbsent(entry.key, () => []).add(
              Film.fromBackendJson(filmJson, entry.value),
            );
      }
    }

    return Schedule(
      cinemas: grouped.entries
          .map((entry) => Cinema(
                name: cinemaNames[entry.key] ?? entry.key,
                films: entry.value,
              ))
          .toList(),
    );
  }
}
