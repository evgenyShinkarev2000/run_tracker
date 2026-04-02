import 'package:fl_chart/fl_chart.dart';

extension IterableExtension on Iterable<FlSpot> {
  (double minX, double maxX, double minY, double maxY)? flSpotMinMax() {
    final iterator = this.iterator;
    if (!iterator.moveNext()) {
      return null;
    }

    var minX = iterator.current.x;
    var maxX = minX;
    var minY = iterator.current.y;
    var maxY = minY;
    while (iterator.moveNext()) {
      if (minX > iterator.current.x) {
        minX = iterator.current.x;
      } else if (maxX < iterator.current.x) {
        maxX = iterator.current.x;
      }
      if (minY > iterator.current.y) {
        minY = iterator.current.y;
      } else if (maxY < iterator.current.y) {
        maxY = iterator.current.y;
      }
    }

    return (minX, maxX, minY, maxY);
  }
}
