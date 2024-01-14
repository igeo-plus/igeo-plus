import 'package:flutter/material.dart';
import 'package:igeo_flutter/widgets/buttons/google_login_button.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  bool accept = false;

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
      ),
    );
  }
}
