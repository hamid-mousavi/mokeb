import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mokeb/core/services/location_service.dart';


class LocationCubit extends Cubit<LocationState> {
  final LocationService locationService;

  LocationCubit(this.locationService) : super(LocationInitial());

  Future<void> fetchCity() async {
    emit(LocationLoading());
    try {
      final city = await locationService.getCurrentLocation();
      emit(LocationLoaded(city as String));
    } catch (e) {
      emit(LocationError(e.toString()));
    }
  }
}



abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationLoaded extends LocationState {
  final String city;
  LocationLoaded(this.city);
}

class LocationError extends LocationState {
  final String message;
  LocationError(this.message);
}
