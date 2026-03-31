import 'package:flutter/material.dart';
import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Data/export.dart';
import 'package:run_tracker/Pages/TrackRecord/BarTab/IntervalType.dart';
import 'package:run_tracker/Pages/TrackRecord/BarTab/UnitType.dart';
import 'package:run_tracker/Services/Track/export.dart';
import 'package:run_tracker/Services/export.dart';
import 'package:run_tracker/Theme/export.dart';

class BarTable extends StatefulWidget {
  final IntervalType intervalType;
  final UnitType unitType;
  final Duration durationInterval;
  final Distance distanceInterval;
  final TrackRecordWithSummaryAndPoints trackRecord;

  const BarTable({
    super.key,
    required this.trackRecord,
    required this.intervalType,
    required this.unitType,
    required this.durationInterval,
    required this.distanceInterval,
  });

  @override
  State<BarTable> createState() => _BarTableState();
}

class _BarTableState extends State<BarTable> {
  late final List<List<PositionPoint>> path;
  List<Interval> intervals = [];
  Speed maxSpeed = Speed.zero;
  Pace maxPace = Pace.zero;

  @override
  void initState() {
    super.initState();

    path = widget.trackRecord.points.splitActiveSegments().toList();
    _updateIntervals();
  }

  @override
  void didUpdateWidget(covariant BarTable oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.intervalType != widget.intervalType ||
        widget.intervalType == IntervalType.distance &&
            oldWidget.distanceInterval != widget.distanceInterval ||
        widget.intervalType == IntervalType.time &&
            oldWidget.durationInterval != widget.durationInterval) {
      _updateIntervals();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        final interval = intervals[index];
        final (label, coef) = _buildUnitLabelAndCoef(interval);

        return Row(
          spacing: 8,
          children: [
            SizedBox(
              width: 40,
              child: Text(
                _buildIntervalLabel(interval, index),
                overflow: TextOverflow.clip,
                maxLines: 1,
                softWrap: false,
              ),
            ),
            SizedBox(height: 16, width: 1, child: VerticalDivider()),
            Expanded(
              child: Row(
                children: [
                  SizedBox(
                    width: 45,
                    child: Text(
                      label,
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      softWrap: false,
                    ),
                  ),
                  Flexible(
                    fit: .loose,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Container(
                          height: 16,
                          width: constraints.maxWidth * coef,
                          color: context.themeData.primaryColor,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16, width: 1, child: VerticalDivider()),
            SizedBox(
              width: 80,
              child: Text(
                interval.heightDelta.toStringAsFixed(1),
                overflow: TextOverflow.fade,
                maxLines: 1,
                softWrap: false,
              ),
            ),
          ],
        );
      },
      separatorBuilder: (_, _) => Divider(),
      itemCount: intervals.length,
    );
  }

  void _updateIntervals() {
    intervals = _buildIntervals().toList();
    maxSpeed = Speed.zero;
    maxPace = Pace.zero;
    for (final interval in intervals) {
      final speed = interval.distance / interval.duration;
      if (speed > maxSpeed) {
        maxSpeed = speed;
      }
      final pace = interval.duration / interval.distance;
      if (pace > maxPace) {
        maxPace = pace;
      }
    }
  }

  (String, double) _buildUnitLabelAndCoef(Interval interval) {
    switch (widget.unitType) {
      case .speed:
        final speed = interval.distance / interval.duration;
        return (
          speed.kilometersPerHour.toStringAsFixed(1),
          (speed / maxSpeed).clamp(0, 1),
        );
      case .pace:
        final pace = interval.duration / interval.distance;
        return (
          pace.tryConvertToDuration()?.mmss ?? "--:--",
          (pace / maxPace).clamp(0, 1),
        );
    }
  }

  String _buildIntervalLabel(Interval interval, int index) {
    final oneBasedIndex = index + 1;
    switch (widget.intervalType) {
      case .distance:
        var accumulated = oneBasedIndex * widget.distanceInterval.meters;
        if (oneBasedIndex == intervals.length) {
          accumulated += interval.distance.meters - widget.distanceInterval.meters;
        }
        return (accumulated / 1000).toStringAsFixed(1);
      case .time:
        var accumulated = widget.durationInterval * oneBasedIndex;
        if (oneBasedIndex == intervals.length) {
          accumulated += interval.duration - widget.durationInterval;
        }
        return accumulated.mmss;
    }
  }

  Iterable<Interval> _buildIntervals() sync* {
    var duration = Duration.zero;
    var distanceMeters = 0.0;
    var height = 0.0;
    PositionPoint? prevPoint;
    for (var points in path) {
      prevPoint = null;
      for (var point in points) {
        if (prevPoint == null) {
          prevPoint = point;
          height = point.altitude ?? 0;
          continue;
        }
        final nextDuration =
            duration + point.createdAt.difference(prevPoint.createdAt);
        final nextDistance =
            distanceMeters + (point.tryFindDistanceMeters(prevPoint) ?? 0);
        if (_shouldCloseInterval(nextDuration, nextDistance)) {
          final result = _interpolateIntervals(
            duration,
            distanceMeters,
            nextDuration,
            nextDistance,
          );
          yield Interval(
            duration: result.$1,
            distance: Distance(result.$2),
            heightDelta: (point.altitude ?? 0) - height,
          );
          height = point.altitude ?? 0;
          duration = result.$3;
          distanceMeters = result.$4;
        } else {
          duration = nextDuration;
          distanceMeters = nextDistance;
        }
        prevPoint = point;
      }
    }

    final interval = _tryBuildLastInterval(
      duration,
      distanceMeters,
      (prevPoint?.altitude ?? 0) - height,
    );
    if (interval != null) {
      yield interval;
    }
  }

  bool _shouldCloseInterval(Duration duration, double distanceMeters) {
    switch (widget.intervalType) {
      case .time:
        return duration > widget.durationInterval;
      case .distance:
        return distanceMeters > widget.distanceInterval.meters;
    }
  }

  (Duration, double, Duration, double) _interpolateIntervals(
    Duration duration,
    double distanceMeters,
    Duration nextDuration,
    double nextDistanceMeters,
  ) {
    assert(duration < nextDuration);
    assert(distanceMeters < nextDistanceMeters);

    switch (widget.intervalType) {
      case .time:
        if (nextDuration < widget.durationInterval) {
          throw AppException(
            message:
                "next duration $nextDuration must be >= duration interval ${widget.durationInterval}",
          );
        }
        final nextIntervalDuration = nextDuration - widget.durationInterval;
        final nextIntervalDurationCoef =
            nextIntervalDuration.inMicroseconds /
            (nextDuration - duration).inMicroseconds;
        final distanceDelta = nextDistanceMeters - distanceMeters;
        final nextIntervalDistance = distanceDelta * nextIntervalDurationCoef;

        return (
          widget.durationInterval,
          distanceMeters + distanceDelta - nextIntervalDistance,
          nextIntervalDuration,
          nextIntervalDistance,
        );
      case .distance:
        if (nextDistanceMeters < widget.distanceInterval.meters) {
          throw AppException(
            message:
                "next distance $nextDistanceMeters must be >= ${widget.distanceInterval.meters}",
          );
        }
        final nextIntervalDistance =
            nextDistanceMeters - widget.distanceInterval.meters;
        final nextIntervalDistanceCoef =
            nextIntervalDistance / (nextDistanceMeters - distanceMeters);
        final durationDelta = nextDuration - duration;
        final nextIntervalDuration = durationDelta * nextIntervalDistanceCoef;

        return (
          duration + durationDelta - nextIntervalDuration,
          widget.distanceInterval.meters,
          nextIntervalDuration,
          nextIntervalDistance,
        );
    }
  }

  Interval? _tryBuildLastInterval(
    Duration duration,
    double distanceMeters,
    double height,
  ) {
    switch (widget.intervalType) {
      case .time:
        if (duration == Duration.zero) {
          return null;
        }
      case .distance:
        if (distanceMeters == 0) {
          return null;
        }
    }

    return Interval(
      duration: duration,
      distance: Distance(distanceMeters),
      heightDelta: height,
    );
  }
}

class Interval {
  final Duration duration;
  final Distance distance;
  final double heightDelta;

  Interval({
    required this.duration,
    required this.distance,
    required this.heightDelta,
  });
}
