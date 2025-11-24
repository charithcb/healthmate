import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/health_provider.dart';

class RecordsListScreen extends ConsumerWidget {
  const RecordsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(healthProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Health Records"),
      ),
      body: ListView.builder(
        itemCount: records.length,
        itemBuilder: (context, index) {
          final r = records[index];

          return Dismissible(
            key: Key(r.id.toString()),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.redAccent,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (_) {
              ref.read(healthProvider.notifier).deleteRecord(r.id!);
            },
            child: Card(
              margin: const EdgeInsets.all(12),
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 15),
                title: Text(
                  "Date: ${r.date}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Steps: ${r.steps}"),
                        Text("Calories: ${r.calories}"),
                        Text("Water: ${r.water} ml"),
                      ]),
                ),
                leading: const Icon(Icons.health_and_safety_rounded,
                    color: Colors.blueAccent, size: 30),
              ),
            ),
          );
        },
      ),
    );
  }
}
