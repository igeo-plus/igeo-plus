import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';

import '../models/point.dart';
import '../models/subject.dart';

import '../utils/routes.dart';

class PointItem extends StatefulWidget {
  final Point point;
  final Subject subject;
  final Map<String, dynamic> userData;
  final Function(int, String, int) onDeletePoint;
  final void Function(int, int) onToggleFavorite;
  //final bool isFavorite;

  const PointItem(
    this.point,
    this.subject,
    this.userData,
    this.onDeletePoint,
    this.onToggleFavorite,
    //this.isFavorite,
  );

  @override
  State<PointItem> createState() => _PointItemState();
}

class _PointItemState extends State<PointItem> {
  bool isFavorite = false;
  void _goToPointDetailsScreen(
      BuildContext context, Subject subject, Point point) {
    Navigator.of(context).pushNamed(AppRoutes.POINT_DETAIL,
        arguments: {"subject": subject, "point": point});
  }

  favoritePoint(int userId, String token, int pointId) async {
    final data = {
      "user_id": userId,
      "authentication_token": token,
      "id": pointId
    };

    final http.Response response = await http.post(
      Uri.parse(
          "https://app.homologacao.uff.br/igeo-retaguarda/api/favorite_point"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    return response;
  }

  @override
  void initState() {
    super.initState();
    isFavorite = widget.point.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    //final subject = ModalRoute.of(context)!.settings.arguments;

    print("testandooooo" + widget.subject.toString());
    return InkWell(
      onTap: () =>
          _goToPointDetailsScreen(context, widget.subject, widget.point),
      splashColor: Colors.amber,
      hoverColor: Color.fromARGB(255, 181, 220, 238),
      child: Dismissible(
        key: ValueKey(widget.point.id),
        onDismissed: (_) {
          widget.onDeletePoint(widget.userData["id"], widget.userData["token"],
              widget.point.id!);
        },
        direction: DismissDirection.endToStart,
        background: Container(
          color: Theme.of(context).errorColor,
          child: const Icon(
            Icons.delete,
            color: Colors.white,
            size: 30,
          ),
          padding: const EdgeInsets.only(right: 20),
          alignment: Alignment.centerRight,
        ),
        child: ListTile(
          leading: const FittedBox(
            fit: BoxFit.fitWidth,
            child: CircleAvatar(
              child: const Icon(
                Icons.gps_fixed_outlined,
                color: Colors.white,
              ),
              backgroundColor: Colors.grey,
            ),
          ),
          title: Text(widget.point.name!),
          subtitle: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 2),
                child: const Icon(
                  Icons.gps_fixed_sharp,
                  size: 13,
                  color: Color.fromARGB(255, 7, 163, 221),
                ),
              ),
              Text(
                  "Lat: ${widget.point.lat!.toStringAsFixed(2)} - Lon: ${widget.point.long!.toStringAsFixed(2)}"),
              const SizedBox(width: 3),
              // Container(
              //   margin: const EdgeInsets.only(right: 2),
              //   child: const Icon(
              //     Icons.calendar_month,
              //     size: 13,
              //     color: Color.fromARGB(255, 7, 163, 221),
              //   ),
              // ),
              // Text(widget.point.date!)
            ],
          ),
          trailing: IconButton(
            icon: isFavorite == true
                ? const Icon(
                    Icons.star,
                    color: Colors.amber,
                  )
                : const Icon(
                    Icons.star_outline,
                    color: Colors.amber,
                  ),
            onPressed: () {
              setState(() {
                //print("ESTADO: " + isFavorite.toString());

                isFavorite = !isFavorite;
              });
              favoritePoint(
                widget.userData["id"],
                widget.userData["token"],
                widget.point.id!,
              );
              widget.onToggleFavorite(widget.point.id!, widget.subject.id);
            },
          ),
        ),
      ),
    );
  }
}
