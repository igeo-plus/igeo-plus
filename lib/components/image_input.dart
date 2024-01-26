import 'package:flutter/material.dart';
import 'dart:io';
import 'package:intl/intl.dart';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

import 'package:image_picker/image_picker.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image/image.dart' as img;
import 'package:geolocator/geolocator.dart';

class ImageInput extends StatefulWidget {
  final Function onSelectImage;
  ImageInput(this.onSelectImage);

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  List<File> storedImage = [];

  double? lat;
  double? long;
  LocationPermission? permission;

  Future<void> _getCurrentUserLocation() async {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    final locData = await Geolocator.getCurrentPosition();
    print(locData);
    setState(
      () {
        lat = locData.latitude;
        long = locData.longitude;
      },
    );
    print("${lat!} + ${long!} OK");
  }

  void takePicture() async {
    await _getCurrentUserLocation();
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
      maxWidth: 1000,
    );

    if (imageFile == null) {
      return;
    }

    final decodeImg = img.decodeImage(File(imageFile.path).readAsBytesSync());

    img.drawString(decodeImg!,
        '${DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now())} - Lat: $lat - Long: $long',
        x: 10, y: 10, font: img.arial24, color: img.ColorRgb8(255, 0, 0));

    final encodeImage = img.encodeJpg(decodeImg, quality: 100);

    setState(() {
      storedImage.add(File(imageFile.path)..writeAsBytesSync(encodeImage));
    });

    //print(storedImage.last.readAsBytes());

    final appDir = await syspaths.getApplicationDocumentsDirectory();
    String fileName = path.basename(storedImage.last.path);
    final savedImage = await storedImage.last.copy('${appDir.path}/$fileName');

    // TODO: Salvar imagem no Storage
    await GallerySaver.saveImage(savedImage.path);

    widget.onSelectImage(savedImage);
  }

  void removePicture(File file) async {
    await file.delete();
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
                            footer: const GridTileBar(
                              backgroundColor: Colors.black54,
                              // leading: Center(
                              //   child: IconButton(
                              //     onPressed: () async {
                              //       await storedImage[index].delete();
                              //       removePicture(storedImage[index]);
                              //     },
                              //     icon: Icon(
                              //       Icons.delete,
                              //       color: Theme.of(context).colorScheme.error,
                              //     ),
                              //   ),
                              // ),
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
