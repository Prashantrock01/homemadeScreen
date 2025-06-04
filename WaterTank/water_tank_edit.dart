import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:biz_infra/Model/WaterTank/water_tank_details_model.dart';
import 'package:biz_infra/Network/dio_service_client.dart';
import 'package:biz_infra/Screens/WaterTank/water_tank_list.dart';
// import 'package:biz_infra/Utils/debugger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:share_plus/share_plus.dart';

import '../../CustomWidgets/configurable_widgets.dart';
import '../../CustomWidgets/image_view.dart';
import '../attachments.dart';
import 'Component/commonSharePasscodeDialogue.dart';
// import 'water_tank_list.dart';

class WaterTankEditScreen extends StatefulWidget {
  final String waterTankId;
  final bool isRenew;
  final WaterTankDetailModel? waterTankData;

  const WaterTankEditScreen({required this.waterTankId, required this.waterTankData, required this.isRenew, super.key});

  @override
  State<WaterTankEditScreen> createState() => _WaterTankEditScreenState();
}

class _WaterTankEditScreenState extends State<WaterTankEditScreen> {
  final waterTankerForm = GlobalKey<FormState>();
  final supplierNameController = TextEditingController();
  final waterTankCapacityController = TextEditingController();
  //final vehicleNumberController = TextEditingController();
  final contactNumberController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final DateFormat dateFormat = DateFormat('dd MMM yyyy');
  DateTime startDate = DateTime.now();

  final ImagePicker _picker = ImagePicker();
  List<File?> capturedImages = [];
  List<String> listOfExistigImagesRecord = [];
  RxList<XFile> imageList = <XFile>[].obs;


  // Method to capture multiple images from the camera
  Future _captureImage() async {
    if (!widget.isRenew) {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          capturedImages.add(File(pickedFile.path));
        });
      }
    } else {
      Get.snackbar("Oops!!!", "Cannot update image(s) in Renew");
    }
  }

  // Method to navigate to the image view screen
  void _viewImage(File imageFile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageViewScreen(
          imageFile: imageFile,
          onDelete: () => _deleteImage(imageFile),
        ),
      ),
    );
  }

  // Method to delete a specific image
  void _deleteImage(File imageFile) {
    setState(() {
      capturedImages.remove(imageFile);
    });
    Navigator.pop(context); // Return to previous screen after deletion
  }

  fetchData() async {
    try {
      if (widget.waterTankData != null) {
        EasyLoading.show();
        supplierNameController.text = widget.waterTankData!.data!.record!.wtsuplierName.toString();
        waterTankCapacityController.text = widget.waterTankData!.data!.record!.wtcapacity.toString();
       // vehicleNumberController.text = widget.waterTankData!.data!.record!.wtvehicleNumber.toString();
        contactNumberController.text = widget.waterTankData!.data!.record!.wtcontactNumber.toString();
        startDateController.text = widget.waterTankData!.data!.record!.wtchooseDate.toString();
        endDateController.text = widget.waterTankData!.data!.record!.wtendDate.toString();

        List<WttakePhoto>? listOfImages = widget.waterTankData!.data!.record!.wttakePhoto;
        listOfImages ??= [];
        listOfExistigImagesRecord = [];
        for (int i = 0; i < listOfImages.length; i++) {
          final uri = Uri.parse(listOfImages[i].urlpath.toString());
          final res = await http.get(uri);
          var bytes = res.bodyBytes;
          final temp = await getTemporaryDirectory();
          final path = '${temp.path}/${listOfImages[i].name}';
          if (File(path).existsSync()) {
            File(path).deleteSync();
            // print("ISDELETED${File(path).existsSync().toString()}");
          }
          File(path).writeAsBytesSync(bytes, mode: FileMode.write);
          capturedImages.add(File(path));
          listOfExistigImagesRecord.add(listOfImages[i].attachmentsid.toString());
        }

        List<WtUploadatachment>? listOfDocImages = widget.waterTankData!.data!.record!.wtUploadAttachment;
        listOfDocImages ??= [];
        for (int i = 0; i < listOfDocImages.length; i++) {
          final uri = Uri.parse(listOfDocImages[i].urlpath.toString());
          final res = await http.get(uri);
          var bytes = res.bodyBytes;
          final temp = await getTemporaryDirectory();
          final path = '${temp.path}/${listOfDocImages[i].name}';
          if (File(path).existsSync()) {
            File(path).deleteSync();
            // print("ISDELETED${File(path).existsSync().toString()}");
          }
          File(path).writeAsBytesSync(bytes, mode: FileMode.write);
          imageList.add(XFile(path));
          listOfExistigImagesRecord.add(listOfDocImages[i].attachmentsid.toString());
        }

         setState(() {});
        EasyLoading.dismiss();
      }
    } catch (e) {
      //print(e.toString());
      EasyLoading.dismiss();
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Water Tanker"),

      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: waterTankerForm,
                  child: Column(
                    children: [
                      textField(
                        readOnly: widget.isRenew,
                        controller: supplierNameController,
                        textInputAction: TextInputAction.next,
                        labelText: 'Name of the Supplier *',
                        hintText: 'Enter Name of the Supplier *',
                        prefixIcon: const Icon(Icons.person),
                        validator: (value) {
                          if (supplierNameController.text.isEmpty) {
                            return 'Please enter supplier name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      textField(
                        readOnly: widget.isRenew,
                        controller: waterTankCapacityController,
                        textInputAction: TextInputAction.next,
                        inputType: TextInputType.number,
                        maxLength: 10,
                        counterText: '',
                        labelText: 'Water Tank Capacity (in litre) *',
                        hintText: 'Enter water tank capacity (in litre) *',
                        prefixIcon: const Icon(Icons.water_drop),
                        validator: (value) {
                          if (supplierNameController.text.isEmpty) {
                            return 'Please enter water tank capacity';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      textField(
                        readOnly: widget.isRenew,
                        controller: contactNumberController,
                        textInputAction: TextInputAction.next,
                        inputType: TextInputType.number,
                        labelText: 'Contact Number *',
                        hintText: 'Enter Contact Number *',
                        maxLength: 10,
                        counterText: "",
                        prefixIcon: const Icon(Icons.phone),
                        validator: (value) {
                          if (contactNumberController.text.isEmpty) {
                            return 'Please enter contact number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) {
                            setState(() {
                              startDate = picked;
                              startDateController.text = dateFormat.format(picked);
                            });
                          }
                        },
                        child: AbsorbPointer(
                          child: textField(
                            controller: startDateController,
                            readOnly: true,
                            textInputAction: TextInputAction.next,
                            inputType: TextInputType.datetime,
                            labelText: 'Start Date *',
                            hintText: 'Select start date',
                            prefixIcon: const Icon(Icons.calendar_today),
                            validator: (value) {
                              if (startDateController.text.isEmpty) {
                                return 'Please select start date';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: startDate,
                            firstDate: startDate,
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) {
                            setState(() {
                              endDateController.text = dateFormat.format(picked);
                            });
                          }
                        },
                        child: AbsorbPointer(
                          child: textField(
                            readOnly: true,
                            controller: endDateController,
                            textInputAction: TextInputAction.next,
                            labelText: 'End Date *',
                            hintText: 'Select end date',
                            prefixIcon: const Icon(Icons.calendar_today),
                            validator: (value) {
                              if (endDateController.text.isEmpty) {
                                return 'Please select end date';
                              }
                              if (value != null && dateFormat.parse(value).compareTo(startDate) < 0) {
                                return 'End date cannot be less than start date';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      // const SizedBox(height: 20),
                      // textButton(
                      //   onPressed: _captureImage,
                      //   style: ElevatedButton.styleFrom(
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(10),
                      //     ),
                      //     minimumSize: Size(MediaQuery.of(context).size.width / 2, 35),
                      //     elevation: 5,
                      //   ),
                      //   widget: const AutoSizeText("Capture Owner Image"),
                      // ),
                      // const SizedBox(height: 20),
                      // if (capturedImages.isNotEmpty)
                      //   GridView.builder(
                      //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      //       crossAxisCount: 3,
                      //       crossAxisSpacing: 10,
                      //       mainAxisSpacing: 10,
                      //     ),
                      //     itemCount: capturedImages.length,
                      //     itemBuilder: (context, index) {
                      //       return GestureDetector(
                      //         onTap: () {
                      //           _viewImage(capturedImages[index]!);
                      //         },
                      //         child: Image.file(
                      //           capturedImages[index]!,
                      //           fit: BoxFit.cover,
                      //         ),
                      //       );
                      //     },
                      //   ),
                      //
                      // const SizedBox(height: 20,),
                      //
                      // UploadAttachmentScreen(mediaList: imageList)
                      const SizedBox(height: 20),
                      textButton(
                        onPressed: _captureImage,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: Size(MediaQuery.of(context).size.width / 2, 35),
                          elevation: 5,
                        ),
                        widget: const AutoSizeText("Capture Owner Image"),
                      ),
                      const SizedBox(height: 20),
                      if (capturedImages.isNotEmpty)
                        GridView.builder(
                          shrinkWrap: true,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: capturedImages.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                _viewImage(capturedImages[index]!);
                              },
                              child:
                              Image.file(
                                capturedImages[index]!,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),

                      const SizedBox(height: 20,),

                      UploadAttachmentScreen(mediaList: imageList) ],
                  ),
                ),
              ),
            ),
            textButton(
              onPressed: () async {
                //    showQRCodeDialog("https://bizinfra.crm-doctor.com/passcodeqr/qr_366630.png","366630");

                if (waterTankerForm.currentState!.validate() && capturedImages.isNotEmpty) {
                  var waterTankData = await dioServiceClient.waterTankSaveRecord(
                      waterSupplierName: supplierNameController.text,
                      waterTankCapacityName: waterTankCapacityController.text,
                     // vehicleNumber: vehicleNumberController.text,
                      contactNumber: contactNumberController.text,
                      startDate: startDateController.text,
                      endDate: endDateController.text,
                      ownerImage: capturedImages,
                      mediaList:imageList,
                      recordId: widget.waterTankId,
                      listOfImageRecordToBeDeleted: listOfExistigImagesRecord,  );
                  if (waterTankData?.statuscode == 1) {
                    // Get.off(()=> const WaterTankList());
                     Get.close(1);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                        const WaterTankList(),
                      ),
                    );
                    showQRCodeDialog(context,waterTankData!.waterTankPasscodeModelData!.data!.qrcodePath.toString(), waterTankData.waterTankPasscodeModelData!.data!.passcode.toString(),'');
                  }
                } else {
                  if (capturedImages.isEmpty) {
                    Get.snackbar("No image(s) captured", "Please capture Vehicle & Driver Image");
                  }
                }
              },
              widget: const Text("Update Vendor"),
            ),
          ],
        ),
      ),
    );
  }
}
