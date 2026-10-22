import 'package:dart_date/dart_date.dart';

class DateUtil {
  static String formatDate(DateTime dt) {
    String twoDigits(int value) => value.toString().padLeft(2, '0');

    return '${dt.year}-${twoDigits(dt.month)}-${twoDigits(dt.day)}';
  }

  static String getWeekDay(DateTime dt) {
    if (dt.weekday == DateTime.now().weekday) {
      return 'Šiandien';
    } else if (dt.weekday == DateTime.now().addDays(1).weekday) {
      return 'Rytoj';
    } else if (dt.weekday == 1) {
      return 'Pirmadienis';
    } else if (dt.weekday == 2) {
      return 'Antradienis';
    } else if (dt.weekday == 3) {
      return 'Trečiadienis';
    } else if (dt.weekday == 4) {
      return 'Ketvirtadienis';
    } else if (dt.weekday == 5) {
      return 'Penktadienis';
    } else if (dt.weekday == 6) {
      return 'Šeštadienis';
    } else if (dt.weekday == 7) {
      return 'Sekmadienis';
    } else {
      return '';
    }
  }
}
