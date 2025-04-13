import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mokeb/models/prayer_time_model.dart';

class AdhanService {
  Future<PrayerTimeModel> getPrayerTimes(double lat, double lng) async {
    final url = Uri.parse(
        'https://api.aladhan.com/v1/timings?latitude=$lat&longitude=$lng&method=8');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return PrayerTimeModel.fromJson(json['data']['timings']);
    } else {
      throw Exception('دریافت زمان اذان ناموفق بود');
    }
  }
}
