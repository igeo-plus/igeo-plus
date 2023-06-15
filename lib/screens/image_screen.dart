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
          panEnabled: false,
          boundaryMargin: const EdgeInsets.all(100),
          minScale: 0.5,
          maxScale: 2,
          child: Image.network(imageUrl),
        ),
      ),
    );
  }
}
