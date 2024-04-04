import 'package:flutter/material.dart';
import 'package:getsetfit/Explore/explore.dart';
import 'dart:async';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Reward/reward.dart';

class StepCalculator extends StatefulWidget {
  @override
  _StepCalculatorState createState() => _StepCalculatorState();
}

class _StepCalculatorState extends State<StepCalculator> {
  late Pedometer _pedometer;
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  late StreamSubscription<StepCount> _pedoStreamSubscription;

  String _status = '?', _steps = '?';
  double _burnedCalories = 0;
  int _savedStepCount = 0, _stepCount = 0;

  @override
  void initState() {
    super.initState();
    checkPermisions();
    //initPlatformState();
  }

  void checkPermisions() async {
    var permActivityRec = await Permission.activityRecognition.status;

    if (permActivityRec.isRestricted) {
      print('permission denied permamently :(');
    } else if (permActivityRec.isPermanentlyDenied) {
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permission's status now is to let the
      // user manually enable it in the system settings.
      openAppSettings();
    } else if (permActivityRec.isProvisional || permActivityRec.isDenied) {
      await Permission.activityRecognition.request();
      checkPermisions();
      return;
    } else if (permActivityRec.isGranted) {
      //restart counting
      initPedo();
      return;
    }
  }

  void onStepCount(StepCount event) {
    print(event);
    setState(() {
      _stepCount = event.steps.toInt() - _savedStepCount;
        mycoins += 0.2;
        dailyProgress++;
      if (_stepCount < 0) {
        // Upon device reboot, pedometer resets. When this happens, the saved counter must be reset as well.
        _savedStepCount = 0;
        storeStepCounter();
        _stepCount = event.steps.toInt() - _savedStepCount;
        //TODO: save this in some storage
      }
      _steps = _stepCount.toString();
      //TODO: get something more accurate than this 0.045 :S
      _burnedCalories = 0.045 * _stepCount;
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event);
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    print(_status);
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = 'Step Count not available';
    });
  }

  void initPedo() async {
    _savedStepCount = await getStoredStepCounter();

    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _pedoStreamSubscription =
        _stepCountStream.listen(onStepCount, onError: onStepCountError);

    if (!mounted) return;
  }

  void refreshCount() {
    _savedStepCount += _stepCount;
    storeStepCounter();

    _stepCount = 0;
    setState(() {
      _steps = '0';
      _burnedCalories = 0;
    });
  }

  void storeStepCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('steps', _savedStepCount);
  }

  Future<int> getStoredStepCounter() async {
    int? steps = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    steps = (await prefs.get('steps')) as int?;
    if (steps == null) return 0;
    return steps;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Step Calculator'),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  refreshCount();
                },
                child: Icon(
                  Icons.refresh,
                  size: 26.0,
                ),
              )),
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.more_vert,
                  color: Colors.lightBlue,
                ),
              )),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 200,
                width: 340,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient:
                        LinearGradient(colors: [Colors.blue, Colors.white])),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Steps taken:',
                      style: TextStyle(fontSize: 30),
                    ),
                    Text(
                      _steps,
                      style: TextStyle(fontSize: 40),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 50,
                thickness: 0,
                color: Colors.white,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    LinearProgressIndicator(
                      borderRadius: BorderRadius.circular(24),
                      value: (_burnedCalories/3000 * 100),
                      minHeight: 100,
                      valueColor: AlwaysStoppedAnimation(Colors.red),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Calories burned:',
                          style: TextStyle(fontSize: 30),
                        ),
                        Text(
                          '~ ' + _burnedCalories.round().toString(),
                          style: TextStyle(fontSize: 40),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(
                height: 100,
                thickness: 0,
                color: Colors.white,
              ),
              Text(
                'Pedestrian status:',
                style: TextStyle(fontSize: 30),
              ),
              Icon(
                _status == 'walking'
                    ? Icons.directions_walk
                    : _status == 'stopped'
                        ? Icons.accessibility_new
                        : Icons.error,
                size: 100,
              ),
              Center(
                child: Text(
                  _status,
                  style: _status == 'walking' || _status == 'stopped'
                      ? TextStyle(fontSize: 30)
                      : TextStyle(fontSize: 20, color: Colors.red),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
