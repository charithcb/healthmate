import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class HealthDB {
  // Singleton instance
  static final HealthDB instance = HealthDB._init();
  static Database? _database;

  HealthDB._init();

  // Get database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('health.db');
    return _database!;
  }

  // Initialize database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }


  Future _createDB(Database db, int version) async {

    await db.execute('''
      CREATE TABLE health_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        steps INTEGER,
        calories INTEGER,
        water INTEGER
      )
    ''');
  }
}


