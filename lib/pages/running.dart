import 'package:flutter/material.dart';

class Running extends StatelessWidget {
  const Running({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Running"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(),
        ),
      ),
    );
  }
}
