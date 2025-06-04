import 'package:auto_size_text/auto_size_text.dart';
import 'package:biz_infra/Screens/owner_tenant_registration/forgot_password.dart';
import 'package:biz_infra/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import '../../CustomWidgets/configurable_widgets.dart';
import '../../CustomWidgets/validations.dart';
import '../../Network/dio_service_client.dart';
import '../../Utils/app_styles.dart';
import '../../Utils/debugger.dart';
// import '../get_started.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final loginFormKey = GlobalKey<FormState>();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final CountdownController _countController = CountdownController(autoStart: true);
  bool timerEnd = false;
  RxBool isUsingMobile = true.obs; //Toggles between mobile and email login.
  RxBool hidePassword = true.obs; //Controls password visibility.
  RxBool showPassword = false.obs; //Determines if the password field should be displayed.
  RxBool resendOtp = false.obs; //Determines if the password field should be displayed.
  RxBool isOtpSend = false.obs; //Indicates whether an OTP has been sent.
  String? trackingUrl; // Store trackingUrl globally

  Future<void> onMobileSubmit() async {
    if (_mobileController.text.isNotEmpty) {
      var response = await dioServiceClient.generatePreLoginOtp(mobile: _mobileController.text);
      if (response != null && response.statuscode == 1) {
        trackingUrl = response.data!.trackingUrl; // Save trackingUrl
        isOtpSend.value = true;
        snackBarMessenger("OTP has been sent to your registered mobile number");
      }
    }
  }

  Future<void> onOtpSubmit() async {
    if (loginFormKey.currentState!.validate() && trackingUrl != null) {
      var loginData = await dioServiceClient.getPhoneNoLogin(
        context: context,
        trackingUrl: trackingUrl!, // Pass trackingUrl here
        fetchedOtp: _otpController.text,
      );

      if (loginData.statuscode == 1) {
        // Navigate based on user role
      } else if (loginData.statusMessage == "OTP is Missing") {
        snackBarMessenger("OTP has been sent to your registered mobile number");
      }
    }
  }

  void togglePasswordView() {
    hidePassword.value = !hidePassword.value;
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int ss = (seconds % 60);
    return "${minutes.toString().padLeft(2, "0")}:${ss.toString().padLeft(2, "0")}";
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _otpController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: loginFormKey,
            child: Column(
              children: [
                Image.asset(
                  'assets/images/Address-amico.png',
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width,
                ),
                tabSelectionWidget(),
                Obx(() {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Mobile Number + OTP or Email + Password Fields
                        if (isUsingMobile.isTrue) mobileNumLogInWidget() else emailPassLogInWidget(),

                        loginButtonWidget()
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget tabSelectionWidget() {
    return Container(
      height: 45,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Constants.primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TabBar(
        labelColor: !context.isDarkMode ? Colors.white : Colors.black,
        unselectedLabelColor: Colors.grey,
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        onTap: (value) {
          if (value == 0) {
            _emailController.clear();
            _passwordController.clear();
            showPassword(false);
            isUsingMobile(true);
          } else {
            _mobileController.clear();
            _otpController.clear();
            isOtpSend(false);
            _countController.restart();
            timerEnd = false;
            isUsingMobile(false);
          }
          // _mobileController.clear();
          // _otpController.clear();
          // isOtpSend.value = false;
          // _emailController.clear();
          // _passwordController.clear();
          // FocusScope.of(context).unfocus();
          // if (showPassword.isTrue) {
          //   showPassword(!showPassword.value);
          // }
          // isUsingMobile(!isUsingMobile.value);
        },
        indicatorPadding: const EdgeInsets.all(4),
        labelPadding: const EdgeInsets.symmetric(horizontal: 26),
        indicator: BoxDecoration(
          color: context.isDarkMode ? Colors.white : Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        unselectedLabelStyle: Styles.textHeadLabel,
        indicatorColor: Colors.transparent,
        tabs: const [
          Tab(text: "Use Mobile"),
          Tab(text: "Use Email"),
        ],
      ),
    );
  }

  Widget mobileNumLogInWidget() {
    return Column(
      children: [
        const AutoSizeText(
          'Please enter your mobile number to proceed further',
          style: Styles.textHeadLabel,
        ),
        const SizedBox(height: 16),
        Column(
          children: [
            // Mobile Number Field
            textField(
              controller: _mobileController,
              inputType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              hintText: 'Enter Mobile Number',
              prefixIcon: const Icon(Icons.phone),
              onChanged: (c) {
                if (isOtpSend.isTrue) {
                  isOtpSend(!isOtpSend.value);
                  _otpController.clear();
                }
              },
              validator: (value) {
                if (value == null || value.length != 10) {
                  return 'Mobile number must be 10 digits';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            Visibility(
              visible: isOtpSend.isTrue,
              child: Column(
                children: [
                  textField(
                    controller: _otpController,
                    inputType: TextInputType.number,
                    hintText: 'Enter OTP',
                    maxLength: 6,
                    counterText: "",
                    prefixIcon: const Icon(Icons.lock),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter OTP';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Countdown(
                            controller: _countController,
                            seconds: 40,
                            build: (BuildContext context, double time) {
                              if (time.toInt() == 0) {
                                return const SizedBox.shrink();
                              }
                              return Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  "Resend OTP in ${formatTime(time.toInt())}",
                                  textAlign: TextAlign.right,
                                ),
                              );
                            },
                            interval: const Duration(milliseconds: 100),
                            onFinished: () {
                              debugger.printLogs('Timer is done!');
                              setState(() {
                                timerEnd = true;
                                resendOtp.value = true;
                              });
                              debugger.printLogs('Timer is done!');
                              debugger.printLogs(timerEnd);
                            },
                          ),
                          Visibility(
                            visible: isOtpSend.value && timerEnd,
                            child: TextButton(
                              onPressed: () {
                                if (timerEnd) {
                                  onMobileSubmit();
                                  _countController.restart();
                                  setState(() {
                                    timerEnd = false; // Reset timer end flag to hide the "Resend OTP" button
                                    resendOtp.value = false; // Hide the button
                                  });
                                }
                              },
                              child: const AutoSizeText(
                                'Resend OTP',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
              //         child: Countdown(
              //             controller: _countController,
              //             seconds: 40,
              //             build: (BuildContext context, double time) => Text(formatTime(time.toInt()), textAlign: TextAlign.right),
              //             interval: const Duration(milliseconds: 100),
              //             onFinished: () {
              //               debugger.printLogs('Timer is done!');
              //               setState(() {
              //                 timerEnd = true;
              //                 resendOtp.value = true;
              //               });
              //               debugger.printLogs('Timer is done!');
              //               debugger.printLogs(timerEnd);
              //             }),
              //       ),
              //     )
              //   ],
              // ),
        //     ),
        //   ],
        // ),
    //     Visibility(
    //       visible: isOtpSend.value && timerEnd,
    //       child: Align(
    //         alignment: Alignment.centerRight,
    //         child: TextButton(
    //           onPressed: () {
    //             if (timerEnd) {
    //               onMobileSubmit();
    //               _countController.restart();
    //               timerEnd = false; // Reset timer end flag
    //             }
    //           },
    //           child: const AutoSizeText(
    //             'Resend OTP',
    //             style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w900, fontSize: 16),
    //           ),
    //         ),
    //       ),
    //     ),
    //   ],
    // );
  }

  Widget emailPassLogInWidget() {
    return Column(
      children: [
        const AutoSizeText('Please enter your email address to proceed further', style: Styles.textHeadLabel),
        const SizedBox(height: 16),
        // Email Field
        AutofillGroup(
          child: Column(
            children: [
              textField(
                controller: _emailController,
                inputType: TextInputType.emailAddress,
                onChanged: (c) {
                  if (showPassword.isTrue) {
                    showPassword(!showPassword.value);
                    _passwordController.clear();
                  }
                },
                autoFillHints: const [AutofillHints.username],
                hintText: 'Enter Email Address',
                prefixIcon: const Icon(Icons.email),
                validator: validateEmail,
              ),

              const SizedBox(height: 15),
              // Password Field
              Visibility(
                visible: showPassword.value,
                child: textField(
                  controller: _passwordController,
                  obscureText: hidePassword.value,
                  autoFillHints: const [AutofillHints.password],
                  hintText: 'Enter Password',
                  maxLines: 1,
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: InkWell(
                    onTap: togglePasswordView,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: Icon(
                        hidePassword.value ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),

        // Forgot Password Button
        Visibility(
          visible: showPassword.value,
          child: Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Get.to(() => const ForgotPassword());
              },
              child: const AutoSizeText(
                'Forgot Password?',
                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w900, fontSize: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget loginButtonWidget() {
    return textButton(
      widget: AutoSizeText(isUsingMobile.isFalse && showPassword.isFalse
          ? 'Enter'
          : isUsingMobile.isTrue && isOtpSend.isFalse
              ? "Send OTP"
              : 'Login'),
      onPressed: () async {
        FocusScope.of(context).unfocus();
        try {
          if (loginFormKey.currentState!.validate()) {
            if (isUsingMobile.value) {
              if (!isOtpSend.value) {
                onMobileSubmit();
              } else {
                onOtpSubmit();
              }
            } else {
              var loginData = await dioServiceClient.getEmailLogin(
                employeeId: _emailController.text,
                password: _passwordController.text,
                context: context,
              );
              if (loginData.statuscode == 0) {
                if (loginData.statusMessage == "Password is Missing") {
                  showPassword.value = true;
                } else if (loginData.statusMessage == "Authentication Failed") {
                  snackBarMessenger(loginData.statusMessage.toString());
                }
              }
            }
          }
        } catch (e) {
          snackBarMessenger("Something went wrong, Try after sometime");
          rethrow;
        }
      },
    );
  }
}
