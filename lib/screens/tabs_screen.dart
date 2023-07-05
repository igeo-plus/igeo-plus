import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';

import 'subjects_screen.dart';
import 'beach_classification_screen.dart';
import 'favorite_screen.dart';

import '../components/main_drawer.dart';

import '../models/subject.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '/models/auth.dart';
import '/utils/routes.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

int _selectedScreenIndex = 0;

class _TabsScreenState extends State<TabsScreen> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> userData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final List<Map<String, Object>> _screens = [
      {"title": "Campos", "screen": SubjectsScreen(userData)},
      {
        "title": "Pontos Favoritos",
        "screen": FavoriteScreen(userData),
      },
      // {
      //   "title": "Classificação de Praias",
      //   "screen": BeachClassificationScreen()
      // },
    ];

    void _selectScreen(int index) {
      setState(() {
        _selectedScreenIndex = index;
      });
    }

    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    Future<void> logOut() async {
      Auth auth = Provider.of<Auth>(context, listen: false);
      await auth.signOut(_auth, _googleSignIn);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_screens[_selectedScreenIndex]['title'] as String),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(AppRoutes.HOME, (route) => false);
              logOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      drawer: const MainDrawer(),
      body: _screens[_selectedScreenIndex]['screen'] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectScreen,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.blueGrey,
        selectedItemColor: Theme.of(context).primaryColor,
        currentIndex: _selectedScreenIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.travel_explore),
            label: 'Campos',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.star_border,
              color: _selectedScreenIndex != 0 ? Colors.amber : Colors.blueGrey,
            ),
            label: 'Pontos favoritos',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.beach_access),
          //   label: 'Classificação de praias',
          // ),
        ],
      ),
    );
  }
}
