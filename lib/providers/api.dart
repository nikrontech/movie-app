import 'dart:convert';

import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/conf.dart';
import 'package:movie_app/models/schedule.dart';
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
    @required DateTime dateFrom,
    DateTime dateTo,
    String searchText,
  }) async {
    final response = await http.get(
      Uri.parse(
        getScheduleUrl(dateFrom, dateTo ?? dateFrom.addDays(1), searchText),
      ),
    );

    if (response.statusCode == 200) {
      return Schedule.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    }

    throw Exception('Failed to fetch schedule');
  }
}
