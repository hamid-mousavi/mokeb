import 'dart:async';
import 'package:intl/intl.dart';

import 'audio_service.dart';

class AdhanCheckerService {
  final String adhanTimeStr;
  final AudioService audioService;

  AdhanCheckerService({required this.adhanTimeStr, required this.audioService});

  Timer? _timer;

  void startChecking() {
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      final now = DateTime.now();
      final formatter = DateFormat('HH:mm');
      final currentTimeStr = formatter.format(now);

      if (currentTimeStr == adhanTimeStr) {
        audioService.playAzan();
      }
    });
  }

  void stopChecking() {
    _timer?.cancel();
  }
}
