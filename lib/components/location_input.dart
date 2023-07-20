import 'package:flutter/material.dart';
//import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../screens/map_screen.dart';

import '../models/point.dart';

class LocationInput extends StatefulWidget with ChangeNotifier {
  Point? point;

  Point? get getPoint {
    return point;
  }

  void setPoint(Point point) {
    this.point = point;
    notifyListeners();
  }

  void clear() {
    point = null;
    notifyListeners();
  }

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  //String? _previewImgUrl;
  double? lat;
  double? long;
  LocationPermission? permission;

  CameraPosition? cameraPosition;
  GoogleMapController? mapController;

  Future<void> _getCurrentUserLocation(Point point) async {
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
        //_previewImgUrl = staticMapImageUrl;

        lat = locData.latitude;
        long = locData.longitude;
        cameraPosition = CameraPosition(
          target: LatLng(lat!, long!),
          zoom: 13,
        );
      },
    );
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition!),
    );

    //final staticMapImageUrl = LocationUtil.generateLocationPreviewImage(
    //  latitude: locData.latitude,
    //  longitude: locData.longitude,
    //);

    //point.changeCoordinates(widget.lat!, widget.long!);

    print("${lat!} + ${long!} OK");
    point.changeCoordinates(lat!, long!);
    widget.setPoint(point);
  }

  Future<void> _selectOnMap(Point point) async {
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

    setState(
      () {
        lat = locData.latitude;
        long = locData.longitude;
        cameraPosition = CameraPosition(
          target: LatLng(lat!, long!),
          zoom: 13,
        );
      },
    );
    point.changeCoordinates(lat!, long!);
    widget.setPoint(point);
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition!),
    );

    final LatLng? selectedPosition = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MapScreen(lat: lat!, long: long!),
        fullscreenDialog: true,
      ),
    );

    if (selectedPosition == null) return;

    setState(() {
      lat = selectedPosition.latitude;
      long = selectedPosition.longitude;
      cameraPosition = CameraPosition(
        target: LatLng(lat!, long!),
        zoom: 13,
      );
    });
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition!),
    );
    point.changeCoordinates(lat!, long!);
    widget.setPoint(point);
  }

  @override
  Widget build(BuildContext context) {
    final point = Provider.of<Point>(context, listen: false);

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 6),
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: lat == null && long == null
              ? const Center(
                  child: Text(
                    'Localização não informada',
                    textAlign: TextAlign.center,
                  ),
                )
              : GoogleMap(
                  initialCameraPosition: cameraPosition!,
                  markers: {
                    Marker(
                      markerId: const MarkerId('p1'),
                      position: LatLng(lat!, long!),
                    ),
                  },
                  mapType: MapType.satellite,
                  onMapCreated: (controller) {
                    setState(() {
                      mapController = controller;
                    });
                  },
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton.icon(
              onPressed: () => _getCurrentUserLocation(point),
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
              onPressed: () => _selectOnMap(point),
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
