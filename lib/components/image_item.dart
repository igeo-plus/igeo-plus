import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../screens/image_screen.dart';

class ImageItem extends StatelessWidget {
  final Uint8List image;
  const ImageItem({required this.image, super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        splashColor: Colors.amber,
        hoverColor: Color.fromARGB(255, 181, 220, 238),
        onTap: () {
          // TODO: mostrar imagem grande
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ImageScreen(image: image)));
        },
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: GridTile(
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.memory(
                  image,
                  height: 200,
                  width: 200,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
