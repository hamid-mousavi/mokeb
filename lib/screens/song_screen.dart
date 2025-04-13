import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class SongScreen extends StatefulWidget {
  final String audioUrl;
  final String title;
  final String artist;
  final String coverImage;

  const SongScreen({
    Key? key,
    required this.audioUrl,
    required this.title,
    required this.artist,
    required this.coverImage,
  }) : super(key: key);

  @override
  _SongScreenState createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {
  late AudioPlayer _audioPlayer;
  double _currentPosition = 0;
  double _duration = 0;
  bool _isPlaying = false;
  bool _isLoading = true;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initAudioPlayer();
  }

  Future<void> _initAudioPlayer() async {
    try {
      // Setup event listeners
      _audioPlayer.playerStateStream.listen(_updatePlayerState);
      _audioPlayer.positionStream.listen(_updatePosition);
      _audioPlayer.durationStream.listen(_updateDuration);

      // Set audio source
      await _audioPlayer.setUrl(widget.audioUrl);

      setState(() {
        _isInitialized = true;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('Error initializing audio player: $e');
    }
  }

  void _updatePlayerState(PlayerState state) {
    if (mounted) {
      setState(() {
        _isPlaying = state.playing;
      });
    }
  }

  void _updatePosition(Duration position) {
    if (mounted) {
      setState(() {
        _currentPosition = position.inMilliseconds.toDouble();
      });
    }
  }

  void _updateDuration(Duration? duration) {
    if (duration != null && mounted) {
      setState(() {
        _duration = duration.inMilliseconds.toDouble();
      });
    }
  }

  Future<void> _togglePlayback() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
  }

  Future<void> _seekAudio(double value) async {
    await _audioPlayer.seek(Duration(milliseconds: value.toInt()));
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Album Art
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: NetworkImage(widget.coverImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Song Info
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.artist,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 30),

            // Progress Bar
            if (_isLoading)
              const LinearProgressIndicator()
            else
              Column(
                children: [
                  Slider(
                    value: _currentPosition.clamp(0, _duration),
                    max: _duration,
                    onChanged: _isInitialized ? _seekAudio : null,
                    activeColor: Colors.blue,
                    inactiveColor: Colors.grey[300],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatTime(_currentPosition)),
                        Text(_formatTime(_duration)),
                      ],
                    ),
                  ),
                ],
              ),

            const Spacer(),

            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous, size: 36),
                  onPressed: () {},
                ),
                const SizedBox(width: 30),
                IconButton(
                  icon: Icon(
                    _isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_filled,
                    size: 56,
                    color: Colors.blue,
                  ),
                  onPressed: _isInitialized ? _togglePlayback : null,
                ),
                const SizedBox(width: 30),
                IconButton(
                  icon: const Icon(Icons.skip_next, size: 36),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(double milliseconds) {
    Duration duration = Duration(milliseconds: milliseconds.toInt());
    return "${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}";
  }
}
