import 'package:flutter/material.dart';

import 'package:igeo_flutter/models/subject.dart';
import 'package:igeo_flutter/models/point.dart';

import '../utils/routes.dart';

import '../components/point_item.dart';

class SubjectPointsScreen extends StatefulWidget {
  const SubjectPointsScreen();

  @override
  State<SubjectPointsScreen> createState() => _SubjectPointsScreenState();
}

class _SubjectPointsScreenState extends State<SubjectPointsScreen> {
  Point? newPoint;
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
  ];

  @override
  Widget build(BuildContext context) {
    final subject = ModalRoute.of(context)!.settings.arguments as Subject;

    points = points.where((point) => point.subject_id == subject.id).toList();

    void awaitResultFromNewPointScreen(BuildContext context) async {
      final result = await Navigator.pushNamed(context, AppRoutes.NEW_POINT,
          arguments: subject);

      if (result == null) {
        return;
      }

      setState(() {
        newPoint = result as Point;
        points.add(newPoint!);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(subject.name),
        actions: [
          IconButton(
            onPressed: () => awaitResultFromNewPointScreen(context),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: PointItem(points),
      floatingActionButton: FloatingActionButton(
        onPressed: () => awaitResultFromNewPointScreen(context),
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
