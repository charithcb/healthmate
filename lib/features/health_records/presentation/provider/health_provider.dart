import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/health_record_model.dart';
import '../../data/repositories/health_repository_impl.dart';

// Dashboard Filter: daily / weekly / monthly
enum FilterType { daily, weekly, monthly }

// Dashboard filter state
final filterProvider = StateProvider<FilterType>((ref) => FilterType.daily);

// View Records: date filter state
final selectedDateProvider = StateProvider<DateTime?>((ref) => null);

// Main health records provider
final healthProvider =
StateNotifierProvider<HealthNotifier, List<HealthRecordModel>>((ref) {
  return HealthNotifier();
});

class HealthNotifier extends StateNotifier<List<HealthRecordModel>> {
  final _repo = HealthRepositoryImpl();

  HealthNotifier() : super([]) {
    loadRecords();
  }

  // Load all records from SQLite
  Future<void> loadRecords() async {
    final records = await _repo.getRecords();
    state = records;
    print("State updated: ${state.length} records");
  }

  // Add new health record
  Future<void> addRecord(HealthRecordModel record) async {
    await _repo.addRecord(record);
    await loadRecords();
  }

  // Delete record
  Future<void> deleteRecord(int id) async {
    await _repo.deleteRecord(id);
    await loadRecords();
  }

  // Update an existing record
  Future<void> updateRecord(HealthRecordModel record) async {
    await _repo.updateRecord(record);
    await loadRecords();
  }
}



