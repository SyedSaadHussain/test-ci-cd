import 'dart:async';
import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:mosque_management_system/core/utils/gps_permission.dart';

class TraceLocationService  {
  late Timer _timer;
  int interval = 10;
  late GPSPermission permission;
  bool isAppInForeground = true;

  // Callback to update the UI with the current time
  final Function(List<List<double>> _coordinates ) onTimeUpdate;

  TraceLocationService({required this.interval, required this.onTimeUpdate});
  final List<List<double>> _coordinates = [];
  Position? currentPosition;


  void paused(){
    isAppInForeground = false;
  }
  void resumed(){
    print('resumed');
    isAppInForeground = true;
  }

  double getDecimal(number){
      return double.parse(number.toStringAsFixed(4));
  }

  void startTracing() {

    permission = new GPSPermission(
      allowDistance: 100,
      latitude: 0,
      longitude: 0,
      isOnlyGPS: true
    );

    // addCoordinate(getDecimal(permission.latitude),getDecimal(permission.longitude));
    //  permission.checkPermission();
    permission.listner.listen((value) {
        if(value){
          currentPosition=permission.currentPosition;
          addCoordinate(getDecimal(currentPosition!.latitude),getDecimal(currentPosition!.longitude));
          onTimeUpdate(_coordinates);
        }
    });

    Duration oneSec = Duration(seconds: interval);

    _timer = Timer.periodic(oneSec, (timer) {
       if(isAppInForeground){
         permission.getCurrentLocation();
       }
       // onTimeUpdate(10);
    });
  }
  // Add an item to the stack
  void addCoordinate(double latitude, double longitude) {
    // If the list exceeds 10 coordinates, remove the first (oldest) one
    bool exists = _coordinates.any((coordinate) =>
    coordinate[0] == latitude && coordinate[1] == longitude);

    if(exists==false){
      if (_coordinates.length >= 6) {
        _coordinates.removeAt(0); // FIFO: Remove the oldest coordinate
      }

      // Add the new coordinate to the end of the list
      _coordinates.add([latitude, longitude]);
    }
  }

  void dispose() {
    _timer.cancel();
  }
}