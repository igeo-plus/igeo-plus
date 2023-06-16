import 'package:flutter/material.dart';

class ImageScreen extends StatelessWidget {
  final String imageUrl;
  const ImageScreen({required this.imageUrl, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Foto")),
      body: Center(
        child: InteractiveViewer(
          maxScale: 4,
          child: Image.network(
            imageUrl,
            width: double.infinity,
          ),
        ),
      ),
    );
  }
}
