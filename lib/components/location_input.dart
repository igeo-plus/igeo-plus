import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../utils/location_util.dart';
import '../screens/map_screen.dart';

import '../models/point.dart';

class LocationInput extends StatefulWidget {
  double? lat;
  double? long;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  //String? _previewImgUrl;

  Future<void> _getCurrentUserLocation() async {
    final locData = await Location().getLocation();

    //final staticMapImageUrl = LocationUtil.generateLocationPreviewImage(
    //  latitude: locData.latitude,
    //  longitude: locData.longitude,
    //);

    setState(() {
      //_previewImgUrl = staticMapImageUrl;
      widget.lat = locData.latitude;
      widget.long = locData.longitude;
    });
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
      //_previewImgUrl = LocationUtil.generateLocationPreviewImage(
      //  latitude: selectedPosition.latitude,
      //  longitude: selectedPosition.longitude,
      // );
      widget.lat = selectedPosition.latitude;
      widget.long = selectedPosition.longitude;
    });

    //print(selectedPosition.latitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 3),
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(10)),
          child: widget.lat == null && widget.long == null
              ? Center(
                  child: Text(
                    'Localização não informada',
                    textAlign: TextAlign.center,
                  ),
                )
              : //Image.network(
              // _previewImgUrl!,
              // fit: BoxFit.cover,
              // width: double.infinity,
              //),
              GoogleMap(
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
                color: Theme.of(context).primaryColor,
              ),
              label: Text(
                "Localização atual",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: _selectOnMap,
              icon: Icon(
                Icons.map,
                size: 16,
                color: Theme.of(context).primaryColor,
              ),
              label: Text(
                "Selecione",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            )
          ],
        )
      ],
    );
  }
}
