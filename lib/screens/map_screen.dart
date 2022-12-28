import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../utils/location_util.dart';

class MapScreen extends StatefulWidget {
  MapScreen();

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  double? lat;
  double? long;

  Future<void> _getCurrentUserLocation() async {
    final locData = await Location().getLocation();

    setState(() {
      lat = locData.latitude;
      long = locData.longitude;
    });
  }

  @override
  Widget build(BuildContext context) {
    _getCurrentUserLocation();
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecione...'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: lat == null && long == null
              ? LatLng(-22, -43)
              : LatLng(lat!, long!),
          zoom: 13,
        ),
        mapType: MapType.satellite,
      ),
    );
  }
}
