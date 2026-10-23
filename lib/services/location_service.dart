import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  static String? city;

  static Future<void> fetchLocation() async {
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

      Position? position = await Geolocator.getLastKnownPosition();
      position ??= await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 5),
        ),
      );

      final placemarks = await Geocoding().placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      final administrativeArea =
          placemarks.isEmpty ? null : placemarks.first.administrativeArea;
      const areaToCity = <String, String>{
        'Vilniaus apskritis': 'VILNIUS',
        'Klaipėdos apskritis': 'KLAIPEDA',
        'Kauno apskritis': 'KAUNAS',
        'Šiaulių apskritis': 'SIAULIAI',
      };
      city = areaToCity[administrativeArea];
      debugPrint('Current city: ${city ?? 'Unknown'}');
    } catch (error) {
      debugPrint('Could not determine current city: $error');
    }
  }
}
