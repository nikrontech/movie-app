import 'package:dart_date/dart_date.dart';

class DateUtil {
  static String formatDate(DateTime dt) {
    return dt.isSameDay(DateTime.now())
        ? dt.toIso8601String()
        : dt.setHour(0, 0, 0, 0, 0).toIso8601String();
  }

  static String getWeekDay(DateTime dt) {
    if (dt.weekday == DateTime.now().weekday) {
      return 'Today';
    } else if (dt.weekday == DateTime.now().addDays(1).weekday) {
      return 'Tomorrow';
    } else if (dt.weekday == 1) {
      return 'Monday';
    } else if (dt.weekday == 2) {
      return 'Tuesday';
    } else if (dt.weekday == 3) {
      return 'Wednesday';
    } else if (dt.weekday == 4) {
      return 'Thursday';
    } else if (dt.weekday == 5) {
      return 'Friday';
    } else if (dt.weekday == 6) {
      return 'Saturday';
    } else if (dt.weekday == 7) {
      return 'Sunday';
    } else {
      return '';
    }
  }
}
