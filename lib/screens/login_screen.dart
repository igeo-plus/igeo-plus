import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../utils/routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? email;
  String? password;
  bool savePassword = true;

  int? id;
  String? firstName;
  String? lastName;
  String? token;

  Map<String, dynamic>? getUserData;

  dynamic userJson;

  final storage = const FlutterSecureStorage();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  //String errorText = '';

  getUser(String email, String password) async {
    final data = {"email": "$email", "password": "$password"};

    final http.Response response = await http.post(
      Uri.parse('https://app.uff.br/umm/api/sign_in_igeo'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    final responseData = jsonDecode(response.body);
    if (!responseData["is_success"] ||
        responseData["messages"] == "Login ou senha incorretos" ||
        responseData == null) {
      Widget alert = AlertDialog(
        title: Row(
          children: [
            const Icon(
              Icons.warning_amber_outlined,
              color: Colors.amber,
            ),
            const Text(
              " Usuário e/ou senha incorretos",
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
              return;
            },
            child: const Text("OK"),
          ),
        ],
      );
      await showDialog(context: context, builder: (ctx) => alert);
      return;
    }
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

    //print(getUserData);
    //return response.body;
  }

  void _goToSubjectsScreen(
      BuildContext context, Map<String, dynamic> userData) {
    Navigator.of(context).popAndPushNamed(
      AppRoutes.HOME2,
      arguments: userData,
    );
  }

  Future<void> readFromStorage() async {
    _emailController.text = await storage.read(key: "KEY_USERNAME") ?? '';
    _passwordController.text = await storage.read(key: "KEY_PASSWORD") ?? '';
    email = await storage.read(key: "KEY_USERNAME") ?? '';
    password = await storage.read(key: "KEY_PASSWORD") ?? '';
  }

  @override
  void initState() {
    super.initState();
    readFromStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('iGeo'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: AutofillGroup(
            child: Form(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo-login.png',
                    width: double.infinity,
                    height: 100,
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
                      decoration: const InputDecoration(labelText: "Email"),
                      textInputAction: TextInputAction.next,
                      autofillHints: [AutofillHints.username],
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
                      decoration: const InputDecoration(labelText: "Senha"),
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) async {
                        await getUser(email!, password!);
                        if (!userJson["is_success"]) {
                          return;
                        }

                        Navigator.of(context)
                            .pushNamed(AppRoutes.HOME2, arguments: getUserData);
                      },
                      autofillHints: [AutofillHints.password],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: const Text("Lembrar"),
                      ),
                      Checkbox(
                          value: savePassword,
                          onChanged: (_) {
                            setState(() {
                              savePassword = !savePassword;
                            });
                          }),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await getUser(email!, password!);
                      if (userJson == null ||
                          userJson != null && !userJson["is_success"]) {
                        return;
                      }

                      if (savePassword) {
                        await storage.write(
                            key: "KEY_USERNAME", value: _emailController.text);

                        await storage.write(
                            key: "KEY_PASSWORD",
                            value: _passwordController.text);
                      }

                      if (userJson["is_success"]) {
                        Navigator.of(context).pushReplacementNamed(
                            AppRoutes.HOME2,
                            arguments: getUserData);
                      }
                    },
                    child: const Text("Login"),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/new-user-screen'),
                      child: const Text("Novo usuário"),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
