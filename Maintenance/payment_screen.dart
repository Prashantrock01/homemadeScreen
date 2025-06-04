import 'dart:developer';
import 'dart:io';

import 'package:biz_infra/CustomWidgets/IntExtensions.dart';
import 'package:biz_infra/Network/dio_service_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import '../../CustomWidgets/confirmation_dialog.dart';
import '../../Model/Maintenance/PaymentDueListModel.dart';
import '../../Model/Maintenance/QRPaymentModel.dart';
import '../../Utils/app_styles.dart';
import '../../Utils/common_widget.dart';
import '../WaterTank/display_image.dart';
import 'UpiScannerAndPayment.dart';

class PaymentScreen extends StatefulWidget {
  final DuePaymentModel? data;

  const PaymentScreen({super.key, this.data});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool? isPay = false;
  bool? isQRShow = false;
  bool isPaymentDone = false; // Tracks if payment is done
  bool isReceiptUploaded = false; // Tracks if receipt is uploaded
  String selectedPaymentMode = "UPI"; // Default selected payment mode
  ScreenshotController screenshotController = ScreenshotController();

  String? qRImageUrl;
  String? qRImageName;
  File? recipeImage;

  late Future<QRPaymentModel?> qrFuture;

  @override
  void initState() {
    super.initState();
    qrFuture = fetchQrDetails();
  }

  Future<QRPaymentModel?> fetchQrDetails() async {
    final response = await dioServiceClient.paymentQrDetailApi();
    if (response != null && response.data?.record?.qrcodePic?.isNotEmpty == true) {
      setState(() {
        qRImageUrl = response.data!.record!.qrcodePic!.first.urlpath!;
        qRImageName = response.data!.record!.qrcodePic!.first.name!;
      });
    }
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Prevent back navigation if payment is done but receipt is not uploaded
        if (isPaymentDone && !isReceiptUploaded) {
          _showUploadReceiptDialog();
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pay'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              // Preserved commented code
              // 16.height,
              // Row(
              //   children: [
              //     SizedBox(
              //       width: (MediaQuery.of(context).size.width - 40) / 2,
              //       child: OutlinedButton(
              //           onPressed: () {
              //             isQRShow = true;
              //             isPay = false;
              //             setState(() {});
              //           },
              //           child: const Text('QR for Pay')),
              //     ),
              //     8.width,
              //     SizedBox(
              //       width: (MediaQuery.of(context).size.width - 40) / 2,
              //       child: ElevatedButton(
              //         style: ButtonStyle(
              //           padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 8, vertical: 0)),
              //         ),
              //         onPressed: () {
              //           isQRShow = false;
              //           isPay = true;
              //           setState(() {});
              //         },
              //         child: const Text('Pay ₹2000'),
              //       ),
              //     ),
              //   ],
              // ),
              // 16.height,
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Text('Pay below amount for maintenance', style: Styles.textHeadLabel),
                      8.height,
                      Text('₹ ${widget.data!.paymentAmount!}', style: Styles.textLargeBoldLabel),
                      16.height,
                      const SizedBox(height: 20),
                      FutureBuilder(
                          future: qrFuture,
                          builder: (context, snap) {
                            if (snap.hasData && snap.data != null) {
                              if (snap.data!.data!.record != null && snap.data!.data!.record!.qrcodePic != null && snap.data!.data!.record!.qrcodePic!.isNotEmpty) {
                                return GestureDetector(
                                    onTap: () {
                                      Get.to(
                                        () => WaterTankImages(imageFiles: [snap.data!.data!.record!.qrcodePic!.first.urlpath!]),
                                      );
                                    },
                                    child: Screenshot(controller: screenshotController, child: Image.network(snap.data!.data!.record!.qrcodePic!.first.urlpath!, height: 200)));
                              } else {
                                return const Text('No Qr code available');
                              }
                            } else {
                              return const Center(child: CircularProgressIndicator());
                            }
                          }),
                      const Text("You can share or Download this QR for Payment", style: Styles.textHeadLabel, textAlign: TextAlign.center),
                      const SizedBox(height: 20),
                      if (qRImageUrl != null && qRImageUrl!.isNotEmpty)
                        Row(
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 72) / 2,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                  padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 8, vertical: 0)),
                                ),
                                onPressed: () {
                                  _saveQrToGallery(context);
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.download, size: 20),
                                    SizedBox(width: 8),
                                    Text('QR Code'),
                                  ],
                                ),
                              ),
                            ),
                            16.width,
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 72) / 2,
                              child: commonOutlineButton(
                                onCall: () async {
                                  await screenshotController.capture().then((image) async {
                                    final file = await _saveScreenshot(image!);
                                    Share.shareXFiles([XFile(file.path)], text: 'Use This QR for the maintenance payment');
                                  }).catchError((onError) {});
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.share_outlined, size: 20, color: Get.iconColor),
                                    const SizedBox(width: 8),
                                    const Text('QR code', style: Styles.textHeadLabel),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // Mark payment as done
                          showPaymentConfirmationDialog(context, title: "Have you done your payment?", subtitle: 'Please Let us know if you done your payment', negativeText: 'No', positiveText: 'Yes',
                              onAccept: () {
                            setState(() {
                              isPaymentDone = true;
                            });
                            Get.back();
                            Get.snackbar(
                              "Wow!..Payment Done",
                              'Please upload your receipt.',
                              snackPosition: SnackPosition.TOP,
                              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                              borderRadius: 10,
                              backgroundColor: Colors.redAccent,
                              colorText: Colors.white,
                            );
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   const SnackBar(content: Text("Payment marked as done! Please upload your receipt.")),
                            // );
                          });
                        },
                        child: const Text('Mark Payment as Done'),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Note: If you Done your payment then please mark payment as done and upload your pay slip for verification',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
              if (isPaymentDone == true)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Text("You have to upload a Pay Slip using below button", style: Styles.textHeadLabel, textAlign: TextAlign.center),
                        16.height,
                        const Text(
                          "Note: If you do not upload your payment slip for verification, the admin may consider your maintenance payment as pending",
                          style: TextStyle(color: Colors.red),
                        ),
                        8.height,
                        ElevatedButton(
                          onPressed: isPaymentDone
                              ? () async {
                                  recipeImage = await pickImage();
                                  dioServiceClient.paymentRecieptUploadAttachment(recordId: widget.data!.id, imageName: recipeImage).then((c) {
                                    if (c != null && c.statuscode == 1) {
                                      setState(() {
                                        isReceiptUploaded = true;
                                      });
                                      Get.back(result: true);
                                      // ScaffoldMessenger.of(context).showSnackBar(
                                      //   SnackBar(content: Text(c.statusMessage!)),
                                      // );
                                      Get.snackbar(
                                        "Success..",
                                        c.statusMessage!,
                                        snackPosition: SnackPosition.TOP,
                                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                                        borderRadius: 10,
                                        backgroundColor: Colors.redAccent,
                                        colorText: Colors.white,
                                      );
                                    }
                                  });
                                }
                              : null,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.upload_outlined, size: 20),
                              SizedBox(width: 8),
                              Text('Upload your Pay Slip', style: Styles.textHeadLabel),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              // Preserved commented code
              if (isQRShow == false && isPay == true)
                Column(
                  children: [
                    // UPI Payment Option
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      leading: Icon(Icons.qr_code_rounded),
                      title: const Text(
                        "UPI",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text("Pay via BHIM, Google Pay or any other UPI app"),
                      trailing: Radio<String>(
                        value: "UPI",
                        groupValue: selectedPaymentMode,
                        onChanged: (value) {
                          setState(() {
                            selectedPaymentMode = value!;
                          });
                        },
                      ),
                    ),
                    // // Cash Payment Option
                    // ListTile(
                    //   contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    //   leading: Icon(Icons.attach_money_rounded),
                    //   title: Text(
                    //     "Cash",
                    //     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    //   ),
                    //   subtitle: Text("Paid via cash"),
                    //   trailing: Radio<String>(
                    //     value: "Cash",
                    //     groupValue: selectedPaymentMode,
                    //     onChanged: (value) {
                    //       setState(() {
                    //         selectedPaymentMode = value!;
                    //       });
                    //     },
                    //   ),
                    // ),
                    // Pay Button
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          // Payment action
                          bool? res = await Get.to(() => UpiScannerAndPayment());
                          if (res == true) {
                            showPaymentConfirmationDialog(context, title: 'Payment Status', subtitle: 'Please Let us know what is your payment status', onAccept: () {});
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50), // Full-width button
                          backgroundColor: Colors.green,
                        ),
                        child: const Text(
                          "Pay",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveQrToGallery(BuildContext context) async {

    try {
      await screenshotController.capture().then((image) async {
        log("-------download");
        final result = await ImageGallerySaverPlus.saveImage(image!, quality: 100, name: "payment_qr");
        if (result["isSuccess"] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("QR Code saved to gallery!")),
          );
        }
      });
    } catch (e) {
      log('Error saving QR Code: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to save QR Code.")),
      );
    }
  }

  Future<File> _saveScreenshot(Uint8List imageBytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/qr.png');
    await file.writeAsBytes(imageBytes);
    return file;
  }

  void _showUploadReceiptDialog() {
    showPaymentConfirmationDialog(
      context,
      title: 'Upload Receipt',
      subtitle: 'Please upload your payment receipt before leaving this screen.\nTo exit without uploading, click on "Exit".',
      negativeText: 'Exit',
      positiveText: 'Ok',
      onCancel: () {
        Get.back();
        Get.back();
      },
      onAccept: () {
        Get.back();
      },
    );
  }

  Future<File> pickImage() async {
    final XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    File? selectedDocImage;
    if (pickedFile != null) {
      setState(() {
        selectedDocImage = File(pickedFile.path);
      });
    }
    return selectedDocImage!;
  }

  qrImageNameGet(QrcodePic? record) {
    qRImageUrl = record!.urlpath!;
    qRImageName = record.name!;
  }
}
