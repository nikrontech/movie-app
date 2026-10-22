class Conf {
//  urls
  // Android emulators reach the host machine through 10.0.2.2.
  static const String apiUrl = 'http://10.0.2.2:8080';
  static const String getScheduleUrl = '%s/api/films?from=%s&to=%s&search=%s';
  static const String getImageUrl = '%s/api/media/image/%s';
  static const String getVideoUrl = '%s/api/media/video/%s';
}
