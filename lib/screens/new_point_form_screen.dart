import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:geolocator/geolocator.dart';

import '../models/point.dart';
import '../models/subject.dart';

import '../components/location_input.dart';

class NewPointFormScreen extends StatefulWidget {
  //final void Function(int, String, String) onSubmit;

  const NewPointFormScreen();

  @override
  State<NewPointFormScreen> createState() => _NewPointFormScreenState();
}

class _NewPointFormScreenState extends State<NewPointFormScreen> {
  final _idController = TextEditingController();
  final _nameController = TextEditingController();

  void _submitForm() {
    final id = int.parse(_idController.text);
    final name = _nameController.text;

    if (name.isEmpty) {
      return;
    }

    //widget.onSubmit(id, name); //acesso ao componente stateful
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Novo ponto"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
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
            SizedBox(
              height: 20,
            ),
            LocationInput(),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
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
    );
  }
}
