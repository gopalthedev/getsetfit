import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getsetfit/Earn/earn.dart';
import 'package:getsetfit/Explore/explore.dart';
import 'package:getsetfit/Reward/reward.dart';
import 'package:getsetfit/Track/track.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  static List<Widget> screens = [
    const Explore(),
    const Earn(),
    const Track(),
    const Reward()
  ];

  int _selectedIndex = 0;

  void setScreen(int i){
    setState(() {
      _selectedIndex = i;
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.black,),
              label: "Explore"

            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add, color: Colors.black,),
              label: "Earn"

            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.stacked_line_chart, color: Colors.black,),
              label: "Track",

            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.attach_money, color: Colors.black,),
              label: "Reward"
            ),
          ],
          elevation: 2,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedItemColor: Colors.blue,
          currentIndex: _selectedIndex,
          onTap: (value) {
            setScreen(value);
          },
        ),
    );
  }
}
