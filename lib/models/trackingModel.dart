import 'package:flutter/material.dart';

class TrackingModel extends StatefulWidget {
  const TrackingModel({super.key, required this.trackImage, required this.trackName});
  final AssetImage trackImage;
  final String trackName;
  @override
  State<TrackingModel> createState() => _TrackingModelState();
}

class _TrackingModelState extends State<TrackingModel> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),),
        height: 180,
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            Image(
              image: widget.trackImage,
              // height: 200,
                fit: BoxFit.cover
            ),
            Container(
              height: 180,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                      colors: [Colors.black, Colors.transparent])),
              child: Center(
                child: Text(
                  widget.trackName,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
