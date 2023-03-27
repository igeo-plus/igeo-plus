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
  final Map<String, dynamic> userData;
  final Subject subject;
  PointList pointList = PointList();

  SubjectPointsScreen(this.userData, this.subject);

  @override
  State<SubjectPointsScreen> createState() => _SubjectPointsScreenState();
}

class _SubjectPointsScreenState extends State<SubjectPointsScreen> {
  Point? newPoint;
  dynamic pointData;

  Future<void> getPoints(int userId, String token) async {
    final dataUser = {"user_id": userId, "authentication_token": token};

    final http.Response response = await http.post(
      Uri.parse('https://app.homologacao.uff.br/umm/api/get_points_from_igeo'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(dataUser),
    );

    var data = jsonDecode(response.body);

    print(data);

    setState(() async {
      pointData = data;
      if (pointData.length == 0) {
        return;
      }
      //for (var el in pointData) {
      pointData.forEach((point) async {
        Point newPoint = Point(
          id: point["id"],
          user_id: point["user_id"],
          subject_id: point["subject_id"],
          name: point["name"],
          lat: point["latitude"],
          long: point["longitude"],
          date: point["date"],
          time: point["time"],
          description: point["description"],
          isFavorite: point["favorite"] as bool,
        );

        if (point["image"] is List && point["image"].length > 0) {
          for (var url in point["image"]) {
            newPoint.addUrlToImageList(url);
          }
        }
        widget.pointList.addPoint(newPoint);

        print(newPoint.image);
      });
    });
  }

  Future<http.Response> postPoint(int subjectId, String name, double latitude,
      double longitude, String date, String time, String description,
      [int userId = 1]) async {
    final data = {
      "user_id": userId,
      "subject_id": subjectId,
      "authentication_token": widget.userData["token"],
      "name": name,
      "latitude": latitude,
      "longitude": longitude,
      "date": date,
      "time": time,
      "description": description,
    };
    final http.Response response = await http.post(
      Uri.parse('https://app.homologacao.uff.br/umm/api/post_point_in_igeo'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    return response;
  }

  // @override
  // void initState() {
  //   super.initState();
  //   getPoints(widget.userData["id"], widget.userData["token"]);
  // }

  @override
  Widget build(BuildContext context) {
    //final subject = ModalRoute.of(context)!.settings.arguments as Subject;
    final Subject subject = widget.subject;

    print("testando:" + subject.name);
    print(widget.userData);
    print(subject.name);
    print(widget.pointList.getPointsForSubject(widget.subject.id));

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
      body: FutureBuilder(
        future: getPoints(widget.userData["id"], widget.userData["token"]),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount:
                    widget.pointList.getPointsForSubject(subject.id).length,
                itemBuilder: (ctx, index) {
                  return Column(
                    children: [
                      PointItem(
                        widget.pointList.getPointsForSubject(subject.id)[index],
                        subject,
                        widget.pointList.removePoint,
                        widget.pointList.togglePointFavorite,
                      ),
                    ],
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => awaitResultFromNewPointScreen(context),
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
