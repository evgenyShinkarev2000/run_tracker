import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:run_tracker/core/AppGeolocation.dart';
import 'package:run_tracker/core/RunRecorder.dart';
import 'package:run_tracker/helpers/GeolocationProvider.dart';
import 'package:run_tracker/helpers/units_helper/units_helper.dart';

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
      double? speed;
      if (geolocation.speed != null && Speed.fromMetersPerSecond(geolocation.speed!).kilometersPerHour > 1.5) {
        speed = geolocation.speed;
      }

      emit(DashBoardGeolocationState(
        speed: speed,
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
  Duration? get pace =>
      speed != null && !speed!.isNaN && speed != 0 ? Speed.fromMetersPerSecond(speed!).toPace().toDurationKm() : null;

  const DashBoardGeolocationState({required this.speed, required this.distance});
}
