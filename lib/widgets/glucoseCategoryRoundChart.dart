import 'package:diabetes_tfg_app/widgets/legendItem.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GlucoseCategoryRoundChart extends StatelessWidget {
  final int high;
  final int normal;
  final int low;

  const GlucoseCategoryRoundChart({
    required this.high,
    required this.normal,
    required this.low,
  });

  @override
  Widget build(BuildContext context) {
    final total = high + normal + low;

    return Column(
      children: [
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          width: 200,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 50,
              sections: [
                PieChartSectionData(
                  value: high.toDouble(),
                  color: Colors.black,
                  title: '${((high / total) * 100).toStringAsFixed(0)}%',
                  radius: 60,
                  titleStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                PieChartSectionData(
                  value: normal.toDouble(),
                  color: Color.fromARGB(255, 85, 42, 196),
                  title: '${((normal / total) * 100).toStringAsFixed(0)}%',
                  radius: 60,
                  titleStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                PieChartSectionData(
                  value: low.toDouble(),
                  color: Color(0xFF3C37FF),
                  title: '${((low / total) * 100).toStringAsFixed(0)}%',
                  radius: 60,
                  titleStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Leyenda
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LegendItem(color: Colors.black, label: "Elevadas: $high"),
            const SizedBox(width: 12),
            LegendItem(
                color: Color.fromARGB(255, 85, 42, 196),
                label: "Normales: $normal"),
            const SizedBox(width: 12),
            LegendItem(color: Color(0xFF3C37FF), label: "Bajas: $low"),
          ],
        ),
      ],
    );
  }
}
