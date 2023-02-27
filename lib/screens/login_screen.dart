import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';

import '../utils/routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? email;
  String? password;
  Map? userData;
  dynamic userJson;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  getUser(String email, String password) async {
    var url = Uri.http("localhost:3000", "api/sign_in");
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    print(data);

    // setState(() {
    //   userJson = data;
    //   if (userJson["is_success"]) {
    //     return;
    //   }
    //   userData = {
    //     "first_name": userJson["first_name"],
    //     "last_name": userJson["last_name"],
    //     "token": userJson["token"],
    //   };
    // });
  }

  void _goToSubjectsScreen(BuildContext context, Map userData) {
    getUser(email!, password!);
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
                  onChanged: (_) => email = _emailController.text,
                  //onSubmitted: (_) => {},
                  controller: _emailController,
                  decoration: InputDecoration(labelText: "Email"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  keyboardType: TextInputType.text,
                  onChanged: (_) => password = _passwordController.text,
                  //onSubmitted: (_) => {},
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: "Senha"),
                  obscureText: true,
                ),
              ),
              ElevatedButton(
                onPressed: () => getUser(email!, password!),
                child: const Text("Login"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
