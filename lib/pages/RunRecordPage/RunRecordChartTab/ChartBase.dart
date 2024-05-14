part of chart_tab;

class ChartBase extends StatelessWidget {
  static const double titleBottomPadding = 8;
  final List<FlSpot> spots;
  final double minX;
  final double maxX;
  final double aspectRation;
  final double topCutInterval;
  final int? bottomTitlesCount;
  final double? bottomCutInterval;
  final double? leftTitlesReservedSize;
  final String Function(double value, TitleMeta meta)? leftTitlesSelector;
  final String Function(double value, TitleMeta meta)? bottomTitlesSelector;

  ChartBase({
    required this.spots,
    required this.minX,
    required this.maxX,
    this.aspectRation = 2,
    this.topCutInterval = 5,
    this.bottomTitlesCount = 3,
    this.leftTitlesReservedSize,
    this.bottomCutInterval,
    this.leftTitlesSelector,
    this.bottomTitlesSelector,
  })  : assert(aspectRation > 0),
        assert(topCutInterval > 0),
        assert(bottomCutInterval == null || bottomCutInterval > 0),
        assert(bottomTitlesCount == null || bottomTitlesCount >= 0);

  @override
  Widget build(BuildContext context) {
    if (spots.isEmpty) {
      return Center(
        child: Text(context.appLocalization.nounNoData),
      );
    }

    final maxY = (spots.max((p) => p.y)!.y / topCutInterval).ceilToDouble() * topCutInterval;
    var minY = 0.0;
    if (bottomCutInterval != null) {
      minY = (minY / bottomCutInterval!).floorToDouble() * bottomCutInterval!;
    }

    double? bottomInterval;
    if (bottomTitlesCount != null) {
      bottomInterval = bottomTitlesCount! >= 2 ? maxX / (bottomTitlesCount! - 1) : maxX;
    }

    final isBottomTitlesVisible = bottomTitlesSelector != null && (bottomTitlesCount == null || bottomTitlesCount! > 0);

    getBottomTitlesWidgetBuilder() {
      getBottomTitlesWidget(double value, TitleMeta meta) {
        final text = bottomTitlesSelector!.call(value, meta);

        return ChartHelper.getBottomTitlesWithEndPointsOffset(value, meta, text, context);
      }

      if (bottomTitlesCount == 1) {
        return (double value, TitleMeta meta) {
          if (value == meta.max) {
            return Container();
          }

          return getBottomTitlesWidget(value, meta);
        };
      }

      return getBottomTitlesWidget;
    }

    final touchTooltipTextStyle = context.themeData.textTheme.bodyMedium!;
    final touchTooltipBackgroundColor =
        Color.lerp(context.themeData.colorScheme.background, context.themeData.colorScheme.primary, 0.05)!;

    return AspectRatio(
      aspectRatio: aspectRation,
      child: LineChart(
        LineChartData(
          minX: minX,
          maxX: maxX,
          minY: minY,
          maxY: maxY,
          lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => touchTooltipBackgroundColor,
            getTooltipItems: (touchedSpots) {
              return touchedSpots
                  .map((ts) => LineTooltipItem(ts.y.roundTo(1).toStringWithoutTrailingZeros(), touchTooltipTextStyle))
                  .toList();
            },
          )),
          titlesData: FlTitlesData(
            topTitles: AxisTitles(),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                  showTitles: leftTitlesSelector != null,
                  reservedSize: leftTitlesReservedSize ?? 22,
                  getTitlesWidget: (value, meta) {
                    final text = leftTitlesSelector!.call(value, meta);

                    return ChartHelper.getLeftTitlesWithEndPointsOffset(value, meta, text, context);
                  }),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                  interval: bottomInterval,
                  showTitles: isBottomTitlesVisible,
                  getTitlesWidget: getBottomTitlesWidgetBuilder()),
            ),
            rightTitles: AxisTitles(),
          ),
          lineBarsData: [
            LineChartBarData(
              dotData: FlDotData(show: false),
              spots: spots,
            ),
          ],
        ),
      ),
    );
  }
}
