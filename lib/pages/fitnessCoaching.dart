import 'package:flutter/material.dart';

class FitnessCoach extends StatelessWidget {
  const FitnessCoach({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fitness Coaches"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [

            ],
          ),
        ),
      )
    );
  }
}
