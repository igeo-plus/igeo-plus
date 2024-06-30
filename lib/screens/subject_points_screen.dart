import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:igeo_flutter/models/subject.dart';
import 'package:igeo_flutter/models/point.dart';
import 'package:sqflite/sqflite.dart';
import '../models/point_list.dart';

import '../utils/routes.dart';
import '../utils/db_utils.dart';

import '../components/point_item.dart';

class SubjectPointsScreen extends StatefulWidget {
  //final Map<String, dynamic> userData;
  final Subject subject;

  const SubjectPointsScreen(this.subject, {super.key});

  @override
  State<SubjectPointsScreen> createState() => _SubjectPointsScreenState();
}

class _SubjectPointsScreenState extends State<SubjectPointsScreen> {
  final db = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  final auth = FirebaseAuth.instance;
  PointList pointList = PointList();
  List<Point> points = [];
  bool isLoading = true;

  Future<Database> initializePointsDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = '$databasePath/points.db';

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE points(id TEXT PRIMARY KEY, name TEXT, date TEXT, time TEXT, user_id TEXT, subject_id TEXT, description TEXT, pickedImages TEXT, lat REAL, long REAL, isFavorite INTEGER)',
        );
      },
    );
  }

  deletePoint(String subjectId, String pointId) async {
    // Delete from local database
    try {
      final localDb = await initializePointsDatabase();
      await localDb.delete('points', where: 'id = ?', whereArgs: [pointId]);
      debugPrint("Point deleted from local database");
    } catch (e) {
      debugPrint("Error deleting point from local database: $e");
      // Handle the error, potentially by queuing the deletion for later
    }

    // Delete from Firebase Firestore
    try {
      await db.collection("subjects").doc(subjectId).collection("points").doc(pointId).delete().then(
            (doc) => debugPrint("Point deleted from Firebase"),
        onError: (e) => debugPrint("Error deleting point from Firebase: $e"),
      );
    } catch(e) {
      debugPrint("Error trying to delete point from firestore");
    }

    // Delete from Firebase Storage
    try {
      final Reference folderRef = storage.ref().child(pointId);
      final ListResult result = await folderRef.listAll();

      for (final Reference ref in result.items) {
        await ref.delete();
      }
    } catch(e) {
      debugPrint("Error deleting imge from storage");
    }
  }

  deletePointDef(String subjectId, String pointId) async {
    Widget alert = AlertDialog(
      title: const Text("Deletar ponto?",
          style: TextStyle(
            color: Color.fromARGB(255, 189, 39, 39),
          )),
      actions: [
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop(); // Close the dialog

            // 1. Delete point from all sources
            await deletePoint(subjectId, pointId);

            // 2. Update UI by removing point from the list and rebuilding
            setState(() {
              points.removeWhere((point) => point.id == pointId);
            });

            // 3. Show SnackBar
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Ponto deletado'),
                duration: Duration(seconds: 2),
              ),
            );

            // 4. Navigate
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SubjectPointsScreen(widget.subject)));
          },
          child: const Text("Sim"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SubjectPointsScreen(widget.subject)));
            setState(() {});
          },
          child: const Text("Não"),
        ),
      ],
    );
    showDialog(context: context, builder: (ctx) => alert);
  }

  bool toBoolean(String str, [bool strict = false]) {
    if (strict == true) {
      return str == '1' || str == 'true';
    }
    return str != '0' && str != 'false' && str != '';
  }

  Future<void> getSubjectPoints() async {
    setState(() {
      isLoading = true;
      points = [];
    });

    try {
      // Load points from local database
      final localDb = await initializePointsDatabase();
      final localPoints = await localDb.query('points', where: 'subject_id = ?', whereArgs: [widget.subject.id]);
      for (var pointMap in localPoints) {
        final pointData = Point(
          id: pointMap['id'] as String,
          user_id: pointMap['user_id'] as String,
          subject_id: pointMap['subject_id'] as String,
          name: pointMap['name'] as String,
          lat: pointMap['lat'] as double,
          long: pointMap['long'] as double,
          date: pointMap['date'] as String,
          time: pointMap['time'] as String,
          description: pointMap['description'] as String,
        );
        setState(() {
          points.add(pointData);
        });
      }
      setState(() {
        isLoading = false;
      });

      // Attempt to synchronize with Firebase (if online)
      try {
        final querySnapshot = await db.collection("subjects").doc(widget.subject.id).collection("points").get();
        final firebasePointIds = querySnapshot.docs.map((doc) => doc.id).toList();

        // Save local points to Firebase if they don't exist there
        for (var point in points) {
          if (!firebasePointIds.contains(point.id)) {
            await db.collection("subjects").doc(widget.subject.id).collection("points").doc(point.id).set(point.toMap());
            debugPrint("Local point ${point.id} saved to Firebase");
          }
        }

        // Load new points from Firebase
        for (var point in querySnapshot.docs) {
          late Point pointData;
          pointData = Point(
            id: point["id"],
            user_id: point["user_id"],
            subject_id: point["subject_id"],
            name: point["name"],
            lat: point["lat"],
            long: point["long"],
            date: point["date"],
            time: point["time"],
            description: point["description"],
          );

          // Check if point already exists in local list
          if (!points.any((p) => p.id == pointData.id)) {
            setState(() {
              points.add(pointData);
            });
          }
        }

      } catch (e) {
        debugPrint('Error getting online points: $e');
      }

    } catch (e) {
      debugPrint('Error in getSubjectPoints(): $e');
      setState(() {
        isLoading = false;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void changeFavorite(String pointId, String subjectId) {
    pointList.togglePointFavorite(pointId, subjectId);
  }

  // @override
  // void initState() {
  //   super.initState();
  //   getPoints(widget.userData["id"], widget.userData["token"]);
  // }
  Future<void> refresh(BuildContext context) async {
    setState(() {
      pointList = PointList();
    });
  }

  @override
  void initState() {
    super.initState();
    getSubjectPoints();
  }

  @override
  Widget build(BuildContext context) {
    //final subject = ModalRoute.of(context)!.settings.arguments as Subject;
    final Subject subject = widget.subject;

    print("testando:" + subject.name);
    //print(widget.userData);
    print(subject.name);

    void awaitResultFromNewPointScreen(BuildContext context, Function reloadPoints) async {
      final result = await Navigator.pushNamed(context, AppRoutes.NEW_POINT,
          arguments: {"subject": subject, "reloadPoints": reloadPoints});

      if (result == null) {
        return;
      }

      Point newPoint = result as Point;

      // Save to local database
      try {
        final localDb = await initializePointsDatabase();
        await localDb.insert('points', newPoint.toMap());
        debugPrint("New point saved to local database");
      } catch (e) {
        debugPrint("Error saving point to local database: $e");
      }

      getSubjectPoints();

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ponto adicionado'),
          duration: Duration(seconds: 2),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(subject.name),
        actions: [
          IconButton(
            onPressed: () => awaitResultFromNewPointScreen(context, getSubjectPoints),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.amber,
                ),
              )
            : points.isNotEmpty
                ? ListView.builder(
                    padding: const EdgeInsets.only(bottom: 50),
                    itemCount:
                        points.length,
                    itemBuilder: (ctx, index) {
                      return Column(
                        children: [
                          //Text("OK"),
                          PointItem(
                            points[index],
                            subject,
                            //widget.userData,
                            deletePointDef,
                            changeFavorite,
                            false,
                          )
                        ],
                      );
                    },
                  )
                : Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.gps_fixed,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Text(
                          'Adicione seu primeiro ponto',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => awaitResultFromNewPointScreen(context, getSubjectPoints),
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
