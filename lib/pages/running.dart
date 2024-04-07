import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Running extends StatelessWidget {
  const Running({super.key});

  @override
  Widget build(BuildContext context) {
    return MyApp();
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Completer<GoogleMapController> _controller = Completer();


  final Set<Marker> _markers = {};


  MapType _currentMapType = MapType.normal;

  static const LatLng _center = LatLng(0, 0);
  LatLng _currentLocation = const LatLng(0, 0); // Initialize with a default value
  double _currentSpeed = 0.0;
  StreamSubscription<Position>? _positionStreamSubscription;

  void _subscribeToPositionStream() {
    _positionStreamSubscription = Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _currentSpeed = position.speed * 3.6; // Convert m/s to km/h
      });
    });
  }
  LatLng _lastMapPosition = _center;

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        infoWindow: InfoWindow(
          title: 'Really cool place',
          snippet: '5 Star Rating',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ));
    });
  }

  void _onSearchingPressed(){
    _positionStreamSubscription = Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);

        _markers.add(Marker(
          // This marker id can be anything that uniquely identifies each marker.
          markerId: MarkerId(_lastMapPosition.toString()),
          position: _currentLocation,
          icon: BitmapDescriptor.defaultMarker,
        ));
      });
    });
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _subscribeToPositionStream();
  }

    @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track Your Self'),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _currentLocation,
              zoom: 11.0,
            ),
            mapType: _currentMapType,
            markers: _markers,
            onCameraMove: _onCameraMove,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.topRight,
              child: Column(
                children: <Widget>[
                  FloatingActionButton(
                    onPressed: _onMapTypeButtonPressed,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    backgroundColor: Colors.blue,
                    child: const Icon(Icons.map, size: 36.0),
                  ),
                  SizedBox(height: 16.0),
                  FloatingActionButton(
                    onPressed: _onAddMarkerButtonPressed,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    backgroundColor: Colors.blue,
                    child: const Icon(Icons.add_location, size: 36.0),
                  ),
                  SizedBox(height: 16.0),
                  FloatingActionButton(
                    onPressed: _onSearchingPressed,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    backgroundColor: Colors.blue,
                    child: const Icon(Icons.location_searching, size: 36.0),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child : Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                height: 100,
                width: 200,
                child: Row(
                  children: [
                    Icon(Icons.speed, size: 50,),
                    Text("${_currentSpeed.round()} Km/h", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),)
                  ],
                ),
              ),
            )
          )
        ],
      ),
    );
  }
}

// class LocationSpeedMapApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return LocationSpeedMapPage();
//   }
// }
//
// class LocationSpeedMapPage extends StatefulWidget {
//   @override
//   _LocationSpeedMapPageState createState() => _LocationSpeedMapPageState();
// }
//
// class _LocationSpeedMapPageState extends State<LocationSpeedMapPage> {
//   GoogleMapController? _mapController;
//   LatLng _currentLocation = LatLng(0, 0); // Initialize with a default value
//   double _currentSpeed = 0.0;
//   StreamSubscription<Position>? _positionStreamSubscription;
//
//   @override
//   void initState() {
//     super.initState();
//     _subscribeToPositionStream();
//   }
//
//   @override
//   void dispose() {
//     _positionStreamSubscription?.cancel();
//     super.dispose();
//   }
//
//   void _onMapCreated(GoogleMapController controller) {
//     setState(() {
//       _mapController = controller;
//     });
//   }
//
//   void _subscribeToPositionStream() {
//     _positionStreamSubscription = Geolocator.getPositionStream().listen((Position position) {
//       setState(() {
//         _currentLocation = LatLng(position.latitude, position.longitude);
//         _currentSpeed = position.speed * 3.6; // Convert m/s to km/h
//         _moveCameraToLocation(_currentLocation);
//       });
//     });
//   }
//
//   void _moveCameraToLocation(LatLng location) {
//     if (_mapController != null) {
//       _mapController!.animateCamera(CameraUpdate.newCameraPosition(
//         CameraPosition(
//           target: location,
//           zoom: 15.0,
//         ),
//       ));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Location & Speed Map'),
//       ),
//       body: Stack(
//         children: [
//           GoogleMap(
//             onMapCreated: _onMapCreated,
//             initialCameraPosition: CameraPosition(
//               target: LatLng(0, 0), // Initial map position (centered at 0,0)
//               zoom: 15.0,
//             ),
//             myLocationEnabled: true,
//             compassEnabled: true,
//             zoomControlsEnabled: true,
//           ),
//           Positioned(
//             top: 16.0,
//             left: 16.0,
//             child: Card(
//               child: Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Latitude: ${_currentLocation.latitude}',
//                       style: TextStyle(fontSize: 16.0),
//                     ),
//                     Text(
//                       'Longitude: ${_currentLocation.longitude}',
//                       style: TextStyle(fontSize: 16.0),
//                     ),
//                     Text(
//                       'Speed: ${_currentSpeed.toStringAsFixed(2)} km/h',
//                       style: TextStyle(fontSize: 16.0),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
