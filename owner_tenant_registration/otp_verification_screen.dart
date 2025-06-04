import 'dart:async';

import 'package:biz_infra/CustomWidgets/configurable_widgets.dart';
import 'package:biz_infra/Network/dio_service_client.dart';
import 'package:biz_infra/Screens/owner_tenant_registration/society_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';


class OtpVerificationScreen extends StatefulWidget {
  final String name;
  final String mobileNumber;
  final String email;
  final String password;

  const OtpVerificationScreen({
    required this.password,
    required this.name,
    required this.mobileNumber,
    required this.email,
    super.key,
  });

  @override
  OtpVerificationScreenState createState() => OtpVerificationScreenState();
}

class OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final otpFormKey = GlobalKey<FormState>();
  String otpValue = '';
  final _otpController = TextEditingController();
  String? uid;
  int countdown = 40;
  Timer? _timer;
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;


  @override
  void initState() {
    super.initState();
    _startCountdown();

    dioServiceClient.generateOtp(
      email: widget.email,
      mobile: widget.mobileNumber,
      name: widget.name,
      module: 'Owner',
    ).then((response) {
      if (response != null && response.data != null) {
        setState(() {
          uid = response.data?.uid;
        });
      } else {
        Get.snackbar('Error', 'Failed to get UID from OTP generation');
      }
    });

         initConnectivity();
        _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
        (List<ConnectivityResult> results) {
      _updateConnectionStatus(results);
    },
    );
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown > 0) {
        setState(() {
          countdown--;
        });
      } else {
        timer.cancel();
      }
    });
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
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifying You'),
      ),
      body: _connectionStatus.contains(ConnectivityResult.none)?
      checkInternetConnection(initConnectivity):
      Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: otpFormKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset('assets/images/sent_otp.png'),
                // const Text(
                //   'Verifying You',
                //   style: TextStyle(
                //     fontSize: 20.0,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                const SizedBox(height: 10.0),
                const Text.rich(
                  TextSpan(
                    text: 'We have sent an ',
                    children: <TextSpan>[
                      TextSpan(
                        text: 'One Time Password',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: ' to your registered Mobile Number and Email for verification',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30.0),
                PinCodeTextField(
                  appContext: context,
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.underline,
                    fieldWidth: 50,
                  ),
                  cursorColor: Colors.black,
                  animationDuration: const Duration(milliseconds: 300),
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    otpValue = value;
                  },
                  onCompleted: (pin) async {
                    if (uid != null && pin.isNotEmpty) {
                      var otpStatus = await dioServiceClient.verifyOtp(
                        uid: uid!,
                        otp: pin,
                      );

                      if (otpStatus != null &&
                          otpStatus.data != null &&
                          otpStatus.data?.value == "true") {
                        Get.to(() => SocietyDetailsScreen(
                          name: widget.name,
                          phone: widget.mobileNumber,
                          email: widget.email,
                          password: widget.password,
                        ));
                      } else {
                        snackBarMessenger('Invalid OTP');
                      }
                    } else {
                      snackBarMessenger('Missing UID or OTP');
                    }
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: countdown > 0
                      ? Text(
                    'Resend OTP in $countdown sec',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                    ),
                  )
                      : TextButton(
                    onPressed: () async {
                      setState(() {
                        otpValue = '';
                        _otpController.clear();
                        countdown = 40; // Reset countdown
                      });
                      _startCountdown(); // Restart countdown

                      var resendOtpResponse = await dioServiceClient.generateOtp(
                        email: widget.email,
                        mobile: widget.mobileNumber,
                        name: widget.name,
                        module: 'Owner',
                      );

                      if (resendOtpResponse != null && resendOtpResponse.data != null) {
                        setState(() {
                          uid = resendOtpResponse.data?.uid;
                        });
                        Future.delayed(const Duration(milliseconds: 500), () {
                          snackBarMessenger('A new OTP has been sent',);
                        });
                      } else {
                        snackBarMessenger('Failed to resend OTP',);
                      }
                    },
                    child: const Text(
                      'Resend OTP',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
