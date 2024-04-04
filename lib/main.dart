import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:getsetfit/Authentication/authentication.dart';
import 'systemvalues.dart';

late List<CameraDescription> cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyD0EZgm8vCOPVIjt9AaUVE5LSfsSLZXgzY",
          appId: "1:507597712389:android:095d3c453dcc834ccc006c",
          messagingSenderId: "507597712389",
          projectId: "getsetfit-b20ca",
          storageBucket: "getsetfit-b20ca.appspot.com"));
  runApp(MaterialApp(
    home: Authentication(),
    color: SystemValues.systemColor,
    debugShowCheckedModeBanner: false,
  ));
}
