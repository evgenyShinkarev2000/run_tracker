import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/date_symbols.dart';
import 'package:run_tracker/helpers/extensions/BuildContextExtension.dart';
import 'package:run_tracker/helpers/extensions/IterableExtension.dart';
import 'package:run_tracker/helpers/extensions/SettingExtension.dart';
import 'package:run_tracker/services/settings/settings.dart';

import 'BarChartTimeInterval.dart';

class BaseBarChart extends StatelessWidget {
  final Widget Function(double, TitleMeta) getLeftTitlesWidget;
  final String Function(double) getTouchTooltip;
  final BarChartTimeInterval barChartTimeMode;
  final int dayInMonth;
  final Map<int, double> rods;

  BaseBarChart({
    required this.barChartTimeMode,
    required this.dayInMonth,
    required this.rods,
    required this.getTouchTooltip,
    required this.getLeftTitlesWidget,
  });

  @override
  Widget build(BuildContext context) {
    final getBottomTitlesWidget = buildGetBottomTitlesWidget(context);
    final tooltipColor =
        Color.lerp(context.themeData.colorScheme.background, context.themeData.colorScheme.primary, 0.05)!;
    final barGroups = buildBarGroups().toList();

    return Container(
      height: 200,
      child: BarChart(
        BarChartData(
          maxY: barGroups.max((bg) => bg.barRods.first.toY)!.barRods.first.toY * 1.2,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(getTouchTooltip(rod.toY), context.themeData.textTheme.bodyMedium!);
              },
              getTooltipColor: (_) => tooltipColor,
            ),
          ),
          barGroups: barGroups,
          titlesData: FlTitlesData(
            rightTitles: AxisTitles(),
            topTitles: AxisTitles(),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 32,
                  getTitlesWidget: (value, meta) {
                    if (value == meta.max) {
                      return Container();
                    }

                    return getLeftTitlesWidget(value, meta);
                  }),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: getBottomTitlesWidget,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Iterable<BarChartGroupData> buildBarGroups() sync* {
    final indexes = getBarChartGroupIndexes();

    for (var i in indexes) {
      yield BarChartGroupData(x: i, barRods: [
        BarChartRodData(toY: rods[i] ?? 0.0),
      ]);
    }
  }

  Iterable<int> getBarChartGroupIndexes() {
    switch (barChartTimeMode) {
      case BarChartTimeInterval.week:
        return Iterable.generate(7, (index) => index);
      case BarChartTimeInterval.month:
        return Iterable.generate(dayInMonth, (index) => index);
      case BarChartTimeInterval.year:
        return Iterable.generate(12, (index) => index);
    }
  }

  List<String> buildDayWeekNames(BuildContext context) {
    final appSettings = context.read<SettingsProvider>().appSettings;
    final dateSymbols = dateTimeSymbolMap()[appSettings.locale.valueOrDefault!.languageCode] as DateSymbols;
    final dayWeekNames = dateSymbols.SHORTWEEKDAYS.map((d) => d).toList();
    final firstValue = dayWeekNames.removeAt(0);
    dayWeekNames.add(firstValue);

    return dayWeekNames;
  }

  List<String> buildMonthNames(BuildContext context) {
    final appSettings = context.read<SettingsProvider>().appSettings;
    final dateSymbols = dateTimeSymbolMap()[appSettings.locale.valueOrDefault!.languageCode] as DateSymbols;

    return dateSymbols.SHORTMONTHS;
  }

  Widget Function(double, TitleMeta) buildGetBottomTitlesWidget(BuildContext context) {
    switch (barChartTimeMode) {
      case BarChartTimeInterval.week:
        final dayWeekNames = buildDayWeekNames(context).toList();

        return (value, meta) {
          return Text(dayWeekNames[value.round()]);
        };

      case BarChartTimeInterval.month:
        return (value, meta) {
          return Text((value.round() + 1).toString());
        };

      case BarChartTimeInterval.year:
        final monthNames = buildMonthNames(context);

        return (value, meta) {
          return Text(monthNames[value.round()].toString());
        };
    }
  }
}
