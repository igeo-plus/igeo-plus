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

    final List<Point> selectedPoints =
        points.where((point) => point.subject_id == subject.id).toList();

    void addPoint(Point newPoint) {
      setState(() {
        selectedPoints.add(newPoint);
      });
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
          Navigator.pushNamed(context, AppRoutes.NEW_POINT, arguments: subject)
              .then(
            (newPoint) {
              addPoint(newPoint as Point);
            },
          ),
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
