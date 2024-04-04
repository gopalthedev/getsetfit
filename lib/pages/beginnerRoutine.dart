import 'package:flutter/material.dart';
import 'package:getsetfit/models/workoutInfo.dart';
import 'package:getsetfit/workouts/workoutlist.dart';

class BeginnerRoutine extends StatelessWidget {
  const BeginnerRoutine({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Beginner hit routine"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
              ...workoutList.map((e) => WorkOutInfo(map: e,))
          ],
        ),
      ),
    );
  }
}
