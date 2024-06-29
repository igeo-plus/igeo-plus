import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../models/subject.dart';
import '../components/subject_item.dart';
import '../components/new_subject_form.dart';
import '../components/main_drawer.dart';
import '../utils/db_utils.dart';

class SubjectsScreen extends StatefulWidget {
  //final Map<String, dynamic> userData;
  const SubjectsScreen();

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  final db = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  final auth = FirebaseAuth.instance;

  bool isLoading = true;
  late Map<String, dynamic> subject;
  List<Subject> subjects = [];

  ScrollController controller = ScrollController();

  Future<Database> initializePointsDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = '$databasePath/points.db';

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE subjects(id TEXT PRIMARY KEY, name TEXT, providerId TEXT, imgId TEXT)',
        );
      },
    );
  }

  Future<Database> initializeSubjectsDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = '$databasePath/subjects.db';

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE subjects(id TEXT PRIMARY KEY, name TEXT, providerId TEXT, imgId TEXT)',
        );
      },
    );
  }

  Future<void> postSubject(String name) async {
    String uid = auth.currentUser!.uid;
    DateTime registrationDate = DateTime.now();
    String millisecondsTimeStamp = registrationDate.millisecondsSinceEpoch.toString();
    String subjectId = "$uid$millisecondsTimeStamp";

    Map<String, dynamic> subject = {
      "id": subjectId,
      "name": name,
      "providerId": uid,
      "imgId": "", // TODO: adicionar opção de inserir imagem
    };

    // Save to Firebase
    try{
      await db.collection("subjects").doc(subjectId).set(subject).then((_) {
        debugPrint("New subject saved to Firebase");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Campo adicionado'),
            duration: Duration(seconds: 2),
          ),
        );
      }).onError((e, _) {
        debugPrint("Error saving to Firebase: $e");
      });
    }
    catch(e){
      debugPrint("Error saving to Firebase: $e");
    }

    // Save to local database
    try {
      final localDb = await initializeSubjectsDatabase();
      await localDb.insert('subjects', subject);
      debugPrint("New subject saved to local database");
    } catch (e) {
      debugPrint("Error saving to local database: $e");
    }

    Navigator.of(context).pop();
    getSubjects();
  }

  Future<void> getSubjects() async {
    String uid = auth.currentUser!.uid;
    setState(() {
      isLoading = true;
      subjects = [];
    });

    try {
      // Load from local database first
      final localDb = await initializeSubjectsDatabase();
      final localSubjects = await localDb.query('subjects', where: 'providerId = ?', whereArgs: [uid]);
      for (var subjectMap in localSubjects) {
        final subjectData = Subject(
          id: subjectMap['id'] as String,
          name: subjectMap['name'] as String,
          providerId: subjectMap['providerId'] as String,
          imgId: subjectMap['imgId'] as String,
        );
        setState(() {
          subjects.add(subjectData);
        });

        // Check if this subject exists in Firebase (for initial sync)
        final firebaseDoc = await db.collection("subjects").doc(subjectData.id).get();
        if (!firebaseDoc.exists) {
          await db.collection("subjects").doc(subjectData.id).set(subjectData.toMap());
          debugPrint("New subject synced to Firebase");
        }
      }

      // Check for internet connectivity
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
        // Fetch updates from Firebase (only if online)
        await db.collection("subjects").where("providerId", isEqualTo: uid).get().then((querySnapshot) async {
          final firebaseSubjects = querySnapshot.docs;
          for (var subject in firebaseSubjects) {
            final subjectData = Subject(
              id: subject.data()["id"],
              name: subject.data()["name"],
              providerId: subject.data()["providerId"],
              imgId: subject.data()["imgId"],
            );

            // Check if subject already exists locally, update if necessary
            final existingIndex = subjects.indexWhere((s) => s.id == subjectData.id);
            if (existingIndex != -1) {
              // Update existing subject
              setState(() {
                subjects[existingIndex] = subjectData;
              });
              // Update local database as well (using sqflite's update method)
              await localDb.update('subjects', subjectData.toMap(), where: 'id = ?', whereArgs: [subjectData.id]);
            } else {
              // Add new subject
              setState(() {
                subjects.add(subjectData);
              });
              // Insert into local database (using sqflite's insert method)
              await localDb.insert('subjects', subjectData.toMap());
            }
          }
        }, onError: (e) {
          debugPrint("Error completing Firebase fetch: $e");
        });
      } else {
        debugPrint("No internet connection, skipping Firebase fetch.");
        // Optionally display a message to the user indicating offline mode
      }

    } catch (e) {
      debugPrint('Error in getSubjects(): $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  deleteSubject(String subjectId) async {
    try {
      // Delete from local databases
      await db.collection("subjects").doc(subjectId).collection("points").get().then((querySnapshot) async {
          for (var point in querySnapshot.docs) {
            final Reference folderRef = storage.ref().child(point["id"]); // pega pasta de cada ponto
            final ListResult result = await folderRef.listAll(); // lista as imagens de cada pasta

            for (final Reference ref in result.items) {
              await ref.delete(); // apaga as imagens
            }

            await db.collection("subjects").doc(subjectId).collection("points").doc(point["id"]).delete().then(
              (doc) => debugPrint("Point deleted"),
              onError: (e) => debugPrint("Error updating document $e"),
            );
          }
        }, onError: (e) {
          debugPrint("Error completing: $e");
        });

        await db.collection("subjects").doc(subjectId).delete().then(
              (doc) => debugPrint("Subject deleted"),
          onError: (e) => debugPrint("Error updating document $e"),
        );
    } catch (e) {
      debugPrint('error in deleteSubject(): $e');
    }

    // Delete from local databases
    final subjectsDb = await initializeSubjectsDatabase();
    await subjectsDb.delete('subjects', where: 'id = ?', whereArgs: [subjectId]);
    debugPrint("Subject deleted from local database");

    final pointsDb = await initializePointsDatabase();
    await pointsDb.delete('points', where: 'subjectId = ?', whereArgs: [subjectId]); // Assuming you have a subjectId field in your points table
    debugPrint("Related points deleted from local database");
  }

  _openNewSubjectFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom),
            child: NewSubjectForm(postSubject),
          )
        );
      }
    );
  }

  @override
  void initState() {
    super.initState();
    getSubjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading ? const Center(child: CircularProgressIndicator()) : subjects.isNotEmpty
        ? ListView.builder(
          controller: controller,
          itemCount: subjects.length,
          itemBuilder: (ctx, index) {
            return SubjectItem(
              subjects[index],
              //widget.userData,
              deleteSubject,
            );
          },
        )
        : Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.beach_access,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(
                width: 5,
              ),
              const Text(
                'Nenhum trabalho de campo criado',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      drawer: const MainDrawer(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "btn1",
            onPressed: () {
              _openNewSubjectFormModal(context);
            },
            backgroundColor: Theme.of(context).primaryColor,
            child: const Icon(Icons.add),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: FloatingActionButton(
              heroTag: "btn2",
              onPressed: () {
                DbUtil.downloadData();
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Dados baixados'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              backgroundColor: Colors.blueGrey,
              child: const Icon(
                Icons.download,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
