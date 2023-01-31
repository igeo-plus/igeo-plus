import 'package:flutter/material.dart';

class NewSubjectForm extends StatefulWidget {
  final void Function(String) onSubmit;

  const NewSubjectForm(this.onSubmit);

  @override
  State<NewSubjectForm> createState() => _NewSubjectFormState();
}

class _NewSubjectFormState extends State<NewSubjectForm> {
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  //final _teacherController = TextEditingController();

  void _submitForm() {
    //final id = int.parse(_idController.text);
    final name = _nameController.text;
    //final teacher = _teacherController.text;

    if (name.isEmpty) {
      return;
    }

    widget.onSubmit(name); //acesso ao componente stateful
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // TextField(
              //   keyboardType: TextInputType.text,
              //   onSubmitted: (_) => _submitForm(),
              //   controller: _idController,
              //   decoration: InputDecoration(labelText: "ID"),
              // ),
              TextField(
                keyboardType: TextInputType.text,
                onSubmitted: (_) => _submitForm(),
                controller: _nameController,
                decoration: InputDecoration(labelText: "Nome"),
              ),
              // TextField(
              //   keyboardType: TextInputType.text,
              //   onSubmitted: (_) => _submitForm(),
              //   controller: _teacherController,
              //   decoration: InputDecoration(labelText: "Professor"),
              // ),
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
      ),
    );
  }
}
