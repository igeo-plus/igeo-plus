import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:igeo_flutter/models/subject.dart';
import 'package:igeo_flutter/models/point.dart';
import '../models/point_list.dart';

import '../utils/routes.dart';

import '../components/point_item.dart';

class SubjectPointsScreen extends StatefulWidget {
  const SubjectPointsScreen({super.key});

  @override
  State<SubjectPointsScreen> createState() => _SubjectPointsScreenState();
}

class _SubjectPointsScreenState extends State<SubjectPointsScreen> {
  Point? newPoint;

  @override
  Widget build(BuildContext context) {
    final subject = ModalRoute.of(context)!.settings.arguments as Subject;

    final pointList = Provider.of<PointList>(context);

    void awaitResultFromNewPointScreen(BuildContext context) async {
      final result = await Navigator.pushNamed(context, AppRoutes.NEW_POINT,
          arguments: subject);

      if (result == null) {
        return;
      }

      setState(() {
        newPoint = result as Point;
        pointList.addPoint(newPoint!);
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
      body: ListView.builder(
        itemCount: pointList.getPointsForSubject(subject.id).length,
        itemBuilder: (ctx, index) {
          return Column(
            children: [
              PointItem(pointList.getPointsForSubject(subject.id)[index],
                  pointList.removePoint, pointList.togglePointFavorite),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => awaitResultFromNewPointScreen(context),
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
