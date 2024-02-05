import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
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

  Future postSubject(String name) async {
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

    await db.collection("subjects").doc(subjectId).set(subject).then((_) {
      debugPrint("New subject saved");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Campo adicionado'),
          duration: Duration(seconds: 2),
        ),
      );
    }
    ).onError((e, _) {
      debugPrint("Error saving sample: $e");
    });

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
      await db.collection("subjects").where("providerId", isEqualTo: uid).get().then((querySnapshot) async {
        late Subject subjectData;
        final subjects = querySnapshot.docs;
        for (var subject in subjects) {
          subjectData = Subject (
            id: subject.data()["id"],
            name: subject.data()["name"],
            providerId: subject.data()["providerId"],
            imgId: subject.data()["imgId"],
          );
          setState(() {
            this.subjects.add(subjectData);
          });
        }
        setState(() {
          isLoading = false;
        });
      }, onError: (e) {
        debugPrint("Error completing: $e");
      });
    } catch (e) {
      debugPrint('error in getSubjects(): $e');
    }
  }

  deleteSubject(String subjectId) async {
    try {
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
