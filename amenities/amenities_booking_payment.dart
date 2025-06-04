import 'dart:io';
import 'dart:typed_data';
import 'package:biz_infra/CustomWidgets/configurable_widgets.dart';
import 'package:biz_infra/Network/dio_service_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../Utils/app_styles.dart';
import 'amenities_booking_listing.dart';

class AmenitiesBookingPayment extends StatefulWidget {
  final String? bookingAmount;
  final String? amenitiesTitle;
  final String? bookingDate;
  final String? bookingSlot;
  final String qrCodeId;
  final String amenitiesId;
  final String bookingOption;
  final String recordId;

  const AmenitiesBookingPayment({super.key, this.bookingAmount, this.amenitiesTitle, this.bookingDate, this.bookingSlot, required this.amenitiesId, required this.qrCodeId, required this.bookingOption, required this.recordId});

  @override
  State<AmenitiesBookingPayment> createState() => _AmenitiesBookingPaymentState();
}

class _AmenitiesBookingPaymentState extends State<AmenitiesBookingPayment> {

  bool isPaymentDone = false; // Tracks if payment is done

  void shareQRCode(String imageUrl) async {
    try {
      // Get temporary directory
      final directory = await getTemporaryDirectory();
      final filePath = "${directory.path}/qrcode.png";

      // Download the image using Dio
      final response = await Dio().download(imageUrl, filePath);

      // Share the image
      await Share.shareXFiles([XFile(filePath)], text: "Here is your QR Code!");

    } catch (e) {
      print("Error sharing QR Code: $e");
    }
  }

  void downloadQRCode(String imageUrl, BuildContext context) async {
    try {
      // Download the image as bytes
      var response = await Dio().get(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      // Convert to Uint8List
      Uint8List imageBytes = Uint8List.fromList(response.data);

      // Save the image to the gallery
      final result = await  ImageGallerySaverPlus.saveImage(imageBytes, quality: 100, name: "QR_Code");

      // Show a success message if saved successfully
      if (result['isSuccess']) {
        snackBarMessenger("QR Code saved to Gallery!");
      } else {
        throw "Saving failed";
      }
    } catch (e) {
      print("Error saving QR Code: $e");
      snackBarMessenger("Failed to save QR Code!");

    }
  }

  Future<File?> pickImageFromGallery(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      return imageFile;
    } else {
      snackBarMessenger("No image selected!");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Amenities Booking Payment"),),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              FutureBuilder(
                future: dioServiceClient.getAmenitiesPaymentQRCode(true, recordId: widget.qrCodeId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator()); // Show a loader while waiting
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}')); // Handle errors
                  }
                  if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(child: Text('No Data Available')); // Handle null case
                  }
                  if(snapshot.hasData && snapshot.data!.data != null && snapshot.data!.data!.record != null && snapshot.data!.data!.record!.qrcodePic != null && snapshot.data!.data!.record!.qrcodePic!.isNotEmpty){
                    return  Column(
                      children: [
                    Center(
                    child: RichText(
                    textAlign: TextAlign.center, // Center align the text
                      text: TextSpan(
                        style: const TextStyle(fontSize: 16, color: Colors.black), // Default text style
                        children: [
                          const TextSpan(text: "Please Pay Rs."),
                          TextSpan(text: widget.bookingAmount.toString(), style: Styles.boldStyle),
                          const TextSpan(text: " to allot your slot for "),
                          TextSpan(text: widget.amenitiesTitle, style: Styles.boldStyle),
                           const TextSpan(text: " on "),
                          TextSpan(text: widget.bookingDate, style: Styles.boldStyle),
                           const TextSpan(text: " from "),
                          TextSpan(text: widget.bookingSlot!.replaceAll('|##|', ','), style: Styles.boldStyle),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                        Image.network(snapshot.data!.data!.record!.qrcodePic!.first.urlpath.toString()),

                        const SizedBox(height: 30),

                        const Text("You can share or Download this QR code for payment"),
                        const SizedBox(height: 10),

                         Row(
                          children: [
                            Expanded(
                                child: textButton(
                                    onPressed:(){
                                      downloadQRCode(snapshot.data!.data!.record!.qrcodePic!.first.urlpath.toString(), context);
                                    },
                                    widget: const Text("Download QR Code"))),
                            const SizedBox(width: 10,),
                            Expanded(child:
                            textButton(
                                onPressed:(){
                                  shareQRCode(snapshot.data!.data!.record!.qrcodePic!.first.urlpath.toString());
                                  },
                                widget: const Text("Share QR Code"))),
                          ],
                        ),
                        const SizedBox(height: 20),

                        const Text(
                          'Note: If you Done your payment then please mark payment as done and upload your pay slip for verification',
                          style: TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 5),

                        textButton(
                            onPressed:(){
                              setState(() {
                                isPaymentDone = true;
                              });
                            },
                            widget:  const Text("Mark Payment as Done")),

                        const SizedBox(height: 30),

                        isPaymentDone ?
                        Card(
                          child: Padding(
                            padding:  const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                const Text("Awesome! Just one last step—please upload your payment slip so we can verify it.", style: TextStyle(fontSize: 16,), textAlign: TextAlign.center),
                                const SizedBox(height: 10),
                                        textButton(
                                          onPressed: () async {
                                            try {
                                              var bookingData = await dioServiceClient.amenitiesSaveRecord(
                                                bookingStatus: 'Approval Pending',
                                                bookingOption: widget.bookingOption,
                                                bookingDate: widget.bookingDate.toString(),
                                                bookingTimeSlot: widget.bookingSlot.toString(),
                                                bookingComments: '',
                                                amenitiesId: widget.recordId,
                                                bookingAmount: widget.bookingAmount.toString(),
                                              );

                                              if (bookingData != null && bookingData.statuscode == 1) {
                                                String generatedRecordId = bookingData.data!.id.toString();

                                                File? image = await pickImageFromGallery(context);
                                                if (image != null) {
                                                  // Show loading indicator

                                                  Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);

                                                  await dioServiceClient.waterTankUploadImage(
                                                    recordId: generatedRecordId,
                                                    fieldName: 'booking_paymentpic',
                                                    imageName: image,
                                                    // Ensure file path is passed if needed
                                                    moduleName: 'Booking',
                                                  );

                                                  Get.back(); // Close the loading dialog
                                                  Get.close(3);
                                                 snackBarMessenger(bookingData.statusMessage.toString());

                                                  Get.to(() => const AmenitiesBookingListing());
                                                }
                                              }
                                            } catch (e) {
                                              Get.back(); // Ensure dialog is dismissed in case of error
                                              Get.snackbar("Upload Failed", "Please try again.");
                                            }
                                          },
                                          widget: const Text("Upload your Pay Slip"),
                                        ),
                                      ],
                            ),
                          ),
                        ): const SizedBox.shrink(),
                      ],
                    );
                  }  else{
                    return const Center(child: CircularProgressIndicator());
                  }
                }

              ),
            ],
          ),
        ),
      ),
    );
  }
}
