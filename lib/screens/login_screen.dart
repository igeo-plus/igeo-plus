import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:igeo_flutter/models/auth.dart';

import '../utils/routes.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool isLoading = false;

  // Future<UserCredential?> _handleSignIn() async {
  //   GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //   GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

  //   final AuthCredential credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth.accessToken,
  //     idToken: googleAuth.idToken,
  //   );

  //   UserCredential? userCredential =
  //       await _auth.signInWithCredential(credential);
  //   User? user = userCredential.user;

  //   if (user != null) {
  //     Widget alert = AlertDialog(
  //       title: Text("Login"),
  //       content: Text(user.email.toString()),
  //       actions: [
  //         TextButton(
  //           onPressed: () {
  //             Navigator.of(context).pop();
  //             return;
  //           },
  //           child: const Text("OK"),
  //         ),
  //       ],
  //     );
  //     await showDialog(context: context, builder: (ctx) => alert);
  //   }

  //   //return userCredential;
  // }

  // getUser(String email, String password) async {
  //   final data = {"email": "$email", "password": "$password"};

  //   final http.Response response = await http.post(
  //     Uri.parse('https://app.uff.br/api/sign_in'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(data),
  //   );

  //   final responseData = jsonDecode(response.body);
  //   if (!responseData["is_success"] ||
  //       responseData["messages"] == "Login ou senha incorretos" ||
  //       responseData == null) {
  //     Widget alert = AlertDialog(
  //       title: const Row(
  //         children: [
  //           Icon(
  //             Icons.warning_amber_outlined,
  //             color: Colors.amber,
  //           ),
  //           Text(
  //             " Usuário e/ou senha incorretos",
  //             style: TextStyle(
  //               fontSize: 12,
  //               color: Color.fromARGB(255, 189, 39, 39),
  //             ),
  //           ),
  //         ],
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () {
  //             Navigator.of(context).pop();
  //             return;
  //           },
  //           child: const Text("OK"),
  //         ),
  //       ],
  //     );
  //     await showDialog(context: context, builder: (ctx) => alert);
  //     return;
  //   }
  //   setState(() {
  //     userJson = jsonDecode(response.body);
  //     id = userJson["data"]["user"]["id"];
  //     firstName = userJson["data"]["user"]["first_name"];
  //     lastName = userJson["data"]["user"]["last_name"];
  //     token = userJson["data"]["user"]["authentication_token"];

  //     getUserData = {
  //       "id": id,
  //       "firstName": firstName,
  //       "lastName": lastName,
  //       "token": token,
  //     };
  //   });

  //   //print(getUserData);
  //   //return response.body;
  // }

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

  Future<void> login() async {
    setState(() {
      isLoading = true;
    });
    Auth auth = Provider.of<Auth>(context, listen: false);
    Map<String, dynamic> data =
        await auth.sendTokenSignIn(_auth, _googleSignIn, context);

    setState(() {
      getUserData = data;
    });

    print(getUserData);
  }

  Future<void> logOut() async {
    Auth auth = Provider.of<Auth>(context, listen: false);
    await auth.signOut(_auth, _googleSignIn);
  }

  // @override
  // void initState() {
  //   super.initState();
  //   readFromStorage();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("iGeo"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo-login.png',
              width: double.infinity,
              height: 200,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Desenvolvido por ",
                    style: TextStyle(color: Colors.blueGrey),
                  ),
                  Text(
                    "LAGEF e STI (UFF)",
                    style: TextStyle(color: Color.fromARGB(255, 7, 163, 221)),
                  )
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(10.0),
            //   child: TextField(
            //     keyboardType: TextInputType.text,
            //     onChanged: (_) {
            //       setState(() {
            //         email = _emailController.text;
            //       });
            //     },
            //     //onSubmitted: (_) => {},
            //     controller: _emailController,
            //     decoration: const InputDecoration(labelText: "Email"),
            //     textInputAction: TextInputAction.next,
            //     autofillHints: [AutofillHints.username],
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(10.0),
            //   child: TextField(
            //     keyboardType: TextInputType.text,
            //     onChanged: (_) {
            //       setState(() {
            //         password = _passwordController.text;
            //       });
            //     },
            //     //onSubmitted: (_) => {},
            //     controller: _passwordController,
            //     decoration: const InputDecoration(labelText: "Senha"),
            //     obscureText: true,
            //     textInputAction: TextInputAction.done,
            //     onSubmitted: (_) async {
            //       await getUser(email!, password!);
            //       if (!userJson["is_success"]) {
            //         return;
            //       }

            //       Navigator.of(context)
            //           .pushNamed(AppRoutes.HOME2, arguments: getUserData);
            //     },
            //     autofillHints: [AutofillHints.password],
            //   ),
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     const Padding(
            //       padding: const EdgeInsets.all(10.0),
            //       child: const Text("Lembrar"),
            //     ), style: ButtonStyle(

            //     Checkbox(
            //         value: savePassword,
            //         onChanged: (_) {
            //           setState(() {
            //             savePassword = !savePassword;
            //           });
            //         }),
            //   ],
            // ),
            const SizedBox(
              height: 50,
            ),
            // ElevatedButton(
            //   onPressed: login,
            //   child: const Text("Gmail Login"),
            // ),

            isLoading
                ? CircularProgressIndicator(
                    color: Colors.amber,
                  )
                : SignInButton(
                    Buttons.GoogleDark,
                    onPressed: () async {
                      await login();
                      Navigator.of(context)
                          .pushNamed(AppRoutes.HOME2, arguments: getUserData);
                      setState(() {
                        isLoading = false;
                      });
                    },
                    text: "Login com Google/Gmail",
                  ),
            const SizedBox(
              height: 30,
            ),
            TextButton(
              onPressed: logOut,
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
