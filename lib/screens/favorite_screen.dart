import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';

import '../models/point_list.dart';
import '../models/subject.dart';
import '../models/point.dart';

import '../components/point_item_favorite.dart';

class FavoriteScreen extends StatefulWidget {
  final List<Subject> subjects;
  const FavoriteScreen(this.subjects, {super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
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
            //isFavorite: true,
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
    final pointList = Provider.of<PointList>(context).favoritePoints;
    return Scaffold(
      body: ListView.builder(
        itemCount: pointList.length,
        itemBuilder: (ctx, index) {
          return Column(
            children: [
              PointItemFavorite(
                pointList[index],
                widget.subjects,
              ),
            ],
          );
        },
      ),
    );
  }
}
