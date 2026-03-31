import 'package:run_tracker/Data/export.dart';

class TrackPointCollection {
  Iterable<BasePoint> get orderedPoints => _orderedPoints;
  final List<BasePoint> _orderedPoints;

  TrackPointCollection._(this._orderedPoints);

  factory TrackPointCollection.fromPoints(Iterable<BasePoint> points) {
    var list = List<BasePoint>.from(points);
    list.sort((a, b) {
      var compare = a.createdAt.compareTo(b.createdAt);
      if (compare != 0) {
        return compare;
      }

      final aType = CheckPointTypeVisitor.determineType(a);
      final bType = CheckPointTypeVisitor.determineType(b);
      if (aType == PointType.Resume) {
        return 1;
      } else if (bType == PointType.Pause) {
        return -1;
      }

      compare = a.id.compareTo(b.id);
      if (compare != 0) {
        return compare;
      }

      return aType.index.compareTo(bType.index);
    });

    return TrackPointCollection._(List.unmodifiable(list));
  }

  Iterable<List<PositionPoint>> splitActiveSegments() sync* {
    List<PositionPoint> positionPoints = [];
    var isPaused = false;
    for (var point in orderedPoints) {
      switch (CheckPointTypeVisitor.determineType(point)) {
        case PointType.Pause:
          isPaused = true;
          if (positionPoints.isNotEmpty) {
            yield positionPoints;
            positionPoints = [];
          }
          break;
        case PointType.Position:
          if (isPaused) {
            break;
          }
          positionPoints.add(point as PositionPoint);
          break;
        case PointType.Resume:
          isPaused = false;
          break;
      }
    }
    if (!isPaused && positionPoints.isNotEmpty) {
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
