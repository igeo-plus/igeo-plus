import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:io';

import 'package:igeo_flutter/models/subject.dart';
import 'package:igeo_flutter/models/point.dart';
import '../models/point_list.dart';

import '../utils/routes.dart';

import '../components/point_item.dart';

class SubjectPointsScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  final Subject subject;

  SubjectPointsScreen(this.userData, this.subject);

  @override
  State<SubjectPointsScreen> createState() => _SubjectPointsScreenState();
}

class _SubjectPointsScreenState extends State<SubjectPointsScreen> {
  Point? newPoint;
  dynamic pointData;
  PointList pointList = PointList();

  Future<void> getPoints(int userId, String token) async {
    pointList.clear();
    setState(() {
      pointList = PointList();
    });
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
        pointList.addPoint(newPoint);

        print(newPoint.image);
      });
    });
  }

  Future<http.Response> postPoint(
      int subjectId,
      String name,
      double latitude,
      double longitude,
      String date,
      String time,
      String description,
      int userId,
      List<File> photos) async {
    //pointList = PointList();
    final data = {
      "user_id": widget.userData["id"],
      "subject_id": subjectId,
      "authentication_token": widget.userData["token"],
      "name": name,
      "latitude": latitude,
      "longitude": longitude,
      "date": date,
      "time": time,
      "description": description,
    };

    if (photos.isNotEmpty) {
      data["photos"] = [];
      photos.forEach(
        (photo) {
          var photoFile = photo.readAsBytes();
          data["photos"].add(photoFile);
        },
      );
    }
    final http.Response response = await http.post(
      Uri.parse('https://app.homologacao.uff.br/umm/api/post_point_in_igeo'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    setState(() {
      pointList.addPoint(
        Point(
          id: pointList.getPoints.last.id! + 1,
          user_id: widget.userData["id"],
          name: name,
          lat: latitude,
          long: longitude,
          date: date,
          time: time,
          description: description,
        ),
      );
    });
    //getPoints(widget.userData["id"], widget.userData["token"]);
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
    //print(pointList.getPointsForSubject(widget.subject.id));

    void awaitResultFromNewPointScreen(BuildContext context) async {
      final result = await Navigator.pushNamed(context, AppRoutes.NEW_POINT,
          arguments: subject);

      if (result == null) {
        return;
      }

      newPoint = result as Point;
      postPoint(
          subject.id,
          result.name!,
          result.lat!,
          result.long!,
          result.date!,
          result.time!,
          result.description!,
          widget.userData["id"],
          result.pickedImages!);

      //getPoints(widget.userData["id"], widget.userData["token"]);
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
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: pointList.getPointsForSubject(subject.id).length,
                    itemBuilder: (ctx, index) {
                      return Column(
                        children: [
                          PointItem(
                            pointList.getPointsForSubject(subject.id)[index],
                            subject,
                            pointList.removePoint,
                            pointList.togglePointFavorite,
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
