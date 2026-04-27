import 'package:cancellation_token/cancellation_token.dart';
import 'package:flutter/material.dart';
import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Data/export.dart';
import 'package:run_tracker/Pages/Statistics/StatisticsInterval.dart';
import 'package:run_tracker/Services/export.dart';

class StatisticsService {
  final TrackRecordSummaryRepository _repository;
  final UserDateTimeConverter _converter;

  StatisticsService(this._repository, this._converter);

  Future<List<Interval>> getByIntervalAndStartDate(
    StatisticsInterval interval,
    DateTime start, [
    CancellationToken? ct,
  ]) async {
    assert(start.isUtc);
    ct?.throwIfCancelled();

    final end = _getEnd(start, interval);

    final summaries = await _repository.getByQuery(
      TrackRecordSummaryQueryModel(
        startStart: OptionalValue(start),
        startEnd: OptionalValue(end),
      ),
      ct,
    );
    final validSummaries = summaries.where((s) => _isValid(start, end, s));
    final intervals = _generateIntervals(start, interval);
    _fillIntervals(intervals, validSummaries, interval);

    return intervals;
  }

  static DateTime normilizeLocalDateTime(
    DateTime dateTime,
    StatisticsInterval interval,
  ) {
    assert(!dateTime.isUtc);

    switch (interval) {
      case .week:
        if (dateTime.weekday != 1) {
          dateTime = dateTime.subtract(Duration(days: dateTime.weekday - 1));
        }

        return DateTime(dateTime.year, dateTime.month, dateTime.day);
      case .month:
        return DateTime(dateTime.year, dateTime.month);
      case .year:
        return DateTime(dateTime.year);
    }
  }

  static bool _isValid(
    DateTime start,
    DateTime end,
    TrackRecordSummary summary,
  ) {
    return summary.start != null &&
        summary.activeDistance != null &&
        summary.activeDuration != null &&
        (summary.start!.isAfter(start) ||
            summary.start!.isAtSameMomentAs(start)) &&
        (summary.start!.isBefore(end) || summary.start!.isAtSameMomentAs(end));
  }

  static void _fillIntervals(
    List<Interval> intervals,
    Iterable<TrackRecordSummary> summaries,
    StatisticsInterval interval,
  ) {
    final keySelector = switch (interval) {
      .week => (DateTime d) => d.weekday - 1,
      .month => (DateTime d) => d.day - 1,
      .year => (DateTime d) => d.month - 1,
    };

    for (final summary in summaries) {
      final interval = intervals[keySelector(summary.start!)];
      ++interval.count;
      interval.distance += summary.activeDistance!;
      interval.duration += summary.activeDuration!;
    }
  }

  List<Interval> _generateIntervals(
    DateTime start,
    StatisticsInterval interval,
  ) {
    final count = switch (interval) {
      .week => 7,
      .month => _getDaysInMonth(start),
      .year => 12,
    };

    return List<Interval>.generate(
      count,
      (_) => Interval(duration: Duration(), distance: Distance(0), count: 0),
    );
  }

  DateTime _getEnd(DateTime start, StatisticsInterval interval) {
    return switch (interval) {
      .week => start.add(Duration(days: 7)),
      .month => start.add(Duration(days: _getDaysInMonth(start))),
      .year => start.copyWith(year: start.year + 1),
    };
  }

  int _getDaysInMonth(DateTime start) {
    start = start.fromUtcToUser(_converter);

    return DateUtils.getDaysInMonth(start.year, start.month);
  }
}

class Interval {
  Duration duration;
  Distance distance;
  int count;

  Interval({
    required this.duration,
    required this.distance,
    required this.count,
  });
}
