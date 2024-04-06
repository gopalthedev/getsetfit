import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async'; // Import Dart async library for Timer
import 'dart:math' as math;

import '../Explore/explore.dart'; // For calculating calorie burn estimation



class RopeCounter extends StatefulWidget {
  @override
  _RopeCounterState createState() => _RopeCounterState();
}

class _RopeCounterState extends State<RopeCounter> {
  int _jumpCount = 0;
  double _duration = 0.0; // Duration in seconds
  double _caloriesBurned = 0.0; // Estimated calories burned

  StreamSubscription<UserAccelerometerEvent>? _streamSubscription;
  bool _isWorkoutActive = false;

  double _lastJumpTime = 0.0; // Track last jump time

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription?.cancel(); // Cancel sensor subscription on dispose
  }

  void _startWorkout() {
    _jumpCount = 0;
    _duration = 0.0;
    _caloriesBurned = 0.0;
    _isWorkoutActive = true;

    _streamSubscription?.cancel(); // Cancel previous subscription if any
    _streamSubscription = userAccelerometerEvents.listen((event) {
      _detectJumps(event.z); // Process z-axis acceleration for jump detection
    });

    _startTimer();
  }

  void _stopWorkout() {
    _isWorkoutActive = false;
    _streamSubscription?.cancel(); // Cancel sensor subscription
  }

  void _detectJumps(double z) {
    // Implement jump detection logic here
    // (Example: using a threshold and state machine)

    // *Example Logic (adjust thresholds as needed):*
    const double jumpThreshold = 6.0; // Minimum z-axis acceleration for a jump
    const double minTimeBetweenJumps = 0.5; // Minimum time between valid jumps (in seconds)

    double currentTime = DateTime.now().millisecondsSinceEpoch / 1000.0; // Current time in seconds

    if (_isWorkoutActive &&
        z > jumpThreshold &&
        currentTime - _lastJumpTime > minTimeBetweenJumps) {
      setState(() {
        _jumpCount++;
        dailyProgress++;
        FirebaseFirestore.instance.collection('User').doc(FirebaseAuth.instance.currentUser!.uid).set({
          'coins' : myCoins + dailyProgress
        });
        _lastJumpTime = currentTime; // Update last jump time
      });
    }
  }

  void _startTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isWorkoutActive) {
        setState(() {
          _duration += 1.0; // Update duration every second
          _calculateCaloriesBurned(); // Recalculate calories as duration changes
        });
      } else {
        timer.cancel(); // Stop the timer when workout is stopped
      }
    });
  }

  void _calculateCaloriesBurned() {
    // Example calorie estimation formula (adjust based on research and user data)
    const double MET = 8.0; // Metabolic Equivalent of jump rope (MET value)
    final double weight = 70.0; // Replace with user's weight (in kg)
    _caloriesBurned = (_duration * MET * weight) / (3600 * 1000); // Joules converted to kcal
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Jump Rope Tracker'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Jumps: $_jumpCount',
                style: const TextStyle(fontSize: 32.0),
              ),
              const SizedBox(height: 20.0),
              Text(
                'Duration: ${Duration(seconds: _duration.toInt()).inMinutes.toString().padLeft(2, '0')}:${Duration(seconds: _duration.toInt()).inSeconds.remainder(60).toString().padLeft(2, '0')} minutes',
                style: const TextStyle(fontSize: 24.0),
              ),
              const SizedBox(height: 20.0),
              Text(
                'Estimated Calories Burned: ${_caloriesBurned.toStringAsFixed(2)} kcal',
                style: const TextStyle(fontSize: 20.0),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _isWorkoutActive ? _stopWorkout : _startWorkout,
                child: Text(_isWorkoutActive ? 'Stop Workout' : 'Start Workout'),
              ),
            ],
          ),
        ),
      );
  }
}