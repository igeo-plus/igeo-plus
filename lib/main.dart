import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'utils/routes.dart';

import 'screens/new_point_form_screen.dart';
import 'screens/login_screen.dart';
import 'screens/tabs_screen.dart';
import 'screens/subject_points_screen.dart';
import 'screens/point_details_screen.dart';
import 'screens/favorite_screen.dart';
import 'screens/new_user_screen.dart';

import 'models/point_list.dart';
import 'models/subject.dart';
import 'models/auth.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp(
  //  options: DefaultFirebaseOptions.currentPlatform,
  // );
  sqfliteFfiInit();

  databaseFactory = databaseFactoryFfi;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //ChangeNotifierProvider(create: (_) => Auth()),
        ChangeNotifierProvider(create: (_) => PointList()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'iGeo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Color.fromARGB(255, 7, 163, 221),
            secondary: Color.fromARGB(255, 67, 63, 50),
          ),
          canvasColor: const Color.fromARGB(255, 245, 245, 245),
        ),
        routes: {
          AppRoutes.HOME: (ctx) => LoginScreen(),
          AppRoutes.HOME2: (ctx) => TabsScreen(),
          //AppRoutes.SUBJECT_POINTS: (ctx) => SubjectPointsScreen(),
          AppRoutes.POINT_DETAIL: (ctx) => PointDetailScreen(),
          AppRoutes.NEW_POINT: (ctx) => NewPointFormScreen(),
          AppRoutes.NEW_USER_SCREEN: (ctx) => NewUserScreen(),
        },
      ),
    );
  }
}
