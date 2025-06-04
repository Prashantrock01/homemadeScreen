import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../../Utils/app_styles.dart';

Future<void> showQRCodeDialog(BuildContext context, String qrCodeUrl, String passcode, String validityPeriod) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialogue(
        passcode: passcode,
        validityPeriod: validityPeriod,
      );
    },
  );
}

class Dialogue extends StatelessWidget {
  final String? qrCodeUrl;
  final String? passcode;
  final String? validityPeriod;

  Dialogue({super.key, this.passcode, this.qrCodeUrl, this.validityPeriod});

  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(child: Text("Water Tank", style: Styles.textBoldLabel)),
                CloseButton(),
              ],
            ),
            Screenshot(
              controller: screenshotController,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      QrImageView(
                        data: passcode.toString(),
                        version: QrVersions.auto,
                        size: 200.0,
                        gapless: true,
                        foregroundColor: Get.iconColor,
                        backgroundColor: Colors.transparent,
                      ),
                      const SizedBox(height: 20),
                      Text("Validity Period: $validityPeriod"),
                      Text(passcode.toString(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Center(child: Text("Please share this passcode to the security at the gate for hassle free entry", textAlign: TextAlign.center)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                await screenshotController.capture().then((image) async {
                  final file = await _saveScreenshot(image!);
                  Share.shareXFiles([XFile(file.path)], text: 'You can use this passcode/Qr for entrance');
                }).catchError((onError) {});
              },
              style: ButtonStyle(
                minimumSize: WidgetStateProperty.all<Size>(const Size(double.infinity, 45)),
                elevation: WidgetStateProperty.all<double>(5),
              ),
              icon: const Icon(Icons.share),
              label: const Text("Share", style: Styles.textHeadLabel),
            ),
          ],
        ),
      ),
    );
  }

  Future<File> _saveScreenshot(Uint8List imageBytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/calendar_screenshot.png');
    await file.writeAsBytes(imageBytes);
    return file;
  }
}
