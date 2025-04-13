// blocs/adhan_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokeb/core/services/adhan_service.dart';
import 'package:mokeb/core/services/location_service.dart';
import '../../models/prayer_time_model.dart';

class AdhanCubit extends Cubit<AdhanState> {
  final LocationService locationService;
  final AdhanService azanService;

  AdhanCubit(this.locationService, this.azanService)
      : super(AdhanLoading());

  Future<void> loadAdhanTimes() async {
    try {
      emit(AdhanLoading());
      final position = await locationService.getCurrentLocation();
      final times =
          await azanService.getPrayerTimes(position.latitude, position.longitude);
      emit(AdhanLoaded(times));
    } catch (e) {
      emit(AdhanError(e.toString()));
    }
  }
}



abstract class AdhanState {}

class AdhanInitial extends AdhanState {}

class AdhanLoading extends AdhanState {}

class AdhanLoaded extends AdhanState {
  final PrayerTimeModel times;
  AdhanLoaded(this.times);
}

class AdhanError extends AdhanState {
  final String message;
  AdhanError(this.message);
}
