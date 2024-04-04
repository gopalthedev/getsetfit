import 'package:flutter/material.dart';

class WorkOutInfo extends StatefulWidget {
  const WorkOutInfo({super.key, required this.map});
  final Map<String, dynamic> map;
  @override
  State<WorkOutInfo> createState() => _WorkOutInfoState();
}

class _WorkOutInfoState extends State<WorkOutInfo> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        clipBehavior: Clip.antiAlias,
        height: 180,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),),
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            Image(
              image: widget.map['workoutImage'],
              // height: 200,
              fit: BoxFit.cover
            ),
            Container(
              height: 180,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                      colors: [Colors.black, Colors.transparent])),
              child: ListTile(
                title: Text(
                  widget.map['workoutName'],
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white),
                ),
                subtitle: Text(
                  widget.map['description'],style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
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
