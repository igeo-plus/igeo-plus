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
  PointList pointList = PointList();
  //const SubjectPointsScreen({super.key});

  @override
  State<SubjectPointsScreen> createState() => _SubjectPointsScreenState();
}

class _SubjectPointsScreenState extends State<SubjectPointsScreen> {
  Point? newPoint;

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
        widget.pointList.addPoint(
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

  postPoint(int subjectId, String name, double latitude, double longitude,
      String date, String time, String description,
      [int userId = 1]) async {
    final data = {
      "point": {
        "user_id": userId,
        "subject_id": subjectId,
        "name": name,
        "latitude": latitude,
        "longitude": longitude,
        "date": date,
        "time": time,
        "description": description
      }
    };
    final http.Response response = await http.post(
      Uri.parse('http://localhost:3000/api/points/post_point'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
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
        postPoint(subject.id, result.name!, result.lat!, result.long!,
            result.date!, result.time!, result.description!);
        widget.pointList.addPoint(newPoint!);
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
        itemCount: widget.pointList.getPointsForSubject(subject.id).length,
        itemBuilder: (ctx, index) {
          return Column(
            children: [
              PointItem(
                  widget.pointList.getPointsForSubject(subject.id)[index],
                  widget.pointList.removePoint,
                  widget.pointList.togglePointFavorite),
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
