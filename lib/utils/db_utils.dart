import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DbUtil {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'points.db'),
      onCreate: ((db, version) {
        return db.execute(
            'CREATE TABLE points (id TEXT PRIMARY KEY, image1 TEXT, image2 TEXT, image3 TEXT, image4 TEXT)');
      }),
      version: 1,
    );
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DbUtil.database();
    await db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DbUtil.database();
    return db.query(table);
  }

  static queryImages(String pointLocalId) async {
    final db = await DbUtil.database();
    return db.rawQuery('SELECT * FROM points WHERE id=?', [pointLocalId]);
  }
}
