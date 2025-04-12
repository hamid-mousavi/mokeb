

import 'package:bloc/bloc.dart';
import 'package:mokeb/core/services/data_services.dart';
import 'package:mokeb/models/adhan.dart';
import 'package:mokeb/models/announcement.dart';
import 'package:mokeb/models/noha.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final DataService dataService;

  HomeBloc(this.dataService) : super(HomeState.initial()) {
    on<LoadHomeData>(_onLoadData);
  }

  Future<void> _onLoadData(LoadHomeData event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final noheList = await dataService.getNohas();
      final adhan = await dataService.getNextAdhan();
      final announcements = await dataService.getAnnouncements();

      emit(state.copyWith(
        noheList: noheList,
        nextAdhan: adhan,
        announcements: announcements,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }
}

class HomeState {
  final List<Noha> noheList;
  final List<Announcement> announcements;
  final Adhan? nextAdhan;
  final bool isLoading;
  final String? error;

  HomeState({
    required this.noheList,
    required this.announcements,
    this.nextAdhan,
    this.isLoading = false,
    this.error,
  });

  factory HomeState.initial() => HomeState(
        noheList: [],
        announcements: [],
        nextAdhan: null,
        isLoading: true,
      );

  HomeState copyWith({
    List<Noha>? noheList,
    List<Announcement>? announcements,
    Adhan? nextAdhan,
    bool? isLoading,
    String? error,
  }) {
    return HomeState(
      noheList: noheList ?? this.noheList,
      announcements: announcements ?? this.announcements,
      nextAdhan: nextAdhan ?? this.nextAdhan,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

abstract class HomeEvent {}

class LoadHomeData extends HomeEvent {}
