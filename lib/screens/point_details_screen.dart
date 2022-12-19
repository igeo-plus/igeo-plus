import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../models/point.dart';
import '../models/subject.dart';

class PointDetailScreen extends StatelessWidget {
  PointDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    final point = arguments["point"] as Point;
    final subject = arguments["subject"] as Subject;
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(child: Text("Ponto ${point.id} de ${subject.name}")),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Color.fromARGB(255, 7, 163, 221)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      "${point.name}",
                      style: TextStyle(
                          color: Color.fromARGB(255, 7, 163, 221),
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.gps_fixed_sharp,
                        size: 14,
                        color: Colors.grey,
                      ),
                      Text(" ${point.date}"),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month,
                        size: 14,
                        color: Colors.grey,
                      ),
                      Text(" Lat: ${point.lat} - Long: ${point.long}"),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.textsms,
                        size: 14,
                        color: Colors.grey,
                      ),
                      Text(" ${point.description}"),
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
