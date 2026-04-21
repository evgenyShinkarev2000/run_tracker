import 'dart:async';

import 'package:camera/camera.dart';
import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Pages/PulseDev/FFTHelper.dart';
import 'package:run_tracker/Services/Camera/export.dart';
import 'package:run_tracker/Services/Pulse/BrightnessWithDuration.dart';
import 'package:run_tracker/Services/Pulse/PPGProcessorBuilder.dart';

class PPGCameraServiceFactory {
  final CameraFrameWithFlashProvider _camera;
  final ILogger _logger;

  PPGCameraServiceFactory({
    required CameraFrameWithFlashProvider camera,
    required ILogger logger,
  }) : _camera = camera,
       _logger = logger;

  PPGCameraService build() {
    return PPGCameraService(frameWithFlashProvider: _camera, logger: _logger);
  }
}

class PPGCameraService implements IDisposable {
  Stream<BrightnessWithDuration> get spotStream => _spotController.stream;
  final StreamController<BrightnessWithDuration> _spotController =
      StreamController.broadcast();

  Stream<double> get pulseStream => _pulseController.stream;
  final StreamController<double> _pulseController =
      StreamController.broadcast();

  final CameraFrameWithFlashProvider _camera;
  // ignore: unused_field
  final ILogger _logger;
  final CameraFrameBrightness _frameBrightness = CameraFrameBrightness();
  StreamSubscription<CameraImage>? _frameSubscription;
  DateTime? _lastFrameTimestamp;
  DateTime? _startedAt;
  DateTime? _stableStartedAt;
  DateTime? _lastFFTRun;

  final Duration _cameraUnstableTime = Duration(milliseconds: 500);
  final double _frameRate = 30;
  final Duration _fftFindFrequency = Duration(seconds: 1);
  final Duration _fftInterval = Duration(seconds: 4);
  late final int _fftSize = (_frameRate * _fftInterval.inSecondsDouble).floor();
  late final CircularBuffer<double> _circularBuffer = CircularBuffer(_fftSize);
  late final FFTHelper _fft = FFTHelper(
    size: _fftSize,
    durationSeconds: _fftInterval.inSecondsDouble,
    wantedFrequencyAccuracy: 1 / 60,
  );
  PPGProcessorBuilder? _lowFilterNormilizer;
  GridLinearInterpolation? _gridInterpolation;

  bool _isDisposed = false;

  PPGCameraService({
    required CameraFrameWithFlashProvider frameWithFlashProvider,
    required ILogger logger,
  }) : _camera = frameWithFlashProvider,
       _logger = logger;

  @override
  void dispose() {
    stop();
    _spotController.close();
    _pulseController.close();
    _isDisposed = true;
  }

  void restart() {
    _ensureNotDisposed();
    stop();
    _frameSubscription = _camera.stream.listen(_handleFrame);
  }

  void stop() {
    if (_frameSubscription == null) {
      return;
    }

    _frameSubscription!.cancel();
    _frameSubscription = null;
    _lastFrameTimestamp = null;
    _startedAt = null;
    _stableStartedAt = null;
    _lastFFTRun = null;
    _lowFilterNormilizer = null;
    _gridInterpolation = null;
    _circularBuffer.clear();
  }

  void _ensureNotDisposed() {
    if (_isDisposed) {
      throw ObjectDisposedException(message: "PPGCameraService was disposed");
    }
  }

  void _handleFrame(CameraImage image) {
    _lastFrameTimestamp = DateTime.timestamp();
    _startedAt ??= _lastFrameTimestamp;
    if (_lastFrameTimestamp!.difference(_startedAt!) < _cameraUnstableTime) {
      return;
    }
    if (_stableStartedAt == null) {
      _stableStartedAt = _lastFrameTimestamp;
      _restartProcessors();
    }

    _processMeasure(
      _lastFrameTimestamp!.difference(_stableStartedAt!),
      _frameBrightness.findBrightness(image),
    );
  }

  void _restartProcessors() {
    _lowFilterNormilizer = _buildProcessor();
    _gridInterpolation = GridLinearInterpolation(1 / _frameRate);
    _circularBuffer.clear();
  }

  void _processMeasure(Duration duration, double brightness) {
    for (final filtered in _lowFilterNormilizer!.add(
      BrightnessWithDuration(brightness: brightness, duration: duration),
    )) {
      _spotController.add(filtered);
      _processPPG(filtered);
    }
  }

  void _processPPG(BrightnessWithDuration measure) {
    for (final interpolated in _gridInterpolation!.interpolate(
      measure.seconds,
      measure.brightness,
    )) {
      _circularBuffer.enqueue(interpolated.$2);
    }
    if (_circularBuffer.count == _fftSize &&
        (_lastFFTRun == null ||
            _lastFrameTimestamp!.difference(_lastFFTRun!) > _fftFindFrequency)) {
      _lastFFTRun = _lastFrameTimestamp;
      final spectogram = _fft.findSpectogram(
        _circularBuffer.toList(),
        minFrequency: 40 / 60,
        maxFrequency: 240 / 60,
      );

      final max = spectogram.spectogram.indexed.selectMaxItem((s) => s.$2);
      if (max == null) {
        throw AppException(
          message: "PPGCameraService._processPPG: empty spectogram",
        );
      }
      final pulsePerMinute = spectogram.indexToFrequency(max.$1) * 60;
      _pulseController.add(pulsePerMinute);
    }
  }

  PPGProcessorBuilder _buildProcessor() {
    return PPGProcessorBuilder()
      ..removeOffset(0.3)
      ..average(0.3)
      ..average(0.2)
      ..average(0.1);
  }
}
