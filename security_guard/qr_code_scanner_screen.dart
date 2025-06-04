import 'dart:developer';

import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:flutter/material.dart';

class QRCodeScannerScreen extends StatefulWidget {
  final Function(String code)? onCall;

  QRCodeScannerScreen({required this.onCall});

  @override
  State<QRCodeScannerScreen> createState() => _QRCodeScannerScreenState();
}

class _QRCodeScannerScreenState extends State<QRCodeScannerScreen> {
  late MobileScannerController _scannerController;

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController(detectionSpeed: DetectionSpeed.noDuplicates);
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AiBarcodeScanner(
      controller: _scannerController,
      onDetect: (barcode) async {
        final String code = barcode.barcodes.first.rawValue ?? '';
        if (code.isNotEmpty) {
          log("-----$code");
          widget.onCall!(code);
          _scannerController.dispose();
        }
      },
    );
  }
}
