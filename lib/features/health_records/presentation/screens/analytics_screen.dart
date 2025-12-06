import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../provider/health_provider.dart';
import '../../data/models/health_record_model.dart';

import '../widgets/charts/steps_line_chart.dart';
import '../widgets/charts/calories_line_chart.dart';
import '../widgets/charts/water_line_chart.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(healthProvider);
    final filter = ref.watch(filterProvider);

    final filtered = _applyFilter(records, filter);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Analytics"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // FILTER BUTTONS
              _buildFilterButtons(ref),
              const SizedBox(height: 25),

              _sectionTitle("Steps Trend"),
              StepsLineChart(records: filtered),
              const SizedBox(height: 40),

              _sectionTitle("Calories Burned Trend"),
              CaloriesLineChart(records: filtered),
              const SizedBox(height: 40),

              _sectionTitle("Water Intake Trend"),
              WaterLineChart(records: filtered),
              const SizedBox(height: 40),

              _sectionTitle("Insights"),
              _buildInsights(filtered),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildFilterButtons(WidgetRef ref) {
    final filter = ref.watch(filterProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _filterButton(ref, FilterType.daily, "Daily"),
        _filterButton(ref, FilterType.weekly, "Weekly"),
        _filterButton(ref, FilterType.monthly, "Monthly"),
      ],
    );
  }

  Widget _filterButton(WidgetRef ref, FilterType type, String text) {
    final active = ref.watch(filterProvider) == type;

    return GestureDetector(
      onTap: () => ref.read(filterProvider.notifier).state = type,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
        decoration: BoxDecoration(
          color: active ? Colors.blueAccent : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: active ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }


  Widget _buildInsights(List<HealthRecordModel> records) {
    if (records.isEmpty) {
      return const Text(
        "Not enough data to show insights.",
        style: TextStyle(fontSize: 16),
      );
    }

    final mostSteps = records.reduce(
            (a, b) => a.steps > b.steps ? a : b);
    final leastSteps = records.reduce(
            (a, b) => a.steps < b.steps ? a : b);

    final avgWater = (records.fold(0, (sum, r) => sum + r.water)) /
        records.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _insightTile(
            "Best Day", "${mostSteps.date} (${mostSteps.steps} steps)"),

        _insightTile(
            "Lowest Activity", "${leastSteps.date} (${leastSteps.steps} steps)"),

        _insightTile(
            "Average Water Intake", "${avgWater.toStringAsFixed(0)} ml"),

      ],
    );
  }

  Widget _insightTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          const Icon(Icons.arrow_right, size: 26),
          const SizedBox(width: 5),
          Text(
            "$title : ",
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  List<HealthRecordModel> _applyFilter(
      List<HealthRecordModel> records,
      FilterType filter,
      ) {
    final now = DateTime.now();

    if (filter == FilterType.daily) {
      final today = DateFormat('yyyy-MM-dd').format(now);
      return records.where((r) => r.date == today).toList();
    }

    if (filter == FilterType.weekly) {
      final weekStart = now.subtract(Duration(days: now.weekday - 1));
      final weekEnd = weekStart.add(const Duration(days: 6));

      return records.where((r) {
        final d = DateTime.parse(r.date);
        return d.isAfter(weekStart.subtract(const Duration(days: 1))) &&
            d.isBefore(weekEnd.add(const Duration(days: 1)));
      }).toList();
    }

    if (filter == FilterType.monthly) {
      return records.where((r) {
        final d = DateTime.parse(r.date);
        return d.year == now.year && d.month == now.month;
      }).toList();
    }

    return [];
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
