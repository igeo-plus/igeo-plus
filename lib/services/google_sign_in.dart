import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:igeo_flutter/components/text.dart';
import 'package:igeo_flutter/utils/db_utils.dart';
import 'package:igeo_flutter/utils/routes.dart';
import '../models/user.dart';

class GoogleSignInHandler {
  BuildContext context;
  GoogleSignInHandler(this.context);

  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  late bool registered;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  UserCredential? userCredential;

  Future<bool> userFound() async {
    late bool found;
    await db.collection("users")
        .doc(auth.currentUser!.uid)
        .get()
        .then((docSnapshot) {
      if(docSnapshot.exists) {
        found = true;
      } else {
        found = false;
      }
    },
      onError: (e) => debugPrint("Error completing: $e"),
    );
    return found;
  }

  Future<void> signInWithGoogle() async {
    if (auth.currentUser != null) {
      try {
        await auth.signOut();
        await googleSignIn.signOut();
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.HOME, (route) => false);
        debugPrint('Deslogado');
      } catch(e) {
        debugPrint("ERRO deslogando:\n$e");
      }
    } else {
      try {
        // Trigger the authentication flow
        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

        // Obtain the auth details from the request
        final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        debugPrint('googleUser: $googleUser');
        debugPrint('googleAuth: $googleAuth');
        userCredential = await auth.signInWithCredential(credential);

        registered = await userFound();

        if (!registered) {
          await submitForm();

          AppUser userdata = AppUser(
            id: auth.currentUser!.uid,
            name: auth.currentUser!.displayName!,
            email: auth.currentUser!.email!,
            favoritePointsIds: []
          );

          await db.collection("users").doc(auth.currentUser!.uid)
            .set(
            {
              "id": auth.currentUser!.uid,
              "name": auth.currentUser!.displayName,
              "email": auth.currentUser!.email,
              "favorite_points_ids": []
            }
          ).then((_) {
            debugPrint("New user saved");
            Navigator.pushNamedAndRemoveUntil(context, AppRoutes.HOME2, (route) => false);
          }
          ).onError((e, _) {
            debugPrint("Error saving user: $e");
          });
        } else {
          debugPrint("User already registered");
          Navigator.pushNamedAndRemoveUntil(context, AppRoutes.HOME2, (route) => false);
        }
      } catch(e) {
        debugPrint("Error in signInWithGoogle: $e");
      }
    }
  }

  Future<void> submitForm() async {
    // final dataFromAccept = await DbUtil.getData("accepts");

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
          style: const TextStyle(
            fontSize: 9,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop();
            await DbUtil.updateAccept();
            Navigator.of(context).pushNamed(AppRoutes.HOME2,);
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Você aceitou o termo de responsabilidade'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          child: const Text("Concordo"),
        ),
        TextButton(
          onPressed: () async {
            try {
              await auth.signOut();
              await googleSignIn.signOut();
              debugPrint('Deslogado');
            } catch(e) {
              debugPrint("ERRO deslogando:\n$e");
            }

            Navigator.of(context).pop();
            SystemNavigator.pop();

            return;
          },
          child: const Text("Discordo"),
        ),
      ],
    );
    await showDialog(context: context, builder: (ctx) => alert);
  }
}