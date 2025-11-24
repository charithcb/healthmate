import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/health_record_model.dart';
import '../../data/repositories/health_repository_impl.dart';

enum FilterType { daily, weekly, monthly }

final filterProvider = StateProvider<FilterType>((ref) => FilterType.daily);

final healthProvider = StateNotifierProvider<HealthNotifier, List<HealthRecordModel>>((ref) {
  return HealthNotifier();
});

class HealthNotifier extends StateNotifier<List<HealthRecordModel>> {
  final _repo = HealthRepositoryImpl();

  HealthNotifier() : super([]) {
    loadRecords();
  }

  Future<void> loadRecords() async {
    final records = await _repo.getRecords();
    state = records;
    print("State updated: ${state.length} records");
  }

  Future<void> addRecord(HealthRecordModel record) async {
    await _repo.addRecord(record);
    await loadRecords();  // refresh UI
  }

  Future<void> deleteRecord(int id) async {
    await _repo.deleteRecord(id);
    await loadRecords();  // refresh UI
  }

  Future<void> updateRecord(HealthRecordModel record) async {
    await _repo.updateRecord(record);
    await loadRecords();
  }
}


