import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';

import '../components/text.dart';

class NewUserScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  Map<String, Object> formData = {};
  bool accept = false;

  final gmailValid =
      RegExp(r"^[a-z0-9](\.?_?[a-z0-9]){5,}[@](gmail.com$|id.uff.br$)");

  //final gmailValid = RegExp(r"^[a-z0-9](\.?_?[a-z0-9]){5,}[@](id.uff.br$)");

  @override
  Widget build(BuildContext context) {
    submitForm() async {
      formKey.currentState?.save();
      //print(formData);

      Widget alert = AlertDialog(
        title: Row(
          children: [
            const Icon(
              Icons.warning_amber_outlined,
              color: Colors.amber,
              size: 12,
            ),
            const Expanded(
              child: Text(
                " Termo de Uso",
                style: TextStyle(
                  fontSize: 10,
                  color: Color.fromARGB(255, 189, 39, 39),
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Text(
            signupText,
            style: TextStyle(
              fontSize: 9,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              accept = true;
              Navigator.of(context).pop();
            },
            child: const Text("Concordo"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              accept = false;
              final formKey = GlobalKey<FormState>();
              Map<String, Object> formData = {};
              return;
            },
            child: const Text("Discordo"),
          ),
        ],
      );
      await showDialog(context: context, builder: (ctx) => alert);

      if (accept) {
        if (formData['first_name'].toString().length < 2 ||
            formData['last_name'].toString().length < 2) {
          Widget alert = AlertDialog(
            title: Row(
              children: [
                const Icon(
                  Icons.warning_amber_outlined,
                  color: Colors.amber,
                ),
                const Text(
                  " Nome ou sobrenome com menos de 2 caracteres",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(255, 189, 39, 39),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
          await showDialog(context: context, builder: (ctx) => alert);
          accept = false;
          return;
        }

        if (gmailValid.hasMatch(formData['email'].toString()) == false) {
          Widget alert = AlertDialog(
            title: Row(
              children: [
                const Icon(
                  Icons.warning_amber_outlined,
                  color: Colors.amber,
                ),
                const Text(
                  " Digite gmail/iduff válido",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(255, 189, 39, 39),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
          await showDialog(context: context, builder: (ctx) => alert);
          accept = false;
          return;
        }

        if (formData['password'] != formData['password_confirmation']) {
          Widget alert = AlertDialog(
            title: Row(
              children: [
                const Icon(
                  Icons.warning_amber_outlined,
                  color: Colors.amber,
                ),
                const Text(
                  " Senha e confirmação de senha diferentes",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(255, 189, 39, 39),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
          await showDialog(context: context, builder: (ctx) => alert);
          accept = false;
          return;
        }

        if (formData["password"].toString().length < 6) {
          Widget alert = AlertDialog(
            title: Row(
              children: [
                const Icon(
                  Icons.warning_amber_outlined,
                  color: Colors.amber,
                ),
                const Text(
                  " Senha menor que 6 caracteres",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(255, 189, 39, 39),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
          await showDialog(context: context, builder: (ctx) => alert);
          return;
        }
        final http.Response response = await http.post(
          Uri.parse('https://app.uff.br/umm/api/sign_up_igeo'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(formData),
        );
        print(response.body);

        if (jsonDecode(response.body)["is_success"] == false) {
          Widget alert = AlertDialog(
            title: Row(
              children: [
                const Icon(
                  Icons.warning_amber_outlined,
                  color: Colors.amber,
                ),
                const Text(
                  " Algo deu errado. Tente novamente",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(255, 189, 39, 39),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
          showDialog(context: context, builder: (ctx) => alert);
          return;
        }
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Novo usuário criado'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        return;
      }
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
                decoration: const InputDecoration(labelText: 'Nome'),
                textInputAction: TextInputAction.next,
                onSaved: (name) => formData['first_name'] = name ?? '',
                onChanged: (name) => formData['first_name'] = name ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Sobrenome'),
                textInputAction: TextInputAction.next,
                onSaved: (lastName) => formData['last_name'] = lastName ?? '',
                onChanged: (lastName) => formData['last_name'] = lastName ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'E-mail'),
                textInputAction: TextInputAction.next,
                onSaved: (email) => formData['email'] = email ?? '',
                onChanged: (email) => formData['email'] = email ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Senha'),
                textInputAction: TextInputAction.next,
                onSaved: (password) => formData['password'] = password ?? '',
                onChanged: (password) => formData['password'] = password ?? '',
                obscureText: true,
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Confirmação de senha'),
                textInputAction: TextInputAction.next,
                onSaved: (passwordConfirmation) =>
                    formData['password_confirmation'] =
                        passwordConfirmation ?? '',
                onChanged: (passwordConfirmation) =>
                    formData['password_confirmation'] =
                        passwordConfirmation ?? '',
                obscureText: true,
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
