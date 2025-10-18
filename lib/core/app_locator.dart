import 'package:geolocator/geolocator.dart';

Future<Position> getCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Check if location services are enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error("Location services are disabled.");
  }

  // Check current permission
  permission = await Geolocator.checkPermission();

  // Request permission if denied
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permission denied.');
    }
  }

  // Handle permanently denied permission
  if (permission == LocationPermission.deniedForever) {
    await Geolocator.openAppSettings(); // Optional: direct user to settings
    return Future.error(
      'Location permission is permanently denied. Please enable it in settings.',
    );
  }

  // All good – get current position
  return await Geolocator.getCurrentPosition(
    locationSettings: LocationSettings(
      accuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 10), // Optional timeout
    ),
  );
}
