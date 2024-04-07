import 'dart:async';

import 'package:all_sensors/all_sensors.dart';
import 'package:flutter/material.dart';

class WeightLifting extends StatefulWidget {
  const WeightLifting({super.key});

  @override
  State<WeightLifting> createState() => _WeightLiftingState();
}

class _WeightLiftingState extends State<WeightLifting> {
  double weightLifted = 0;

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
      if (weightLifted <= 30) {
        colorList = listofColor[0];
      } else if (weightLifted > 30 && weightLifted <= 60) {
        colorList = listofColor[1];
      } else {
        colorList = listofColor[2];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weight Lifting", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                        "You have lifted :",
                        style: TextStyle(fontSize: 30),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "$weightLifted",
                        style: TextStyle(fontSize: 30, color: Colors.black),
                      ),
                      Text(
                        "Weight",
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
                      weightLifted = 0;

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
                        lastSessionData = weightLifted;
                        lastSessiontime = currentSessiontime;
                        weightLifted = 0;
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
                    "Weigth Lifting : $lastSessionData in time :" + lastSessiontime),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image(
                  image: AssetImage("asset/weightLifting.jpg"),
                  color: Colors.white,
                  colorBlendMode: BlendMode.multiply,
                ),
              ),
              SizedBox(height:10,),
              Text("Keep mobile in your pocket", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
            ],
          ),
        ),
      ),
    );
  }
}
