import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:igeo_flutter/utils/routes.dart';
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
  final auth = FirebaseAuth.instance;

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
      "provider_id": uid,
      "img_id": "", // TODO: adicionar opção de inserir imagem
    };

    await db.collection("subjects").doc(subjectId).set(subject).then((_) {
      debugPrint("New subject saved");
      // TODO: recarregar subjects
      // Navigator.pushNamedAndRemoveUntil(context, AppRoutes.SUBJECTS, (route) => false);
    }
    ).onError((e, _) {
      debugPrint("Error saving sample: $e");
    });

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Campo adicionado'),
        duration: Duration(seconds: 2),
      ),
    );

    getSubjects();
  }

  Future<void> getSubjects() async {
    String uid = auth.currentUser!.uid;
    setState(() {
      subjects = [];
    });
    try {
      await db.collection("subjects").where("provider_id", isEqualTo: uid).get().then((querySnapshot) async {
        late Subject subjectData;
        final subjects = querySnapshot.docs;
        for (var subject in subjects) {
          // TODO: criar subject model
          subjectData = Subject (
              id: subject.data()["id"],
              name: subject.data()["name"],
              providerId: subject.data()["provider_id"],
              imgId: subject.data()["img_id"],
          );
          this.subjects.add(subjectData);
        }
      }, onError: (e) {
        debugPrint("Error completing: $e");
      });
    } catch (e) {
      debugPrint('error in getSubjects(): $e');
    }
  }

  // TODO: apagar subject do firebase
  deleteSubject(String subjectId) async {

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getSubjects(),
        builder: (context, snapshot) => snapshot.connectionState == ConnectionState.waiting
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.amber,
              ),
            )
          : subjects.isNotEmpty
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
