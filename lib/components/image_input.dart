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
  List<File> storedImage = [];

  void takePicture() async {
    if (storedImage.length >= 4) {
      AlertDialog alert = AlertDialog(
        title: const Text("Você atingiu o limite de 4 imagens"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("OK"),
          ),
        ],
      );

      showDialog(context: context, builder: (ctx) => alert);
      return;
    }
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

  void removePicture(File file) {
    setState(() {
      storedImage.remove(file);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            height: 370,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey),
            ),
            alignment: Alignment.center,
            child: storedImage.isEmpty
                ? const Text("Sem fotos")
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 1,
                    ),
                    itemCount: storedImage.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: GridTile(
                          child: Image.file(
                            storedImage[index],
                            fit: BoxFit.cover,
                          ),
                          footer: GridTileBar(
                            backgroundColor: Colors.black54,
                            leading: Center(
                              child: IconButton(
                                onPressed: () {
                                  removePicture(storedImage[index]);
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Theme.of(context).errorColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Expanded(
              child: TextButton.icon(
                onPressed: takePicture,
                icon: Icon(
                  Icons.camera,
                  color: Theme.of(context).errorColor,
                  size: 16,
                ),
                label: const Text(
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
