import 'package:flutter/material.dart';
import 'package:igeo_flutter/components/image_input.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:io';

import '../models/point.dart';
import '../models/subject.dart';
import '../models/point_list.dart';

import '../components/location_input.dart';

class NewPointFormScreen extends StatefulWidget {
  //Point? newPoint;
  @override
  State<NewPointFormScreen> createState() => _NewPointFormScreenState();
}

class _NewPointFormScreenState extends State<NewPointFormScreen> {
  //final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  int? id = 1;
  String? name;
  double lat = -22;
  double long = -43;
  String date = DateFormat("d/M/yyyy").format(DateTime.now());
  String time = DateTime.now().toString().substring(10, 19);
  String description = "asaousoaisj";
  int user_id = 1;
  int? subject_id;

  List<File> pickedImages = [];

  void addImage(File pickedImage) {
    if (pickedImages.length >= 4) {
      print('limite de imagens atingido');
      return;
    }
    pickedImages.add(pickedImage);
  }

  void sendBackData(BuildContext context, Point newPoint, Subject subject) {
    newPoint.id = 1;
    newPoint.name = name;
    newPoint.date = date;
    newPoint.time = time;
    newPoint.user_id = user_id;
    newPoint.subject_id = subject.id;
    newPoint.description = description;
    //newPoint.pickedImages = pickedImages;

    Navigator.pop(context, newPoint);
  }

  @override
  Widget build(BuildContext context) {
    final subject = ModalRoute.of(context)!.settings.arguments as Subject;
    final locationInput = LocationInput();

    return MultiProvider(
      providers: [
        //ChangeNotifierProvider(create: (_) => LocationInput()),
        ChangeNotifierProvider(create: (_) => Point())
      ],
      child: Scaffold(
        appBar: AppBar(
          title: FittedBox(
            child: Text("Novo ponto em ${subject.name}"),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Form(
            child: Column(
              children: [
                // TextField(
                //   keyboardType: TextInputType.number,
                //   onChanged: (_) => id = int.parse(_idController.text),
                //   controller: _idController,
                //   decoration: const InputDecoration(labelText: "ID"),
                // ),
                TextField(
                  keyboardType: TextInputType.text,
                  onChanged: (_) => name = _nameController.text,
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "Nome"),
                  textInputAction: TextInputAction.next,
                ),
                TextField(
                  keyboardType: TextInputType.multiline,
                  onChanged: (_) => description = _descriptionController.text,
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: "Descrição"),
                  maxLines: 6,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(
                  height: 20,
                ),
                locationInput,
                ImageInput(addImage),
                Padding(
                  padding: const EdgeInsets.only(top: 7.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (id == null) {
                        Navigator.of(context).pop();
                      } else {
                        sendBackData(context, locationInput.point!, subject);
                      }
                    },
                    child: const Text(
                      "Novo ponto",
                      style: TextStyle(fontFamily: 'Roboto'),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
