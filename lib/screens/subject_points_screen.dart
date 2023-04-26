import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:igeo_flutter/models/subject.dart';
import 'package:igeo_flutter/models/point.dart';
import '../models/point_list.dart';

import '../utils/routes.dart';

import '../components/point_item.dart';

class SubjectPointsScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  final Subject subject;

  const SubjectPointsScreen(this.userData, this.subject, {super.key});

  @override
  State<SubjectPointsScreen> createState() => _SubjectPointsScreenState();
}

class _SubjectPointsScreenState extends State<SubjectPointsScreen> {
  Point? newPoint;
  dynamic pointData;
  PointList pointList = PointList();

  deletePoint(int userId, String token, int pointId) async {
    final data = {
      "user_id": userId,
      "authentication_token": token,
      "id": pointId
    };

    final http.Response response = await http.post(
      Uri.parse(
          "https://app.homologacao.uff.br/igeo-retaguarda/api/delete_point"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    return response;
  }

  deletePointDef(int userId, String token, int pointId) async {
    pointList.removePoint(pointId);
    await deletePoint(userId, token, pointId);
  }

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

  Future postPoint(
      int subjectId,
      String name,
      double latitude,
      double longitude,
      String date,
      String time,
      String description,
      int userId,
      List<File> photos) async {
    // final data = {
    //   "user_id": widget.userData["id"],
    //   "subject_id": subjectId,
    //   "authentication_token": widget.userData["token"],
    //   "name": name,
    //   "latitude": latitude,
    //   "longitude": longitude,
    //   "date": date,
    //   "time": time,
    //   "description": description,
    //   "photos": [],
    // };

    var request = http.MultipartRequest(
      "POST",
      Uri.parse(
          "https://app.homologacao.uff.br/igeo-retaguarda/api/post_point"),
    );

    // request.fields["user_id"] = '${widget.userData["id"]}';
    // request.fields["subject_id"] = "$subjectId";
    // request.fields["authentication_token"] = widget.userData["token"];
    // request.fields["name"] = name;
    // request.fields["latitude"] = "$latitude";
    // request.fields["longitude"] = "$longitude";
    // request.fields["date"] = date;
    // request.fields["time"] = time;
    // request.fields["description"] = description;
    request.fields["authentication_token"] = widget.userData["token"];
    request.fields["user_id"] = '${widget.userData["id"]}';
    request.fields["point[user_id]"] = '${widget.userData["id"]}';
    request.fields["point[subject_id]"] = "$subjectId";
    request.fields["point[name]"] = name;
    request.fields["point[latitude]"] = "$latitude";
    request.fields["point[longitude]"] = "$longitude";
    request.fields["point[date]"] = date;
    request.fields["point[time]"] = time;
    request.fields["point[description]"] = description;

    if (photos.isNotEmpty) {
      for (var photo in photos) {
        Future<Uint8List> buffer = photo.readAsBytes();

        request.files.add(
          http.MultipartFile.fromBytes(
            'point[photos][]',
            await buffer,
            filename: photo.path,
          ),
        );
      }
    }
    print("print request:  " + request.fields.toString());
    print(request.files.toString());

    var response = await request.send();
    // final http.Response response = await http.post(
    //   Uri.parse('https://app.homologacao.uff.br/umm/api/post_point_in_igeo'),
    //   headers: <String, String>{
    //     'Content-Type': 'application/json; charset=UTF-8',
    //   },
    //   body: jsonEncode(data),
    // );
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
    //return request;

    return response.stream.bytesToString();
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
                            widget.userData,
                            deletePointDef,
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
