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
    XFile? imageFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1200,
    );

    if (imageFile == null) {
      return;
    }

    setState(() {
      storedImage.add(File(imageFile.path));
    });

    //print(storedImage.last.readAsBytes());

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
    return Column(
      children: [
        Container(
          height: 370,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          alignment: Alignment.center,
          child: storedImage.isEmpty
              ? //Stack(children: [
              const Text("Sem fotos")
              // Padding(
              //   padding: const EdgeInsets.only(right: 10.0),
              //   child: TextButton.icon(
              //     onPressed: takePicture,
              //     icon: Icon(
              //       Icons.camera,
              //       color: Theme.of(context).colorScheme.error,
              //       size: 16,
              //     ),
              //     label: const Text(
              //       "Tirar foto",
              //       style: TextStyle(color: Colors.grey, fontSize: 12),
              //     ),
              //   ),
              // ),
              //])
              : Stack(
                  children: [
                    GridView.builder(
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
                            footer: GridTileBar(
                              backgroundColor: Colors.black54,
                              leading: Center(
                                child: IconButton(
                                  onPressed: () {
                                    removePicture(storedImage[index]);
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                              ),
                            ),
                            child: Image.file(
                              storedImage[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: TextButton.icon(
            onPressed: takePicture,
            icon: Icon(
              Icons.camera,
              color: Theme.of(context).colorScheme.error,
              size: 16,
            ),
            label: const Text(
              "Tirar foto",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}
