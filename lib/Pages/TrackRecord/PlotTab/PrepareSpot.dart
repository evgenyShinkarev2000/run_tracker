import 'package:fl_chart/fl_chart.dart';
import 'package:run_tracker/Core/export.dart';

class PrepareSpotsParams {
  final bool applyCenteredAverage;
  final bool applyMovingAverage;
  final bool applyDownSampling;
  final double? intervalAverage;
  final int? downSamplingThreshold;

  PrepareSpotsParams({
    required this.applyDownSampling,
    required this.applyMovingAverage,
    this.downSamplingThreshold,
    this.intervalAverage,
    required this.applyCenteredAverage,
  }) : assert(!applyDownSampling || downSamplingThreshold != null),
       assert(!applyCenteredAverage || intervalAverage != null),
       assert(!applyMovingAverage || intervalAverage != null);
}

class PrepareSpots {
  static final PrepareSpots instance = PrepareSpots();
  static final LargeTriangleDownSamplingGeneric<FlSpot> downSampler =
      LargeTriangleDownSamplingGeneric<FlSpot>(
        getX: (s) => s.x,
        getY: (s) => s.y,
      );
  static final CenteredIntervalAverageGeneric<FlSpot> centeredIntervalAverage =
      CenteredIntervalAverageGeneric(getX: (s) => s.x, getY: (s) => s.y);

  static IntervalAverageGeneric<FlSpot> createIntervalAverage(
    double intervalSize,
  ) {
    return IntervalAverageGeneric<FlSpot>(
      intervalSize: intervalSize,
      getX: (s) => s.x,
      getY: (s) => s.y,
    );
  }

  List<FlSpot> process(PrepareSpotsParams params, List<FlSpot> spots) {
    if (params.applyDownSampling) {
      spots = downSampler
          .downSample(spots, params.downSamplingThreshold!)
          .toList();
    }

    if (params.applyMovingAverage) {
      final intervalAverage = createIntervalAverage(params.intervalAverage!);
      spots = spots.map((s) => s.copyWith(y: intervalAverage.add(s))).toList();
    }
    if (params.applyCenteredAverage) {
      spots = centeredIntervalAverage
          .mapByCenteredAverage(spots, params.intervalAverage!)
          .map((e) => e.$1.copyWith(y: e.$2))
          .toList();
    }

    return spots;
  }
}
