import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:run_tracker/core/AppGeolocation.dart';
import 'package:run_tracker/helpers/GeolocationProvider.dart';
import 'package:run_tracker/helpers/GeolocatorWrapper.dart';
import 'package:run_tracker/helpers/extensions/PositionExtension.dart';

class PositionSignificantCubit extends Cubit<PositionSignificantState> {
  final IGeolocationProvider geoRepo;
  final double significantDistance;
  late final StreamSubscription<AppGeolocation> geolocationSubscription;
  AppGeolocation? lastSignificantGeolocation;
  PositionSignificantCubit(
      {required this.geoRepo,
      required PositionSignificantState initialState,
      required GeolocatorWrapper geolocationWrapper,
      this.significantDistance = 10,
      bool isPaused = false})
      : super(initialState) {
    geolocationWrapper.getLastPosition().then((p) => emit(state.copyWith(initialPosition: p?.toLatLng())));
    Future.delayed(Duration(seconds: 5), () {
      if (isClosed || state.initialPosition != null) {
        return;
      }
      emit(state.copyWith(initialPosition: LatLng(0, 0)));
    });

    geolocationSubscription = geoRepo.geolocationStream.listen((appGeolocation) {
      emit(state.copyWith(
        currentGeolocation: appGeolocation,
        isDistanceOffsetSignificant: _isOffsetSignificant(appGeolocation),
      ));
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
    emit(state.copyWith(isDistanceOffsetSignificant: true));
  }

  void pause() {
    geolocationSubscription.pause();
    emit(state.copyWith(isDistanceOffsetSignificant: false));
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
  final LatLng? initialPosition;

  PositionSignificantState(this.currentGeolocation, this.isDistanceOffsetSignificant, [this.initialPosition]);

  PositionSignificantState copyWith({
    AppGeolocation? currentGeolocation,
    bool? isDistanceOffsetSignificant,
    LatLng? initialPosition,
  }) {
    return PositionSignificantState(
      currentGeolocation ?? this.currentGeolocation,
      isDistanceOffsetSignificant ?? this.isDistanceOffsetSignificant,
      initialPosition ?? this.initialPosition,
    );
  }
}
