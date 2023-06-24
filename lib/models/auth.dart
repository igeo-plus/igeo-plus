import 'package:flutter/material.dart';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth with ChangeNotifier {
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
    }
    print("AQUI  " + userCredential.user!.uid.toString());
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
