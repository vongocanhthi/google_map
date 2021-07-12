import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter/cupertino.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GoogleMapController _googleMapController;
  String _dropdownValue = "Normal";

  List<String> _mapTypeTextList = [
    "None",
    "Normal",
    "Satellite",
    "Terrain",
    "Hybrid"
  ];

  MapType _mapType = MapType.terrain;
  List<MapType> _mapTypeList = [
    MapType.none,
    MapType.normal,
    MapType.satellite,
    MapType.terrain,
    MapType.hybrid
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Google Map")),
      ),
      body: Column(
        children: [
          Row(children: [
            Text("Select map type: "),
            DropdownButton(
              value: _dropdownValue,
              onChanged: (String? value) {
                setState(() {
                  _dropdownValue = value!;
                  for (int i = 0; i < _mapTypeTextList.length; i++) {
                    if (_dropdownValue == _mapTypeTextList[i]) {
                      _mapType = _mapTypeList[i];
                    }
                  }
                });
              },
              items: _mapTypeTextList.map<DropdownMenuItem<String>>((text) {
                return DropdownMenuItem<String>(
                  value: text,
                  child: Text("$text"),
                );
              }).toList(),
            )
          ]),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(37.4219999, -122.0862462),
              ),
              onMapCreated: (controller) {
                _googleMapController = controller;
              },
              mapType: _mapType,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              rotateGesturesEnabled: false,
              // scrollGesturesEnabled: false,
              tiltGesturesEnabled: false,
              zoomControlsEnabled: false,
              zoomGesturesEnabled: true,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.location_searching),
        onPressed: () {
          _googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                  target: LatLng(37.4219999, -122.0862462), zoom: 20.0),
            ),
          );
        },
      ),
    );
  }
}
