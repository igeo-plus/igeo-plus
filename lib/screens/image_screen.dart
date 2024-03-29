import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:gallery_saver/gallery_saver.dart';

class ImageScreen extends StatelessWidget {
  final Uint8List image;
  const ImageScreen({required this.image, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Foto")),
      body: Center(
        child: InteractiveViewer(
          maxScale: 4,
          child: Image.memory(
            image,
            width: double.infinity,
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     await GallerySaver.saveImage(imageUrl);
      //     ScaffoldMessenger.of(context).hideCurrentSnackBar();
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(
      //         content: const Text('Foto salva na galeria'),
      //         duration: const Duration(seconds: 2),
      //       ),
      //     );
      //   },
      //   backgroundColor: Theme.of(context).primaryColor,
      //   child: const Icon(Icons.download),
      // ),
    );
  }
}
