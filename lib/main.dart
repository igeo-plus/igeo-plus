import 'package:flutter/material.dart';
import 'utils/routes.dart';
import 'screens/login_screen.dart';
import 'screens/subjects_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iGeo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color.fromARGB(255, 7, 163, 221),
          secondary: Color.fromARGB(255, 67, 63, 50),
        ),
        canvasColor: const Color.fromRGBO(255, 244, 244, 244),
      ),
      routes: {
        AppRoutes.HOME: (ctx) => const LoginScreen(),
        AppRoutes.SUBJECTS: (ctx) => const SubjectsScreen(),
      },
    );
  }
}
