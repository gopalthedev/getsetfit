import 'dart:ui';

import 'package:flutter/material.dart';

class SystemValues {
  static final Color systemColor = Colors.white;

  static showSnack(String text, BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text, style: const TextStyle(color: Colors.black, fontSize: 18),),
        backgroundColor: Colors.blue.shade100,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(10),
        behavior: SnackBarBehavior.floating,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      ),
    );
  }
}
