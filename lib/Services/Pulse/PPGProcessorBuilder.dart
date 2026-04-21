import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Services/Pulse/BrightnessWithDuration.dart';

class PPGProcessorBuilder {
  static const double defaultLowFilterIntervalSeconds = 0.3;
  final List<Iterable<BrightnessWithDuration> Function(BrightnessWithDuration)> _processors = [];

  static double _getX(BrightnessWithDuration point) => point.seconds;
  static double _getY(BrightnessWithDuration point) => point.brightness;

  void average([double interval = defaultLowFilterIntervalSeconds]) {
    final average = InternalCenteredIntervalAverageGeneric(
      getX: _getX,
      getY: _getY,
      interval: interval,
    );
    _processors.add(
      (s) => average.processItem(s).map((r) => r.$1.copyWithBrightness(r.$2)),
    );
  }

  void averageRepeat({
    double interval = defaultLowFilterIntervalSeconds,
    int count = 1,
  }) {
    for (final _ in Iterable.generate(count)) {
      average(interval);
    }
  }

  void removeOffset([double interval = defaultLowFilterIntervalSeconds]) {
    final average = InternalCenteredIntervalAverageGeneric(
      getX: _getX,
      getY: _getY,
      interval: interval,
    );

    _processors.add(
      (s) => average.processItem(s).map((r) => r.$1.copyWithBrightness(r.$1.brightness - r.$2)),
    );
  }

  void removeOffsetRepeat({
    double interval = defaultLowFilterIntervalSeconds,
    int count = 1,
  }) {
    for (final _ in Iterable.generate(count)) {
      removeOffset(interval);
    }
  }

  Iterable<BrightnessWithDuration> add(BrightnessWithDuration measure) sync* {
    if (_processors.isEmpty) {
      yield measure;
      return;
    }

    yield* _processRecursive(0, measure);
  }

  Iterable<BrightnessWithDuration> _processRecursive(
    int processorIndex,
    BrightnessWithDuration parameter,
  ) sync* {
    final processor = _processors[processorIndex];
    if (processorIndex < _processors.length - 1) {
      for (final result in processor(parameter)) {
        yield* _processRecursive(processorIndex + 1, result);
      }

      return;
    }

    yield* processor(parameter);
  }
}