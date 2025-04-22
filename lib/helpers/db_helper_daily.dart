import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/daily_report.dart';

class DailyDBHelper {
  static Database? _db;
  static const String dbName = 'daily_reports.db';
  static const String tableName = 'daily_reports';

  /// DB 인스턴스 반환 (싱글톤)
  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  /// DB 초기화 및 테이블 생성
  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(_createTableSQL);
    });
  }

  static const String _createTableSQL = '''
    CREATE TABLE IF NOT EXISTS $tableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      date TEXT,
      siteName TEXT,
      workDescription TEXT,
      workerCount INTEGER,
      weather TEXT,
      issues TEXT
    )
  ''';

  /// 일일작업일보 저장
  static Future<void> insertReport(DailyReport report) async {
    final db = await database;
    try {
      await db.insert(tableName, report.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      print('✅ 일일작업일보 저장 완료');
    } catch (e) {
      print('❌ 저장 실패: \$e');
    }
  }

  /// 일일작업일보 전체 조회
  static Future<List<DailyReport>> getReports() async {
    final db = await database;
    final maps = await db.query(tableName);
    return maps.map((e) => DailyReport.fromMap(e)).toList();
  }

  /// 일일작업일보 수정
  static Future<void> updateReport(DailyReport report) async {
    final db = await database;
    try {
      await db.update(
        tableName,
        report.toMap(),
        where: 'id = ?',
        whereArgs: [report.id],
      );
      print('📝 일일작업일보 수정 완료');
    } catch (e) {
      print('❌ 수정 실패: \$e');
    }
  }

  /// 일일작업일보 삭제
  static Future<void> deleteReport(int id) async {
    final db = await database;
    try {
      await db.delete(
        tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
      print('🗑️ 일일작업일보 삭제 완료');
    } catch (e) {
      print('❌ 삭제 실패: \$e');
    }
  }
}