import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:just_audio/just_audio.dart';

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerStateSubscription;

  AudioBloc() : super(AudioInitial()) {
    on<InitAudio>(_onInitAudio);
    on<PlayAudio>(_onPlayAudio);
    on<PauseAudio>(_onPauseAudio);
    on<SeekAudio>(_onSeekAudio);
    on<DisposeAudio>(_onDisposeAudio);
  }

  Future<void> _onInitAudio(InitAudio event, Emitter<AudioState> emit) async {
    emit(AudioLoading());
    try {
      await _audioPlayer.setUrl(event.audioUrl);
      await Future.delayed(const Duration(seconds: 1)); // تاخیر 1 ثانیه
      final duration = await _audioPlayer.duration;
      if (duration == null) {
        emit(AudioError('Could not get audio duration'));
        return;
      }

      // Setup listeners
      _positionSubscription = _audioPlayer.positionStream.listen((position) {
        add(PlayAudio()); // Trigger state update
      });

      _playerStateSubscription = _audioPlayer.playerStateStream.listen((state) {
        if (state.playing) {
          add(PlayAudio());
        } else {
          add(PauseAudio());
        }
      });

      emit(AudioReady(duration.inMilliseconds.toDouble()));
    } catch (e) {
      emit(AudioError('Failed to initialize audio: $e'));
    }
  }

  Future<void> _onPlayAudio(PlayAudio event, Emitter<AudioState> emit) async {
    if (state is AudioReady || state is AudioPaused) {
      final currentState = state;
      if (currentState is AudioReady) {
        await _audioPlayer.play();
        emit(AudioPlaying(0, currentState.duration));
      } else if (currentState is AudioPaused) {
        await _audioPlayer.play();
        emit(AudioPlaying(
          currentState.currentPosition,
          currentState.duration,
        ));
      }
    } else if (state is AudioPlaying) {
      final currentState = state as AudioPlaying;
      emit(AudioPlaying(
        _audioPlayer.position.inMilliseconds.toDouble(),
        currentState.duration,
      ));
    }
  }

  Future<void> _onPauseAudio(PauseAudio event, Emitter<AudioState> emit) async {
    if (state is AudioPlaying) {
      final currentState = state as AudioPlaying;
      await _audioPlayer.pause();
      emit(AudioPaused(
        _audioPlayer.position.inMilliseconds.toDouble(),
        currentState.duration,
      ));
    }
  }

  Future<void> _onSeekAudio(SeekAudio event, Emitter<AudioState> emit) async {
    if (state is AudioPlaying || state is AudioPaused) {
      await _audioPlayer.seek(Duration(milliseconds: event.position.toInt()));

      final currentState = state;
      if (currentState is AudioPlaying) {
        emit(AudioPlaying(event.position, currentState.duration));
      } else if (currentState is AudioPaused) {
        emit(AudioPaused(event.position, currentState.duration));
      }
    }
  }

  Future<void> _onDisposeAudio(
      DisposeAudio event, Emitter<AudioState> emit) async {
    await _positionSubscription?.cancel();
    await _playerStateSubscription?.cancel();
    await _audioPlayer.dispose();
    emit(AudioInitial());
  }

  @override
  Future<void> close() {
    _positionSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _audioPlayer.dispose();
    return super.close();
  }
}

abstract class AudioState {}

class AudioInitial extends AudioState {}

class AudioLoading extends AudioState {}

class AudioReady extends AudioState {
  final double duration;
  AudioReady(this.duration);
}

class AudioPlaying extends AudioState {
  final double currentPosition;
  final double duration;
  AudioPlaying(this.currentPosition, this.duration);
}

class AudioPaused extends AudioState {
  final double currentPosition;
  final double duration;
  AudioPaused(this.currentPosition, this.duration);
}

class AudioError extends AudioState {
  final String message;
  AudioError(this.message);
}

abstract class AudioEvent {}

class InitAudio extends AudioEvent {
  final String audioUrl;
  InitAudio(this.audioUrl);
}

class PlayAudio extends AudioEvent {}

class PauseAudio extends AudioEvent {}

class SeekAudio extends AudioEvent {
  final double position;
  SeekAudio(this.position);
}

class DisposeAudio extends AudioEvent {}
