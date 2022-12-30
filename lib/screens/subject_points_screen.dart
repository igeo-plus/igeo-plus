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

    void _addPoint(
      int id,
      String name,
      double lat,
      double long,
      DateTime date,
      DateTime time,
      String description,
      int subject_id,
      int user_id,
    ) {
      final Point newPoint = Point(
        id: id,
        name: name,
        lat: lat,
        long: long,
        date: date,
        time: time,
        description: description,
        subject_id: subject_id,
        user_id: user_id,
      );

      setState(() {
        selectedPoints.add(newPoint);
      });

      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("${subject.name}"),
        actions: [
          IconButton(
            onPressed: () => {
              Navigator.pushNamed(
                context,
                AppRoutes.NEW_POINT,
                arguments: subject,
              ),
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: PointItem(selectedPoints),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.pushNamed(context, AppRoutes.NEW_POINT).then(
            (result) {
              print(result as String);
            },
          ),
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
