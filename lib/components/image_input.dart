import 'package:flutter/material.dart';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  final Function onSelectImage;
  const ImageInput(this.onSelectImage);

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  List<dynamic> storedImage = [];

  void takePicture() async {
    final ImagePicker picker = ImagePicker();
    XFile imageFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    ) as XFile;

    setState(() {
      storedImage.add(File(imageFile.path));
    });

    final appDir = await syspaths.getApplicationDocumentsDirectory();
    String fileName = path.basename(storedImage.last.path);
    final savedImage = await storedImage.last.copy('${appDir.path}/$fileName');

    widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            height: 300,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey),
            ),
            alignment: Alignment.center,
            child: storedImage.isEmpty
                ? const Text("Sem fotos")
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    itemCount: storedImage.length,
                    itemBuilder: (context, index) =>
                        Image.file(storedImage[index]),
                  ),
          ),
          const SizedBox(
            width: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Expanded(
              child: TextButton.icon(
                onPressed: takePicture,
                icon: Icon(
                  Icons.camera,
                  color: Theme.of(context).errorColor,
                  size: 16,
                ),
                label: Text(
                  "Tirar foto",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
