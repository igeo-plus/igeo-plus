import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/subject.dart';
import '../models/point.dart';
import '../models/point_list.dart';

import '../components/subject_item.dart';
import '../components/new_subject_form.dart';
import '../components/main_drawer.dart';

class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({super.key});

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  List<Subject> subjects = [
    Subject(id: 1, name: "Geomorfologia", teacher: "Guilherme"),
    Subject(id: 2, name: "Pedologia", teacher: "Pedro"),
  ];

  List<Point> points = [
    Point(
      id: 1,
      name: "Teste 1",
      lat: -22,
      long: -43,
      date: DateTime.now().toString(),
      time: DateTime.now().toString(),
      description: "bla bla bla",
      subject_id: 1,
      user_id: 1,
    ),
    Point(
      id: 2,
      name: "Teste 2",
      lat: -22,
      long: -43,
      date: DateTime.now().toString(),
      time: DateTime.now().toString(),
      description: "bla bla bla",
      subject_id: 1,
      user_id: 1,
    ),
    Point(
      id: 1,
      name: "Teste 3",
      lat: -22,
      long: -43,
      date: DateTime.now().toString(),
      time: DateTime.now().toString(),
      description: "bla bla bla",
      subject_id: 2,
      user_id: 1,
    ),
  ];

  void _addSubject(int id, String name, String teacher) {
    setState(() {
      subjects.add(
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
    // final pointList = Provider.of<PointList>(context);

    // for (var i = 0; i < points.length; i++) {
    //   pointList.addPoint(points[i]);
    // }

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
