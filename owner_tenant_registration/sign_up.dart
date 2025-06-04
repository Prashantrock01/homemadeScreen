import 'package:biz_infra/CustomWidgets/configurable_widgets.dart';
import 'package:biz_infra/Screens/owner_tenant_registration/otp_verification_screen.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../CustomWidgets/validations.dart';
import '../../Network/dio_service_client.dart';
import 'login.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';


class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final signUpForm = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  RxBool hidePassword = true.obs;
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;


  void togglePasswordView() {
    hidePassword.value = !hidePassword.value;
  }


  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
          (List<ConnectivityResult> results) {
        _updateConnectionStatus(results);
      },
    );
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  /// Initialize connectivity status
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (_) {
      return;
    }

    if (!mounted) return;
    _updateConnectionStatus(result);
  }

  /// Update the internet connection status
  void _updateConnectionStatus(List<ConnectivityResult> result) {
    setState(() {
      _connectionStatus = result.isNotEmpty ? result : [ConnectivityResult.none];
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body:_connectionStatus.contains(ConnectivityResult.none)?
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 50, color: Colors.grey),
            const SizedBox(height: 20),
            const Text("No Internet Connection", style: TextStyle(fontSize: 20, color: Colors.grey)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: initConnectivity,
              child: const Text("Retry"),
            ),
          ],
        ),
      ):
      Stack(children: [
        Column(
          children: [
            Expanded(
              child: Form(
                key: signUpForm,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/society_register.png', height: MediaQuery.of(context).size.height/2.5,),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child:  Column(
                          children: [
                            textField(
                              controller: phoneController,
                              inputType: TextInputType.phone,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10), // Limit input to 10 digits
                              ],
                              textInputAction: TextInputAction.next,
                              prefixIcon: const CountryCodePicker(initialSelection: '+91',),
                              hintText: 'Mobile Number',
                              validator: (value) {
                                if (value == null || value.length != 10) {
                                  return 'Mobile Number must be 10 digits';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),

                            textField(
                              controller: nameController,
                              textInputAction: TextInputAction.next,
                              hintText: 'Enter name',
                              prefixIcon: const Icon(Icons.person),
                              validator: (value) {
                                if (nameController.text.isEmpty) {
                                  return 'Please enter name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            textField(
                              controller: emailController,
                              textInputAction: TextInputAction.next,
                              inputType: TextInputType.emailAddress,
                              hintText: 'Enter Email',
                              prefixIcon: const Icon(Icons.email),
                              validator: validateEmail,
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: textButton(
                widget: const Text('Continue'),
                onPressed: () async {
                  if (signUpForm.currentState!.validate()) {

                    EasyLoading.show();
                    var ownerRegistrationData = await dioServiceClient.validatingExistingUser(ownerTenantMobile: phoneController.text, ownerTenantEmail: emailController.text);
                    if(ownerRegistrationData?.statuscode == 1){
                      Get.to(()=> OtpVerificationScreen(name: nameController.text, mobileNumber: phoneController.text, email: emailController.text, password: passwordController.text));
                      // snackBarMessenger(ownerRegistrationData!.data!.message.toString());
                  }
                    else {
                      if (ownerRegistrationData!.statusMessage!.contains('Mobile number already registered')) {
                        snackBarMessenger('Mobile number already registered');
                      } else if (ownerRegistrationData.statusMessage!.contains('Email already registered')) {
                        snackBarMessenger('Email already registered');
                      } else if (ownerRegistrationData.statusMessage!.contains('Mobile number and email are already registered')) {
                        snackBarMessenger('Mobile number and email are already registered');
                      }
                    }
                    EasyLoading.dismiss();
                  }
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: [
                  const Text('Existing User?'),
                  TextButton(
                    child: const Text('LOGIN',
                      style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    onPressed: () {
                      Get.to(()=> const LoginScreen());
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ]),
    );
  }
}