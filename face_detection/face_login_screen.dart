import 'dart:io';

import 'package:flutter/material.dart';

import 'face_login.dart';


class Employee {
  String name;
  String employeeId;
  String aadhaarNumber;
  String mobileNumber;
  File? profilePicture;

  Employee({
    required this.name,
    required this.employeeId,
    required this.aadhaarNumber,
    required this.mobileNumber,
    this.profilePicture,
  });
}

class FaceLoginScreen extends StatefulWidget {
  final Employee employee;

  FaceLoginScreen({required this.employee});

  @override
  FaceLoginScreenState createState() => FaceLoginScreenState();
}

class _FaceLoginScreenState extends State<FaceLoginScreen> {
  File? image;
  String? signInTime;
  String? breakOutTime;
  String? breakInTime;
  String? signOutTime;
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Face Login',
          style: TextStyle(color: Colors.black, fontSize: 35, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              image != null ? Image.file(image!) : Container(),
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 22),
                ],
              ),
              const SizedBox(height: 22),
              const SizedBox(height: 22),
              signInTime != null
                  ? Text('Signed In Time: $signInTime',style: const TextStyle(color: Colors.green,
                  fontWeight: FontWeight.bold),)
                  : Container(),
              signOutTime != null
                  ? Text('Signed Out Time: $signOutTime',style: const TextStyle(color: Colors.blue,
                  fontWeight: FontWeight.bold),)
                  : Container(),
              breakOutTime != null
                  ? Text('Break Out Time: $breakOutTime',style: const TextStyle(color: Colors.blue,
                  fontWeight: FontWeight.bold),)
                  : Container(),
              breakInTime != null
                  ? Text('Break In Time: $breakInTime',style: const TextStyle(color: Colors.green,
                  fontWeight: FontWeight.bold),)
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

