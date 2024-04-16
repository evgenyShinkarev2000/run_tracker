import 'dart:math';
import 'dart:typed_data';

import 'package:run_tracker/core/DataWithDateTime.dart';
import 'package:run_tracker/core/DecileClapmFilter.dart';
import 'package:run_tracker/core/PulseByMetronome.dart';
import 'package:run_tracker/core/PulseMinExtremumFinder.dart';
import 'package:run_tracker/core/library/Derivative.dart';
import 'package:run_tracker/core/library/ImageCrop.dart';
import 'package:run_tracker/core/library/MovingAverage.dart';

class PulseByCamera {
  final ImageCrop _imageCrop = ImageCrop();
  final double widthCropFactor;
  final double heightCropFactor;

  final DecileClampFilter _lumyFilter = DecileClampFilter();
  final MovingAverage _lumyAverage = MovingAverage(4);

  final Derivative _lumyDerivative = Derivative();
  final DecileClampFilter _lumyDerivativeFilter = DecileClampFilter(thresholdCoef: 0.3, borderCoef: 0.1);
  final MovingAverage _lumyDerivativeAverage = MovingAverage(5);

  final PulseMinExtremumFinder _pulseMinExtremumFinder = PulseMinExtremumFinder();
  final PulseByMetronome _pulseByMetronome = PulseByMetronome(averageCount: 3, medianFilterTresholdCoef: 0.5);

  PulseByCamera([this.widthCropFactor = 0.75, this.heightCropFactor = 0.75]) {
    assert(widthCropFactor <= 1 && widthCropFactor > 0);
    assert(heightCropFactor <= 1 && heightCropFactor > 0);
  }

  double findAverageFilteredLumy(DateTime timeStamp, Uint8List lumies, int width, int height) {
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

    var sum = 0.0;
    for (var lumy in centerLumies) {
      sum += lumy;
    }

    var averageLumy = (sum / centerLumies.length);
    averageLumy = _lumyAverage.add(averageLumy);
    final averageLumyFiltered = _lumyFilter.filter(DataWithDateTime(timeStamp, averageLumy));
    final averageLumyFilteredAverage = _lumyAverage.add(averageLumyFiltered);

    return averageLumyFilteredAverage;
  }

  double? findAverageFilteredLumyDerivative(DateTime timeStamp, double averageLumy) {
    final averageLumyDerivative = _lumyDerivative.find(Point(timeStamp.microsecondsSinceEpoch.toDouble(), averageLumy));
    if (averageLumyDerivative == null) {
      return null;
    }

    // return averageLumyDerivative!.y;

    final averageLumyDerivativeFiltered = _lumyDerivativeFilter.filter(DataWithDateTime(
        DateTime.fromMicrosecondsSinceEpoch(averageLumyDerivative.x.toInt()), averageLumyDerivative.y));

    // return averageLumyDerivativeFiltered;

    final averageLumyDerivativeFilteredAverage = _lumyDerivativeAverage.add(averageLumyDerivativeFiltered);

    return averageLumyDerivativeFilteredAverage;
  }

  DataWithDateTime<int>? findPulseByDerivative(DateTime timeStamp, double averageLumyDerivative) {
    _pulseMinExtremumFinder.add(DataWithDateTime(timeStamp, averageLumyDerivative));
    if (_pulseMinExtremumFinder.hasNewExtremum) {
      final extremum = _pulseMinExtremumFinder.seizeExtremum()!;
      final pulse = _pulseByMetronome.findPulse(extremum.dateTime);

      if (pulse != null) {
        return DataWithDateTime(extremum.dateTime, pulse);
      }

      return null;
    }

    return null;
  }

  /// beats per minute
  int? findPulse(DateTime timeStamp, double averageLumy) {}
}
