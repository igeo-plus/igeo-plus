import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong2/latlong.dart' as latLng;

import '../models/point.dart';
import '../models/subject.dart';
import '../utils/location_util.dart';

// import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
// import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

class PointDetailScreen extends StatelessWidget {
  const PointDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    final point = arguments["point"] as Point;
    final subject = arguments["subject"] as Subject;

    final imageUrl = LocationUtil.generateLocationPreviewImage(
      latitude: point.lat,
      longitude: point.long,
    );

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
            child: Text(
                "Ponto ${point.id} de ${subject.name.substring(0, 5)}...")),
      ),
      body: Center(
        child: Column(
          children: [
            Image.network(imageUrl),
            Padding(
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
                        child: FittedBox(
                          child: Text(
                            "${point.name}",
                            style: TextStyle(
                                color: Color.fromARGB(255, 7, 163, 221),
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: FittedBox(
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_month,
                                size: 14,
                                color: Colors.grey,
                              ),
                              Text(
                                  " ${DateFormat("d/M/yyyy").format(point.date)}"),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: FittedBox(
                          child: Row(
                            children: [
                              Icon(
                                Icons.gps_fixed_sharp,
                                size: 14,
                                color: Colors.grey,
                              ),
                              Text(
                                  " Lat: ${point.lat + 1031029102} - Long: ${point.long}"),
                            ],
                          ),
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.textsms,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                                Text(
                                  " Descrição",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 7, 163, 221)),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text("${point.description}"),
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.photo,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                                Text(
                                  " Fotos",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 7, 163, 221)),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text("Fotos do ponto"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
