import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:run_tracker/core/AppGeolocation.dart';
import 'package:run_tracker/helpers/GeolocationProvider.dart';
import 'package:run_tracker/helpers/GeolocatorWrapper.dart';

class PositionSignificantCubit extends Cubit<PositionSignificantState> {
  final IGeolocationProvider geoRepo;
  final double significantDistance;
  late final StreamSubscription<AppGeolocation> geolocationSubscription;
  AppGeolocation? lastSignificantGeolocation;
  PositionSignificantCubit(
      {required this.geoRepo,
      required PositionSignificantState initialState,
      this.significantDistance = 10,
      bool isPaused = false})
      : super(initialState) {
    geolocationSubscription = geoRepo.geolocationStream.listen((appGeolocation) {
      emit(PositionSignificantState(appGeolocation, _isOffsetSignificant(appGeolocation)));
    });
    if (isPaused) {
      geolocationSubscription.pause();
    }
  }

  @override
  Future<void> close() async {
    await geolocationSubscription.cancel();

    await super.close();
  }

  void resume() {
    geolocationSubscription.resume();
    emit(PositionSignificantState(state.currentGeolocation, true));
  }

  void pause() {
    geolocationSubscription.pause();
    emit(PositionSignificantState(state.currentGeolocation, false));
  }

  bool _isOffsetSignificant(AppGeolocation appGeolocation) {
    if (lastSignificantGeolocation == null) {
      lastSignificantGeolocation = appGeolocation;

      return true;
    }

    final distance = GeolocatorWrapper.distanceBetweenGeolocations(lastSignificantGeolocation!, appGeolocation);
    if (distance > significantDistance) {
      lastSignificantGeolocation = appGeolocation;

      return true;
    }

    return false;
  }
}

class PositionSignificantState {
  final AppGeolocation? currentGeolocation;
  final bool isDistanceOffsetSignificant;

  PositionSignificantState(this.currentGeolocation, this.isDistanceOffsetSignificant);
}
