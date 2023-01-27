import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';

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
  final pointList = PointList();

  dynamic pointData;

  getPoints([int userId = 1]) async {
    var url = Uri.http("localhost:3000", "api/points/users/$userId");
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    setState(() {
      pointData = data;
      if (pointData.length == 0) {
        return;
      }
      for (var el in pointData) {
        pointList.addPoint(
          Point(
            id: el["id"],
            user_id: el["user_id"],
            subject_id: el["subject_id"],
            name: el["name"],
            lat: el["latitude"],
            long: el["longitude"],
            date: el["date"],
            time: el["time"],
            description: el["description"],
            isFavorite: el["favorite"] as bool,
          ),
        );
        print(el["favorite"]);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getPoints();
  }

  @override
  Widget build(BuildContext context) {
    final subject = ModalRoute.of(context)!.settings.arguments as Subject;

    //final pointList = Provider.of<PointList>(context);

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
