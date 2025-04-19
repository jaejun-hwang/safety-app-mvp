import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'safety_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE daily_reports (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        site TEXT,
        content TEXT
      )
    ''');
  }

  Future<int> insertReport(Map<String, dynamic> report) async {
    final db = await database;
    return await db.insert('daily_reports', report);
  }

  Future<List<Map<String, dynamic>>> getReports() async {
    final db = await database;
    return await db.query('daily_reports');
  }
}
