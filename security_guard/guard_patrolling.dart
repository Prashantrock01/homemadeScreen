import 'package:biz_infra/Screens/security_guard/qr_code_scanner_screen.dart';
import 'package:flutter/material.dart';

class GuardPatrolling extends StatelessWidget {
  GuardPatrolling({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QRCodeScannerScreen(onCall: (code) {});
  }
}
