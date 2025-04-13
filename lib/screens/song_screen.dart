import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mokeb/bloc/song/audio_bloc.dart';

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
  State<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {
  late final AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    _audioPlayer.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state.playing;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AudioBloc()..add(InitAudio(widget.audioUrl)),
      child: Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Album Art
              Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: NetworkImage(widget.coverImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Song Info
              Text(widget.title,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(widget.artist,
                  style: TextStyle(fontSize: 18, color: Colors.grey[600])),
              const SizedBox(height: 30),

              // Progress Bar
              BlocBuilder<AudioBloc, AudioState>(
                builder: (context, state) {
                  if (state is AudioLoading) {
                    return const LinearProgressIndicator();
                  } else if (state is AudioError) {
                    return Text(state.message,
                        style: TextStyle(color: Colors.red));
                  } else if (state is AudioReady ||
                      state is AudioPlaying ||
                      state is AudioPaused) {
                    final currentPosition = state is AudioReady
                        ? 0
                        : (state as dynamic).currentPosition;
                    final duration = state is AudioReady
                        ? state.duration
                        : (state as dynamic).duration;

                    return Column(
                      children: [
                        Slider(
                          value: currentPosition.clamp(0, duration),
                          max: duration,
                          onChanged: (value) {
                            context.read<AudioBloc>().add(SeekAudio(value));
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_formatTime(currentPosition)),
                              Text(_formatTime(duration)),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  return Container();
                },
              ),

              const Spacer(),

              // Controls
              BlocBuilder<AudioBloc, AudioState>(
                builder: (context, state) {
                  final isPlaying = state is AudioPlaying;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.skip_previous, size: 36),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 30),
                      IconButton(
                        icon: Icon(
                          isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_filled,
                          size: 56,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          isPlaying
                              ? context.read<AudioBloc>().add(PauseAudio())
                              : context.read<AudioBloc>().add(PlayAudio());
                        },
                      ),
                      const SizedBox(width: 30),
                      IconButton(
                        icon: const Icon(Icons.skip_next, size: 36),
                        onPressed: () {},
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(double milliseconds) {
    Duration duration = Duration(milliseconds: milliseconds.toInt());
    return "${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}";
  }
}
