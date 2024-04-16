import 'dart:async';
import 'dart:io';

import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart' as pp;
import 'package:run_tracker/core/DataWithDateTime.dart';
import 'package:run_tracker/core/PulseByCamera.dart';

class PulseCameraCubit extends Cubit<PulseCameraCubitState> {
  final PulseByCamera _pulseByCamera = PulseByCamera();
  late final StreamSubscription<CameraImageData> frameSubscription;
  final CameraPlatform cameraInstance = CameraPlatform.instance;
  late final int cameraIdWithSettings;
  late final Timer _timer;
  late final File writeFile;
  int? stringLength;
  DateTime? lastFrameTime;
  int? frameRate;

  PulseCameraCubit() : super(PulseCameraCubitState()) {
    _init();
  }

  Future<void> _init() async {
    final directoryPath = await pp.getDownloadsDirectory();
    writeFile = File("${directoryPath!.path}/data");

    final cameraIds = await cameraInstance.availableCameras();
    cameraIdWithSettings = await cameraInstance.createCameraWithSettings(
        cameraIds.first, MediaSettings(enableAudio: false, fps: 30, resolutionPreset: ResolutionPreset.low));

    await cameraInstance.initializeCamera(cameraIdWithSettings);
    await cameraInstance.setFlashMode(cameraIdWithSettings, FlashMode.torch);

    frameSubscription = cameraInstance
        .onStreamedFrameAvailable(cameraIdWithSettings, options: CameraImageStreamOptions())
        .listen(handleFrame);
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      handleUpdateChart();
    });
    emit(state.copyWith(cameraPreview: cameraInstance.buildPreview(cameraIdWithSettings)));
  }

  void handleUpdateChart() {
    if (frameRate != null) {
      state.frameRate = frameRate!;
    }
    final dateTime = DateTime.now().subtract(Duration(seconds: 5));
    state.lumies.removeWhere((lm) => lm.dateTime.isBefore(dateTime));
    state.lumiesDerivative.removeWhere((ld) => ld.dateTime.isBefore(dateTime));
    emit(state.copyWith());
  }

  void handleFrame(CameraImageData cameraImageData) {
    if (stringLength == null) {
      stringLength = cameraImageData.planes[0].bytes.length;
      writeFile.writeAsString("stringLength: ${stringLength!}\n", mode: FileMode.writeOnly);
    }
    writeFile.writeAsBytes(cameraImageData.planes[0].bytes, mode: FileMode.writeOnlyAppend);

    final dateTime = DateTime.now();
    if (lastFrameTime != null) {
      frameRate = (1e6 / (dateTime.microsecondsSinceEpoch - lastFrameTime!.microsecondsSinceEpoch)).round();
    }
    lastFrameTime = dateTime;
    final lumy = _pulseByCamera.findAverageFilteredLumy(
        dateTime, cameraImageData.planes[0].bytes, cameraImageData.width, cameraImageData.height);
    state.lumies.add(DataWithDateTime(dateTime, lumy));

    final lumyDerivative = _pulseByCamera.findAverageFilteredLumyDerivative(dateTime, lumy);
    if (lumyDerivative != null) {
      state.lumiesDerivative.add(DataWithDateTime(dateTime, lumyDerivative));
      state.pulse = _pulseByCamera.findPulseByDerivative(dateTime, lumyDerivative)?.data ?? state.pulse;
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
  List<DataWithDateTime<double>> lumies = [];
  List<DataWithDateTime<double>> lumiesDerivative = [];
  int frameRate;
  int? pulse;

  PulseCameraCubitState({this.cameraPreview, List<DataWithDateTime<double>>? lumies, this.frameRate = 0}) {
    if (lumies != null) {
      this.lumies = lumies;
    }
  }

  PulseCameraCubitState copyWith(
      {Widget? cameraPreview,
      List<DataWithDateTime<double>>? lumies,
      int? frameRate,
      List<DataWithDateTime<double>>? lumiesDerivative,
      int? pulse}) {
    final copy = PulseCameraCubitState();
    copy.cameraPreview = cameraPreview ?? this.cameraPreview;
    copy.lumies = lumies ?? this.lumies;
    copy.frameRate = frameRate ?? this.frameRate;
    copy.lumiesDerivative = lumiesDerivative ?? this.lumiesDerivative;
    copy.pulse = pulse ?? this.pulse;

    return copy;
  }
}
