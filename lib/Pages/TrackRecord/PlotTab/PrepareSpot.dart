import 'package:fl_chart/fl_chart.dart';
import 'package:run_tracker/Core/export.dart';

class PrepareSpotsParams {
  final bool applyMovingAverage;
  final bool applyDownSampling;
  final double? movingAverageInterval;
  final int? downSamplingThreshold;

  PrepareSpotsParams({
    required this.applyDownSampling,
    required this.applyMovingAverage,
    this.downSamplingThreshold,
    this.movingAverageInterval,
  }) : assert(applyDownSampling && downSamplingThreshold != null),
       assert(applyMovingAverage && movingAverageInterval != null);
}

class PrepareSpots {
  Iterable<FlSpot> process(PrepareSpotsParams params, List<FlSpot> spots) {
    if (params.applyMovingAverage) {
      final intervalAverage = IntervalAverageGeneric<FlSpot>(
        intervalSize: params.movingAverageInterval!,
        getX: (s) => s.x,
        getY: (s) => s.y,
      );
      spots = spots.map((s) => s.copyWith(y: intervalAverage.add(s))).toList();
    }

    if (params.applyDownSampling) {
      final downSampler = LargeTriangleDownSamplingGeneric<FlSpot>(
        getX: (s) => s.x,
        getY: (s) => s.y,
      );

      return downSampler.downSample(spots, params.downSamplingThreshold!);
    }

    return spots;
  }
}
