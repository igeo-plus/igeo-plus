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
import '../utils/db_utils.dart';

import '../components/point_item.dart';

class SubjectPointsScreen extends StatefulWidget {
  //final Map<String, dynamic> userData;
  final Subject subject;

  const SubjectPointsScreen(this.subject, {super.key});

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
      Uri.parse("https://app.uff.br/umm/api/delete_point_in_igeo"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    return response;
  }

  deletePointDef(int userId, String token, int pointId) async {
    Widget alert = AlertDialog(
      title: const Text("Deletar ponto?",
          style: TextStyle(
            color: Color.fromARGB(255, 189, 39, 39),
          )),
      actions: [
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop();
            pointList.removePoint(pointId);
            await deletePoint(userId, token, pointId);

            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Ponto deletado'),
                duration: const Duration(seconds: 2),
                // action: SnackBarAction(
                //   label: 'DESFAZER',
                //   onPressed: () {
                //     cart.removeSingleItem(product.id);
                //   },
              ),
            );
          },
          child: const Text("Sim"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            setState(() {});
          },
          child: const Text("Não"),
        ),
      ],
    );
    showDialog(context: context, builder: (ctx) => alert);
  }

  // Future<void> getPoints() async {
  //   //int userId, String token) async {
  //   pointList.clear();
  //   setState(() {
  //     pointList = PointList();
  //   });
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

  //   pointData = data;
  //   if (pointData.length == 0) {
  //     return;
  //   }

  //   pointData.forEach((point) {
  //     Point newPoint = Point(
  //       id: point["id"],
  //       user_id: point["user_id"],
  //       subject_id: point["subject_id"],
  //       name: point["name"],
  //       lat: point["latitude"],
  //       long: point["longitude"],
  //       date: point["date"],
  //       time: point["time"],
  //       description: point["description"],
  //       isFavorite: point["favorite"] as bool,
  //     );

  //     if (point["image"] is List && point["image"].length > 0) {
  //       for (var url in point["image"]) {
  //         newPoint.addUrlToImageList(url);
  //       }
  //     }
  //     pointList.addPoint(newPoint);

  //     //print(newPoint.image);
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
    setState(() {
      pointList = PointList();
    });
    pointData = await DbUtil.getData("points");
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
    print(await DbUtil.getData("points"));
    return await DbUtil.getData("points");
  }

  Future postPoint(
      int subjectId,
      String name,
      double latitude,
      double longitude,
      String date,
      String time,
      String description,
      //int userId,
      List<File> photos) async {
    // var request = http.MultipartRequest(
    //   "POST",
    //   Uri.parse("https://app.uff.br/igeo-retaguarda/api/post_point"),
    // );

    // request.fields["authentication_token"] = widget.userData["token"];
    // request.fields["user_id"] = '${widget.userData["id"]}';
    // request.fields["point[user_id]"] = '${widget.userData["id"]}';
    // request.fields["point[subject_id]"] = "$subjectId";
    // request.fields["point[name]"] = name;
    // request.fields["point[latitude]"] = "$latitude";
    // request.fields["point[longitude]"] = "$longitude";
    // request.fields["point[date]"] = date;
    // request.fields["point[time]"] = time;
    // request.fields["point[description]"] = description;

    if (photos.isNotEmpty) {
      DbUtil.insert(
        'points',
        {
          'subject_id': subjectId,
          'name': name,
          'lat': latitude,
          'long': longitude,
          'date': date,
          'time': time,
          'description': description,
          'image1': photos.asMap().containsKey(0) ? photos[0].path : '',
          'image2': photos.asMap().containsKey(1) ? photos[1].path : '',
          'image3': photos.asMap().containsKey(2) ? photos[2].path : '',
          'image4': photos.asMap().containsKey(3) ? photos[3].path : ''
        },
      );
    } else {
      DbUtil.insert(
        'points',
        {
          'subject_id': subjectId,
          'name': name,
          'lat': latitude,
          'long': longitude,
          'date': date,
          'time': time,
          'description': description,
        },
      );
    }

    // final http.Response response2 = await http.post(
    //   Uri.parse('https://app.uff.br/umm/api/get_points_from_igeo'),
    //   headers: <String, String>{
    //     'Content-Type': 'application/json; charset=UTF-8',
    //   },
    //   body: jsonEncode(dataUser),
    // );

    List data = await getPoints();

    pointData = data;
    if (pointData.length == 0) {
      return;
    }

    setState(() {
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

    print(pointData);
  }

  void changeFavorite(int pointId, int subjectId) {
    pointList.togglePointFavorite(pointId, subjectId);
  }

  // @override
  // void initState() {
  //   super.initState();
  //   getPoints(widget.userData["id"], widget.userData["token"]);
  // }
  Future<void> refresh(BuildContext context) async {
    setState(() {
      pointList = PointList();
    });
  }

  @override
  Widget build(BuildContext context) {
    //final subject = ModalRoute.of(context)!.settings.arguments as Subject;
    final Subject subject = widget.subject;

    print("testando:" + subject.name);
    //print(widget.userData);
    print(subject.name);

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
          result.pickedImages!);

      //getPoints(widget.userData["id"], widget.userData["token"]);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Ponto adicionado'),
          duration: const Duration(seconds: 2),
          // action: SnackBarAction(
          //   label: 'DESFAZER',
          //   onPressed: () {
          //     cart.removeSingleItem(product.id);
          //   },
          // ),
        ),
      );
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
      body: RefreshIndicator(
        onRefresh: () => refresh(context),
        child: FutureBuilder(
          future: getPoints(),
          builder: (context, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.amber,
                  ),
                )
              : pointList.getPointsForSubject(subject.id).isNotEmpty
                  ? ListView.builder(
                      padding: const EdgeInsets.only(bottom: 50),
                      itemCount:
                          pointList.getPointsForSubject(subject.id).length,
                      itemBuilder: (ctx, index) {
                        return Column(
                          children: [
                            //Text("OK"),
                            PointItem(
                              pointList.getPointsForSubject(subject.id)[index],
                              subject,
                              //widget.userData,
                              deletePointDef,
                              changeFavorite,
                              false,
                            )
                          ],
                        );
                      },
                    )
                  : Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.gps_fixed,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text(
                            'Adicione seu primeiro ponto',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
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
