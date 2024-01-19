import 'package:firebase_auth/firebase_auth.dart';
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
  final auth = FirebaseAuth.instance;
  List<Subject> subjects = [];

  dynamic subjectData;

  ScrollController controller = ScrollController();

  // TODO: salvar subject no firebase
  Future postSubject(String name) async {
    String uid = auth.currentUser!.uid;
    DateTime registrationDate = DateTime.now();
    String millisecondsTimeStamp = registrationDate.millisecondsSinceEpoch.toString();
    String subjectId = "$uid$millisecondsTimeStamp";

    // TODO: salvar

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Campo adicionado'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // TODO: pegar subjects do firebase
  getSubjects() async {

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
