import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../utils/routes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void _goToSubjectsScreen(BuildContext context) {
    Navigator.of(context).popAndPushNamed(AppRoutes.SUBJECTS);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('iGeo'),
      ),
      body: Center(
        child: Column(
          children: [
            Image.asset(
              'assets/images/logo-login.png',
              width: double.infinity,
              height: 150,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                keyboardType: TextInputType.text,
                onSubmitted: (_) => {},
                //controller: _titleController,
                decoration: InputDecoration(labelText: "Login"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                keyboardType: TextInputType.text,
                onSubmitted: (_) => {},
                //controller: _titleController,
                decoration: InputDecoration(labelText: "Senha"),
                obscureText: true,
              ),
            ),
            ElevatedButton(
              onPressed: () => _goToSubjectsScreen(context),
              child: const Text("Login"),
            )
          ],
        ),
      ),
    );
  }
}
