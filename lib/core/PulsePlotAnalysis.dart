import 'package:run_tracker/core/LumyMeasuring.dart';

class PulsePlotAnalysis {
  final List<LumyMeasuring> measurements = [];
  final List<LumyMeasuring> maxExtremums = [];
  final List<LumyMeasuring> minExtremums = [];
  LumyMeasuring? maxLumyMeasuring;
  LumyMeasuring? minLumyMeasuring;

  void addMeasuring(LumyMeasuring lumyMeasuring) {
    if (minLumyMeasuring == null || lumyMeasuring.averageLumy < minLumyMeasuring!.averageLumy) {
      minLumyMeasuring = lumyMeasuring;
    }
    if (maxLumyMeasuring == null || lumyMeasuring.averageLumy > maxLumyMeasuring!.averageLumy) {
      maxLumyMeasuring = lumyMeasuring;
    }

    final length = measurements.length;
    if (length >= 2) {
      final measuring_2 = measurements[length - 2];
      final measuring_1 = measurements[length - 1];

      if (measuring_1.averageLumy > measuring_2.averageLumy && measuring_1.averageLumy > lumyMeasuring.averageLumy) {
        maxExtremums.add(measuring_1);
      } else if (measuring_1.averageLumy < measuring_2.averageLumy &&
          measuring_1.averageLumy < lumyMeasuring.averageLumy) {
        minExtremums.add(measuring_1);
      }
    }

    measurements.add(lumyMeasuring);
  }
}
