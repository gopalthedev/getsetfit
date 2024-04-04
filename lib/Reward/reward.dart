import 'package:flutter/material.dart';
double mycoins = 0.0;

class Reward extends StatefulWidget {
  const Reward({super.key});

  @override
  State<Reward> createState() => _RewardState();
}

class _RewardState extends State<Reward> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("My Wallet")),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.centerRight,
                children: [
                  Container(
                    height: 200,
                    width: 340,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.red.shade200,
                      borderRadius: BorderRadius.circular(24)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Center(child: Text("My Coins: ", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.blue),)),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 200,
                    width: 100,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        color: Colors.yellow.shade200,
                        borderRadius: BorderRadius.circular(24)
                    ),
                    child: Center(child: Text("$mycoins", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 30),)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
