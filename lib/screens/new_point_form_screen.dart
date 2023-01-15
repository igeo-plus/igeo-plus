import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/point.dart';
import '../models/subject.dart';

import '../components/location_input.dart';

class NewPointFormScreen extends StatefulWidget {
  //Point? newPoint;
  @override
  State<NewPointFormScreen> createState() => _NewPointFormScreenState();
}

class _NewPointFormScreenState extends State<NewPointFormScreen> {
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  int? id;
  String? name;
  double lat = -22;
  double long = -43;
  DateTime date = DateTime.now();
  DateTime time = DateTime.now();
  String description = "asaousoaisj";
  int user_id = 1;
  int subject_id = 1;

  void sendBackData(
      BuildContext context,
      // int id,
      // String name,
      // double lat,
      // double long,
      // DateTime date,
      // DateTime time,
      // int user_id,
      // int subject_id,
      // String description,
      Point newPoint) {
    // Point newPoint = Point(
    //   id: id,
    //   name: name,
    //   lat: lat,
    //   long: long,
    //   date: date,
    //   time: time,
    //   user_id: user_id,
    //   subject_id: subject_id,
    //   description: description,
    // );
    //print(newPoint.name);
    newPoint.id = id;
    newPoint.name = name;
    newPoint.date = date;
    newPoint.time = time;
    newPoint.user_id = user_id;
    newPoint.subject_id = subject_id;
    newPoint.description = description;

    Navigator.pop(context, newPoint);
  }

  @override
  Widget build(BuildContext context) {
    final subject = ModalRoute.of(context)!.settings.arguments as Subject;
    var point = Provider.of<Point>(context);

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          child: Text("Novo ponto em ${subject.name}"),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (_) => id = int.parse(_idController.text),
                controller: _idController,
                decoration: const InputDecoration(labelText: "ID"),
              ),
              TextField(
                keyboardType: TextInputType.text,
                onChanged: (_) => name = _nameController.text,
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Nome"),
              ),
              const SizedBox(
                height: 20,
              ),
              LocationInput(),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (id == null) {
                      Navigator.of(context).pop();
                    } else {
                      sendBackData(
                        context,
                        point,
                      );
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
    );
  }
}
