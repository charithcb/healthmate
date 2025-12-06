import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/health_provider.dart';
import 'update_record_screen.dart';
import 'package:intl/intl.dart';

class RecordsListScreen extends ConsumerWidget {
  const RecordsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(healthProvider);
    final selectedDate = ref.watch(selectedDateProvider);

    // Filter logic
    final filteredRecords = selectedDate == null
        ? records
        : records.where((r) => r.date == DateFormat('yyyy-MM-dd').format(selectedDate)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Health Records"),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () => _pickDate(context, ref),
          ),
          if (selectedDate != null)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.red),
              onPressed: () => ref.read(selectedDateProvider.notifier).state = null,
            ),
        ],
      ),

      body: filteredRecords.isEmpty
          ? Center(
        child: Text(
          selectedDate == null
              ? "No Records Found"
              : "No records for ${DateFormat('yyyy-MM-dd').format(selectedDate)}",
          style: const TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: filteredRecords.length,
        itemBuilder: (context, index) {
          final r = filteredRecords[index];

          return Card(
            margin: const EdgeInsets.all(12),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: ListTile(
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),

              leading: const Icon(Icons.health_and_safety_rounded,
                  color: Colors.blueAccent, size: 32),

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

              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.green),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              UpdateRecordScreen(record: r),
                        ),
                      );
                    },
                  ),
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

  // Date picker
  Future<void> _pickDate(BuildContext context, WidgetRef ref) async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    );

    if (picked != null) {
      ref.read(selectedDateProvider.notifier).state = picked;
    }
  }

  // Delete conformation popup
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


