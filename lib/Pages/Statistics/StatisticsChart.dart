import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart' hide Interval;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/date_symbols.dart';
import 'package:run_tracker/Core/Exceptions/export.dart';
import 'package:run_tracker/Core/Extension/export.dart';
import 'package:run_tracker/Pages/Statistics/StatisticsInterval.dart';
import 'package:run_tracker/Pages/Statistics/StatisticsService.dart';
import 'package:run_tracker/Providers/Settings/export.dart';
import 'package:run_tracker/Theme/export.dart';
import 'package:run_tracker/localization/export.dart';

class StatisticsChart extends ConsumerStatefulWidget {
  final StatisticsInterval intervalKind;
  final List<Interval> intervals;
  final Color leftColor;
  final String Function(double) formatLeftTouchY;
  final String Function(double) formatLeftTitlesY;
  final double Function(Interval) getLeftY;
  final Color rightColor;
  final String Function(double) formatRightTouchY;
  final String Function(double) formatRightTitlesY;
  final double Function(Interval) getRightY;

  const StatisticsChart({
    super.key,
    required this.intervalKind,
    required this.intervals,
    required this.formatLeftTouchY,
    required this.formatLeftTitlesY,
    required this.getLeftY,
    required this.formatRightTouchY,
    required this.formatRightTitlesY,
    required this.getRightY,
    required this.leftColor,
    required this.rightColor,
  });

  @override
  ConsumerState<StatisticsChart> createState() => _StatisticsChartState();
}

class _StatisticsChartState extends ConsumerState<StatisticsChart> {
  List<BarChartGroupData> _bars = [];
  double _leftFactor = 1;
  double _rightFactor = 1;

  @override
  void initState() {
    super.initState();

    _updateChart();
  }

  @override
  void didUpdateWidget(covariant StatisticsChart oldWidget) {
    if (widget.intervals != oldWidget.intervals) {
      _updateChart();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: .horizontal,
          child: Container(
            padding: EdgeInsets.only(top: 8),
            width: max(constraints.maxWidth, _getChartMinWidth()),
            height: constraints.minHeight,
            child: _buildChart(context),
          ),
        );
      },
    );
  }

  double _getChartMinWidth() {
    return switch (widget.intervalKind) {
      .week => 300,
      .month => 900,
      .year => 600,
    };
  }

  Widget _buildChart(BuildContext context) {
    final touchTooltipBackgroundColor =
        context.themeData.colorScheme.surfaceContainer;
    Color getBackgroundColor(BarChartGroupData _) =>
        touchTooltipBackgroundColor;
    final formatBottomTitles = _buildGetBottomTitlesWidget();

    return BarChart(
      BarChartData(
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: _getBarTooltipItem,
            getTooltipColor: getBackgroundColor,
            fitInsideVertically: true,
            fitInsideHorizontally: true,
          ),
        ),
        barGroups: _bars,
        maxY: 1,
        minY: 0,
        titlesData: FlTitlesData(
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 44,
              interval: 0.5,
              getTitlesWidget: (value, meta) => SideTitleWidget(
                meta: meta,
                fitInside: .fromTitleMeta(meta),
                child: Text(widget.formatRightTitlesY(value / _rightFactor)),
              ),
            ),
          ),
          topTitles: AxisTitles(),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              interval: 0.5,
              getTitlesWidget: (value, meta) => SideTitleWidget(
                fitInside: .fromTitleMeta(meta),
                meta: meta,
                child: Text(widget.formatLeftTitlesY(value / _leftFactor)),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: formatBottomTitles,
            ),
          ),
        ),
      ),
    );
  }

  void _updateChart() {
    var max = widget.intervals.selectMaxNum(widget.getLeftY) ?? 0;
    _leftFactor = max == 0 ? 1 : 1 / max;
    max = widget.intervals.selectMaxNum(widget.getRightY) ?? 0;
    _rightFactor = max == 0 ? 1 : 1 / max;

    _bars = widget.intervals.indexed
        .map(
          (i) => BarChartGroupData(
            x: i.$1,
            barRods: [
              BarChartRodData(
                toY: _leftFactor * widget.getLeftY(i.$2),
                color: widget.leftColor,
              ),
              BarChartRodData(
                toY: _rightFactor * widget.getRightY(i.$2),
                color: widget.rightColor,
              ),
            ],
          ),
        )
        .toList();
  }

  DateSymbols _getDateSymbols() {
    return dateTimeSymbolMap()[ref
                .read(localeProvider)
                .value
                ?.locale
                .languageCode ??
            AppLocales.fallback.locale.languageCode]
        as DateSymbols;
  }

  List<String> _buildDayWeekNames() {
    final dayWeekNames = _getDateSymbols().SHORTWEEKDAYS.map((d) => d).toList();
    final firstValue = dayWeekNames.removeAt(0);
    dayWeekNames.add(firstValue);

    return dayWeekNames;
  }

  List<String> buildMonthNames(BuildContext context) {
    return _getDateSymbols().SHORTMONTHS;
  }

  Widget Function(double, TitleMeta) _buildGetBottomTitlesWidget() {
    switch (widget.intervalKind) {
      case .week:
        final dayWeekNames = _buildDayWeekNames();

        return (value, meta) {
          return Text(dayWeekNames[value.round()]);
        };
      case .month:
        return (value, meta) {
          return Text((value + 1).toStringAsFixed(0));
        };

      case .year:
        final monthNames = buildMonthNames(context);

        return (value, meta) {
          return Text(monthNames[value.round()]);
        };
    }
  }

  BarTooltipItem _getBarTooltipItem(
    BarChartGroupData group,
    int groupIndex,
    BarChartRodData bar,
    int barIndex,
  ) {
    return switch (barIndex) {
      0 => BarTooltipItem(
        widget.formatLeftTouchY(bar.toY / _leftFactor),
        context.themeData.textTheme.bodyMedium!,
      ),
      1 => BarTooltipItem(
        widget.formatRightTouchY(bar.toY / _rightFactor),
        context.themeData.textTheme.bodyMedium!,
      ),
      _ => throw NotSupportedException(),
    };
  }
}
