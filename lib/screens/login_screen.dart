import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:igeo_flutter/utils/routes.dart';
import 'package:igeo_flutter/widgets/buttons/google_login_button.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final auth = FirebaseAuth.instance;

  bool isLoading = false;
  bool accept = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("iGeo"),
      // ),
      body: Center(
        child: FutureBuilder<bool>(
          future: checkUserLoggedIn(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.data == true) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushNamedAndRemoveUntil(context, AppRoutes.HOME2, (route) => false);
              });
              return Container();
            } else {
              return SingleChildScrollView(
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
                    const SizedBox(
                      height: 50,
                    ),
                    isLoading
                        ? const CircularProgressIndicator(
                      color: Colors.amber,
                    )
                        : const GoogleLoginButton(),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> checkUserLoggedIn() async {
    return auth.currentUser != null;
  }
}
