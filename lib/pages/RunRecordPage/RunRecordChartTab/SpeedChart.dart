part of chart_tab;

class SpeedChart extends StatelessWidget {
  final List<FlSpot> spots;
  final double minX;
  final double maxX;

  SpeedChart({
    required this.spots,
    required this.minX,
    required this.maxX,
  });

  @override
  Widget build(BuildContext context) {
    return ChartBase(
      spots: spots,
      minX: minX,
      maxX: maxX,
      topCutInterval: 5,
      bottomTitlesSelector: (value, meta) => ChartHelper.durationToTitle(Duration(microseconds: value.round())),
      leftTitlesSelector: (value, meta) => value.roundTo(1).toStringWithoutTrailingZeros(),
      leftTitlesReservedSize: 30,
      touchTooltipSelector: (value) => value.roundTo(1).toStringWithoutTrailingZeros(),
    );
  }
}
