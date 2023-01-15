import 'package:flutter/material.dart';

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
  List<Subject> _subjects = [
    Subject(id: 1, name: "Geomorfologia", teacher: "Guilherme"),
    Subject(id: 2, name: "Pedologia", teacher: "Pedro"),
  ];

  void _addSubject(int id, String name, String teacher) {
    setState(() {
      _subjects.add(
        Subject(
          id: id,
          name: name,
          teacher: teacher,
        ),
      );
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
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Campos"),
      // ),
      body: ListView.builder(
        itemCount: _subjects.length,
        itemBuilder: (ctx, index) {
          return SubjectItem(_subjects[index]);
        },
      ),
      drawer: const MainDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openNewSubjectFormModal(context),
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
      ),
    );
  }
}
