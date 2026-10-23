import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  static final navigatorKey = GlobalKey<NavigatorState>();
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
      debugPrint('Placemarks: $placemarks');
      _showPlacemarks(placemarks);
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

  static void _showPlacemarks(List<Placemark> placemarks) {
    final context = navigatorKey.currentState?.overlay?.context;
    if (context == null || placemarks.isEmpty) return;
    final details = placemarks.map((placemark) {
      return [
        'name: ${placemark.name}',
        'street: ${placemark.street}',
        'locality: ${placemark.locality}',
        'subLocality: ${placemark.subLocality}',
        'administrativeArea: ${placemark.administrativeArea}',
        'subAdministrativeArea: ${placemark.subAdministrativeArea}',
        'postalCode: ${placemark.postalCode}',
        'country: ${placemark.country}',
        'isoCountryCode: ${placemark.isoCountryCode}',
      ].join('\n');
    }).join('\n\n');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Location placemarks'),
          content: SingleChildScrollView(
            child: Text(details),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    });
  }
}
