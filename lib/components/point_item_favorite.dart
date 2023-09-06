import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';

import '../models/point.dart';
import '../models/subject.dart';

import '../utils/routes.dart';

class PointItemFavorite extends StatelessWidget {
  final Point point;
  final List<Subject> subjects;
  //final Map<String, dynamic> userData;

  const PointItemFavorite(this.point, this.subjects, {super.key});

  void _goToPointDetailsScreen(
      BuildContext context, List<Subject> subjects, Point point) {
    Subject subject =
        subjects.where((subject) => subject.id == point.subject_id).first;
    Navigator.of(context).pushNamed(AppRoutes.POINT_DETAIL,
        arguments: {"subject": subject, "point": point});
  }

  // Future favoritePoint(int userId, String token, int pointId) async {
  //   final data = {
  //     "user_id": userId,
  //     "authentication_token": token,
  //     "id": pointId
  //   };

  //   final http.Response response = await http.post(
  //     Uri.parse("https://app.uff.br/umm/api/favorite_point_in_igeo"),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(data),
  //   );
  //   return response;
  // }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.horizontal,
      background: Container(
        color: Colors.amber,
        padding: const EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
        child: const Icon(
          Icons.star_border_outlined,
          color: Colors.white,
          size: 30,
        ),
      ),
      key: ValueKey(point.id),
      onDismissed: (_) {
        //point.toggleFavorite();
        //favoritePoint(
        //userData["id"],
        //userData["token"],
        //point.id!,
      },
      child: InkWell(
        onTap: () => _goToPointDetailsScreen(context, subjects, point),
        splashColor: Colors.amber,
        hoverColor: const Color.fromARGB(255, 181, 220, 238),
        child: ListTile(
          leading: const FittedBox(
            fit: BoxFit.fitWidth,
            child: CircleAvatar(
              child: Icon(
                Icons.star_border_outlined,
                color: Colors.amber,
              ),
            ),
          ),
          title: Text(point.name!),
          subtitle: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 2),
                child: const Icon(
                  Icons.gps_fixed_sharp,
                  size: 12,
                  color: Color.fromARGB(255, 7, 163, 221),
                ),
              ),
              Text(
                  "Lat: ${point.lat!.toStringAsFixed(1)} - Lon: ${point.long!.toStringAsFixed(1)} - "),
              Container(
                margin: const EdgeInsets.only(right: 2),
                child: const Icon(
                  Icons.calendar_month,
                  size: 12,
                  color: Color.fromARGB(255, 7, 163, 221),
                ),
              ),
              Text(point.date!)
            ],
          ),
        ),
      ),
    );
  }
}
