part of chart_tab;

class PulseChart extends StatelessWidget {
  final List<FlSpot> spots;
  final double minX;
  final double maxX;
  final double aspectRation;
  final double topCutInterval;
  final double? bottomCutInterval;

  PulseChart({
    required this.spots,
    required this.minX,
    required this.maxX,
    this.aspectRation = 2,
    this.topCutInterval = 10,
    this.bottomCutInterval,
  })  : assert(aspectRation > 0),
        assert(topCutInterval > 0),
        assert(bottomCutInterval == null || bottomCutInterval > 0);

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

    return AspectRatio(
      aspectRatio: aspectRation,
      child: LineChart(
        LineChartData(
          minX: minX,
          maxX: maxX,
          minY: minY,
          maxY: maxY,
          titlesData: FlTitlesData(
            topTitles: AxisTitles(),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 35,
                getTitlesWidget: (value, meta) => ChartHelper.getLeftTitlesWithEndPointsOffset(
                  value,
                  meta,
                  value.round().toString(),
                  context,
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                  interval: maxX / 2,
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final duration = Duration(microseconds: value.round());
                    final text = duration.hours > 0 ? duration.hhmmss : duration.mmss;

                    return ChartHelper.getBottomTitlesWithEndPointsOffset(value, meta, text, context);
                  }),
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
