import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:firebase_core/firebase_core.dart';

class AddDetails extends StatelessWidget {
  const AddDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return UserInfoForm();
  }
}

class UserInfoForm extends StatefulWidget {
  @override
  _UserInfoFormState createState() => _UserInfoFormState();
}

class _UserInfoFormState extends State<UserInfoForm> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  final users = FirebaseFirestore.instance.collection('User');
  final key = encrypt.Key.fromLength(32);
  final iv = encrypt.IV.fromLength(16);

  String _encryptData(String data) {
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(data, iv: iv);
    return encrypted.base64;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final encryptedAge = _encryptData(_ageController.text);
      final encryptedHeight = _encryptData(_heightController.text);
      final encryptedWeight = _encryptData(_weightController.text);

      users.doc(FirebaseAuth.instance.currentUser!.uid).set({
        'age': encryptedAge,
        'height': encryptedHeight,
        'weight': encryptedWeight,
        'timestamp': Timestamp.now(),
      }).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User info saved')),
        );
        _ageController.clear();
        _heightController.clear();
        _weightController.clear();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving user info')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Information'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Age",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: Colors.white12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Height (in cm)",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: Colors.white12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your height';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Weight (Kg)",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: Colors.white12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your weight';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
