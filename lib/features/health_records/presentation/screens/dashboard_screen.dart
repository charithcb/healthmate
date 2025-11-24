import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../provider/health_provider.dart';
import '../../data/models/health_record_model.dart';

import 'add_record_screen.dart';
import 'records_list_screen.dart';
import 'analytics_screen.dart';

import '../../../../core/theme/theme_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(healthProvider);

    // TODAY FILTER ONLY
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final todayRecords = records.where((r) => r.date == today).toList();

    final totalSteps =
    todayRecords.fold(0, (sum, r) => sum + r.steps);
    final totalCalories =
    todayRecords.fold(0, (sum, r) => sum + r.calories);
    final totalWater =
    todayRecords.fold(0, (sum, r) => sum + r.water);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "HealthMate Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,

        actions: [
          Consumer(
            builder: (context, ref, child) {
              final isDark = ref.watch(themeProvider);

              return IconButton(
                icon: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
                onPressed: () {
                  ref.read(themeProvider.notifier).state = !isDark;
                },
              );
            },
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildStatCard(
              title: "Today's Steps",
              value: "$totalSteps",
              icon: Icons.directions_walk,
              color: Colors.orange,
            ),
            const SizedBox(height: 20),

            _buildStatCard(
              title: "Calories Burned",
              value: "$totalCalories kcal",
              icon: Icons.local_fire_department,
              color: Colors.red,
            ),
            const SizedBox(height: 20),

            _buildStatCard(
              title: "Water Intake",
              value: "$totalWater ml",
              icon: Icons.water_drop,
              color: Colors.blue,
            ),

            const Spacer(),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const AddRecordScreen()),
                );
              },
              icon: const Icon(Icons.add_circle_outline,
                  color: Colors.white),
              label: const Text(
                "Add New Record",
                style: TextStyle(fontSize: 17, color: Colors.white),
              ),
            ),

            const SizedBox(height: 15),

            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const RecordsListScreen()),
                );
              },
              icon: const Icon(Icons.list_alt),
              label: const Text(
                "View Records",
                style: TextStyle(fontSize: 17),
              ),
            ),

            const SizedBox(height: 15),

            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const AnalyticsScreen()),
                );
              },
              icon: const Icon(Icons.analytics_outlined),
              label: const Text(
                "Analytics",
                style: TextStyle(fontSize: 17),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 5),
              Text(value,
                  style: TextStyle(
                      fontSize: 22,
                      color: color,
                      fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }
}





