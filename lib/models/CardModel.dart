import 'package:flutter/material.dart';
import 'package:getsetfit/pages/beginnerRoutine.dart';

class CardModel extends StatefulWidget {
  const CardModel({super.key, required this.goto, required this.title, required this.category, required this.image});

  final Widget goto;
  final String title;
  final String category;
  final AssetImage image;

  @override
  State<CardModel> createState() => _CardModelState();
}

class _CardModelState extends State<CardModel> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => widget.goto));
      },
      child: SizedBox(
        height: 200,
        width: 340,
        child: Card(
          elevation: 2,
          borderOnForeground: true,
          clipBehavior: Clip.hardEdge,
          child: Stack(
            children: [
              Image(
                image: widget.image,
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
                            onPressed: () {},
                            style: ButtonStyle(
                              fixedSize: MaterialStateProperty.all(Size(100 , 10)),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white)),
                            child: const Text("Upgrade", style: TextStyle(color: Colors.black),)),
                        OutlinedButton(
                            onPressed: () {},
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
                    child:  ListTile(
                      dense: false,
                      title: Text(widget.title),
                      subtitle: Text(widget.category),
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
