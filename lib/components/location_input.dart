import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../utils/location_util.dart';
import '../screens/map_screen.dart';
import '../utils/routes.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImgUrl;

  Future<void> _getCurrentUserLocation() async {
    final locData = await Location().getLocation();

    final staticMapImageUrl = LocationUtil.generateLocationPreviewImage(
      latitude: locData.latitude,
      longitude: locData.longitude,
    );

    setState(() {
      _previewImgUrl = staticMapImageUrl;
    });
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
                size: 18,
              ),
              label: Text(
                "Localização atual",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            TextButton.icon(
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.MAP_SCREEN),
              icon: Icon(
                Icons.map,
                size: 18,
              ),
              label: Text(
                "Selecione",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ],
        )
      ],
    );
  }
}
