import 'package:fl_chart/fl_chart.dart';
import 'package:run_tracker/Core/export.dart';

class TransformMethods {
  static const double defaultInterval = 60 / 200;

  static Iterable<FlSpot> removeOffset(
    Iterable<FlSpot> spots, [
    double interval = defaultInterval,
  ]) {
    final movingAverage = InternalCenteredIntervalAverageGeneric<FlSpot>(
      getX: getX,
      getY: getY,
      interval: interval,
    );

    return movingAverage
        .mapByCenteredAverage(spots)
        .map((s) => s.$1.copyWith(y: s.$1.y - s.$2));
  }

  static Iterable<FlSpot> removeOffsetRepeat(
    Iterable<FlSpot> spots, {
    double interval = defaultInterval,
    int count = 1,
  }) {
    for (final _ in Iterable.generate(count)) {
      spots = removeOffset(spots, interval);
    }

    return spots;
  }

  static Iterable<FlSpot> average(
    Iterable<FlSpot> spots, [
    double interval = defaultInterval,
  ]) {
    final movingCenteredAverage =
        InternalCenteredIntervalAverageGeneric<FlSpot>(
          getX: getX,
          getY: getY,
          interval: interval,
        );

    return movingCenteredAverage
        .mapByCenteredAverage(spots)
        .map((s) => s.$1.copyWith(y: s.$2));
  }

  static Iterable<FlSpot> averageRepeat(
    Iterable<FlSpot> spots, {
    double interval = defaultInterval,
    int count = 1,
  }) {
    for (final _ in Iterable.generate(count)) {
      spots = average(spots, interval);
    }

    return spots;
  }

  static Iterable<FlSpot> interpolateAll(
    Iterable<FlSpot> spots,
    double gridStep,
  ) sync* {
    final interpolation = GridLinearInterpolation(gridStep);
    for (final spot in spots) {
      yield* interpolation
          .interpolate(spot.x, spot.y)
          .map((xy) => FlSpot(xy.$1, xy.$2));
    }
  }

  static double getX(FlSpot spot) => spot.x;
  static double getY(FlSpot spot) => spot.y;
}

extension TransformMethodsExtension on Iterable<FlSpot> {
  Iterable<FlSpot> average([
    double interval = TransformMethods.defaultInterval,
  ]) => TransformMethods.average(this, interval);

  Iterable<FlSpot> averageRepeat({
    double interval = TransformMethods.defaultInterval,
    int count = 1,
  }) => TransformMethods.averageRepeat(this, interval: interval, count: count);

  Iterable<FlSpot> removeOffset([
    double interval = TransformMethods.defaultInterval,
  ]) => TransformMethods.removeOffset(this, interval);

  Iterable<FlSpot> removeOffsetRepeat({
    double interval = TransformMethods.defaultInterval,
    int count = 1,
  }) => TransformMethods.removeOffsetRepeat(
    this,
    interval: interval,
    count: count,
  );

  Iterable<FlSpot> interpolateAll(double interval) => TransformMethods.interpolateAll(this, interval);
}

class TransformBuilder {
  final List<Iterable<FlSpot> Function(FlSpot)> _processors = [];

  void average([double interval = TransformMethods.defaultInterval]) {
    final average = InternalCenteredIntervalAverageGeneric(
      getX: TransformMethods.getX,
      getY: TransformMethods.getY,
      interval: interval,
    );
    _processors.add(
      (s) => average.processItem(s).map((r) => r.$1.copyWith(y: r.$2)),
    );
  }

  void averageRepeat({
    double interval = TransformMethods.defaultInterval,
    int count = 1,
  }) {
    for (final _ in Iterable.generate(count)) {
      average(interval);
    }
  }

  void removeOffset([double interval = TransformMethods.defaultInterval]) {
    final average = InternalCenteredIntervalAverageGeneric(
      getX: TransformMethods.getX,
      getY: TransformMethods.getY,
      interval: interval,
    );

    _processors.add(
      (s) => average.processItem(s).map((r) => r.$1.copyWith(y: r.$1.y - r.$2)),
    );
  }

  void removeOffsetRepeat({
    double interval = TransformMethods.defaultInterval,
    int count = 1,
  }) {
    for (final _ in Iterable.generate(count)) {
      removeOffset(interval);
    }
  }

  Iterable<FlSpot> add(FlSpot spot) sync* {
    if (_processors.isEmpty) {
      yield spot;
      return;
    }

    yield* _processRecursive(0, spot);
  }

  Iterable<FlSpot> _processRecursive(
    int processorIndex,
    FlSpot parameter,
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
