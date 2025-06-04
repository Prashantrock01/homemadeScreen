import 'package:biz_infra/CustomWidgets/configurable_widgets.dart';
import 'package:biz_infra/Network/dio_service_client.dart';
// import 'package:biz_infra/Screens/owner_tenant_registration/login.dart';
import 'package:biz_infra/company_code.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class EmployeeEditEmailScreen extends StatefulWidget {
  final String email;

  const EmployeeEditEmailScreen({required this.email, super.key});

  @override
  EmployeeEditEmailScreenState createState() => EmployeeEditEmailScreenState();
}

class EmployeeEditEmailScreenState extends State<EmployeeEditEmailScreen> {
  final TextEditingController _emailController = TextEditingController();


  @override
  void initState() {
    _emailController.text = widget.email.toString();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset('assets/images/update_email.png'),
                    const SizedBox(height: 30,),
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
                        print("AAAAAAAAAAAAAAAAAAAAAAAAAAA");
                        var updatedEmailId = await dioServiceClient.employeeEmailEdit(updatedEmail: _emailController.text);
                        if (updatedEmailId?.statuscode == 1) {
                          snackBarMessenger("${updatedEmailId!.statusMessage}\n Please login using updated email address");
                          // Get.to(() => EmployeeProfileScreen());
                          Get.offAll(()=>const CompanyCode());
                        }
                        else{
                          if(updatedEmailId?.statuscode == 0){
                            if(updatedEmailId!.statusMessage!.contains('Email already exists for another Service Engineer.')){
                              snackBarMessenger("Email already exists");
                            }
                          }
                        }
                        },

                      widget: const Text('Update')),
                ),

                const SizedBox(width: 20),
                Expanded(
                  child: textButton(
                      onPressed: () async{
                        Get.back();
                      }
                      , widget: const Text('Cancel')
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
