import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:geolocator/geolocator.dart';

import '../models/point.dart';
import '../models/subject.dart';

class NewPointForm extends StatefulWidget {
  final void Function(int, String, String) onSubmit;

  const NewPointForm(this.onSubmit);

  @override
  State<NewPointForm> createState() => _NewPointFormState();
}

class _NewPointFormState extends State<NewPointForm> {
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _teacherController = TextEditingController();

  Future<void> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double lat = position.latitude;
    double long = position.longitude;
    print("Latitude: $lat and Longitude: $long");
  }

  void _submitForm() {
    final id = int.parse(_idController.text);
    final name = _nameController.text;
    final teacher = _teacherController.text;
    final lat = _teacherController.text;
    final long = _teacherController.text;

    if (name.isEmpty || teacher.isEmpty) {
      return;
    }

    widget.onSubmit(id, name, teacher); //acesso ao componente stateful
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              keyboardType: TextInputType.text,
              onSubmitted: (_) => _submitForm(),
              controller: _idController,
              decoration: InputDecoration(labelText: "ID"),
            ),
            TextField(
              keyboardType: TextInputType.text,
              onSubmitted: (_) => _submitForm(),
              controller: _nameController,
              decoration: InputDecoration(labelText: "Nome"),
            ),
            TextField(
              keyboardType: TextInputType.text,
              onSubmitted: (_) => _submitForm(),
              controller: _teacherController,
              decoration: InputDecoration(labelText: "Professor"),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _submitForm,
                child: Text(
                  "Novo campo",
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
    );
  }
}
