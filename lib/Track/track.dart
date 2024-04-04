import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getsetfit/Track/Nutrition/nutrition.dart';
import 'package:getsetfit/models/trackingModel.dart';

class Track extends StatefulWidget {
  const Track({super.key});

  @override
  State<Track> createState() => _TrackState();
}

class _TrackState extends State<Track> {
  final nutritionImage = const AssetImage("asset/nutritionImage.jpg");
  final lowerBodyImage = const AssetImage("asset/lowerBodyImage.jpg");
  final upperBodyImage = const AssetImage("asset/upperBodyImage.jpg");
  final spiritualImage = const AssetImage("asset/spiritualImage.jpg");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Center(
          child: const Text(
            "Track you fitness",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Nutrition()));
              },
                child: TrackingModel(
                    trackImage: nutritionImage, trackName: "Nutrition")),
            TrackingModel(trackImage: upperBodyImage, trackName: "Upper Body"),
            TrackingModel(trackImage: lowerBodyImage, trackName: "Lower Body"),
            TrackingModel(trackImage: spiritualImage, trackName: "Spiritual"),
          ],
        ),
      ),
    );
  }
}
