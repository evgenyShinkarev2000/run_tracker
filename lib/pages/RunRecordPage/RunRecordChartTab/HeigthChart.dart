part of chart_tab;

class HeightChart extends StatelessWidget {
  final List<FlSpot> spots;
  final double minX;
  final double maxX;

  HeightChart({
    required this.spots,
    required this.minX,
    required this.maxX,
  });

  @override
  Widget build(BuildContext context) {
    for (var p in spots) {
      debugPrint("${p.x} ${p.y}");
    }
    return ChartBase(
      spots: spots,
      minX: minX,
      maxX: maxX,
      topCutInterval: 5,
      bottomCutInterval: 5,
      bottomTitlesSelector: (value, meta) => ChartHelper.durationToTitle(Duration(microseconds: value.round())),
      leftTitlesSelector: (value, meta) => value.round().toString(),
      leftTitlesReservedSize: 30,
      touchTooltipSelector: (value) => value.round().toString(),
    );
  }
}
