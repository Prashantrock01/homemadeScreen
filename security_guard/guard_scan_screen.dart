import 'dart:developer';

// import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:biz_infra/Screens/WaterTank/water_tank_details.dart';
import 'package:biz_infra/Screens/security_guard/qr_code_scanner_screen.dart';
import 'package:biz_infra/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Network/dio_service_client.dart';
import '../DomesticHelp/domestic_help_profile_screen.dart';

class GuardQRCodeScanner extends StatefulWidget {
  final void Function(int, String)? onCallBck;

  const GuardQRCodeScanner({super.key, this.onCallBck});

  @override
  State<GuardQRCodeScanner> createState() => _GuardQRCodeScannerState();
}

class _GuardQRCodeScannerState extends State<GuardQRCodeScanner> {
  // late MobileScannerController _scannerController;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   _scannerController = MobileScannerController(detectionSpeed: DetectionSpeed.noDuplicates);
  // }
  //
  // @override
  // void dispose() {
  //   _scannerController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QRCodeScannerScreen(
        onCall: (barcode) async {
          final String code = barcode ?? '';
          log("---log data--------$code");
          if (code.isNotEmpty) {
            await dioServiceClient.passcodeVerifyApi(passcode: code.toString()).then((e) {
              log(e!.data!.toString());
              if (e.statuscode == 1 && e.data != null && e.data!.moduleName == Constants.domesticHelp) {
                Get.to(() => const DomesticHelpProfileScreen(), arguments: {'recordId': e.data!.domesticHelpId, 'isAllowInOut': true, 'isScan': true});
              } else if (e.statuscode == 1 && e.data != null && e.data!.moduleName == Constants.waterTank) {
                Get.to(() => WaterTankDetails(waterTankId: e.data!.watertankid!, isAllowInOut: true, isScan: true));
              } else if (e.statuscode == 1 && e.data != null && e.data!.moduleName == Constants.visitorsModule) {
                Get.back();
                widget.onCallBck!(Constants.appBarNameList.indexOf('Visitor'), e.data!.visitorId.toString());
                // log(e.toJson());
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.statusMessage.toString())),
                );
              } else {
                Get.back();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.statusMessage.toString())),
                );
              }
            }).catchError((e) {
              log("Error $e");
            });
            // _scannerController.dispose();
          }
        },
      ),
    );
  }
}
