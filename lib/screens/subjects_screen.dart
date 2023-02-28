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

  // getSubjects2(int userId) async {
  //   var url = Uri.http("localhost:3000", "api/subjects/users/$userId");
  //   //print("ok 1");
  //   var response = await http.get(url);
  //   //print("ok 2");
  //   var data = jsonDecode(response.body);
  //   setState(() {
  //     subjectData = data;
  //     if (subjectData.length == 0) {
  //       print("Vazio");
  //       return;
  //     }
  //     for (var el in subjectData) {
  //       subjects.add(
  //         Subject(
  //           id: el["id"],
  //           name: el["name"],
  //         ),
  //       );
  //     }
  //   });
  // }

  getSubjects(int userId, String token) async {
    final dataUser = {
      "user": {"id": userId, "authentication_token": token}
    };
    final http.Response response = await http.post(
      Uri.parse('http://localhost:3000/api/get_subjects'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(dataUser),
    );

    var data = jsonDecode(response.body);

    print(data);
    setState(() {
      subjectData = data;
      if (subjectData.length == 0) {
        print("Vazio");
        return;
      }
      for (var el in subjectData) {
        subjects.add(
          Subject(
            id: el["id"],
            name: el["name"],
          ),
        );
      }
    });
  }

  Future<http.Response> postSubject(
      int subjectId, String name, int userId) async {
    final data = {
      "subject": {"id": "$subjectId", "name": name, "user_id": userId}
    };
    final http.Response response = await http.post(
      Uri.parse('http://localhost:3000/api/subjects/post_subject'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    return response;
  }

  void _addSubject(String name) {
    setState(() {
      subjects.add(Subject(
        id: subjects.isEmpty ? 0 : subjects.last.id + 1,
        name: name,
      ));
      postSubject(subjects.isEmpty ? 0 : subjects.last.id + 1, name,
          widget.userData["id"]);
    });

    Navigator.of(context).pop();
  }

  _openNewSubjectFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return NewSubjectForm(_addSubject);
      },
    );
  }

  @override
  void initState() {
    super.initState();

    getSubjects(widget.userData["id"], widget.userData["token"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: subjects.length > 0
          ? ListView.builder(
              itemCount: subjects.length,
              itemBuilder: (ctx, index) {
                return SubjectItem(subjects[index]);
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
      drawer: const MainDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openNewSubjectFormModal(context),
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
