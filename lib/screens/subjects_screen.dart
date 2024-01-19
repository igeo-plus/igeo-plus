import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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
  List<Subject> subjects = [];

  dynamic subjectData;

  ScrollController controller = ScrollController();

  getSubjects() async {
    subjects = [];
    subjectData = await DbUtil.getData("subjects");
    if (subjectData.length == 0) {
      print("vazio");
      return;
    }

    subjectData.forEach((subject) {
      subjects.add(
        Subject(id: subject["id"], name: subject["subject_name"]),
      );
    });
    subjects.forEach(
      (subject) => print("${subject.id} - ${subject.name}"),
    );
  }

  Future postSubject(String name) async {
    await DbUtil.insert('subjects', {
      'subject_name': name,
    });
  }

  void _addSubject(String name) {
    postSubject(name).then((value) => setState(() {
          subjects.add(Subject(
            id: subjects.isEmpty ? 0 : subjects.last.id + 1,
            name: name,
          ));
        }));

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Campo adicionado'),
        duration: Duration(seconds: 2),
      ),
    );
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
            child: NewSubjectForm(_addSubject),
          )
        );
      }
    );
  }

  deleteSubject(int userId, String token, int subjectId) async {
    final data = {
      "user_id": userId,
      "authentication_token": token,
      "id": subjectId
    };

    final http.Response response = await http.post(
      Uri.parse("https://app.uff.br/api/delete_subject_in_igeo"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    print("AQUI:" + response.body.toString());
    return response;
  }
  deleteSubjectDef(int subjectId) async {}

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
                    deleteSubjectDef,
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
