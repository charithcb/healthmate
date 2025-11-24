import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/health_record_model.dart';
import '../provider/health_provider.dart';

class UpdateRecordScreen extends ConsumerStatefulWidget {
  final HealthRecordModel record;

  const UpdateRecordScreen({super.key, required this.record});

  @override
  ConsumerState<UpdateRecordScreen> createState() =>
      _UpdateRecordScreenState();
}

class _UpdateRecordScreenState
    extends ConsumerState<UpdateRecordScreen> {
  late TextEditingController stepsCtrl;
  late TextEditingController caloriesCtrl;
  late TextEditingController waterCtrl;

  @override
  void initState() {
    super.initState();
    stepsCtrl = TextEditingController(text: widget.record.steps.toString());
    caloriesCtrl = TextEditingController(text: widget.record.calories.toString());
    waterCtrl = TextEditingController(text: widget.record.water.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Update Record")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: stepsCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Steps"),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: caloriesCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Calories"),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: waterCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Water (ml)"),
            ),
            const SizedBox(height: 40),

            ElevatedButton(
              child: const Text("Save Changes"),
              onPressed: () {
                final updatedRecord = HealthRecordModel(
                  id: widget.record.id,
                  date: widget.record.date,
                  steps: int.parse(stepsCtrl.text),
                  calories: int.parse(caloriesCtrl.text),
                  water: int.parse(waterCtrl.text),
                );

                ref.read(healthProvider.notifier).updateRecord(updatedRecord);

                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
