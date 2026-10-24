import 'package:dart_date/dart_date.dart';
import 'package:movie_app/app_text.dart';

class DateUtil {
  static String formatDate(DateTime dt) {
    String twoDigits(int value) => value.toString().padLeft(2, '0');

    return '${dt.year}-${twoDigits(dt.month)}-${twoDigits(dt.day)}';
  }

  static String formatDateTime(DateTime dt) {
    String twoDigits(int value) => value.toString().padLeft(2, '0');

    return '${dt.year}-${twoDigits(dt.month)}-${twoDigits(dt.day)}'
        'T${twoDigits(dt.hour)}:${twoDigits(dt.minute)}:${twoDigits(dt.second)}';
  }

  static String getWeekDay(DateTime dt) {
    if (dt.weekday == DateTime.now().weekday) {
      return AppText.today;
    } else if (dt.weekday == DateTime.now().addDays(1).weekday) {
      return AppText.tomorrow;
    } else if (dt.weekday == 1) {
      return AppText.monday;
    } else if (dt.weekday == 2) {
      return AppText.tuesday;
    } else if (dt.weekday == 3) {
      return AppText.wednesday;
    } else if (dt.weekday == 4) {
      return AppText.thursday;
    } else if (dt.weekday == 5) {
      return AppText.friday;
    } else if (dt.weekday == 6) {
      return AppText.saturday;
    } else if (dt.weekday == 7) {
      return AppText.sunday;
    } else {
      return '';
    }
  }
}
