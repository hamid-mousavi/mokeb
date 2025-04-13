import 'package:just_audio/just_audio.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();

  Future<void> playAzan() async {
    try {
      await _player.setAsset('assets/audio/azan.mp3');
      await _player.play();
    } catch (e) {
      print("خطا در پخش اذان: $e");
    }
  }

  void stop() {
    _player.stop();
  }
}
