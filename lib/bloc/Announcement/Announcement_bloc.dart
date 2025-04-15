// lib/bloc/announcement/announcement_event.dart
import 'package:mokeb/core/services/announcement_service.dart';
import 'package:mokeb/models/announcement.dart';
// lib/bloc/announcement/announcement_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';

class AnnouncementBloc extends Bloc<AnnouncementEvent, AnnouncementState> {
  final AnnouncementService service;

  AnnouncementBloc(this.service) : super(AnnouncementInitial()) {
    on<LoadAnnouncements>((event, emit) async {
      emit(AnnouncementLoading());
      try {
        final announcements = await service.fetchAnnouncements();
        emit(AnnouncementLoaded(announcements));
      } catch (e) {
        emit(AnnouncementError("خطا در بارگذاری اطلاعیه‌ها"));
      }
    });
  }
}


abstract class AnnouncementEvent {}

class LoadAnnouncements extends AnnouncementEvent {}

abstract class AnnouncementState {}

class AnnouncementInitial extends AnnouncementState {}

class AnnouncementLoading extends AnnouncementState {}

class AnnouncementLoaded extends AnnouncementState {
  final List<Announcement> announcements;

  AnnouncementLoaded(this.announcements);
}

class AnnouncementError extends AnnouncementState {
  final String message;

  AnnouncementError(this.message);
}
