import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

import 'package:igeo_flutter/models/subject.dart';
import 'package:igeo_flutter/models/point.dart';

import '../utils/routes.dart';
import '../screens/point_details_screen.dart';
import '../screens/new_point_form_screen.dart';

import '../components/point_item.dart';

class SubjectPointsScreen extends StatefulWidget {
  //final List<Point> points;
  SubjectPointsScreen();

  @override
  State<SubjectPointsScreen> createState() => _SubjectPointsScreenState();
}

class _SubjectPointsScreenState extends State<SubjectPointsScreen> {
  @override
  Widget build(BuildContext context) {
    final subject = ModalRoute.of(context)!.settings.arguments as Subject;

    final List<Point> points = [
      Point(
        id: 1,
        name: "Teste",
        lat: -22,
        long: -43,
        date: DateTime.now(),
        time: DateTime.now(),
        description: "bla bla bla",
        subject_id: 1,
        user_id: 1,
      ),
      Point(
        id: 2,
        name: "Teste",
        lat: -22,
        long: -43,
        date: DateTime.now(),
        time: DateTime.now(),
        description: "bla bla bla",
        subject_id: 1,
        user_id: 1,
      ),
    ];

    final selectedPoints =
        points.where((point) => point.subject_id == subject.id).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("${subject.name.toString()}"),
        actions: [
          IconButton(
            onPressed: () =>
                {Navigator.pushNamed(context, AppRoutes.NEW_POINT)},
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: PointItem(selectedPoints),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {Navigator.pushNamed(context, AppRoutes.NEW_POINT)},
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
      ),
    );
  }
}
