import 'package:flutter/material.dart';

class AdminLogin extends StatefulWidget {
  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool isUsingMobile = true; // Toggle between mobile number and email

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         title: const Text('Admin Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              isUsingMobile
                  ? 'Please enter your mobile number to proceed further'
                  : 'Please enter your email address to proceed further',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            isUsingMobile
                ? TextField(
              controller: _mobileController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixText: '+91 ', // Adds +91 as prefix inside the TextField
                hintText: 'Enter Mobile Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            )
                : TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Enter Email Address',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 5),
            TextButton(
              onPressed: () {
                setState(() {
                  // Toggle between mobile and email
                  isUsingMobile = !isUsingMobile;
                });
              },
              child: Text(isUsingMobile ? 'Use Email' : 'Use Mobile'),
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Implement submit functionality based on whether mobile or email is used
                  if (isUsingMobile) {
                    if (_mobileController.text.isNotEmpty) {
                      // Proceed with the entered mobile number
                      print('Mobile: ${_mobileController.text}');
                    } else {
                      // Show error or validation for mobile number
                      print('Please enter a valid mobile number');
                    }
                  } else {
                    if (_emailController.text.isNotEmpty &&
                        _emailController.text.contains('@')) {
                      // Proceed with the entered email
                      print('Email: ${_emailController.text}');
                    } else {
                      // Show error or validation for email
                      print('Please enter a valid email address');
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                  backgroundColor: Colors.green, // Disabled style color
                ),
                child: const Text('Submit'),
              ),
            ),
            const Spacer(),
            const Text(
              'Does not sell or trade your data',
                style: TextStyle(color: Colors.grey)
            ),

            const Text(
                  'ISO 27001 certified for information security',
                style: TextStyle(color: Colors.grey)
            ),
            const Text(
                  'Encrypts and secures your data',
                style: TextStyle(color: Colors.grey)
            ),
            const Text(
                  'Certified GDPR ready',
              style: TextStyle(color: Colors.grey)
             // textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Center(
              child: GestureDetector(
                onTap: () {
                  // Handle Privacy Policy link click
                },
                child: const Text(
                  'Privacy Policy',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Center(
              child: GestureDetector(
                onTap: () {
                  // Handle Terms & Conditions link click
                },
                child: const Text(
                  'Terms & Conditions',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
