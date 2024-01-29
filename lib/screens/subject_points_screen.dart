import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:igeo_flutter/models/subject.dart';
import 'package:igeo_flutter/models/point.dart';
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

  deletePoint(String subjectId, String pointId) async {
    final Reference folderRef = storage.ref().child(pointId);
    final ListResult result = await folderRef.listAll();

    // apagando as imagens do ponto
    for (final Reference ref in result.items) {
      await ref.delete();
    }

    await db.collection("subjects").doc(subjectId).collection("points").doc(pointId).delete().then(
      (doc) => debugPrint("Point deleted"),
      onError: (e) => debugPrint("Error updating document $e"),
    );
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
            Navigator.of(context).pop();
            pointList.removePoint(pointId);
            await deletePoint(subjectId, pointId);

            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Ponto deletado'),
                duration: Duration(seconds: 2),
                // action: SnackBarAction(
                //   label: 'DESFAZER',
                //   onPressed: () {
                //     cart.removeSingleItem(product.id);
                //   },
              ),
            );
          },
          child: const Text("Sim"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
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
      await db.collection("subjects").doc(widget.subject.id).collection("points").get().then((querySnapshot) {
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
          setState(() {
            points.add(pointData);
          });
        }
      }, onError: (e) {
        debugPrint("Error completing: $e");
      });

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      debugPrint('error in getSubjects(): $e');
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
      await db.collection("subjects")
          .doc(subject.id)
          .collection("points")
          .doc(newPoint.id)
          .set(newPoint.toMap()).then((_) {
        debugPrint("New point saved");
      }
      ).onError((e, _) {
        debugPrint("Error saving point: $e");
      });

      //getPoints(widget.userData["id"], widget.userData["token"]);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ponto adicionado'),
          duration: Duration(seconds: 2),
          // action: SnackBarAction(
          //   label: 'DESFAZER',
          //   onPressed: () {
          //     cart.removeSingleItem(product.id);
          //   },
          // ),
        ),
      );

      reloadPoints();
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
