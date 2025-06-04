import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:biz_infra/Network/end_points.dart';
import 'package:biz_infra/Screens/bottom_navigation.dart';
import 'package:biz_infra/Screens/get_started.dart';
import 'package:biz_infra/Screens/security_guard/guard_home_screen.dart';
import 'package:biz_infra/Screens/vendor_regd/InfraEmp/infra_emp_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Network/dio_service_client.dart';
import '../Utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SharedPreferences? sharedPreferences;

  @override
  void initState() {
    checkForLogin();
    super.initState();
  }

  void checkForLogin() {
    Future.delayed(
      const Duration(seconds: 5),
      () async {
        sharedPreferences = await SharedPreferences.getInstance();

        String? token = sharedPreferences!.getString("TOKEN");
        String? userUniqueId = sharedPreferences!.getString("USERUNIQUEID");
        String? userName = sharedPreferences!.getString("USERNAME");
        String? userRole = sharedPreferences!.getString("USERROLE");
        String? assignedUserId = sharedPreferences!.getString("ASSIGNEDUSERID");
        String? email = sharedPreferences!.getString("EMAIL");
        String? userImage = sharedPreferences!.getString("USERIMAGE");
        String? societyName = sharedPreferences!.getString("SOCIETYNAME");
        String? societyBlock = sharedPreferences!.getString("SOCIETYBLOCK");
        String? societyNumber = sharedPreferences!.getString("SOCIETYNUMBER");
        String? badgeNo = sharedPreferences!.getString("BADGENO");
        String? address = sharedPreferences!.getString("ADDRESS");
        String? qrcodeId = sharedPreferences!.getString("QR_CODE_ID");
        if (token != null && userName != null) {
          String? baseUrl = sharedPreferences!.getString('baseUrl')!.isNotEmpty ? sharedPreferences!.getString('baseUrl') : dioServiceClient.defaultBaseUrl;

          dioServiceClient.updateBaseUrl(baseUrl ?? '');
          Constants.accessToken = token.toString();
          Constants.userUniqueId = userUniqueId.toString();
          Constants.userName = userName.toString();
          Constants.userRole = userRole.toString();
          Constants.assignedUserId = assignedUserId.toString();
          Constants.email = email.toString();
          Constants.userImage = userImage.toString();
          Constants.societyName = societyName.toString();
          Constants.societyBlock = societyBlock.toString();
          Constants.societyNumber = societyNumber.toString();
          Constants.userBadgeNo = badgeNo.toString();
          Constants.address = address.toString();
          Constants.qrcodeId = qrcodeId.toString();
          if (Constants.userRole == Constants.securitySupervisor) {
            Get.offAll(() => const GuardHomeScreen());
          } else if (Constants.userRole == Constants.marketing) {
            Get.offAll(() => const InfraEmpDashboard());
          } else {
            Get.offAll(() => const BottomNavigation());
          }
        } else {
          Get.offAll(() => const GetStarted());
          // Get.to(() => (token != null) ? const BottomNavigation() : const GetStarted(),);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: ClipOval(
              child: SizedBox.fromSize(
                size: const Size.fromRadius(70),
                child: Image.asset(
                  'assets/images/infraLogo.png',
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const AutoSizeText(
            "INFRA EYE",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
