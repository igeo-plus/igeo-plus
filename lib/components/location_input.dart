import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../utils/location_util.dart';
import '../screens/map_screen.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImgUrl;

  double? _lat;
  double? _long;

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

  Future<void> _selectOnMap() async {
    final locData = await Location().getLocation();

    setState(() {
      _lat = locData.latitude;
      _long = locData.longitude;
    });

    final selectedLocation = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MapScreen(lat: _lat!, long: _long!),
        fullscreenDialog: true,
      ),
    );

    if (selectedLocation == null) return;
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
              onPressed: _selectOnMap,
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
