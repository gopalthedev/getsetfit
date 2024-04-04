import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:getsetfit/Authentication/signup.dart';
import 'package:getsetfit/systemvalues.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AssetImage logo = const AssetImage("asset/getsetfit.jpg");

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool checkFields() {
    if (_emailController.value.text.isEmpty || _passwordController.value.text.isEmpty) {
      SystemValues.showSnack("Enter all the fields", context);
      return false;
    }
    return true;
  }

  Future login() async {
    if(checkFields()) {
      try {
       final auth =  FirebaseAuth.instance;
        auth.signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim());
      }
      on FirebaseAuthException catch(e) {
        SystemValues.showSnack("${e.message}", context);
        if (kDebugMode) {
          print("Error is $e");
        }
      }
    }
  }

  Future loginWithGoogle() async {
    await FirebaseAuth.instance.signInWithProvider(GoogleAuthProvider());
  }

  Future loginWithFaceBook() async {
    await FirebaseAuth.instance.signInWithProvider(FacebookAuthProvider());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 60, bottom: 5, left: 10, right: 10),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black, width: 0),
                    // gradient: const LinearGradient(colors: [
                    //   Colors.blue,
                    //   Colors.white,
                    // ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
                    color: Colors.blue.shade50 //Color(0xF0F0F0)
                ),
                child: Center(
                  child: Image(
                    image: logo,
                    color: Colors.blue.shade50,
                    colorBlendMode: BlendMode.multiply,
                    height: 300,
                    width: 300,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(left: 10, top: 15, bottom: 15),
              child: Text(
                "Log In",
                style: TextStyle(fontSize: 30),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
              child: SizedBox(
                height: 50,
                child: TextFormField(
                  controller: _emailController,
                    textAlign: TextAlign.justify,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Email",
                        hintStyle: const TextStyle(color: Colors.black,),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide:
                            const BorderSide(color: Colors.purpleAccent)))),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
              child: SizedBox(
                height: 50,
                child: TextField(
                  controller: _passwordController,
                    textAlign: TextAlign.justify,
                    decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: const TextStyle(color: Colors.black,),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide:
                            const BorderSide(color: Colors.purpleAccent)))),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0.5,
                    backgroundColor: Colors.blue.shade400,
                  ),
                  onPressed:login,
                  child: const Text(
                    "Log In",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
              child: Row(
                children: [
                  Container(
                    height: 1,
                    width: 140,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text("OR"),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 1,
                    width: 140,
                    color: Colors.grey,
                  )
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding:
                  const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          height: 50,
                          width: 150,
                          child: OutlinedButton(
                              onPressed: loginWithGoogle,
                              child: const Text("Google", style: TextStyle(
                                  color: Colors.black),))),
                      SizedBox(
                          height: 50,
                          width: 150,
                          child: OutlinedButton(
                              onPressed: loginWithFaceBook,
                              child: const Text("Facebook", style: TextStyle(
                                  color: Colors.black),))),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUp()));
                      },
                      child: const Text("New User? Create account",
                        style: TextStyle(color: Colors.black),),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
