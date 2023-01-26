import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';

import '../models/subject.dart';

import '../components/subject_item.dart';
import '../components/new_subject_form.dart';
import '../components/main_drawer.dart';

class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({super.key});

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  List<Subject> subjects = [];

  dynamic subjectData;

  getSubjects([int userId = 1]) async {
    var url = Uri.http("localhost:3000", "api/subjects/users/$userId");
    //print("ok 1");
    var response = await http.get(url);
    //print("ok 2");
    var data = jsonDecode(response.body);
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

  Future<http.Response> postSubject(int subjectId, String name,
      [int userId = 1]) async {
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

    // setState(() {
    //   _messages.add("Alerta gerado!");
    // });
    return response;
  }

  void _addSubject(String name) {
    setState(() {
      subjects.add(
        Subject(
          id: subjects.isEmpty ? 0 : subjects.last.id + 1,
          name: name,
        ),
      );
      postSubject(subjects.isEmpty ? 0 : subjects.last.id + 1, name);
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
    getSubjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: subjects.length,
        itemBuilder: (ctx, index) {
          return SubjectItem(subjects[index]);
        },
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
