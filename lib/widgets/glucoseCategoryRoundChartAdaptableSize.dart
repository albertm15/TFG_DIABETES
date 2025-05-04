import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GlucoseCategoryRoundChartAdaptableSize extends StatelessWidget {
  final int high;
  final int normal;
  final int low;

  const GlucoseCategoryRoundChartAdaptableSize({
    required this.high,
    required this.normal,
    required this.low,
  });

  @override
  Widget build(BuildContext context) {
    final total = high + normal + low;

    return Column(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 30,
              sections: [
                PieChartSectionData(
                  value: high.toDouble(),
                  color: Colors.black,
                  title: '${((high / total) * 100).toStringAsFixed(0)}%',
                  radius: 45,
                  titleStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                PieChartSectionData(
                  value: normal.toDouble(),
                  color: Color.fromARGB(255, 85, 42, 196),
                  title: '${((normal / total) * 100).toStringAsFixed(0)}%',
                  radius: 45,
                  titleStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                PieChartSectionData(
                  value: low.toDouble(),
                  color: Color(0xFF3C37FF),
                  title: '${((low / total) * 100).toStringAsFixed(0)}%',
                  radius: 45,
                  titleStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Leyenda
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem(Colors.black, "Elevadas: $high"),
            const SizedBox(width: 12),
            _buildLegendItem(
                Color.fromARGB(255, 85, 42, 196), "Normales: $normal"),
            const SizedBox(width: 12),
            _buildLegendItem(Color(0xFF3C37FF), "Bajas: $low"),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }
}
