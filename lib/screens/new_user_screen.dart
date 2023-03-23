import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class NewUserScreen extends StatelessWidget {
  const NewUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Novo usuário"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
            child: ListView(
          children: [],
        )),
      ),
    );
  }
}
