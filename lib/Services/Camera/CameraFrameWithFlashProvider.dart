import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:run_tracker/Core/export.dart';

//TODO попробовать упростить
class CameraFrameWithFlashProvider implements IDisposable {
  Stream<CameraImage> get stream => _streamController.stream;
  late final StreamController<CameraImage> _streamController =
      StreamController.broadcast(
        onListen: _handleListen,
        onCancel: _handleCancelListen,
      );

  ValueListenable<CameraController?> get cameraController => _cameraController;
  final ValueNotifier<CameraController?> _cameraController = ValueNotifier(
    null,
  );

  bool _isDisposed = false;
  _CameraState _cameraState = .noUsed;
  Future<void> _stateChanging = Future.value();

  final ILogger _logger;

  CameraFrameWithFlashProvider(this._logger);

  @override
  void dispose() {
    _isDisposed = true;
    _streamController.close();
    _cameraController.value?.dispose();
    _cameraController.dispose();
  }

  Future<void> startCamera() async {
    _ensureState();
    await _startCameraWithLock();
  }

  Future<void> stopCamera() async {
    _ensureState();
    await _stopCameraWithLock();
  }

  void _handleListen() async {
    try {
      await _startCameraWithLock();
    } on ObjectDisposedException {
      // stream closed in dispose, skip.
    } catch (ex, s) {
      _logger.logError(
        "Exception in _handleListen when _startCameraWithLock",
        appException: AppException.caught(ex, s),
      );
    }
  }

  void _handleCancelListen() async {
    try {
      await _stopCameraWithLock();
    } catch (ex, s) {
      _logger.logError(
        "Exception in _handleCancelListen when _stopCameraWithLock()",
        appException: AppException.caught(ex, s),
      );
    }
  }

  void _ensureState() {
    if (_isDisposed) {
      throw ObjectDisposedException(
        message: "CameraFrameWithFlashProvider is disposed",
      );
    }
  }

  Future<void> _startCameraWithLock() async {
    if (_cameraState == .starting) {
      await _stateChanging;
    } else {
      try {
        await _stateChanging;
      } catch (ex) {
        // _stateChanging not from _startCameraWithLock
      }
    }

    if (_cameraState == _CameraState.using) {
      return;
    }
    if (_isDisposed) {
      _throwDisposedDuringStart();
    }

    final completer = Completer();
    _stateChanging = completer.future;
    _cameraState = .starting;

    CameraController? cameraController;
    try {
      cameraController = await _createAndStartController();
      if (_isDisposed) {
        await cameraController.dispose();
        _throwDisposedDuringStart();
      }
    } catch (ex) {
      _cameraState = .startingError;
      completer.completeError(ex);
      rethrow;
    }

    _cameraState = .using;
    completer.complete();
    _cameraController.value = cameraController;
  }

  Future<CameraController> _createAndStartController() async {
    List<CameraDescription>? cameras;
    try {
      cameras = await availableCameras();
    } catch (ex) {
      throw AppException(
        message: "Exception when await availableCameras()",
        innerException: AppException.inner(ex),
      );
    }

    CameraDescription? camera;
    try {
      camera = await _chooseCamera(cameras);
    } catch (ex) {
      throw AppException(
        message: "Exception  when await _chooseCamera(cameras)",
        innerException: AppException.inner(ex),
      );
    }

    final cameraController = CameraController(
      camera,
      .low,
      enableAudio: false,
      fps: 30,
    );

    try {
      await cameraController.initialize();
    } catch (ex) {
      throw AppException(
        message: "Exception when cameraController.initialize()",
        innerException: AppException.inner(ex),
      );
    }

    try {
      await cameraController.setFlashMode(.torch);
    } catch (ex, s) {
      _logger.logWarning(
        "Exception when cameraController.setFlashMode(.torch)",
        appException: AppException.caught(ex, s),
      );
    }
    try {
      await cameraController.startImageStream(_handleFrame);
    } catch (ex) {
      try {
        await cameraController.dispose();
      } catch (ex) {
        throw AppException(
          message:
              "Exception when cameraController.dispose() after exception in cameraController.startImageStream(_handleFrame)",
          innerException: AppException.inner(ex),
        );
      }
      throw AppException(
        message: "Exception when CameraController.startImageStream",
        innerException: AppException.inner(ex),
      );
    }

    return cameraController;
  }

  Future<CameraDescription> _chooseCamera(List<CameraDescription> cameras) {
    if (cameras.isEmpty) {
      throw AppException(message: "Device hasn't camera");
    }
    //TODO выбор из настроек
    CameraDescription? backCamera;
    for (final camera in cameras) {
      if (camera.lensDirection == .back) {
        backCamera ??= camera;
        if (camera.lensType == .telephoto) {
          return Future.value(camera);
        }
      }
    }

    return Future.value(backCamera ?? cameras.first);
  }

  Future<void> _stopCameraWithLock() async {
    if (_cameraState == .stopping) {
      await _stateChanging;
    } else {
      try {
        await _stateChanging;
      } catch (ex) {
        // _stateChanging not from _stopCameraWithLock
      }
    }

    if (_cameraState == _CameraState.noUsed || _isDisposed) {
      return;
    }
    final completer = Completer();
    _stateChanging = completer.future;
    _cameraState = .stopping;

    try {
      await _stopCameraInternal();
    } catch (ex) {
      _cameraState = .stoppingError;
      completer.completeError(ex);
      rethrow;
    }

    _cameraState = .noUsed;
    completer.complete();
    _cameraController.value = null;
  }

  Future<void> _stopCameraInternal() async {
    final controller = _cameraController.value;
    if (controller == null) {
      if (_cameraState == .using) {
        throw AppException(
          message:
              "CameraFrameWithFlashProvider._cameraState == .using but _cameraController.value == null",
        );
      }
      return;
    }
    await controller.dispose();
  }

  void _handleFrame(CameraImage image) {
    _streamController.add(image);
  }

  static void _throwDisposedDuringStart() {
    throw ObjectDisposedException(
      message:
          "CameraFrameWithFlashProvider was dispoed during call _startCameraWithLock",
    );
  }
}

enum _CameraState {
  noUsed,
  starting,
  startingError,
  using,
  stopping,
  stoppingError,
}
