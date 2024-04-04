import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:getsetfit/Authentication/loginPage.dart';
import 'package:getsetfit/Main/mainPage.dart';

class Authentication extends StatelessWidget {
  Authentication({super.key});

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:StreamBuilder<User?>(stream: auth.authStateChanges(), builder: (context, snapshot) {
        if(snapshot.hasData){
         return  const MainPage();
        }
        return const LoginPage();
      },)
    );
  }
}
