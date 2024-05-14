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
      bottomTitlesSelector: (value, meta) {
        final duration = Duration(microseconds: value.toInt());

        return duration.hours > 0 ? duration.hhmmss : duration.mmss;
      },
      leftTitlesSelector: (value, meta) => value.roundTo(1).toStringWithoutTrailingZeros(),
      leftTitlesReservedSize: 28,
    );
  }
}
