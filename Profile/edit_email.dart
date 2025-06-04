import 'package:biz_infra/Network/dio_service_client.dart';
// import 'package:biz_infra/Screens/Profile/profile.dart';
import 'package:biz_infra/company_code.dart';
// import 'package:biz_infra/Screens/owner_tenant_registration/authentication_screen.dart';
// import 'package:biz_infra/company_code.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../CustomWidgets/configurable_widgets.dart';
// import '../bottom_navigation.dart';
// import '../owner_tenant_registration/login.dart';

class EditEmailScreen extends StatefulWidget {
  final String email;

  const EditEmailScreen({required this.email, super.key});

  @override
  EditEmailScreenState createState() => EditEmailScreenState();
}

class EditEmailScreenState extends State<EditEmailScreen> {
  final TextEditingController _emailController = TextEditingController();


  @override
  void initState() {

    _emailController.text = widget.email.toString();

    // print("editEmail Screen");
    // print(widget.email);
    // print( _emailController.text);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset('assets/images/update_email.png'),
                    const SizedBox(height: 30),
                    textField(
                      controller: _emailController,
                      textInputAction: TextInputAction.next,
                      inputType: TextInputType.emailAddress,
                      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                      labelText: 'Update Email *',
                      prefixIcon: const Icon(Icons.email),
                      validator: (value) {
                        if (_emailController.text.isEmpty) {
                          return 'Please enter valid email';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: textButton(
                    onPressed: () async {
                      var updatedEmailId = await dioServiceClient.emailEdit(
                          updatedEmail: _emailController.text);
                      if (updatedEmailId?.statuscode == 1) {
                        snackBarMessenger("${updatedEmailId!.statusMessage}\n Please login using updated email address");
                        // Get.back();
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (BuildContext context) => const ProfileScreen(),
                        //   ),
                        // );
                        Get.offAll(()=> const CompanyCode());
                      }else{
                        if(updatedEmailId?.statuscode == 0){
                          if(updatedEmailId!.statusMessage!.contains('Email already exists for another owner or tenant')){
                            snackBarMessenger("Email already exists");
                          }
                        }
                      }
                    },
                    widget: const Text('Update'),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: textButton(
                    onPressed: () async {
                      Get.back();
                    },
                    widget: const Text('Cancel'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );


  }
}
