import 'package:flutter/material.dart';

import '../models/point.dart';
import '../models/subject.dart';
import '../utils/location_util.dart';

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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.network(
                  imageUrl,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Color.fromARGB(255, 7, 163, 221)),
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
                                  color: Colors.redAccent,
                                ),
                                Text(" ${point.date!}"),
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
                                  Icons.lock_clock,
                                  size: 14,
                                  color: Colors.redAccent,
                                ),
                                Text(" ${point.time!}"),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: FittedBox(
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.gps_fixed_sharp,
                                  size: 14,
                                  color: Colors.redAccent,
                                ),
                                FittedBox(
                                  child: Text(
                                      " Lat: ${point.lat!} - Long: ${point.long!}"),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.textsms,
                                    size: 14,
                                    color: Colors.redAccent,
                                  ),
                                  const Text(
                                    " Descrição",
                                    style: TextStyle(color: Colors.grey),
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
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.photo,
                                    size: 14,
                                    color: Colors.redAccent,
                                  ),
                                  Text(
                                    " Fotos",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                              GridView(
                                children: [
                                  ...point.image.map((e) => Image.network(e))
                                ],
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 3 / 2,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
