import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Data/export.dart';

class TrackSummary {
  static final TrackSummary empty = TrackSummary();

  final DateTime? start;
  final DateTime? end;
  final Duration? activeDuration;
  final Distance? activeDistance;
  final Duration? activePositioningDuration;

  TrackSummary({
    this.start,
    this.end,
    this.activeDuration,
    this.activeDistance,
    this.activePositioningDuration,
  });
}

class TrackSummaryCalculator {
  TrackSummary calculateSummary(List<BasePoint> points) {
    if (points.isEmpty) {
      return TrackSummary.empty;
    }

    points.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    final visitor = TrackPositionVisitor();
    for (final point in points) {
      point.accept(visitor);
    }
    
    return TrackSummary(
      start: points.first.createdAt,
      end: points.last.createdAt,
      activeDuration: _findActiveDuration(points),
      activeDistance: Distance(visitor.activeDistance),
      activePositioningDuration: visitor.activeDuration,
    );
  }

  Duration _findActiveDuration(List<BasePoint> points) {
    if (points.length <= 1) {
      return Duration.zero;
    }

    var previousPoint = points.first;
    var isPaused =
        CheckPointTypeVisitor.determineType(previousPoint) == PointType.Pause;
    var duration = Duration.zero;

    for (var point in points.skip(1).take(points.length - 2)) {
      switch (CheckPointTypeVisitor.determineType(point)) {
        case PointType.Position:
          continue;
        case PointType.Resume:
          isPaused = false;
          previousPoint = point;
        case PointType.Pause:
          if (!isPaused) {
            duration += point.createdAt.difference(previousPoint.createdAt);
          }
          isPaused = true;
          previousPoint = point;
      }
    }
    if (!isPaused) {
      duration = points.last.createdAt.difference(previousPoint.createdAt);
    }

    return duration;
  }
}

class TrackPositionVisitor implements ITrackRecordPointVisitor<void> {
  double get activeDistance => _activeDistance;
  double _activeDistance = 0;

  Duration get activeDuration => _activeDuration;
  Duration _activeDuration = Duration.zero;

  bool _isPaused = false;
  PositionPoint? _previousPositionPoint;

  @override
  void visitPausePoint(PausePoint pausePoint) {
    _isPaused = true;
    _previousPositionPoint = null;
  }

  @override
  void visitPositionPoint(PositionPoint positionPoint) {
    if (_isPaused) {
      return;
    }
    if (_previousPositionPoint != null) {
      final distance = AppPosition.tryFindDistanceByCoordinates(
        _previousPositionPoint!.latitude,
        _previousPositionPoint!.longitude,
        _previousPositionPoint!.altitude,
        positionPoint.latitude,
        positionPoint.longitude,
        positionPoint.altitude,
      );
      if (distance != null) {
        _activeDistance += distance;
        _activeDuration += positionPoint.createdAt.difference(
          _previousPositionPoint!.createdAt,
        );
      }
    }
    _previousPositionPoint = positionPoint;
  }

  @override
  void visitResumePoint(ResumePoint resumePoint) {
    _isPaused = false;
  }
}
