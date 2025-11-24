import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/health_provider.dart';
import 'update_record_screen.dart';

class RecordsListScreen extends ConsumerWidget {
  const RecordsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(healthProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Health Records"),
      ),
      body: records.isEmpty
          ? const Center(
        child: Text(
          "No Records Found",
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: records.length,
        itemBuilder: (context, index) {
          final r = records[index];

          return Card(
            margin: const EdgeInsets.all(12),
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: ListTile(
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),

              // LEFT ICON
              leading: const Icon(Icons.health_and_safety_rounded,
                  color: Colors.blueAccent, size: 32),

              // TITLE + DETAILS
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

              // RIGHT SIDE BUTTONS
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // EDIT BUTTON
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.green),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => UpdateRecordScreen(record: r),
                        ),
                      );
                    },
                  ),

                  // DELETE BUTTON
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _showDeleteDialog(context, ref, r.id!);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // DELETE CONFIRMATION DIALOG
  void _showDeleteDialog(BuildContext context, WidgetRef ref, int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Record"),
        content: const Text("Are you sure you want to delete this record?"),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
            onPressed: () {
              ref.read(healthProvider.notifier).deleteRecord(id);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

