import 'dart:typed_data';

import 'package:run_tracker/core/library/ImageCrop.dart';
import 'package:run_tracker/core/library/MovingAverage.dart';

class PulseByCamera {
  final ImageCrop _imageCrop = ImageCrop();
  final double widthCropFactor;
  final double heightCropFactor;
  final MovingAverage _lumyAverage = MovingAverage(3);
  final MovingAverage _pulseAverage = MovingAverage(3);

  PulseByCamera([this.widthCropFactor = 0.75, this.heightCropFactor = 0.75]) {
    assert(widthCropFactor <= 1 && widthCropFactor > 0);
    assert(heightCropFactor <= 1 && heightCropFactor > 0);
  }

  double findAverageLumy(Uint8List lumies, int width, int height) {
    if (lumies.isEmpty) {
      return 0;
    }
    assert(lumies.length == width * height);

    var targetWidth = (width * widthCropFactor).round();
    var targetHeight = (height * heightCropFactor).round();

    if (targetWidth <= 0) {
      targetWidth = 1;
    }
    if (targetHeight <= 0) {
      targetHeight = 1;
    }

    final centerLumies = _imageCrop.uint8Iterator(
      lumies,
      width,
      height,
      targetWidth,
      targetHeight,
    );

    var sum = BigInt.zero;
    for (var lumy in centerLumies) {
      sum += BigInt.from(lumy);
    }

    final average = (sum / BigInt.from(centerLumies.length)).toDouble();
    _lumyAverage.add(average);

    return _lumyAverage.average!;
  }

  /// beats per minute
  int? findPulse(double averageLumy, DateTime timeStamp) {}
}
