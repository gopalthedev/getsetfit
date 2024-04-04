import 'dart:async';
import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:getsetfit/Main/mainPage.dart';
import 'package:getsetfit/systemvalues.dart';
import 'package:image_picker/image_picker.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  AssetImage placeholderImage = AssetImage("asset/getsetfit.jpg");
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _numberController = TextEditingController();
  final _nameController = TextEditingController();


  late Timer timer;

  File? _image;
  String? profileImage;
  final picker = ImagePicker();
  final currentUserId = FirebaseAuth.instance.currentUser?.uid.toString();


  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
    await setProfileImage();
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
    await showOption();
    String? url;
    try {
      Reference imageFolder = await FirebaseStorage.instance
          .ref("images/profileImages")
          .child(currentUserId!);

      await imageFolder.putFile(_image!);
      await imageFolder.getDownloadURL().then((value) => url = value);

      await FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUserId)
          .update({"profileImage": url}).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(SystemValues.showSnack("Profile image has been set successfully", context));
      });
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future showOption() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
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

  Future signIn() async {
    if (!_emailController.text.isEmpty ||
        !_nameController.text.isEmpty ||
        !_numberController.text.isEmpty ||
        !_passwordController.text.isEmpty) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        await FirebaseAuth.instance.currentUser?.sendEmailVerification();

        SystemValues.showSnack(
            "We have sent verification email for on your registered email",
            context);

        timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
          await FirebaseAuth.instance.currentUser?.reload();
          final user = FirebaseAuth.instance.currentUser;
          if(user!.emailVerified){
            timer.cancel();
            addUser();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage()));
          }
        });
      } on FirebaseAuthException catch (e) {
        SystemValues.showSnack("${e.code}", context);
        if (kDebugMode) {
          print("Error is $e");
        }
      }
    } else {
      SystemValues.showSnack("Enter all the fields", context);
    }
  }

  Future addUser() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance.collection("User").doc(uid).set({
      "name": _nameController.text.trim(),
      "number": _numberController.text.trim(),
      "image" : profileImage
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SystemValues.systemColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100,),
            GestureDetector(
              onTap: setProfileImage,
              child: CircleAvatar(
                radius: 50,
                child: Image(
                  image: profileImage == null ? placeholderImage : NetworkImage(profileImage!) as ImageProvider,
                ),
              ),
            ),
            const Center(
              child: Text(
                "Sign Up",
                style: TextStyle(fontSize: 24),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10, right: 10, top: 10, bottom: 10),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: "Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: Colors.white12),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: TextField(
                controller: _numberController,
                decoration: InputDecoration(
                  hintText: "Number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: Colors.white12),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: Colors.white12),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: Colors.white12),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: SizedBox(
                height: 50,
                width: double.maxFinite,
                child: OutlinedButton(
                    onPressed: signIn,
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
