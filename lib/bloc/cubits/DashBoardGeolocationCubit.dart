import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:run_tracker/core/AppGeolocation.dart';
import 'package:run_tracker/core/RunRecorder.dart';
import 'package:run_tracker/helpers/GeolocationProvider.dart';
import 'package:run_tracker/helpers/SpeedHelper.dart';

class DashBoardGeolocationCubit extends Cubit<DashBoardGeolocationState> {
  final IRunRecorder _runRecorder;
  final IGeolocationProvider _geoRepo;
  late final StreamSubscription<AppGeolocation> geolocationSubscription;

  DashBoardGeolocationCubit({
    required IGeolocationProvider geoRepo,
    required IRunRecorder runRecorder,
    initialState = const DashBoardGeolocationState(
      distance: null,
      speed: null,
    ),
  })  : _geoRepo = geoRepo,
        _runRecorder = runRecorder,
        super(initialState) {
    geolocationSubscription = _geoRepo.geolocationStream.listen((geolocation) {
      emit(DashBoardGeolocationState(
        speed: geolocation.speed,
        distance: _runRecorder.distance,
      ));
    });
  }

  @override
  Future<void> close() async {
    await geolocationSubscription.cancel();
    await super.close();
  }
}

class DashBoardGeolocationState {
  final double? distance;

  /// m/s
  final double? speed;

  /// m/km
  Duration? get pace => SpeedHelper.speedToPace(speed);

  const DashBoardGeolocationState({required this.speed, required this.distance});
}
