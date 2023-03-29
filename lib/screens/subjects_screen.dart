import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';

import '../models/subject.dart';

import '../components/subject_item.dart';
import '../components/new_subject_form.dart';
import '../components/main_drawer.dart';

class SubjectsScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  const SubjectsScreen(this.userData, {super.key});

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  List<Subject> subjects = [];

  dynamic subjectData;

  Future<http.Response> getSubjects(int userId, String token) async {
    subjects = [];
    final dataUser = {"user_id": userId, "authentication_token": token};

    final http.Response response = await http.post(
      Uri.parse(
          'https://app.homologacao.uff.br/umm/api/get_subjects_from_igeo'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(dataUser),
    );

    var data = jsonDecode(response.body);
    subjectData = await data;

    print(data);
    setState(() async {
      if (subjectData.length == 0) {
        print("Vazio");
        return;
      }
      subjectData.forEach((subject) async {
        subjects.add(
          Subject(
            id: subject["id"],
            name: subject["name"],
          ),
        );
      });
    });
    return response;
  }

  Future<http.Response> postSubject(
      int subjectId, String name, int userId, String token) async {
    final data = {
      "user_id": userId,
      "authentication_token": token,
      "name": name
    };

    final http.Response response = await http.post(
      Uri.parse('https://app.homologacao.uff.br/umm/api/post_subject_in_igeo'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    return response;
  }

  void _addSubject(String name) {
    postSubject(subjects.isEmpty ? 0 : subjects.last.id + 1, name,
            widget.userData["id"], widget.userData["token"])
        .then((value) => setState(() {
              subjects.add(Subject(
                id: subjects.isEmpty ? 0 : subjects.last.id + 1,
                name: name,
              ));
              //getSubjects(widget.userData["id"], widget.userData["token"]);
            }));

    Navigator.of(context).pop();
    //getSubjects(widget.userData["id"], widget.userData["token"]);
  }

  _openNewSubjectFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return NewSubjectForm(_addSubject);
      },
    );
  }

  // @override
  // void initState() {
  //   super.initState();
  //   getSubjects(widget.userData["id"], widget.userData["token"]);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getSubjects(widget.userData["id"], widget.userData["token"]),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : subjects.length > 0
                    ? ListView.builder(
                        itemCount: subjects.length,
                        itemBuilder: (ctx, index) {
                          return SubjectItem(subjects[index], widget.userData);
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
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Nenhum trabalho de campo criado',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
      ),
      drawer: const MainDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openNewSubjectFormModal(context),
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
