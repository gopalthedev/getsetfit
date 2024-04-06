import 'package:flutter/material.dart';
import 'package:getsetfit/workoutTracker/pushUpTracker.dart';

class SweatSession extends StatefulWidget {
  const SweatSession({super.key, required this.goto});
  final Widget goto;
  @override
  State<SweatSession> createState() => _SweatSessionState();
}

class _SweatSessionState extends State<SweatSession> {
  AssetImage cardImage = new AssetImage("asset/streching.jpg");

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => widget.goto));
      },
      child: SizedBox(
        height: 200,
        width: 180,
        child: Card(
          elevation: 2,
          borderOnForeground: true,
          clipBehavior: Clip.hardEdge,
          child: Stack(
            children: [
              Image(
                image: cardImage,
                fit: BoxFit.cover,
                height: double.maxFinite,
                width: double.maxFinite,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => widget.goto));
                            },
                            style: ButtonStyle(
                                fixedSize: MaterialStateProperty.all(Size(100 , 10)),
                                backgroundColor:
                                MaterialStateProperty.all(Colors.white)),
                            child: const Row(
                              children: [
                                Icon(Icons.star_border_outlined, size: 15, color: Colors.black,),
                                Text("Rate", style: TextStyle(color: Colors.black)),
                              ],
                            )),
                      ],
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(24),
                            topLeft: Radius.circular(24))),
                    child: const ListTile(
                      dense: false,
                      title: Text("Core"),
                      subtitle: Text("Fitness coach"),
                    ),
                  )
                ],
              ),


            ],
          ),
        ),
      ),
    );
  }
}
