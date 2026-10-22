import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<void> logCurrentCity() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        debugPrint('Location service is disabled');
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        debugPrint('Location permission was not granted');
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
        ),
      );
      final placemarks = await Geocoding().placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      final administrativeArea = placemarks.isEmpty
          ? null
          : placemarks.first.administrativeArea;

      debugPrint(
        'Current administrative area: ${administrativeArea ?? 'Unknown'}',
      );
    } catch (error) {
      debugPrint('Could not determine current city: $error');
    }
  }
}
