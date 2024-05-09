import 'dart:async';
import 'dart:collection';

import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:run_tracker/core/DataWithDateTime.dart';
import 'package:run_tracker/core/PulseByCamera.dart';

class PulseCameraCubit extends Cubit<PulseCameraCubitState> {
  final Duration cameraUnstableTime;
  final PulseByCamera _pulseByCamera = PulseByCamera();
  late final StreamSubscription<CameraImageData> frameSubscription;
  final CameraPlatform cameraInstance = CameraPlatform.instance;
  late final int cameraIdWithSettings;
  late final Timer _timer;
  bool isCameraStable = false;
  DateTime? cameraStartedTime;

  PulseCameraCubit({
    Duration? cameraUnstableTime,
  })  : cameraUnstableTime = cameraUnstableTime ?? Duration(seconds: 1),
        super(PulseCameraCubitState()) {
    _init();
  }

  Future<void> _init() async {
    final cameraIds = await cameraInstance.availableCameras();
    cameraIdWithSettings = await cameraInstance.createCameraWithSettings(
        cameraIds.first, MediaSettings(enableAudio: false, fps: 30, resolutionPreset: ResolutionPreset.low));

    await cameraInstance.initializeCamera(cameraIdWithSettings);
    await cameraInstance.setFlashMode(cameraIdWithSettings, FlashMode.torch);

    frameSubscription = cameraInstance
        .onStreamedFrameAvailable(cameraIdWithSettings, options: CameraImageStreamOptions())
        .listen(handleFrame);
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      handleUpdateChart();
    });
    emit(state.copyWith(cameraPreview: cameraInstance.buildPreview(cameraIdWithSettings)));
  }

  void handleUpdateChart() {
    if (!isCameraStable) {
      return;
    }

    emit(state.copyWith());
  }

  void removeOldValues() {
    final timeLimit = DateTime.now().subtract(Duration(seconds: 10));
    while (state.lumies.isNotEmpty) {
      if (state.lumies.first.dateTime.isBefore(timeLimit)) {
        state.lumies.removeFirst();
      } else {
        break;
      }
    }
  }

  void handleFrame(CameraImageData cameraImageData) {
    final frameTime = DateTime.now();
    steadyCamera(frameTime);
    if (!isCameraStable) {
      return;
    }

    final lumy = _pulseByCamera.findAverageFilteredLumy(
        frameTime, cameraImageData.planes[0].bytes, cameraImageData.width, cameraImageData.height);
    state.lumies.add(DataWithDateTime(frameTime, lumy));
    state.pulse = _pulseByCamera.findPulse(frameTime, lumy) ?? state.pulse;

    if (state.lumies.length > 1000) {
      removeOldValues();
    }
  }

  void steadyCamera(DateTime frameTime) {
    if (!isCameraStable) {
      if (cameraStartedTime == null) {
        cameraStartedTime = frameTime;
      } else if (Duration(microseconds: frameTime.microsecondsSinceEpoch - cameraStartedTime!.microsecondsSinceEpoch) >
          cameraUnstableTime) {
        isCameraStable = true;
      }
    }
  }

  @override
  Future<void> close() async {
    _timer.cancel();
    await frameSubscription.cancel();
    await cameraInstance.setFlashMode(cameraIdWithSettings, FlashMode.off);
    await cameraInstance.dispose(cameraIdWithSettings);

    await super.close();
  }
}

class PulseCameraCubitState {
  Widget? cameraPreview;
  Queue<DataWithDateTime<double>> lumies = Queue();
  int frameRate;
  double? pulse;

  PulseCameraCubitState({this.cameraPreview, Queue<DataWithDateTime<double>>? lumies, this.frameRate = 0}) {
    if (lumies != null) {
      this.lumies = lumies;
    }
  }

  PulseCameraCubitState copyWith({
    Widget? cameraPreview,
    Queue<DataWithDateTime<double>>? lumies,
    int? frameRate,
    double? pulse,
  }) {
    final copy = PulseCameraCubitState();
    copy.cameraPreview = cameraPreview ?? this.cameraPreview;
    copy.lumies = lumies ?? this.lumies;
    copy.frameRate = frameRate ?? this.frameRate;
    copy.pulse = pulse ?? this.pulse;

    return copy;
  }
}
