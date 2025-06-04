import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:biz_infra/CustomWidgets/configurable_widgets.dart';
import 'package:biz_infra/Network/dio_service_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../CustomWidgets/image_view.dart';
import '../attachments.dart';
// import '../attachments.dart';

class WaterTanker extends StatefulWidget {
  const WaterTanker({super.key});

  @override
  State<WaterTanker> createState() => _WaterTankerState();
}

class _WaterTankerState extends State<WaterTanker> {
  final waterTankerForm = GlobalKey<FormState>();
  final supplierNameController = TextEditingController();
  final waterTankCapacityController = TextEditingController();

  // final vehicleNumberController = TextEditingController();
  final contactNumberController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final DateFormat dateFormat = DateFormat('dd MMM yyyy');
  DateTime startDate = DateTime.now();
  String? waterStartDate;
  String? waterEndDate;

  final ImagePicker userImagePicker = ImagePicker();
  List<File?> capturedUserImages = [];

  RxList<XFile> imageList = <XFile>[].obs;

  // Method to capture multiple images from the camera
  Future<void> _captureUserImage() async {
    final pickedFile = await userImagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        capturedUserImages.add(File(pickedFile.path));
      });
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
      capturedUserImages.remove(imageFile);
    });
    // Navigator.pop(context); // Return to previous screen after deletion
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Water Tanker"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: waterTankerForm,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Column(
                      children: [
                        textField(
                          controller: supplierNameController,
                          textInputAction: TextInputAction.next,
                          inputType: TextInputType.name,
                          // inputFormatters: [
                          //   FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
                          // ],
                          labelText: 'Name of the Supplier *',
                          hintText: 'Enter Name of the Supplier *',
                          prefixIcon: const Icon(Icons.person),
                          validator: (value) {
                            if (supplierNameController.text.isEmpty) {
                              return 'Please enter supplier name';
                            }
                            return null;
                          },
                          textCapitalization: TextCapitalization.words,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        textField(
                          controller: waterTankCapacityController,
                          textInputAction: TextInputAction.next,
                          inputType: TextInputType.number,
                          maxLength: 10,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
                          ],
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
                          controller: contactNumberController,
                          textInputAction: TextInputAction.next,
                          inputType: TextInputType.number,
                          labelText: 'Contact Number *',
                          hintText: 'Enter Contact Number *',
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                          ],
                          maxLength: 10,
                          counterText: "",
                          prefixIcon: const Icon(Icons.phone),
                          validator: (value) {
                            if (contactNumberController.text.isEmpty) {
                              return 'Please enter contact number';
                            } else if (contactNumberController.text.length < 10) {
                              return 'Please enter 10 digit valid phone number';
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
                                waterStartDate = DateFormat('dd-MM-yyyy').format(picked);
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
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
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
                                waterEndDate = DateFormat('dd-MM-yyyy').format(picked);
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
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
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
                        const SizedBox(height: 20),
                        textButton(
                          onPressed: _captureUserImage,
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
                        if (capturedUserImages.isNotEmpty) //here there is capturedUserImage list
                          GridView.builder(
                            shrinkWrap: true,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: capturedUserImages.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  _viewImage(capturedUserImages[index]!);
                                },
                                child: Image.file(
                                  capturedUserImages[index]!,
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                        const SizedBox(height: 20),
                        UploadAttachmentScreen(mediaList: imageList),
                        const SizedBox(height: 20),

                      ],
                    ),
                  ),
                ),
              ),
            ),
            textButton(
              onPressed: () async {
                if (waterTankerForm.currentState!.validate() && capturedUserImages.isNotEmpty && imageList.isNotEmpty) {
                  var waterTankData = await dioServiceClient.waterTankSaveRecord(
                      waterSupplierName: supplierNameController.text,
                      waterTankCapacityName: waterTankCapacityController.text,
                      contactNumber: contactNumberController.text,
                      startDate: waterStartDate!,
                      endDate: waterEndDate!,
                      ownerImage: capturedUserImages,
                      mediaList: imageList);
                  if (waterTankData?.statuscode == 1) {
                    Get.back(result: true);
                  }
                } else {
                  if (capturedUserImages.isEmpty || imageList.isEmpty) {
                    snackBarMessenger("Please upload both Owner Image & Documents");
                  }
                }
              },
              widget: const Text("Create Vendor"),
            ),
          ],
        ),
      ),
    );
  }
}
