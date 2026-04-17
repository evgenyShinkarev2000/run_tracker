import 'dart:math';

import 'package:run_tracker/Core/Math/CenteredProcessorGeneric.dart';
import 'package:run_tracker/Core/Math/Distribution.dart';
import 'package:run_tracker/Core/Math/DistributionQueue.dart';

class CompressorFunctions {
  static double interpolationParameter(
    double value,
    double minLimit,
    double maxValue,
  ) {
    return (value - minLimit) / (maxValue - minLimit);
  }

  static double linearMap(
    double interpolationParameter,
    double minLimit,
    double maxLimit,
  ) {
    return minLimit + (maxLimit - minLimit) * interpolationParameter;
  }

  static double Function(
    double value,
    double minLimit,
    double maxLimit,
    double maxValue,
  )
  buildTransform(double Function(double interpolationParameter) tTransform) {
    return (double value, double minLimit, double maxLimit, double maxValue) {
      return linearMap(
        tTransform(interpolationParameter(value, minLimit, maxValue)),
        minLimit,
        maxLimit,
      );
    };
  }

  static double Function(Distribution, double)
  buildLowInterquartileLimitByQuantile(double lowQuantile) =>
      buildLowScaledInterquartileLimit(
        interpolationParameter(lowQuantile, 0, 50),
      );

  static double Function(Distribution, double)
  buildHightInterquartileLimitByQuantile(double hightQuantile) =>
      buildHightScaledInterquartileLimit(
        interpolationParameter(hightQuantile, 100, 50),
      );

  static double Function(Distribution, double) buildLowScaledInterquartileLimit(
    double scale,
  ) {
    return (Distribution distribution, double lowThreshold) {
      final interquartile =
          distribution.findQuantileValue(75) -
          distribution.findQuantileValue(25);

      return max(distribution.min, lowThreshold - interquartile * scale);
    };
  }

  static double Function(Distribution, double)
  buildHightScaledInterquartileLimit(double scale) {
    return (Distribution distribution, double hightThreshold) {
      final interquartile =
          distribution.findQuantileValue(75) -
          distribution.findQuantileValue(25);

      return min(distribution.max, hightThreshold + interquartile * scale);
    };
  }
}

class CompressorGeneric<T> {
  final double Function(T item) _getY;

  final double lowQuntile;
  final double highQuntile;

  final double Function(
    double curValue,
    double lowThreshold,
    double lowLimit,
    double minValue,
  )
  _compressLowValue;
  final double Function(
    double curValue,
    double hightThreshold,
    double hightLimit,
    double maxValue,
  )
  _compressHightValue;
  final double Function(Distribution distribution, double lowThreshold)
  _findLowLimit;
  final double Function(Distribution distribution, double hightThreshold)
  _findHightLimit;
  final DistributionQueueGeneric<T> _distributionQueue;
  final CenteredProcessorGeneric<T> _centeredProcessor;

  CompressorGeneric({
    required double Function(T item) getX,
    required double Function(T item) getY,
    required double prevInterval,
    required double nextInterval,
    required this.lowQuntile,
    required this.highQuntile,
    required double Function(
      double curValue,
      double hightThreshold,
      double highLimit,
      double maxValue,
    )
    compressLowValue,
    required double Function(
      double curValue,
      double lowThreshold,
      double lowLimit,
      double minValue,
    )
    compressHightValue,
    required double Function(Distribution distribution, double lowThreshold)
    findLowLimit,
    required double Function(Distribution distribution, double hightThreshold)
    findHightLimit,
  }) : assert(prevInterval >= 0),
       assert(lowQuntile >= 0),
       assert(highQuntile <= 100),
       _compressLowValue = compressLowValue,
       _compressHightValue = compressHightValue,
       _findLowLimit = findLowLimit,
       _findHightLimit = findHightLimit,
       _getY = getY,
       _distributionQueue = DistributionQueueGeneric(getY: getY),
       _centeredProcessor = CenteredProcessorGeneric(
         getX: getX,
         prevInterval: prevInterval,
         nextInterval: nextInterval,
       );

  factory CompressorGeneric.symmetricQuantilePow({
    required double Function(T) getX,
    required double Function(T) getY,
    required double interval,
    required double power,
    required double quantile,
  }) {
    assert(quantile >= 0 && quantile <= 100);
    final transform = CompressorFunctions.buildTransform(
      (v) => pow(v, power).toDouble(),
    );
    return CompressorGeneric(
      getX: getX,
      getY: getY,
      prevInterval: interval / 2,
      nextInterval: interval / 2,
      lowQuntile: quantile,
      highQuntile: 100 - quantile,
      compressLowValue: transform,
      compressHightValue: transform,
      findLowLimit: CompressorFunctions.buildLowInterquartileLimitByQuantile(
        quantile,
      ),
      findHightLimit:
          CompressorFunctions.buildHightInterquartileLimitByQuantile(
            100 - quantile,
          ),
    );
  }

  Iterable<(T, double)> compress(Iterable<T> items) sync* {
    for (final item in items) {
      yield* _processItem(item);
    }

    yield* _completeProcessQueue();
  }

  Stream<(T, double)> compressAsync(Stream<T> items) async* {
    await for (final item in items) {
      for (final result in _processItem(item)) {
        yield result;
      }
    }

    for (final result in _completeProcessQueue()) {
      yield result;
    }
  }

  Iterable<(T, double)> _processItem(T item) sync* {
    for (final result in _centeredProcessor.add(item)) {
      for (final _ in Iterable.generate(result.$1)) {
        _distributionQueue.dequeue();
      }
      yield (result.$2, _compressIfNeed(_getY(result.$2)));
    }
    _distributionQueue.enqueue(item);
  }

  Iterable<(T, double)> _completeProcessQueue() sync* {
    for (var result in _centeredProcessor.complete()) {
      for (final _ in Iterable.generate(result.$1)) {
        _distributionQueue.dequeue();
      }
      yield (result.$2, _compressIfNeed(_getY(result.$2)));
    }
  }

  double _compressIfNeed(double value) {
    final lowThreshold = _distributionQueue.findQuantileValue(lowQuntile);
    if (value < lowThreshold) {
      return _compressLowValue(
        value,
        lowThreshold,
        _findLowLimit(_distributionQueue.distribution, lowThreshold),
        _distributionQueue.minValue,
      );
    }

    final hightThreshold = _distributionQueue.findQuantileValue(highQuntile);
    if (value > hightThreshold) {
      return _compressHightValue(
        value,
        hightThreshold,
        _findHightLimit(_distributionQueue.distribution, hightThreshold),
        _distributionQueue.maxValue,
      );
    }

    return value;
  }
}
