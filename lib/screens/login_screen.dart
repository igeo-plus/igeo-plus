import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:math';

import '../utils/routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? email;
  String? password;

  int? id;
  String? firstName;
  String? lastName;
  String? token;

  Map<String, dynamic>? getUserData;

  dynamic userJson;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String errorText = '';

  getUser(String email, String password) async {
    final data = {"email": "$email", "password": "$password"};

    final http.Response response = await http.post(
      Uri.parse('https://app.homologacao.uff.br/umm/api/sign_in_igeo'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    setState(() {
      userJson = jsonDecode(response.body);
      id = userJson["data"]["user"]["id"];
      firstName = userJson["data"]["user"]["first_name"];
      lastName = userJson["data"]["user"]["last_name"];
      token = userJson["data"]["user"]["authentication_token"];

      getUserData = {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "token": token,
      };
    });

    print(getUserData);
  }

  void _goToSubjectsScreen(
      BuildContext context, Map<String, dynamic> userData) {
    Navigator.of(context).popAndPushNamed(
      AppRoutes.HOME2,
      arguments: userData,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('iGeo'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Image.asset(
                'assets/images/logo-login.png',
                width: double.infinity,
                height: 150,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  keyboardType: TextInputType.text,
                  onChanged: (_) {
                    setState(() {
                      email = _emailController.text;
                    });
                  },
                  //onSubmitted: (_) => {},
                  controller: _emailController,
                  decoration: InputDecoration(labelText: "Email"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  keyboardType: TextInputType.text,
                  onChanged: (_) {
                    setState(() {
                      password = _passwordController.text;
                    });
                  },
                  //onSubmitted: (_) => {},
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: "Senha"),
                  obscureText: true,
                ),
              ),
              Text(errorText),
              ElevatedButton(
                onPressed: () async {
                  var a = await getUser(email!, password!);
                  if (userJson["is_success"] != true) {
                    setState(() {
                      errorText = "E-mail ou senha incorretos";
                    });
                    return;
                  }

                  Navigator.of(context)
                      .popAndPushNamed(AppRoutes.HOME2, arguments: getUserData);
                },
                child: const Text("Login"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
