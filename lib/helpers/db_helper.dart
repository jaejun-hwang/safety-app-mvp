import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/work_permit.dart';

class DBHelper {
  static Database? _db;
  static const String databaseName = 'work_permits.db';
  static const String tableName = 'work_permits';

  static Future<Database> get database async {
    if (_db != null) {
      return _db!;
    }
    _db = await _initDatabase();
    return _db!;
  }

  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, databaseName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS $tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            constructionName TEXT,
            location TEXT,
            content TEXT,
            date TEXT,
            supervisor TEXT,
            workerCount INTEGER,
            safetyChecked INTEGER,
            notes TEXT
          )
        ''');
      },
    );
  }

  static Future<void> insertWorkPermit(WorkPermit permit) async {
    final db = await database;
    try {
      await db.insert(
        tableName,
        permit.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('작업허가서 저장 완료 (DB)');
    } catch (e) {
      print('데이터베이스 저장 오류: $e');
    }
  }

  static Future<List<WorkPermit>> getWorkPermits() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return WorkPermit.fromMap(maps[i]);
    });
  }

  // ✅ [추가] 작업허가서 수정 기능
  static Future<void> updateWorkPermit(WorkPermit permit) async {
    final db = await database;
    try {
      await db.update(
        tableName,
        permit.toMap(),
        where: 'id = ?',
        whereArgs: [permit.id],
      );
      print('작업허가서 수정 완료 (DB)');
    } catch (e) {
      print('수정 실패: $e');
    }
  }
  // [추가] 작업허가서 삭제 기능
  static Future<void> deleteWorkPermit(int id) async {
    final db = await database;
    try {
      await db.delete(
        tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
      print('작업허가서 삭제 완료 (DB)');
    } catch (e) {
      print('삭제 실패: $e');
    }
  }
}
