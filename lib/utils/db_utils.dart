import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:permission_handler/permission_handler.dart';

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
        'CREATE TABLE subjects (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, subject_name TEXT, subject_imageUrl TEXT)');

    db.execute(
        'CREATE TABLE points (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, lat REAL, long REAL, date TEXT, time TEXT, description TEXT, is_favorite TEXT DEFAULT "false", image1 TEXT, image2 TEXT, image3 TEXT, image4 TEXT,subject_id INTEGER, FOREIGN KEY (subject_id) REFERENCES subjects(id))');

    db.execute(
        'CREATE TABLE accepts (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, accept TEXT)');

    db.rawInsert('INSERT INTO accepts (accept) VALUES("false")');
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
      int pointId, int subjectId) async {
    final db = await DbUtil.database();
    return db.rawQuery('SELECT * FROM points WHERE id=? AND subject_id=?',
        [pointId, subjectId]);
  }

  static Future<void> favoritePoint(int pointId, int subjectId) async {
    final db = await DbUtil.database();

    final data = db.rawQuery('SELECT * FROM points WHERE id=? AND subject_id=?',
        [pointId, subjectId]);

    data.then(
      (response) {
        if (response[0]["is_favorite"] == "false") {
          var result = db.rawUpdate('''
    UPDATE points
    SET is_favorite = ?
    WHERE id = ? AND subject_id = ?
    ''', ['true', pointId, subjectId]);
        }

        if (response[0]["is_favorite"] == "true") {
          var result = db.rawUpdate('''
    UPDATE points
    SET is_favorite = ?
    WHERE id = ? AND subject_id = ?
    ''', ['false', pointId, subjectId]);
        }
      },
    );
  }

  static Future<int> updateAccept() async {
    final db = await DbUtil.database();

    Map<String, String> row = {
      'accept': 'true',
    };

    var result = await db.update(
      'accepts',
      row,
      where: 'id = ?',
      whereArgs: [1],
    );

    return result;
  }

  static void generateCsv(List<List<dynamic>> inputData) async {
    List<List<dynamic>> data = inputData;
    print("teste");
    print(data);
    String csvData = const ListToCsvConverter().convert(data);
    print(csvData);
    final String directory =
        (await syspaths.getApplicationSupportDirectory()).path;
    final String documentsDirectory =
        (await syspaths.getApplicationDocumentsDirectory()).path;
    final path = "$directory/csv-${DateTime.now()}.csv";
    //final documentsPath = "$documentsDirectory/csv-${DateTime.now()}.csv";
    final documentsPath =
        "/storage/emulated/0/Download/csv-${DateTime.now()}.csv";
    print(path);
    print(documentsPath);
    final File file = File(path);
    final File downloadedFile = File(documentsPath);
    await file.writeAsString(csvData);
    var status = await Permission.storage.request();
    if (status.isGranted) {
      await downloadedFile.writeAsString(csvData);
    }
  }

  static Future<dynamic> downloadData() async {
    final db = await DbUtil.database();

    final int dataLength = await db
        .rawQuery(
            'SELECT p.long, p.lat, p.id, p.name, p.description, p.date, p.time, s.subject_name FROM points AS p JOIN subjects AS s on p.subject_id = s.id')
        .then((value) => value.length);

    if (dataLength == 0) {
      return;
    }

    List<List<dynamic>> listData = [
      [
        "long",
        "lat",
        "id",
        "name",
        "description",
        "date",
        "time",
        "subject_name"
      ],
    ];
    await db
        .rawQuery(
            'SELECT p.long, p.lat, p.id, p.name, p.description, p.date, p.time, s.subject_name FROM points AS p JOIN subjects AS s on p.subject_id = s.id')
        .then((value) {
      print("listdata");
      print(value);
      value.forEach((element) => listData.add([
            element["long"],
            element["lat"],
            element["id"],
            element["name"],
            element["description"],
            element["date"],
            element["time"],
            element["subject_name"],
          ]));
      generateCsv(listData);
    });

    return db.rawQuery(
        'SELECT p.long, p.lat, p.id, p.name, p.description, p.date, p.time, s.subject_name FROM points AS p JOIN subjects AS s on p.subject_id = s.id');
  }
}
