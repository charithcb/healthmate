import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../data/models/health_record_model.dart';

class StepsLineChart extends StatelessWidget {
  final List<HealthRecordModel> records;

  const StepsLineChart({super.key, required this.records});

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return const Text("No data for this filter.");
    }

    final spots = records.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.steps.toDouble());
    }).toList();

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Colors.orange,
              belowBarData: BarAreaData(show: false),
              dotData: const FlDotData(show: true),
            ),
          ],
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}
