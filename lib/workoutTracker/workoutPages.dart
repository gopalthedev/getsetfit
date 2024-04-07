import 'package:flutter/material.dart';
import 'package:getsetfit/pages/beginnerRoutine.dart';
import 'package:getsetfit/pages/ropeCounter.dart';
import 'package:getsetfit/workoutTracker/acceleromete.dart';

import '../pages/cycling.dart';
import '../pages/fitnessCoaching.dart';
import '../pages/running.dart';

List<List<dynamic>> sweetSessions = [
  [FitnessCoaching(), NetworkImage("https://img.freepik.com/free-photo/young-woman-pink-top-standing-with-coach_1157-32123.jpg?w=996")]
];

List<List<dynamic>>exploreWorkouts = [
  [BeginnerRoutine(), "Begginer's HIIT routine", "category", AssetImage('asset/streching.jpg')],
  [RopeCounter(), "Rope Jumping", "category", AssetImage('asset/ropeJump.jpg')],
  [Cycling(), "Cycling", "category", AssetImage('asset/cycling.jpg')],
  [Running(), "Running", "category", AssetImage('asset/running.jpg')]
];