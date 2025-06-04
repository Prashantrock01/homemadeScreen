import 'dart:developer';

import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class UpiScannerAndPayment extends StatefulWidget {
  const UpiScannerAndPayment({super.key});

  @override
  _UpiScannerAndPaymentState createState() => _UpiScannerAndPaymentState();
}

class _UpiScannerAndPaymentState extends State<UpiScannerAndPayment> with WidgetsBindingObserver {
  late MobileScannerController _scannerController;

  String? scannedUrl;
  bool isReturningFromUPI = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scannerController = MobileScannerController(detectionSpeed: DetectionSpeed.noDuplicates);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && isReturningFromUPI) {
      isReturningFromUPI = false;
      Get.back(result: true);
    }
  }

  @override
  void dispose() {
    _scannerController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Get.back(result: false);
        return Future.value(true);
      },
      child: Scaffold(
        body: AiBarcodeScanner(
          controller: _scannerController,
          onDetect: (c) async {
            scannedUrl = c.barcodes.first.rawValue;
            setState(() {});
            log("----Scan url----$scannedUrl");
            launchUpiUrl(scannedUrl!);

            // showUPIOptions();
          },
        ),
      ),
    );
  }

  // void _launchUPIPayment(String upiUrl) async {
  //   try {
  //     final uri = Uri.parse('$upiUrl&am=2&cu=INR');
  //     final payeeVpa = uri.queryParameters['pa']!;
  //     final payeeName = uri.queryParameters['pn'] ?? 'Unknown';
  //     final transactionRefId = uri.queryParameters['aid'] ?? 'T12345';
  //     final amount = double.tryParse(uri.queryParameters['am'] ?? '1') ?? 0;
  //     log("-----url $uri");
  //     // Launch UPI app for payment
  //     final UpiTransactionResponse response = await UpiPay.initiateTransaction(
  //       amount: amount.toString(),
  //       app: UpiApplication.googlePay,
  //       receiverName: payeeName,
  //       receiverUpiAddress: payeeVpa,
  //       transactionRef: transactionRefId,
  //       transactionNote: 'A UPI Transaction',
  //      // merchantCode: '7372',
  //     );
  //
  //
  //     if (response.status == UpiTransactionStatus.success) {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Payment Success")));
  //     } else {
  //       log("-Upi response -----$response");
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Payment Failed: ${response.status}")));
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Error initiating payment: $e")),
  //     );
  //   }
  // }
  Future<void> launchUpiUrl(String upiUrl) async {
    bool canLaunchApp = await canLaunchUrl(Uri.parse('$upiUrl&am=2.0&cu=INR'));

    if (canLaunchApp) {
      setState(() {
        isReturningFromUPI = true; // Set the flag before launching
      });

      log("-------$upiUrl");
      bool launched = await launchUrl(
        Uri.parse(upiUrl),
        mode: LaunchMode.externalApplication,
      );

      log("-------$launched");

      if (!launched) {
        setState(() {
          isReturningFromUPI = false; // Reset the flag if the app did not launch
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to launch the external app.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot launch the UPI app.')),
      );
    }
  }
}
