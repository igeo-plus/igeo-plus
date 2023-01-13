import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../screens/map_screen.dart';

class LocationInput extends StatefulWidget {
  double? lat;
  double? long;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  //String? _previewImgUrl;

  Future<void> _getCurrentUserLocation() async {
    try {
      final locData = await Location().getLocation();
      setState(
        () {
          //_previewImgUrl = staticMapImageUrl;
          widget.lat = locData.latitude;
          widget.long = locData.longitude;
        },
      );
    } catch (error) {
      setState(
        () {
          widget.lat = -22.6;
          widget.long = -43.0;
        },
      );
    }

    //final staticMapImageUrl = LocationUtil.generateLocationPreviewImage(
    //  latitude: locData.latitude,
    //  longitude: locData.longitude,
    //);

    print(widget.lat);
  }

  Future<void> _selectOnMap() async {
    final locData = await Location().getLocation();

    setState(() {
      widget.lat = locData.latitude;
      widget.long = locData.longitude;
    });

    final LatLng? selectedPosition = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MapScreen(lat: widget.lat!, long: widget.long!),
        fullscreenDialog: true,
      ),
    );

    if (selectedPosition == null) return;

    setState(() {
      widget.lat = selectedPosition.latitude;
      widget.long = selectedPosition.longitude;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 3),
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: widget.lat == null && widget.long == null
              ? const Center(
                  child: Text(
                    'Localização não informada',
                    textAlign: TextAlign.center,
                  ),
                )
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: LatLng(widget.lat!, widget.long!), zoom: 13),
                  markers: {
                    Marker(
                      markerId: const MarkerId('p1'),
                      position: LatLng(widget.lat!, widget.long!),
                    ),
                  },
                  mapType: MapType.satellite,
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
                color: Theme.of(context).errorColor,
              ),
              label: const Text(
                "Pegar localização",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: _selectOnMap,
              icon: Icon(
                Icons.map,
                size: 16,
                color: Theme.of(context).errorColor,
              ),
              label: const Text(
                "Selecionar",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
