import 'package:diabetes_tfg_app/models/gluoseLogModel.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DailyGlucoseEvolutionChart extends StatelessWidget {
  final List<GlucoseLogModel> glucoseData;

  const DailyGlucoseEvolutionChart({required this.glucoseData});

  List<FlSpot> fromGlucoseLogsToFlSpots(List<GlucoseLogModel> dailyLogs) {
    List<FlSpot> spots = [];
    for (GlucoseLogModel log in dailyLogs) {
      List<String> timeStringParts = log.time.split(":");
      double hours = double.parse(timeStringParts[0]);
      double minutes = double.parse(timeStringParts[1]);
      double seconds = double.parse(timeStringParts[2]);
      double time = hours + (minutes / 60) + (seconds / 3600);
      spots.add(FlSpot(time, log.glucoseValue.toDouble()));
    }

    return spots;
  }

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
      lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (touchedSpot) => Colors.white)),
      lineBarsData: [
        LineChartBarData(
          spots: fromGlucoseLogsToFlSpots(glucoseData),
          isCurved: true,
          color: Color.fromARGB(255, 85, 42, 196),
        ),
      ],
    ));
  }
}
