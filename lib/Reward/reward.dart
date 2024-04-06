import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Explore/explore.dart';

class Reward extends StatefulWidget {
  const Reward({super.key});

  @override
  State<Reward> createState() => _RewardState();
}

class _RewardState extends State<Reward> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance.collection('User').doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
      myCoins = value['coins'];
    });
  }


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
                    child: Center(child: Text("$myCoins", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 30),)),
                  ),
                ],
              ),
              const SizedBox(height: 100,),
              OutlinedButton(onPressed:(){
                FirebaseAuth.instance.signOut();
              } , child: Text("Sign Out"))
            ],
          ),
        ),
      ),
    );
  }
}
