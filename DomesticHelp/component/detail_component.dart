import 'dart:io';
import 'package:biz_infra/Utils/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import '../../../CustomWidgets/configurable_widgets.dart';
import '../../../CustomWidgets/image_view.dart';
import '../../../Model/DomesticHelp/domestic_help_detail_model.dart';
import '../../../Utils/app_styles.dart';

class DetailComponent extends StatefulWidget {
  final DomesticHelperDetail? detail;

  const DetailComponent({super.key, this.detail});

  @override
  State<DetailComponent> createState() => _DetailComponentState();
}

class _DetailComponentState extends State<DetailComponent> {
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                commonListComponent(title: 'Available Time ', value: formatTimeString(widget.detail!.domhelpTimeslot.toString())),
                // commonListComponent(title: 'Vehicle Number ', value: widget.detail!.domhelpVehicleno.toString()),
                commonListComponent(title: 'Document Type ', value: widget.detail!.domhelpDocType.toString()),
                commonListComponent(title: 'Document Number ', value: widget.detail!.domhelpDocnumber.toString()),
                const SizedBox(height: 8),
                if (widget.detail!.domhelpDocUpload != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Document Proof', style: Styles.textBoldLabel),
                      const SizedBox(height: 8),
                      Row(
                          children: widget.detail!.domhelpDocUpload!.map((e) {
                        return GestureDetector(
                          onTap: () async {
                            File file = await getFile(e.urlpath.toString(), e.name.toString());
                            // Optionally handle image tap to show full-screen
                            // showDialog(
                            //   context: context,
                            //   builder: (_) => Dialog(
                            //     child: Image.network(photos[index].urlpath.toString()),
                            //   ),
                            // );
                            Get.to(() => ImageViewScreen(imageFile: file));
                          },
                          child: Image.network(
                            e.urlpath.toString(),
                            width: (MediaQuery.of(context).size.width - 72) / 2,
                            height: 150,
                          ),
                        );
                      }).toList()),
                    ],
                  ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () {
                    generateQRPasscodeDialogue(context);
                  },
                  style: ButtonStyle(
                    side: const WidgetStatePropertyAll(BorderSide(color: Colors.grey, width: 0.5)),
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.qr_code, size: 20, color: Get.iconColor),
                      const SizedBox(width: 4),
                      const Text('Get QR/Passcode', style: Styles.smallBoldText),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void generateQRPasscodeDialogue(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Your Qr/Passcode", style: Styles.textBoldLabel),
                    CloseButton(),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Screenshot(
                controller: screenshotController,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        QrImageView(
                          data: widget.detail!.passcodeDetails!.passcode.toString(),
                          version: QrVersions.auto,
                          size: 200.0,
                          gapless: true,
                          foregroundColor: Get.iconColor,
                          backgroundColor: Colors.transparent,
                        ),
                        const SizedBox(height: 20),
                        Text("Your Passcode is ${widget.detail!.passcodeDetails!.passcode!}", style: Styles.textLargeBoldLabel, textAlign: TextAlign.center),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("You can share your passcode/QR by clicking below button", style: Styles.textHeadLabel, textAlign: TextAlign.center),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: commonOutlineButton(
                  onCall: () async {
                    await screenshotController.capture().then((image) async {
                      final file = await _saveScreenshot(image!);
                      Share.shareXFiles([XFile(file.path)], text: 'You can use this passcode/Qr for entrance');
                    }).catchError((onError) {});
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.share_outlined, size: 20, color: Get.iconColor),
                      const SizedBox(width: 8),
                      const Text('Share QR/Passcode', style: Styles.textHeadLabel),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget commonListComponent({required String title, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("$title: ", style: Styles.smallText),
        Expanded(child: Text(value, style: Styles.textBoldLabel, textAlign: TextAlign.end)),
      ],
    );
  }

  // Method to save the screenshot as a file
  Future<File> _saveScreenshot(Uint8List imageBytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/qr.png');
    await file.writeAsBytes(imageBytes);
    return file;
  }

  String formatTimeString(String input) {
    input = input.replaceAll(RegExp(r'[\[\]]'), '');
    List<String> timeRanges = input.split(', ');

    List<String> formattedRanges = timeRanges.map((range) {
      RegExp regex = RegExp(r'(\d+)-(\d+)\s?(AM|PM)');
      Match? match = regex.firstMatch(range);

      if (match != null) {
        String startHour = match.group(1)!;
        String endHour = match.group(2)!;
        String meridian = match.group(3)!;

        String formattedStart = '$startHour:00 $meridian';
        String formattedEnd = '$endHour:00 $meridian';

        return '$formattedStart-$formattedEnd';
      }
      return range;
    }).toList();

    return formattedRanges.join(', ');
  }
}
