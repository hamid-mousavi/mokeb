import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
   Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

 static Future<String> getCityName(Position position) async {
  try {
    final placemarks = await placemarkFromCoordinates(
        position.latitude, position.longitude);

    if (placemarks.isNotEmpty) {
      final place = placemarks.first;
      final city = place.locality ?? place.subAdministrativeArea ?? place.administrativeArea;
      final country = place.country ?? "";
      return "${city ?? "نامشخص"}, $country";
    }
  } catch (e) {
    print("خطا در گرفتن نام شهر: $e");
  }

  return "موقعیت نامشخص";
}

 }
