import 'package:flutter/material.dart';

import 'subjects_screen.dart';
import 'beach_classification_screen.dart';
import 'favorite_screen.dart';

import '../components/main_drawer.dart';

import '../models/subject.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

List<Subject> subjects = [
  Subject(id: 1, name: "Geomorfologia"),
  Subject(id: 2, name: "Pedologia"),
];

class _TabsScreenState extends State<TabsScreen> {
  int _selectedScreenIndex = 0;
  final List<Map<String, Object>> _screens = [
    {"title": "Campos", "screen": SubjectsScreen()},
    {
      "title": "Pontos Favoritos",
      "screen": FavoriteScreen(subjects),
    },
    {"title": "Classificação de Praias", "screen": BeachClassificationScreen()},
  ];

  void _selectScreen(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_screens[_selectedScreenIndex]['title'] as String),
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
            ),
            label: 'Pontos favoritos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.beach_access),
            label: 'Classificação de praias',
          ),
        ],
      ),
    );
  }
}
