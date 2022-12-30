import 'package:flutter/material.dart';

import '../models/point.dart';
import '../models/subject.dart';

import '../components/location_input.dart';

class NewPointFormScreen extends StatefulWidget {
  Point? newPoint;
  @override
  State<NewPointFormScreen> createState() => _NewPointFormScreenState();
}

class _NewPointFormScreenState extends State<NewPointFormScreen> {
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  int id = 25;
  String name = 'as';
  double lat = 22;
  double long = 43;
  DateTime date = DateTime.now();
  DateTime time = DateTime.now();
  String description = "asaousoaisj";
  int user_id = 1;
  int subject_id = 1;

  // void _onSubmit() {
  //   id = 25;
  //   name = _nameController.text;
  //   lat = LocationInput().lat as double;
  //   long = LocationInput().long as double;
  // }

  @override
  Widget build(BuildContext context) {
    final subject = ModalRoute.of(context)?.settings.arguments as Subject;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Novo ponto"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              TextField(
                keyboardType: TextInputType.number,
                onSubmitted: (_) {
                  id = _idController.text as int;
                },
                controller: _idController,
                decoration: const InputDecoration(labelText: "ID"),
              ),
              TextField(
                keyboardType: TextInputType.text,
                onSubmitted: (_) {
                  name = _nameController.text;
                },
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Nome"),
              ),
              const SizedBox(
                height: 20,
              ),
              LocationInput(),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    widget.newPoint = Point(
                      id: id,
                      name: name,
                      lat: lat,
                      long: long,
                      date: date,
                      time: time,
                      user_id: user_id,
                      subject_id: subject.id,
                      description: description,
                    );
                    print(widget.newPoint?.name);

                    Navigator.of(context).pop(widget.newPoint?.name);
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
