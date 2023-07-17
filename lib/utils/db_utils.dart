import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DbUtil {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'points.db'),
      onCreate: ((db, version) => createDb(db)),
      version: 1,
    );
  }

  static void createDb(Database db) {
    db.execute(
        'CREATE TABLE users (id INTEGER PRIMARY KEY, first_name TEXT, last_name TEXT, email TEXT, accept_use TEXT)');

    db.execute(
        'CREATE TABLE subjects (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, imageUrl TEXT)');

    db.execute(
        'CREATE TABLE points (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, lat REAL, long REAL, date TEXT, time TEXT, description TEXT, is_favorite TEXT DEFAULT "false", image1 TEXT, image2 TEXT, image3 TEXT, image4 TEXT,subject_id INTEGER, FOREIGN KEY (subject_id) REFERENCES subjects(id))');
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

  static Future<List<Map<String, dynamic>>> queryImages(
      String pointLocalId) async {
    final db = await DbUtil.database();
    return db.rawQuery('SELECT * FROM points WHERE id=?', [pointLocalId]);
  }
}
