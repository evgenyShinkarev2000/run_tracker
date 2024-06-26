part of chart_tab;

class PulseChart extends StatelessWidget {
  final List<FlSpot> spots;
  final double minX;
  final double maxX;

  PulseChart({
    required this.spots,
    required this.minX,
    required this.maxX,
  });

  @override
  Widget build(BuildContext context) {
    return ChartBase(
      spots: spots,
      chartLineStyle: ChartLineStyle.dashed,
      isDotDataVisible: true,
      minX: minX,
      maxX: maxX,
      minY: 40,
      topCutInterval: 10,
      bottomTitlesSelector: (value, meta) => ChartHelper.durationToTitle(Duration(microseconds: value.round())),
      leftTitlesSelector: (value, meta) => value.round().toString(),
      leftTitlesReservedSize: 30,
      touchTooltipSelector: (value) => value.round().toString(),
    );
  }
}
