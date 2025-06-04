import 'package:auto_size_text/auto_size_text.dart';
import 'package:biz_infra/CustomWidgets/configurable_widgets.dart';
import 'package:biz_infra/Screens/owner_tenant_registration/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../Utils/app_styles.dart';
import 'login.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';


class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {

  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

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
      body: _connectionStatus.contains(ConnectivityResult.none)?
      checkInternetConnection(initConnectivity):
      Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF8B8B8B),
              Color(0xFF8B6F4A), // Light gold shade
              Color(0xFFD1B572), // Bright gold in the middle
              //Color(0xFFFFF9E3), // Slightly darker gold
              // Color(0xFF000000), // Deep black
              //Color(0xFF4B4B4B), // Dark gray
              Color(0xFF8B8B8B),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 100, left: 15, right: 15, bottom: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AutoSizeText("Welcome \nJoin us and explore everything by accessing your account.",
                textAlign: TextAlign.center,
                style: Styles.whiteBold,),
              const Spacer(),
              Image.asset('assets/images/authenticate_bg.gif'),
              const Spacer(),
             // const AutoSizeText("Register now to simplify living for both Owners and Tenants.", style:Styles.whiteRegularText,),
              textButton(
                onPressed: (){
                  Get.to(
                        () => const SignUp(),
                    transition: Transition.rightToLeft,
                    popGesture: true,
                  );
                },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(10),
                    minimumSize: Size(MediaQuery.of(context).size.width/2, MediaQuery.of(context).size.height* 0.06),
                    elevation: 10,
                    shape: RoundedRectangleBorder(borderRadius:  BorderRadius.circular(30.0)),),
                  widget:  const AutoSizeText("Resident Registration")),


              const SizedBox(height: 10,),

              textButton(
                onPressed: (){
                  Get.to(()=> const LoginScreen());
                },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(10),
                    minimumSize: Size(MediaQuery.of(context).size.width/2, MediaQuery.of(context).size.height* 0.06),
                    elevation: 10,
                    shape: RoundedRectangleBorder(borderRadius:  BorderRadius.circular(30.0)),),
                  widget:  const AutoSizeText("Login")
              )
            ],
          ),
        ),
      ),
    );
  }
}
