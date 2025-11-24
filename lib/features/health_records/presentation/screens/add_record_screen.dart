import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/health_record_model.dart';
import '../provider/health_provider.dart';
import 'package:intl/intl.dart';

class AddRecordScreen extends ConsumerStatefulWidget {
  const AddRecordScreen({super.key});

  @override
  ConsumerState<AddRecordScreen> createState() =>
      _AddRecordScreenState();
}

class _AddRecordScreenState extends ConsumerState<AddRecordScreen> {
  final _formKey = GlobalKey<FormState>();

  final stepsCtrl = TextEditingController();
  final caloriesCtrl = TextEditingController();
  final waterCtrl = TextEditingController();
  String selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Health Record"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              TextFormField(
                controller: stepsCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Steps",
                  prefixIcon: Icon(Icons.directions_walk),
                ),
                validator: (v) =>
                v!.isEmpty ? "Enter steps" : null,
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: caloriesCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Calories",
                  prefixIcon:
                  Icon(Icons.local_fire_department),
                ),
                validator: (v) =>
                v!.isEmpty ? "Enter calories" : null,
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: waterCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Water Intake (ml)",
                  prefixIcon: Icon(Icons.water_drop),
                ),
                validator: (v) =>
                v!.isEmpty ? "Enter water intake" : null,
              ),

              const SizedBox(height: 15),

              Row(
                children: [
                  const Icon(Icons.calendar_month),
                  const SizedBox(width: 10),
                  Text(
                    selectedDate,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: pickDate,
                    child: const Text("Select Date"),
                  ),
                ],
              ),

              const Spacer(),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 55),
                ),
                onPressed: () => saveRecord(context),
                child: const Text("Save Record"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future pickDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        selectedDate = DateFormat('yyyy-MM-dd').format(date);
      });
    }
  }

  void saveRecord(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final newRecord = HealthRecordModel(
        date: selectedDate,
        steps: int.parse(stepsCtrl.text),
        calories: int.parse(caloriesCtrl.text),
        water: int.parse(waterCtrl.text),
      );

      print("Saving record: ${newRecord.toMap()}");

      ref.read(healthProvider.notifier).addRecord(newRecord);

      Navigator.pop(context);
    }
  }
}
