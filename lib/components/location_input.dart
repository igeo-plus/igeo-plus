import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImgUrl;

  Future<void> _getCurrentUserLocation() async {
    final locData = await Location().getLocation();
    print(locData.latitude);
    print(locData.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _previewImgUrl == null
              ? Center(
                  child: Text(
                    'Localização não informada',
                    textAlign: TextAlign.center,
                  ),
                )
              : Image.network(
                  _previewImgUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton.icon(
              onPressed: _getCurrentUserLocation,
              icon: Icon(
                Icons.location_on,
                size: 16,
              ),
              label: Text(
                "Localização atual",
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: Icon(
                Icons.map,
                size: 16,
              ),
              label: Text(
                "Selecione no mapa",
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ),
          ],
        )
      ],
    );
  }
}
