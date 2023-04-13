import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_web/google_maps_flutter_web.dart';

import '../models/point.dart';
import '../models/subject.dart';
import '../utils/location_util.dart';

import '../components/image_item.dart';

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
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(point.lat!, point.long!),
                    zoom: 13,
                  ),
                  mapType: MapType.satellite,
                  //onTap: widget.isReadOnly ? null : _selectPosition,
                  markers: {
                    Marker(
                      markerId: const MarkerId('p1'),
                      position: LatLng(point.lat!, point.long!),
                    )
                  },
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
                              style: const TextStyle(
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
                                const Icon(
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
                              point.image.length == 0
                                  ? Center(
                                      child: Text(
                                      "Sem fotos adicionadas",
                                      style: TextStyle(color: Colors.grey),
                                    ))
                                  : SizedBox(
                                      height: 200,
                                      child: GridView.builder(
                                        padding: const EdgeInsets.all(10),
                                        itemCount: point.image.length,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio: 3 / 2,
                                          crossAxisSpacing: 5,
                                          mainAxisSpacing: 5,
                                        ),
                                        itemBuilder: (BuildContext context,
                                                index) =>
                                            ImageItem(
                                                imageUrl: point.image[index]),
                                      ),
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
      ),
    );
  }
}
