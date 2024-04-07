import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:getsetfit/Authentication/loginPage.dart';
import 'package:getsetfit/models/CardModel.dart';
import 'package:getsetfit/models/SweatSessions.dart';
import 'package:getsetfit/models/activitesData.dart';
import 'package:getsetfit/models/stepCalculator.dart';
import 'package:getsetfit/pages/adduserDetails.dart';
import 'package:getsetfit/pages/pose_detection.dart';
import 'package:getsetfit/workouts/workoutlist.dart';
import 'package:image_picker/image_picker.dart';

import '../models/fitnessCategory.dart';
import '../systemvalues.dart';
import '../workoutTracker/pushUpTracker.dart';
import '../workoutTracker/weightLifting.dart';
import '../workoutTracker/workoutPages.dart';


double dailyProgress = 0;
double dailyGoal = 1;
int stepGoal = 0;
int pushUpGoal = 0;
int squatsGoal = 0;
double myCoins = 0;

MyActivities myData = MyActivities();

class Explore extends StatefulWidget {
  const Explore({super.key});
  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {

  String? userImage;
  String? userName;


  final user = FirebaseAuth.instance.currentUser!;
  File? _image;
  String? profileImage;
  final picker = ImagePicker();
  final currentUserId = FirebaseAuth.instance.currentUser?.uid.toString();

  String greeting(){
    DateTime time = DateTime.now();
    if(time.hour < 12){
      return "Good Morning";
    }
    else if(time.hour > 12 && time.hour < 17){
      return "Good Afternoon";
    }else{
      return "Good Evening";
    }
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future setProfileImage() async {
    showOption();
    String? url;
    try {
      Reference imageFolder = FirebaseStorage.instance
          .ref("images/profileImages")
          .child(currentUserId!);

      await imageFolder.putFile(_image!);
      await imageFolder.getDownloadURL().then((value) => url = value);

      await FirebaseFirestore.instance
          .collection("User")
          .doc(currentUserId)
          .update({"image": url}).then((value) {
        SystemValues.showSnack(
            "Profile image has been set successfully", context);
        getUserDetails();
      });
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future showOption() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) =>
          CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.of(context).pop();
                    getImageFromGallery();
                  },
                  child: const Text("Gallery")),
              CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.of(context).pop();
                    getImageFromCamera();
                  },
                  child: const Text("Camera"))
            ],
          ),
    );
  }

  Future getUserDetails() async {
    await FirebaseFirestore.instance.collection("User").doc(user.uid)
        .get()
        .then((value) {
      if (kDebugMode) {
        print(value.data());
      }
      Map<String, dynamic> map = value.data()!;
      setState(() {
          userName = map['name'];
          if(userName  == null){
            userName = globalUser!.name;
          }
          userImage = map['image'];
      });
    });
  }

  void addDailyGoal(){
    showModalBottomSheet(context: context, builder: (BuildContext context){
      return Padding(padding: EdgeInsets.all(8), child: Column(
        children: [
          ListTile(
            title: Text("Set Step Goal"),
            onTap: (){
              setState(() {
                dailyGoal++;
                stepGoal++;
              });
            },
            subtitle: Row(
              children: [
                Icon(Icons.add),
                Text("Your set goal is $stepGoal")
              ],
            ),
          ),
          ListTile(
            title: Text("Set Push Goal"),
            onTap: (){
              setState(() {
                dailyGoal++;
                pushUpGoal++;
              });
            },
            subtitle: Row(
              children: [
                Icon(Icons.add),
                Text("Your set goal is $pushUpGoal")
              ],
            ),
          ),
          ListTile(
            title: Text("Set Squats Goal"),
            onTap: (){
              setState(() {
                dailyGoal++;
                squatsGoal++;
              });
            },
            subtitle: Row(
              children: [
                Icon(Icons.add),
                Text("Your set goal is $squatsGoal")
              ],
            ),
          ),
          ElevatedButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text("Add"))
        ],
      ),);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: setProfileImage,
                    child: CircleAvatar(
                      backgroundImage: userImage == null ? const AssetImage("asset/yoga.jpg")
                          : NetworkImage(userImage!) as ImageProvider,
                      radius: 25,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        greeting(),
                        style: TextStyle(color: Colors.black, fontSize: 24),
                      ),
                      Text(
                        userName.toString(),
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      )
                    ],
                  ),
                  const Spacer(),
                  IconButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddDetails()));
                  }, icon: Icon(Icons.format_align_left_rounded))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Card(
                color: Colors.white,
                elevation: 2,
                shadowColor: Colors.grey,
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        "Track your progress daily",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      const SizedBox(height: 10,),
                      Text(
                        "Your are ${(100 - ((dailyProgress/dailyGoal)*100).round())}% closer to your daily goal",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      const SizedBox(height: 10,),
                      LinearProgressIndicator(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(24),
                        value: (dailyProgress/dailyGoal)*100,
                        minHeight: 10,
                      ),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          Text("Your daily goal $dailyGoal", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),)
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width - 100,
                      height: 48,
                      child: SearchBar(
                          hintText: "Search Activities",
                          elevation: MaterialStateProperty.all(1),
                          backgroundColor:
                          MaterialStateProperty.all(Colors.white),
                          side: MaterialStateProperty.all(
                              BorderSide(color: Colors.grey)),
                          leading: const Icon(Icons.search_outlined))),
                  GestureDetector(
                    onTap: (){
                      addDailyGoal();
                    },
                    child: const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.menu),
                      radius: 24,
                    ),
                  )
                ],
              ),

              // explore top workouts

              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Explore top workouts",
                        style: TextStyle(fontSize: 18),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.arrow_back_ios_new_outlined,
                                size: 18,
                              )),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.arrow_forward_ios_outlined,
                                size: 18,
                              )),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) => CardModel(goto: exploreWorkouts[index][0], title: exploreWorkouts[index][1], category: exploreWorkouts[index][2], image: exploreWorkouts[index][3],),
                      itemCount: exploreWorkouts.length,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                  // horizontal listview
                ],
              ),
              // quick sweat sessions
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       Text(
                        "Hello ${greeting()} mam",
                        style: TextStyle(fontSize: 18),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.arrow_back_ios_new_outlined,
                                size: 18,
                              )),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.arrow_forward_ios_outlined,
                                size: 18,
                              )),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) => SweatSession(goto: sweetSessions[index][0], image: sweetSessions[index][1],),
                      itemCount: sweetSessions.length,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                  // horizontal listview
                ],
              ),
              const SizedBox(height: 20,),
              // fitness categories

               Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Fitness Categories",
                    style: TextStyle(color: Colors.black, fontSize: 18),),
                  SizedBox(height: 20,),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => WeightLifting()));
                            },
                            child: const FitnessCategory(placeholderImage: AssetImage(
                                "asset/weight-lifting.jpg"),
                              category: 'Weight Lifting',),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ProximitySensorScreen()));
                            },
                            child: const FitnessCategory(placeholderImage: AssetImage(
                                "asset/arm.jpg"), category: 'Arm',),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => PoseDetection()));
                            },
                            child: const FitnessCategory(placeholderImage: AssetImage(
                                "asset/yoga.jpg"), category: 'Yoga',),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => StepCalculator()));
                            },
                            child: const FitnessCategory(placeholderImage: AssetImage(
                                "asset/heart.jpg"), category: 'High',),
                          ),

                        ],
                      )
                    ],
                  )
                ],
              )
            ],
          )
          ,
        )
        ,
      )
      ,
    );
  }
}
