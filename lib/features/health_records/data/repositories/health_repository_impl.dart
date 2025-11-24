import '../datasources/health_db.dart';
import '../models/health_record_model.dart';

class HealthRepositoryImpl {
  final db = HealthDB.instance;

  Future<int> addRecord(HealthRecordModel record) async {
    final database = await db.database;
    return database.insert('health_records', record.toMap());
  }

  Future<List<HealthRecordModel>> getRecords() async {
    final database = await db.database;
    final result = await database.query('health_records');
    return result.map((e) => HealthRecordModel.fromMap(e)).toList();
  }

  Future<int> updateRecord(HealthRecordModel record) async {
    final database = await db.database;
    return database.update(
      'health_records',
      record.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  Future<int> deleteRecord(int id) async {
    final database = await db.database;
    return database.delete(
      'health_records',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
