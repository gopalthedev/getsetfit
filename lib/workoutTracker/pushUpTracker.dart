import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:all_sensors/all_sensors.dart';

import '../Explore/explore.dart';

class ProximitySensorScreen extends StatefulWidget {
  @override
  _ProximitySensorScreenState createState() => _ProximitySensorScreenState();
}

class _ProximitySensorScreenState extends State<ProximitySensorScreen> {
  bool _isNear = false;
  double pushUpCount = 0;
  bool isRestart = false;
  double lastSessionData = 0.0;
  String lastSessiontime = "";
  String currentSessiontime = "";
  final stopWatch = Stopwatch();
  late StreamSubscription<ProximityEvent> _proximitySubscription;
  List<List<Color>> listofColor = [
    [Colors.green.shade200, Colors.green],
    [Colors.green.shade200, Colors.green, Colors.yellow],
    [Colors.green.shade200, Colors.green, Colors.yellow, Colors.red]
  ];
  late List<Color> colorList = [Colors.green.shade200, Colors.green];

  void selectColor() {
    setState(() {
      if (pushUpCount <= 30) {
        colorList = listofColor[0];
      } else if (pushUpCount > 30 && pushUpCount <= 60) {
        colorList = listofColor[1];
      } else {
        colorList = listofColor[2];
      }
    });
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _activateProximitySensor();
  //   selectColor();
  // }

  void _activateProximitySensor() {
    _proximitySubscription = proximityEvents!.listen((ProximityEvent event) {
      setState(() {
        _isNear = event.getValue();
        if (_isNear) pushUpCount++;
        dailyProgress++;
        FirebaseFirestore.instance.collection('User').doc(FirebaseAuth.instance.currentUser!.uid).set({
          'coins' : myCoins + dailyProgress
        });
        selectColor();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Push Ups"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: colorList,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "You have done :",
                      style: TextStyle(fontSize: 30),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "$pushUpCount",
                      style: TextStyle(fontSize: 30, color: Colors.black),
                    ),
                    Text(
                      "Push Ups",
                      style: TextStyle(fontSize: 30),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  onPressed: () {
                    stopWatch.start();
                    pushUpCount = 0;
                    _activateProximitySensor();
                  },
                  child: Text("Start Session"),
                  clipBehavior: Clip.antiAlias,
                  elevation: 1,
                  color: Colors.green.shade200,
                  height: 40,
                  shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    _proximitySubscription.cancel();
                    setState(() {
                      currentSessiontime = stopWatch.elapsed.toString();
                      stopWatch.stop();
                      lastSessionData = pushUpCount;
                      lastSessiontime = currentSessiontime;
                      pushUpCount = 0;
                      currentSessiontime = "";
                    });
                  },
                  child: Text("Stop Session"),
                  clipBehavior: Clip.antiAlias,
                  elevation: 1,
                  color: Colors.red.shade200,
                  height: 40,
                  shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            ListTile(
              title: Text("Your last seesion"),
              subtitle: Text(
                  "PushUps : $lastSessionData in time :" + lastSessiontime),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image(
                image: AssetImage("asset/psuhUpImage.jpg"),
                color: Colors.white,
                colorBlendMode: BlendMode.multiply,
              ),
            ),
            SizedBox(height:10,),
            Text("Keep your phone below your chest", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _proximitySubscription.cancel(); // Turn off proximity sensor subscription
    super.dispose();
  }
}
