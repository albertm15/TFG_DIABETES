import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GlucoseHyperHypoBarChart extends StatelessWidget {
  final int hypoCount;
  final int hyperCount;

  const GlucoseHyperHypoBarChart({
    required this.hypoCount,
    required this.hyperCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 30,
              sections: [
                PieChartSectionData(
                  value: hyperCount.toDouble(),
                  color: Colors.black,
                  title: "${hyperCount}",
                  radius: 45,
                  titleStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                PieChartSectionData(
                  value: hypoCount.toDouble(),
                  color: Color(0xFF3C37FF),
                  title: "${hypoCount}",
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
            _buildLegendItem(Colors.black, "Hyperglucemias"),
            const SizedBox(width: 12),
            _buildLegendItem(Color(0xFF3C37FF), "Hypoglucemias"),
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
