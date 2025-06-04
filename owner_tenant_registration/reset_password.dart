import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import '../../CustomWidgets/configurable_widgets.dart';
import '../../Network/dio_service_client.dart';
import '../../Utils/debugger.dart';
import '../../company_code.dart';
// import 'login.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword( {required this.uid,super.key});
  final String uid;

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {

  late Key showText;
  bool visibilityText = false;

  final _resetFormKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final otpController = TextEditingController();
  final createPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _passwordObscureText  = true;
  bool _confirmPasswordObscureText  = true;
  String otpValue = "";
  var confirmPassword;
  final CountdownController _controller = CountdownController(autoStart: true);
  bool timerend = false;
  // DioServiceClient dioServiceClient= DioServiceClient();
  SharedPreferences? sharedPreferences;


  void _togglePasswordView() {
    setState(() {
      _passwordObscureText  = !_passwordObscureText ;

    });
  }
  void _toggleConfirmPasswordView() {
    setState(() {
      _confirmPasswordObscureText  = !_confirmPasswordObscureText;

    });
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int ss = (seconds % 60);
    return "${minutes.toString().padLeft(2, "0")}:${ss.toString().padLeft(2, "0")}";
  }

  @override
  Widget build(BuildContext context) {
     return
      Scaffold(
      appBar: AppBar(title: const Text("Reset Password")),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: _resetFormKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/Group 2621@3x.png',
                        fit: BoxFit.cover,
                      ),

                      const AutoSizeText("OTP has been sent to your registered Mobile No/Email ID", textAlign: TextAlign.center),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("6-Digit OTP", textAlign: TextAlign.left),
                          Countdown(
                              controller: _controller,
                              seconds: 40,
                              build: (BuildContext context, double time) => Text(formatTime(time.toInt()), textAlign: TextAlign.right),
                              interval: const Duration(milliseconds: 100),
                              onFinished: () {
                                debugger.printLogs('Timer is done!');
                                setState(() {
                                  timerend = true;
                                });
                                debugger.printLogs('Timer is done!');
                                debugger.printLogs(timerend);
                              })
                        ],
                      ),

                      // OTPTextField(
                      //   controller: otpController,
                      //   length: 6, // You can set the desired OTP length here
                      //   width: MediaQuery.of(context).size.width,
                      //   textFieldAlignment: MainAxisAlignment.spaceAround,
                      //   fieldWidth: 45,
                      // //  otpFieldStyle: OtpFieldStyle(focusBorderColor: Colors.amber), // focused border color
                      //   // borderColor: Colors.purple, // enabled border color
                      //
                      //   fieldStyle: FieldStyle.underline,
                      //   onChanged: (value) {
                      //     setState(() {
                      //       visibilityText = false;
                      //     });
                      //   },
                      //   onCompleted: (pin) {
                      //     setState(() {
                      //       otpValue = pin;
                      //     });
                      //   },
                      // ),
                      PinCodeTextField(
                        appContext: context,
                        length: 6,
                        obscureText: false,
                        animationType: AnimationType.fade,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.underline, // Adjust field style
                          fieldWidth: 50,
                        ),
                        cursorColor: Colors.grey,
                        animationDuration: const Duration(milliseconds: 300),
                        // enableActiveFill: true, // Ensures filled background on active fields
                        controller: otpController,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          // Do nothing on change if not required
                        },
                        onCompleted: (pin) {
                          setState(() {
                            otpValue = pin;  // Store the OTP entered by the user
                          });
                          //print("OTP Entered: $otpValue");
                        },
                      ),



                      const SizedBox(height: 20,),
                      if (visibilityText)
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Please enter the OTP.',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),

                      const SizedBox(height: 5,),

                      textField(
                        obscureText: _passwordObscureText,
                        controller: createPasswordController,
                        inputType: TextInputType.text,
                        maxLines: 1,  // Add this line
                        validator: (value) {
                          confirmPassword = value;
                          if ((value ?? '').trim().isEmpty) {
                            return "Please enter password";
                          }
                          return null;
                        },
                        prefixIcon: const Icon(Icons.lock),
                        hintText: "Create Password",
                        suffixIcon: InkWell(
                          onTap: _togglePasswordView,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: Icon(
                              _passwordObscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20,),

                      textField(
                        obscureText: _confirmPasswordObscureText,
                        controller: confirmPasswordController,
                        inputType: TextInputType.text,
                        maxLines: 1,  // Add this line
                        validator: (value) {
                          if ((value ?? '').trim().isEmpty) {
                            return "Please enter Password";
                          }
                          if(value != confirmPassword){
                            return "Password doesn't match";
                          }
                          return null;
                        },
                        prefixIcon: const Icon(Icons.lock),
                        hintText: "Re-enter created password",
                        suffixIcon: InkWell(
                          onTap: _toggleConfirmPasswordView,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: Icon(
                              _confirmPasswordObscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20,),
                    ],
                  ),
                ),
              ),
            ),
            textButton(
              onPressed: () async {
                if (_resetFormKey.currentState!.validate()) {
                  setState(() {
                    visibilityText = otpValue.isEmpty;
                  });
                  await dioServiceClient.resetPassword(widget.uid, otpValue, createPasswordController.text, confirmPasswordController.text);
                  Get.offAll(() => const CompanyCode());
                }
              },
              widget: const AutoSizeText("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}



