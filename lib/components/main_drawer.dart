import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:igeo_flutter/services/google_sign_in.dart';
import 'package:igeo_flutter/utils/routes.dart';
import 'package:provider/provider.dart';

import '../models/auth.dart';

//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:google_sign_in/google_sign_in.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  late GoogleSignInHandler _googleSignInHandler;

  @override
  void initState() {
    super.initState();
    _googleSignInHandler = GoogleSignInHandler(context);
  }

  Widget _createDrawerItem(IconData icon, String label, Function onTap) {
    return TextButton(
      child: ListTile(
        leading: Icon(icon, color: Color.fromARGB(255, 7, 163, 221)),
        title: Text(label),
      ),
      onPressed: () => onTap(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          AppBar(
            title: const Text("Menu"),
            automaticallyImplyLeading: false,
          ),
          //_createDrawerItem(Icons.person, "Editar conta", () => print("ok")),
          _createDrawerItem(Icons.logout, "Logout", () {
            _googleSignInHandler.signInWithGoogle();
          }),
          _createDrawerItem(Icons.close, "Fechar", () {
            SystemNavigator.pop();
          })
        ],
      ),
    );
  }
}
