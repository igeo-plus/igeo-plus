import 'package:flutter/material.dart';
import 'dart:io';

import '../models/point.dart';
import '../models/subject.dart';
import '../utils/location_util.dart';
import '../utils/db_utils.dart';

import '../components/image_item.dart';

class PointDetailScreen extends StatelessWidget {
  const PointDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    final point = arguments["point"] as Point;
    final subject = arguments["subject"] as Subject;

    List<String> images = [];

    final imageUrl = LocationUtil.generateLocationPreviewImage(
      latitude: point.lat!.toDouble(),
      longitude: point.long!.toDouble(),
    );

    Future<void> loadData() async {
      final dataList = await DbUtil.queryImages(
          point.user_id.toString() + point.date! + point.time!);
      print("OK:" + images.toString());

      if (dataList.asMap().containsKey(0) &&
          dataList[0]['image1'].toString().isEmpty == false) {
        images.add(dataList[0]['image1']);
      }

      if (dataList.asMap().containsKey(0) &&
          dataList[0]['image2'].toString().isEmpty == false) {
        images.add(dataList[0]['image2']);
      }

      if (dataList.asMap().containsKey(0) &&
          dataList[0]['image3'].toString().isEmpty == false) {
        images.add(dataList[0]['image3']);
      }

      if (dataList.asMap().containsKey(0) &&
          dataList[0]['image4'].toString().isEmpty == false) {
        images.add(dataList[0]['image4']);
      }

      // dataList[1] != '' ? images.add(File(dataList[1]['image2'])) : null;
      // dataList[2] != '' ? images.add(File(dataList[2]['image3'])) : null;
      // dataList[3] != '' ? images.add(File(dataList[3]['image4'])) : null;
      print(dataList);
    }

    //loadData();
    print("AQUI" + images.toString());

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          child: Text("Ponto em ${subject.name}"),
        ),
      ),
      body: FutureBuilder(
        future: loadData(),
        builder: (ctx, snapshot) => Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: InteractiveViewer(
                    child: Image.network(
                      imageUrl,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
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
                                  const Icon(
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
                                        " Lat: ${point.lat!.toDouble()} - Long: ${point.long!.toDouble()}"),
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
                                  children: const [
                                    Icon(
                                      Icons.textsms,
                                      size: 14,
                                      color: Colors.redAccent,
                                    ),
                                    Text(
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
                                  children: const [
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
                                //point.image.length == 0
                                images.isEmpty
                                    ? Center(
                                        child: Text(
                                        "Sem fotos adicionadas",
                                        style: TextStyle(color: Colors.grey),
                                      ))
                                    : //Image.file(
                                    //images[0]) //Text(images.toString())
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                4,
                                        child: GridView.builder(
                                          padding: const EdgeInsets.all(10),
                                          itemCount: images
                                              .length, //point.image.length,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            childAspectRatio: 3 / 2,
                                            crossAxisSpacing: 5,
                                            mainAxisSpacing: 5,
                                          ),
                                          itemBuilder:
                                              (BuildContext context, index) =>
                                                  //Image.file(images[index]),
                                                  ImageItem(
                                                      imageUrl: images[index]),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
