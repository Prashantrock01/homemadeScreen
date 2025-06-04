import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class FaceLoginScreen extends StatefulWidget {
  @override
  FaceLoginScreenState createState() => FaceLoginScreenState();
}

class FaceLoginScreenState extends State<FaceLoginScreen> {
  XFile? image;
  final ImagePicker picker = ImagePicker();
  String? signInTime;
  String? breakOutTime;
  String? breakInTime;
  String? signOutTime;
  bool isSignedIn = false;
  bool isOnBreak = false;

  Future<void> pickImage() async {
    XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        image = image;
      });
    }
  }

  Future<bool> detectFace(XFile image) async {
    // Replace this with actual face detection logic using your preferred method
    // bool faceDetected = await yourFaceDetectionAPI.detectFace(image.path);
    // For demonstration, we'll assume it returns a simulated result
    bool faceDetected = true; // Simulate a positive detection (or false for no detection)
    return faceDetected;
  }

  Future<void> signIn() async {
    if (isSignedIn) {
      showMessage('You must sign out first before signing in again.');
      return;
    }
    await pickImage();
    if (image != null) {
      bool faceDetected = await detectFace(image!);
      if (faceDetected) {
        setState(() {
          signInTime = DateFormat('yyyy-MM-dd – kk:mm:ss').format(DateTime.now());
          breakOutTime = null;
          breakInTime = null;
          signOutTime = null;
          isSignedIn = true;
          isOnBreak = false;
        });
        showMessage('You have successfully signed in.');
      } else {
        showMessage('No face detected. Please try again.');
      }
    }
  }

  Future<void> _breakOut() async {
    if (!isSignedIn) {
      showMessage('You must sign in first.');
      return;
    }
    await pickImage();
    if (image != null) {
      bool faceDetected = await detectFace(image!);
      if (faceDetected) {
        setState(() {
          breakOutTime = DateFormat('yyyy-MM-dd – kk:mm:ss').format(DateTime.now());
          isOnBreak = true;
        });
        showMessage('You have successfully taken a break.');
      } else {
        showMessage('No face detected. Please try again.');
      }
    }
  }

  Future<void> _breakIn() async {
    if (!isSignedIn || !isOnBreak) {
      showMessage('You must be signed in and on a break to break in.');
      return;
    }
    await pickImage();
    if (image != null) {
      bool faceDetected = await detectFace(image!);
      if (faceDetected) {
        setState(() {
          breakInTime = DateFormat('yyyy-MM-dd – kk:mm:ss').format(DateTime.now());
          isOnBreak = false;
        });
        showMessage('You have successfully returned from break.');
      } else {
        showMessage('No face detected. Please try again.');
      }
    }
  }

  Future<void> _signOut() async {
    if (!isSignedIn) {
      showMessage('You must sign in first.');
      return;
    }
    await pickImage();
    if (image != null) {
      bool faceDetected = await detectFace(image!);
      if (faceDetected) {
        setState(() {
          signOutTime = DateFormat('yyyy-MM-dd – kk:mm:ss').format(DateTime.now());
          isSignedIn = false;
          isOnBreak = false;
        });
        showMessage('You have successfully signed out.');
      } else {
        showMessage('No face detected. Please try again.');
      }
    }
  }

  void showMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message, style: const TextStyle(color: Colors.red)),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Face Attendance System', style: TextStyle(/*color: Colors.blue*/)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              image == null
                  ? const Text('No image selected.', style: TextStyle(color: Colors.red))
                  : Column(
                      children: [
                        Image.file(File(image!.path), height: 200),
                        const SizedBox(height: 15),
                        signInTime != null ? Text('Sign In Time: $signInTime', style: const TextStyle(color: Colors.black)) : Container(),
                        const SizedBox(height: 15),
                        breakOutTime != null ? Text('Break Out Time: $breakOutTime', style: const TextStyle(color: Colors.black)) : Container(),
                        const SizedBox(height: 15),
                        breakInTime != null ? Text('Break In Time: $breakInTime', style: const TextStyle(color: Colors.black)) : Container(),
                        const SizedBox(height: 15),
                        signOutTime != null ? Text('Sign Out Time: $signOutTime', style: const TextStyle(color: Colors.black)) : Container(),
                        const SizedBox(height: 20),
                      ],
                    ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          onPressed: signIn,
                          child: const Text('Sign In', style: TextStyle(color: Colors.green)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          onPressed: _signOut,
                          child: const Text('Sign Out', style: TextStyle(color: Colors.blue)),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          onPressed: _breakOut,
                          child: const Text('Break Out', style: TextStyle(color: Colors.amber)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          onPressed: _breakIn,
                          child: const Text('Break In', style: TextStyle(color: Colors.amber)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
