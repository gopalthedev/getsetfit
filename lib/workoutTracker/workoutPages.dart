import 'package:flutter/material.dart';
import 'package:getsetfit/pages/beginnerRoutine.dart';
import 'package:getsetfit/pages/ropeCounter.dart';
import 'package:getsetfit/workoutTracker/acceleromete.dart';

import '../pages/cycling.dart';
import '../pages/fitnessCoaching.dart';
import '../pages/running.dart';

List<Widget> sweetSessions = [
  FitnessCoach(),
];

List<Widget> exploreWorkouts = [
  BeginnerRoutine(),
  RopeCounter(),
  Cycling(),
  Running(),
];