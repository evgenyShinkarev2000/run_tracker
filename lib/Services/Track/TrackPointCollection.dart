import 'package:run_tracker/Data/export.dart';

class TrackPointCollection {
  Iterable<BasePoint> get orderedPoints => _orderedPoints;
  final List<BasePoint> _orderedPoints;

  TrackPointCollection._(this._orderedPoints);

  factory TrackPointCollection.fromPoints(Iterable<BasePoint> points) {
    var list = List<BasePoint>.from(points);
    list.sort((a, b) {
      final compare = a.createdAt.compareTo(b.createdAt);

      return compare == 0 ? a.id.compareTo(b.id) : compare;
    });

    return TrackPointCollection._(List.unmodifiable(list));
  }

  Iterable<List<PositionPoint>> splitPath() sync* {
    List<PositionPoint> positionPoints = [];
    for (var point in orderedPoints) {
      switch (CheckPointTypeVisitor.determineType(point)) {
        case PointType.Pause:
          if (positionPoints.isNotEmpty) {
            yield positionPoints;
            positionPoints = [];
          }
          break;
        case PointType.Position:
          positionPoints.add(point as PositionPoint);
          break;
        case PointType.Resume:
          break;
      }
    }
    if (positionPoints.isNotEmpty) {
      yield positionPoints;
    }
  }

  Iterable<PositionPoint> activePositionPoints() sync* {
    var isPaused = false;
    for (var point in orderedPoints) {
      switch (CheckPointTypeVisitor.determineType(point)) {
        case PointType.Resume:
          isPaused = false;
          break;
        case PointType.Pause:
          isPaused = true;
          break;
        case PointType.Position:
          if (isPaused) {
            break;
          }
          yield point as PositionPoint;
          break;
      }
    }
  }
}
