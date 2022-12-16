import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

import 'package:igeo_flutter/models/subject.dart';
import 'package:igeo_flutter/models/point.dart';

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
    ];

    final selectedPoints =
        points.where((point) => point.subject_id == subject.id).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("${subject.name.toString()}"),
      ),
      body: ListView.builder(
        itemCount: selectedPoints.length,
        itemBuilder: (ctx, index) {
          return Text(selectedPoints[index].name as String);
        },
      ),
    );
  }
}
