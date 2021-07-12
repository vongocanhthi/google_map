import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/cupertino.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GoogleMapController _googleMapController;
  String _dropdownValue = "Normal";
  late Permission _permission;
  PermissionStatus _permissionStatus = PermissionStatus.denied;

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
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void openLocationSetting() async {
    final AndroidIntent intent = new AndroidIntent(
      action: 'android.settings.LOCATION_SOURCE_SETTINGS',
    );
    await intent.launch();
  }

  Future<void> _checkPermission() async {
    final serviceStatus = await Permission.locationWhenInUse.serviceStatus;
    final isGpsOn = serviceStatus == ServiceStatus.enabled;
    if (!isGpsOn) {
      openLocationSetting();
      print('Turn on location services before requesting permission.');
      return;
    }

    final status = await Permission.locationWhenInUse.request();
    if (status == PermissionStatus.granted) {
      _googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(37.4219999, -122.0862462),
            zoom: 20.0,
          ),
        ),
      );
      print('Permission granted');
    } else if (status == PermissionStatus.denied) {
      print('Permission denied. Show a dialog and again ask for the permission');
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Take the user to the settings page.');
      await openAppSettings();
    }
  }

  Future<void> _requestPermission(Permission permission) async {
    final status = await permission.request();

    setState(() {
      print(status);
      _permissionStatus = status;
      print(_permissionStatus);
    });
  }

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
          //todo
          _checkPermission();
        },
      ),
    );
  }
}
