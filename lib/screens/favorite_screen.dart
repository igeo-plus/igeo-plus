import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';

import '../models/point_list.dart';
import '../models/subject.dart';
import '../models/point.dart';

import '../components/point_item_favorite.dart';

import '../utils/db_utils.dart';

class FavoriteScreen extends StatefulWidget {
  //final Map<String, dynamic> userData;

  const FavoriteScreen(); //this.userData, {super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  var pointList = PointList();

  dynamic pointData;
  dynamic subjectData;

  List<Subject> subjects = [];

  // Future<http.Response> getSubjects(int userId, String token) async {
  //   subjects = [];
  //   final dataUser = {"user_id": userId, "authentication_token": token};

  //   final http.Response response = await http.post(
  //     Uri.parse('https://app.uff.br/umm/api/get_subjects_from_igeo'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(dataUser),
  //   );

  //   var data = jsonDecode(response.body);
  //   subjectData = data;

  //   print(data);
  //   setState(() {
  //     if (subjectData.length == 0) {
  //       print("Vazio");
  //       return;
  //     }
  //     subjectData.forEach((subject) {
  //       subjects.add(
  //         Subject(
  //           id: subject["id"],
  //           name: subject["name"],
  //         ),
  //       );
  //     });
  //   });

  //   // controller.animateTo(
  //   //   controller.position.maxScrollExtent,
  //   //   curve: Curves.easeOut,
  //   //   duration: const Duration(milliseconds: 300),
  //   // );

  //   return response;
  // }
  getSubjects() async {
    // subjects = [];
    // subjectData = await DbUtil.getData("subjects");
    // setState(() {
    //   if (subjectData.length == 0) {
    //     print("vazio");
    //     return;
    //   }
    //
    //   subjectData.forEach((subject) {
    //     subjects.add(
    //       Subject(id: subject["id"], name: subject["subject_name"]),
    //     );
    //   });
    // });
    // // subjects.forEach(
    // //   (subject) => print("${subject.id} - ${subject.name}"),
    // // );
    // // print(subjects);
  }

  // Future<void> getPoints(int userId, String token) async {
  //   pointList.clear();

  //   pointList = PointList();

  //   final dataUser = {"user_id": userId, "authentication_token": token};

  //   final http.Response response = await http.post(
  //     Uri.parse('https://app.uff.br/umm/api/get_points_from_igeo'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(dataUser),
  //   );

  //   var data = jsonDecode(response.body);

  //   print(data);

  //   setState(() {
  //     pointData = data;
  //     if (pointData.length == 0) {
  //       return;
  //     }

  //     pointData.forEach((point) {
  //       Point newPoint = Point(
  //         id: point["id"],
  //         user_id: point["user_id"],
  //         subject_id: point["subject_id"],
  //         name: point["name"],
  //         lat: point["latitude"],
  //         long: point["longitude"],
  //         date: point["date"],
  //         time: point["time"],
  //         description: point["description"],
  //         isFavorite: point["favorite"] as bool,
  //       );

  //       if (point["image"] is List && point["image"].length > 0) {
  //         for (var url in point["image"]) {
  //           newPoint.addUrlToImageList(url);
  //         }
  //       }
  //       pointList.addPoint(newPoint);

  //       print(newPoint.image);
  //     });
  //   });
  // }
  bool toBoolean(String str, [bool strict = false]) {
    if (strict == true) {
      return str == '1' || str == 'true';
    }
    return str != '0' && str != 'false' && str != '';
  }

  getPoints() async {
    pointList.clear();
    pointData = await DbUtil.getData("points");
    setState(() {
      pointList = PointList();

      if (pointData.length == 0) {
        print("vazio");
        return;
      }
      pointData.forEach((point) {
        Point newPoint = Point(
          id: point["id"],
          user_id: point["user_id"],
          subject_id: point["subject_id"],
          name: point["name"],
          lat: point["lat"],
          long: point["long"],
          date: point["date"],
          time: point["time"],
          description: point["description"],
          isFavorite: toBoolean(point["is_favorite"]),
        );

        if (point["image"] is List && point["image"].length > 0) {
          for (var url in point["image"]) {
            newPoint.addUrlToImageList(url);
          }
        }
        pointList.addPoint(newPoint);
      });
    });
    //print(await DbUtil.getData("points"));
    //return await DbUtil.getData("points");
  }

  @override
  void initState() {
    super.initState();
    getSubjects();
    getPoints();
  }

  @override
  Widget build(BuildContext context) {
    final pointList2 = pointList.favoritePoints;
    return Scaffold(
      body: ListView.builder(
        itemCount: pointList2.length,
        itemBuilder: (ctx, index) {
          return Column(
            children: [
              PointItemFavorite(
                pointList2[index],
                subjects,
              ),
            ],
          );
        },
      ),
    );
  }
}
