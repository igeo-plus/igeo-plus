import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

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
  final _descriptionController = TextEditingController();
  int? id;
  String? name;
  double lat = -22;
  double long = -43;
  String date = DateFormat("d/M/yyyy").format(DateTime.now());
  String time = DateTime.now().toString().substring(10, 19);
  String description = "asaousoaisj";
  int user_id = 1;
  int subject_id = 1;

  void sendBackData(BuildContext context, Point newPoint) {
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
                TextField(
                  keyboardType: TextInputType.multiline,
                  onChanged: (_) => description = _descriptionController.text,
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: "Descrição"),
                  maxLines: 6,
                ),
                const SizedBox(
                  height: 20,
                ),
                locationInput,
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (id == null) {
                        Navigator.of(context).pop();
                      } else {
                        sendBackData(
                          context,
                          locationInput.point!,
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
      ),
    );
  }
}
