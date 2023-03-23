import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class NewUserScreen extends StatelessWidget {
  //const NewUserScreen({super.key});

  final formKey = GlobalKey<FormState>();
  final Map<String, Object> formData = {};

  @override
  Widget build(BuildContext context) {
    void submitForm() {
      formKey.currentState?.save();
      print(formData);
      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Novo usuário"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nome'),
                textInputAction: TextInputAction.next,
                onSaved: (name) => formData['first_name'] = name ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Sobrenome'),
                textInputAction: TextInputAction.next,
                onSaved: (last_name) => formData['last_name'] = last_name ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'E-mail'),
                textInputAction: TextInputAction.next,
                onSaved: (email) => formData['email'] = email ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Senha'),
                textInputAction: TextInputAction.next,
                onSaved: (password) => formData['password'] = password ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Confirmação de senha'),
                textInputAction: TextInputAction.next,
                onSaved: (password_confirmation) =>
                    formData['password_confirmation'] =
                        password_confirmation ?? '',
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 15.0, left: 100, right: 100),
                child: ElevatedButton(
                  onPressed: () => submitForm(),
                  child: const Text("Cadastrar"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
