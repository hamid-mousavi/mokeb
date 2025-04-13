import 'package:intl/intl.dart';
import 'package:mokeb/core/services/adhan_service.dart';
import 'package:mokeb/models/prayer_time_model.dart';

class NextAzan {
  final String name;
  final DateTime time;

  NextAzan({required this.name, required this.time});
}

NextAzan getNextAzan(PrayerTimeModel model) {
  final now = DateTime.now();

  final format = DateFormat("HH:mm");

  final List<NextAzan> azans = [
    NextAzan(name: "اذان صبح", time: _parseTodayTime(model.fajr, format)),
    NextAzan(name: "اذان ظهر", time: _parseTodayTime(model.dhuhr, format)),
    NextAzan(name: "اذان عصر", time: _parseTodayTime(model.asr, format)),
    NextAzan(name: "اذان مغرب", time: _parseTodayTime(model.maghrib, format)),
    NextAzan(name: "اذان عشاء", time: _parseTodayTime(model.isha, format)),
  ];

  final futureAzans = azans.where((a) => a.time.isAfter(now)).toList();
  futureAzans.sort((a, b) => a.time.compareTo(b.time));

  if (futureAzans.isNotEmpty) {
    return futureAzans.first;
  } else {
    // اگه همه اذان‌های امروز گذشته بودن، اذان فردا صبح رو نشون بده
    final tomorrowFajr = _parseTodayTime(model.fajr, format)
        .add(const Duration(days: 1));
    return NextAzan(name: "اذان صبح (فردا)", time: tomorrowFajr);
  }
}

DateTime _parseTodayTime(String timeStr, DateFormat format) {
  final parsedTime = format.parse(timeStr);
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day, parsedTime.hour, parsedTime.minute);
}
