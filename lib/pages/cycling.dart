
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class Cycling extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SpeedometerPage();
  }
}

class SpeedometerPage extends StatefulWidget {
  @override
  _SpeedometerPageState createState() => _SpeedometerPageState();
}

class _SpeedometerPageState extends State<SpeedometerPage> {

  double _currentSpeed = 0.0;
  StreamSubscription<Position>? _positionStreamSubscription;
  LatLng _currentLocation = LatLng(0, 0);
    void _subscribeToPositionStream() {
    _positionStreamSubscription = Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _currentSpeed = position.speed * 3.6; // Convert m/s to km/h
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getPermission();
    _subscribeToPositionStream();
  }

  getPermission()async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.unableToDetermine) {
      permission = await GeolocatorPlatform.instance.requestPermission();
    }else{
      getPermission();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Speedometer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Current Speed:',
              style: TextStyle(fontSize: 20.0),
            ),
            Text(
              '${_currentSpeed.toStringAsFixed(2)} km/h',
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
