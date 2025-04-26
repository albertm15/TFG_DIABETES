import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DailyGlucoseEvolutionChart extends StatelessWidget {
  final List<FlSpot> glucoseData;

  const DailyGlucoseEvolutionChart({required this.glucoseData});

  @override
  Widget build(BuildContext context) {
    return LineChart(LineChartData(
      maxX: 24,
      maxY: 500,
      minX: 0,
      minY: 0,
      gridData:
          FlGridData(show: true, horizontalInterval: 50, verticalInterval: 3),
      titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
              sideTitles:
                  SideTitles(showTitles: true, interval: 3, reservedSize: 24))),
      lineBarsData: [
        LineChartBarData(
          spots: glucoseData,
          isCurved: true,
          color: Color.fromARGB(255, 85, 42, 196),
        ),
      ],
    ));
  }
}
