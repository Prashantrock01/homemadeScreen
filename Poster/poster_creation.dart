// ignore_for_file: invalid_use_of_protected_member

import 'dart:io';

import 'package:biz_infra/CustomWidgets/configurable_widgets.dart';
import 'package:biz_infra/Model/adv_notice_board/adv_notice_board_creation_modal.dart';
import 'package:biz_infra/Model/adv_notice_board/dropdowns/adv_notice_share_dropdown_modal.dart';
import 'package:biz_infra/Model/adv_notice_board/dropdowns/adv_notice_type_dropdown_modal.dart';
import 'package:biz_infra/Network/dio_service_client.dart';
import 'package:biz_infra/Screens/poster/poster_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class PosterCreation extends StatefulWidget {
  const PosterCreation({super.key});

  @override
  State<PosterCreation> createState() => _PosterCreationState();
}

class _PosterCreationState extends State<PosterCreation> {
  // final DioServiceClient _dioClient = DioServiceClient();

  final _formKey = GlobalKey<FormState>();

  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _advNoticeTypeController = TextEditingController();
  final _subjectController = TextEditingController();
  final _advNoticeDescriptionController = TextEditingController();
  final _chooseController = TextEditingController();

  final ValueNotifier<File?> _empPickedImageFileNotifier =
      ValueNotifier<File?>(null);

  XFile? advImage;

  @override
  void initState() {
    super.initState();
    callAdvNoticeType();
    callAdvNoticeShare();
  }

  RxList<dynamic>? advNoticeType = [].obs;
  RxList<dynamic>? advNoticeShare = [].obs;

  void callAdvNoticeType() async {
    AdvNoticeTypeDropdownModal? response = await dioServiceClient.getAdvNoticeType();
    if (response?.statuscode == 1) {
      advNoticeType!.value = response?.data?.advnoticeType
              ?.map((x) => x.advnoticeType.toString())
              .toList() ??
          [];
    }
  }

  void callAdvNoticeShare() async {
    AdvNoticeShareDropdownModal? response =
        await dioServiceClient.getAdvNoticeShare();
    if (response?.statuscode == 1) {
      advNoticeShare!.value = response?.data?.advnoticeShare
              ?.map((x) => x.advnoticeShare.toString())
              .toList() ??
          [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Poster'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 4.0,
            ),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 20),
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 5),
                          borderRadius:
                              BorderRadius.circular(15), // Rounded corners
                        ),
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(15), // Match the corners
                          child: ValueListenableBuilder<File?>(
                            valueListenable: _empPickedImageFileNotifier,
                            builder: (context, file, child) {
                              return Container(
                                decoration: BoxDecoration(
                                  image: file != null
                                      ? DecorationImage(
                                          image: FileImage(file),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: buildCurvyRectangle(
                          all: 5,
                          color: Colors.black,
                          borderRadius: 30,
                          child: buildCurvyRectangle(
                            all: 5,
                            color: Colors.amberAccent,
                            borderRadius: 30,
                            child: GestureDetector(
                              onTap: _showAdvImageSourceDialog,
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                textField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _startDateController,
                  labelText: 'Start Date *',
                  hintText: 'Please select start date',
                  suffixIcon: const Icon(Icons.calendar_month),
                  onTap: () => datePicker(_startDateController),
                  validator: (value) =>
                      value!.isEmpty ? 'please enter start date' : null,
                  readOnly: true,
                ),
                const SizedBox(
                  height: 15,
                ),
                textField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _endDateController,
                  labelText: 'End Date *',
                  hintText: 'Please select end date',
                  suffixIcon: const Icon(Icons.calendar_month),
                  onTap: () => datePicker(_endDateController),
                  validator: (value) =>
                      value!.isEmpty ? 'please enter end date' : null,
                  readOnly: true,
                ),
                const SizedBox(
                  height: 15,
                ),
                Obx(
                  () => dropdownUI(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    context: context,
                    controller: _advNoticeTypeController,
                    formLabel: 'Notice Type',
                    labelText: 'Notice Type *',
                    hintText: 'Please select notice type',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select notice type';
                      }
                      return null;
                    },
                    data: advNoticeType!.value.cast(),
                    onChanged: (int? value) {},
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                textField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _subjectController,
                  labelText: 'Subject *',
                  hintText: 'Please select notice type',
                  validator: (value) =>
                      value!.isEmpty ? 'please write subject' : null,
                  readOnly: false,
                  minLines: 1,
                  maxLines: 5,
                  inputType: TextInputType.text,
                ),
                const SizedBox(
                  height: 15,
                ),
                textField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _advNoticeDescriptionController,
                  labelText: 'Notice Description *',
                  hintText: 'Write description',
                  validator: (value) =>
                      value!.isEmpty ? 'please write subject' : null,
                  readOnly: false,
                  minLines: 1,
                  maxLines: 5,
                  inputType: TextInputType.text,
                ),
                const SizedBox(
                  height: 15,
                ),
                Obx(
                  () => dropdownUI(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    context: context,
                    controller: _chooseController,
                    formLabel: 'Choose whom to share with',
                    labelText: 'Choose whom to share with *',
                    hintText: 'Please select your choice',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select whom to share';
                      }
                      return null;
                    },
                    data: advNoticeShare!.value.cast(),
                    onChanged: (int? value) {},
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                customElevatedButton(
                  text: 'Submit',
                  fontSize: 20,
                  // onPressed: () async {
                  //   // Save the context in a variable
                  //   final scaffoldMessenger = ScaffoldMessenger.of(context);

                  //   if (_formKey.currentState!.validate() && advImage != null) {
                  //     try {
                  //       AdvNoticeBoardCreationModal? res =
                  //           await _dioClient.submitAdvNotice(
                  //         posterStartDate: _startDateController.text,
                  //         posterEndDate: _endDateController.text,
                  //         advNoticeType: _advNoticeTypeController.text,
                  //         advNoticeSub: _subjectController.text,
                  //         advNoticeDescription:
                  //             _advNoticeDescriptionController.text,
                  //         advNoticeShare: _chooseController.text,
                  //         image: advImage,
                  //       );
                  //       scaffoldMessenger.showSnackBar(
                  //         const SnackBar(
                  //           content: Text(
                  //               'Successfully created a poster.'),
                  //         ),
                  //       );
                  //       if (res!.statuscode == 1) {
                  //         Get.close(1);
                  //         Navigator.pushReplacement(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (BuildContext context) =>
                  //                 const PosterList(),
                  //           ),
                  //         );
                  //       } else {
                  //         // Display the status message from the response
                  //         Get.snackbar(
                  //           "Oops!",
                  //           res.statusMessage!,
                  //           snackPosition: SnackPosition.TOP,
                  //           margin: const EdgeInsets.symmetric(
                  //             horizontal: 20,
                  //             vertical: 200,
                  //           ),
                  //           borderRadius: 10,
                  //           backgroundColor: Colors.redAccent,
                  //           colorText: Colors.white,
                  //         );
                  //       }
                  //     } catch (e) {
                  //       Get.snackbar(
                  //         "Oops!! Failed to create poster",
                  //         e.toString(),
                  //         snackPosition: SnackPosition.TOP,
                  //         margin: const EdgeInsets.symmetric(
                  //             horizontal: 20, vertical: 200),
                  //         borderRadius: 10,
                  //         backgroundColor: Colors.redAccent,
                  //         colorText: Colors.white,
                  //       );
                  //     }
                  //   } else {
                  //     // Show an error message if no image is selected
                  //     Get.snackbar(
                  //       "No image selected",
                  //       "Please capture or upload an employee image to proceed.",
                  //       snackPosition: SnackPosition.TOP,
                  //       margin: const EdgeInsets.symmetric(
                  //           horizontal: 20, vertical: 200),
                  //       borderRadius: 10,
                  //       backgroundColor: Colors.orange,
                  //       colorText: Colors.white,
                  //     );
                  //   }
                  // },
                  onPressed: () async {
                    final scaffoldMessenger = ScaffoldMessenger.of(context);

                    if (advImage == null) {
                      // Show a snackbar if no image is selected
                      Get.snackbar(
                        "No image selected",
                        "Please capture or upload an employee image to proceed.",
                        snackPosition: SnackPosition.TOP,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 50),
                        borderRadius: 10,
                        backgroundColor: Colors.orange,
                        colorText: Colors.white,
                      );
                      return; // Stop further execution
                    }

                    if (!_formKey.currentState!.validate()) {
                      return; // Stop further execution if form is invalid
                    }

                    try {
                      AdvNoticeBoardCreationModal? res =
                          await dioServiceClient.submitAdvNotice(
                        posterStartDate: _startDateController.text,
                        posterEndDate: _endDateController.text,
                        advNoticeType: _advNoticeTypeController.text,
                        advNoticeSub: _subjectController.text,
                        advNoticeDescription:
                            _advNoticeDescriptionController.text,
                        advNoticeShare: _chooseController.text,
                        image: advImage,
                      );

                      scaffoldMessenger.showSnackBar(
                        const SnackBar(
                            content: Text('Successfully created a poster.')),
                      );

                      if (res!.statuscode == 1) {
                        Get.close(1);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const PosterList(),
                          ),
                        );
                      } else {
                        Get.snackbar(
                          "Oops!",
                          res.statusMessage!,
                          snackPosition: SnackPosition.TOP,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 50),
                          borderRadius: 10,
                          backgroundColor: Colors.redAccent,
                          colorText: Colors.white,
                        );
                      }
                    } catch (e) {
                      Get.snackbar(
                        "Oops!! Failed to create poster",
                        e.toString(),
                        snackPosition: SnackPosition.TOP,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 50),
                        borderRadius: 10,
                        backgroundColor: Colors.redAccent,
                        colorText: Colors.white,
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? hasValidImageUrl(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    String pattern =
        r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/+#-]*[\w@?^=%&amp;/+#-])?';
    RegExp regExp = RegExp(pattern);

    if (!regExp.hasMatch(value)) {
      return 'Please enter a valid image URL';
    }

    return null;
  }

  String? hasValidProductUrl(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    String pattern =
        r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/+#-]*[\w@?^=%&amp;/+#-])?';
    RegExp regExp = RegExp(pattern);

    if (!regExp.hasMatch(value)) {
      return 'Please enter a valid product URL';
    }

    return null;
  }

  Future<void> datePicker(TextEditingController con) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      con.text = DateFormat('dd/MM/yyyy').format(pickedDate);
    }
  }

  void _showAdvImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          title: const Text(
            'Select Adv Photo',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  _pickAdvImage(
                    ImageSource.camera,
                  );
                },
                label: const Text(
                  'Take a Photo',
                ),
                icon: const Icon(
                  Icons.camera,
                  // color: Colors.amber,
                ),
                iconAlignment: IconAlignment.start,
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  _pickAdvImage(
                    ImageSource.gallery,
                  );
                },
                label: const Text(
                  'Choose from Gallery',
                ),
                icon: const Icon(
                  Icons.photo_library,
                  // color: Colors.amber,
                ),
                iconAlignment: IconAlignment.start,
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                label: const Text(
                  'Cancel',
                ),
                icon: const Icon(
                  Icons.cancel,
                  // color: Colors.amber,
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void _pickAdvImage(ImageSource source) async {
    advImage = await ImagePicker().pickImage(
      source: source,
      imageQuality: 95,
    );

    if (advImage == null) {
      return;
    }

    _empPickedImageFileNotifier.value = File(advImage!.path);
  }

  Widget buildCurvyRectangle({
    required Widget child,
    required double all,
    required Color color,
    required double borderRadius,
  }) =>
      Container(
        padding: EdgeInsets.all(all),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: child,
      );

  Widget customElevatedButton({
    required String text,
    double? fontSize,
    Color? backgroundColor,
    Color? textColor,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: const Size.fromWidth(200),
          elevation: 5,
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
