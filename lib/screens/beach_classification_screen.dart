import 'package:flutter/widgets.dart';

class BeachClassificationScreen extends StatefulWidget {
  const BeachClassificationScreen({super.key});

  @override
  State<BeachClassificationScreen> createState() =>
      _BeachClassificationScreenState();
}

class _BeachClassificationScreenState extends State<BeachClassificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Classificação de praia"),
    );
  }
}
