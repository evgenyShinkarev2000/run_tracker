import 'dart:async';

import 'package:camera/camera.dart' as DefaultCamera;
import 'package:camera_platform_interface/camera_platform_interface.dart' as CPI;
import 'package:camera_android_camerax/camera_android_camerax.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:run_tracker/core/LumyMeasuring.dart';
import 'package:run_tracker/core/PulseByCamera.dart';

class PulseCameraCubit extends Cubit<PulseCameraCubitState> {
  final PulseByCamera _pulseByCamera = PulseByCamera();
  final AndroidCameraCameraX androidCamera = AndroidCameraCameraX();
  // late final StreamSubscription<CPI.CameraImageData> frameSubscription;
  late final int cameraIdWithSettings;
  late final Timer _timer;
  DateTime? lastFrameTime;
  int? frameRate;

  PulseCameraCubit() : super(PulseCameraCubitState()) {
    _init();
  }

  Future<void> _init() async {
    final cameraIds = await androidCamera.availableCameras();
    cameraIdWithSettings = await androidCamera.createCameraWithSettings(cameraIds.first,
        CPI.MediaSettings(enableAudio: false, fps: 60, resolutionPreset: DefaultCamera.ResolutionPreset.medium));

    await androidCamera.initializeCamera(cameraIdWithSettings);
    await androidCamera.setFlashMode(cameraIdWithSettings, DefaultCamera.FlashMode.torch);
    await androidCamera.startVideoCapturing(CPI.VideoCaptureOptions(cameraIdWithSettings, streamCallback: handleFrame));

    // frameSubscription = androidCamera.onStreamedFrameAvailable(cameraIdWithSettings).listen(handleFrame);
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      handleUpdateChart();
    });
    emit(state.copyWith(cameraPreview: androidCamera.buildPreview(cameraIdWithSettings)));
  }

  void handleUpdateChart() {
    if (frameRate != null) {
      state.frameRate = frameRate!;
    }
    final dateTime = DateTime.now().subtract(Duration(seconds: 5));
    state.lumies.removeWhere((lm) => lm.timeStamp.isBefore(dateTime));
    emit(state.copyWith());
  }

  void handleFrame(CPI.CameraImageData cameraImageData) {
    final dateTime = DateTime.now();
    if (lastFrameTime != null) {
      frameRate = (1e6 / (dateTime.microsecondsSinceEpoch - lastFrameTime!.microsecondsSinceEpoch)).round();
    }
    lastFrameTime = dateTime;
    final lumy =
        _pulseByCamera.findAverageLumy(cameraImageData.planes[0].bytes, cameraImageData.width, cameraImageData.height);
    state.lumies.add(LumyMeasuring(dateTime, lumy));
  }

  @override
  Future<void> close() async {
    _timer.cancel();
    // await frameSubscription.cancel();
    await androidCamera.stopVideoRecording(cameraIdWithSettings);
    await androidCamera.dispose(cameraIdWithSettings);

    await super.close();
  }
}

Uint8List lumaToRGBA(Uint8List lumies) {
  final buffer = WriteBuffer(startCapacity: lumies.length * 4);
  for (var luma in lumies) {
    buffer.putUint8(luma);
    buffer.putUint8(luma);
    buffer.putUint8(luma);
    buffer.putUint8(255);
  }

  return buffer.done().buffer.asUint8List();
}

Uint8List mockedPixels() {
  final buffer = WriteBuffer(startCapacity: 1600);
  for (var _ in Iterable.generate(1600)) {
    buffer.putUint32(0xff0000ff);
  }

  return buffer.done().buffer.asUint8List();
}

class PulseCameraCubitState {
  Widget? cameraPreview;
  List<LumyMeasuring> lumies = [];
  int frameRate;

  PulseCameraCubitState({this.cameraPreview, List<LumyMeasuring>? lumies, this.frameRate = 0}) {
    if (lumies != null) {
      this.lumies = lumies;
    }
  }

  PulseCameraCubitState copyWith({Widget? cameraPreview, List<LumyMeasuring>? lumies, int? frameRate}) {
    final copy = PulseCameraCubitState();
    copy.cameraPreview = cameraPreview ?? this.cameraPreview;
    copy.lumies = lumies ?? this.lumies;
    copy.frameRate = frameRate ?? this.frameRate;

    return copy;
  }
}
