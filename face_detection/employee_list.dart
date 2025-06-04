import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'face_login.dart';

class EmployeeList extends StatefulWidget {
  const EmployeeList({super.key});

  @override
  EmployeeListState createState() => EmployeeListState();
}

class EmployeeListState extends State<EmployeeList> {
  final List<Map<String, String>> employees = [
    {'name': 'Prashant Ranjan Singh', 'employeeId': 'E001', 'aadhaarNumber': '1234 5678 9012', 'mobileNumber': '9876543210', 'profilePic': 'https://via.placeholder.com/200'},
    {'name': 'Shubham Singh', 'employeeId': 'E002', 'aadhaarNumber': '2345 6789 0123', 'mobileNumber': '8765432109', 'profilePic': 'https://via.placeholder.com/150'},
    {'name': 'Neha S', 'employeeId': 'E003', 'aadhaarNumber': '3456 7890 1234', 'mobileNumber': '7654321098', 'profilePic': 'https://via.placeholder.com/150'},
    {'name': 'Sekhar Suman', 'employeeId': 'E004', 'aadhaarNumber': '4567 8901 2345', 'mobileNumber': '6238282345', 'profilePic': 'https://via.placeholder.com/150'},
    {'name': 'Swarnima M', 'employeeId': 'E005', 'aadhaarNumber': '5678 9012 3456', 'mobileNumber': '6238283456', 'profilePic': 'https://via.placeholder.com/150'},
    {'name': 'Shudhanshu S', 'employeeId': 'E006', 'aadhaarNumber': '6789 0123 4567', 'mobileNumber': '6238284567', 'profilePic': 'https://via.placeholder.com/150'},
    {'name': 'Maya S', 'employeeId': 'E006', 'aadhaarNumber': '7890 1234 5678', 'mobileNumber': '9008284567', 'profilePic': 'https://via.placeholder.com/150'}
  ];

  final ImagePicker picker = ImagePicker();

  Future<void> showImagePickerOptions(BuildContext context, int index) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    setState(() {
                      employees[index]['profilePic'] = image.path;
                    });
                  }
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () async {
                  final XFile? image = await picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    setState(() {
                      employees[index]['profilePic'] = image.path;
                    });
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee List', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
        // backgroundColor: Colors.grey,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: employees.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
            child: Card(
              // elevation: 7,
              // color: Colors.white,
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: GestureDetector(
                      onTap: () {
                        showImagePickerOptions(context, index);
                      },
                      child: CircleAvatar(
                        backgroundImage: employees[index]['profilePic']!.contains('http') ? NetworkImage(employees[index]['profilePic']!) : FileImage(File(employees[index]['profilePic']!)) as ImageProvider,
                      ),
                    ),
                    title: Text(
                      employees[index]['name']!,
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Employee ID: ${employees[index]['employeeId']}',
                          style: const TextStyle(fontWeight: FontWeight.w400),
                        ),
                        Text(
                          'Aadhaar Number: ${employees[index]['aadhaarNumber']}',
                          style: const TextStyle(fontWeight: FontWeight.w400),
                        ),
                        Text(
                          'Mobile Number: ${employees[index]['mobileNumber']}',
                          style: const TextStyle(fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FaceLoginScreen()),
                      );
                    },
                  ),
                  // const Divider(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
