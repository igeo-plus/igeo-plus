import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final auth = FirebaseAuth.instance;
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
  String? subject_id;

  List<File> pickedImages = [];

  void addImage(File pickedImage) {
    if (pickedImages.length >= 4) {
      print('limite de imagens atingido');
      return;
    }
    pickedImages.add(pickedImage);
    // TODO: Criar pasta com o nome igual ao id do subject para guardar as imagens
    // TODO: Nomear imagens com o timestamp
  }

  // void removeImage(File pickedImage) {
  //   pickedImage.delete();
  //   pickedImages.remove(pickedImage);
  // }

  Future<void> sendBackData(BuildContext context, Point newPoint, Subject subject) async {
    String uid = auth.currentUser!.uid;
    final db = FirebaseFirestore.instance;
    DateTime registrationDate = DateTime.now();
    String millisecondsTimeStamp = registrationDate.millisecondsSinceEpoch.toString();
    String pointId = "$uid$millisecondsTimeStamp";

    newPoint.id = pointId;
    newPoint.name = name;
    newPoint.date = date;
    newPoint.time = time;
    newPoint.user_id = uid;
    newPoint.subject_id = subject.id;
    newPoint.description = description;
    newPoint.pickedImages = []; // TODO: Mandar pro storage e salvar os ids na lista

    await db.collection("subjects")
        .doc(subject.id)
        .collection("points")
        .doc(pointId)
        .set(newPoint.toMap()).then((_) {
      debugPrint("New point saved");
    }
    ).onError((e, _) {
      debugPrint("Error saving point: $e");
    });

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
                  padding: const EdgeInsets.only(top: 2.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (id == null) {
                        Navigator.of(context).pop();
                      } else {
                        //printIps();
                        sendBackData(context, locationInput.point!, subject);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                    ),
                    child: const Text(
                      "Novo ponto",
                      style: TextStyle(fontFamily: 'Roboto'),
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
