import 'package:biz_infra/CustomWidgets/configurable_widgets.dart';
import 'package:biz_infra/company_code.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Network/dio_service_client.dart';
// import 'login.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ChangePasswordScreenState createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  RxBool createHidePassword = true.obs;
  RxBool confirmHidePassword = true.obs;

  void toggleCreatePasswordView() {
    createHidePassword.value = !createHidePassword.value;
  }
  void toggleConfirmPasswordView() {
    confirmHidePassword.value = !confirmHidePassword.value;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _newPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                     Image.asset('assets/images/change_password.png'),

                      Obx(()=>
                         textField(
                          controller: _newPasswordController,
                          obscureText: createHidePassword.value,
                          maxLines: 1,
                          labelText: 'Create New Password',
                          validator: _validatePassword,
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: InkWell(
                            onTap: toggleCreatePasswordView,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: Icon(
                                createHidePassword.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                //color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      Obx(()=> textField(
                          controller: _confirmPasswordController,
                          obscureText: confirmHidePassword.value,
                          maxLines: 1,
                          labelText: 'Confirm New Password',
                          validator: _validateConfirmPassword,
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: InkWell(
                            onTap: toggleConfirmPasswordView,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: Icon(
                                confirmHidePassword.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                //color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),




                    ],
                  ),
                ),
              ),

              textButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    dioServiceClient.changePassword(newPassword: _newPasswordController.text,
                      confirmPassword:_confirmPasswordController.text,);
                    Get.offAll(() => const CompanyCode());
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Password changed successfully')),
                    );
                  }
                },
                widget: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
