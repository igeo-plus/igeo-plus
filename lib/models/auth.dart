import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../components/text.dart';

class Auth with ChangeNotifier {
  sendTokenSignIn(FirebaseAuth auth, GoogleSignIn googleSignIn,
      BuildContext context) async {
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) return null;

    GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential? userCredential =
        await auth.signInWithCredential(credential);

    User? user = userCredential.user;

    bool accept = true;

    final responseNewUser = await http.post(
      Uri.parse("https://app.uff.br/igeo-retaguarda/api/new_user"),
      body: {
        "email": googleUser.email.toString(),
      },
    );

    final responseNewUserData = jsonDecode(responseNewUser.body);

    if (responseNewUserData["new_user"] == true) {
      Widget alert = AlertDialog(
        title: const Row(
          children: [
            Icon(
              Icons.warning_amber_outlined,
              color: Colors.amber,
              size: 12,
            ),
            Expanded(
              child: Text(
                " Termos de Uso",
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
            style: const TextStyle(
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
            onPressed: () async {
              Navigator.of(context).pop();
              accept = false;
              await googleSignIn.signOut();
              await auth.signOut();
              return;
            },
            child: const Text("Discordo"),
          ),
        ],
      );
      await showDialog(context: context, builder: (ctx) => alert);
    }

    if (accept == false) return;

    final response = await http.post(
      Uri.parse("https://app.uff.br/igeo-retaguarda/api/sign_in"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${googleAuth.idToken.toString()}',
      },
    );

    final responseData = jsonDecode(response.body);
    if (!responseData["is_success"] ||
        responseData["messages"] == "Login ou senha incorretos" ||
        responseData == null) {
      Widget alert = AlertDialog(
        title: const Row(
          children: [
            Icon(
              Icons.warning_amber_outlined,
              color: Colors.amber,
            ),
            Text(
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

    int id = responseData["data"]["user"]["id"];
    String firstName = responseData["data"]["user"]["first_name"] ?? "";
    String lastName = responseData["data"]["user"]["last_name"] ?? "";
    String token = responseData["data"]["user"]["authentication_token"] ?? "";

    Map<String, dynamic> getUserData = {
      "id": id,
      "firstName": firstName,
      "lastName": lastName,
      "token": token,
    };

    return getUserData;
  }

  Future<Map<String, dynamic>?> handleSignIn(FirebaseAuth auth,
      GoogleSignIn googleSignIn, BuildContext context) async {
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential? userCredential =
        await auth.signInWithCredential(credential);
    User? user = userCredential.user;

    if (user != null) {
      Widget alert = AlertDialog(
        title: Text("Login"),
        content: Text(user.email.toString()),
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

      String token = googleAuth.idToken.toString();

      while (token.length > 0) {
        int initLength = (token.length >= 500 ? 500 : token.length);
        print(token.substring(0, initLength));
        int endLength = token.length;
        token = token.substring(initLength, endLength);
      }
    }
    //print(googleAuth.idToken.toString());
    //print("AQUI  " + userCredential.user!.uid.toString());
    //return userCredential;

    Map<String, dynamic> userData = {
      "uid": user!.uid.toString(),
      "email": user!.email.toString(),
      "token": userCredential.credential!.token,
      "acessToken": userCredential.credential!.accessToken,
    };

    print("LOGADO  " + userData.toString());
    return userData;
  }

  Future<void> signOut(FirebaseAuth auth, GoogleSignIn googleUser) async {
    await googleUser.signOut();
    await auth.signOut();
    print("deslogado");
  }
}
