// ignore_for_file: invalid_use_of_protected_member

import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:biz_infra/CustomWidgets/configurable_widgets.dart';
import 'package:biz_infra/Model/employee_registration/dropdowns/employee_block_dropdown_modal.dart';
import 'package:biz_infra/Model/employee_registration/dropdowns/employee_role_dropdown_modal.dart';
import 'package:biz_infra/Model/employee_registration/dropdowns/employee_role_userwise_dropdown_modal.dart';
import 'package:biz_infra/Model/employee_registration/dropdowns/employee_society_dropdown_modal.dart';
import 'package:biz_infra/Network/dio_service_client.dart';
import 'package:biz_infra/Utils/constants.dart';

// import 'package:biz_infra/Screens/registration/employee_registration/employee_registration_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';

import '../../../Utils/common_widget.dart';
import 'employee_registration_list.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as imglib;

class EmployeeRegistration extends StatefulWidget {
  const EmployeeRegistration({super.key});

  @override
  State<EmployeeRegistration> createState() => _EmployeeRegistrationState();
}

class _EmployeeRegistrationState extends State<EmployeeRegistration> {
  // final DioServiceClient _dioClient = DioServiceClient();

  final _formKey = GlobalKey<FormState>();

  final _employeeNameController = TextEditingController();
  final _mobileNoController = TextEditingController();
  final _emailIDController = TextEditingController();
  final _aadharNoController = TextEditingController();
  final _roleController = TextEditingController();
  final _societyController = TextEditingController();
  final _blockController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  final _weekOffController = TextEditingController();

  // final _setPasswordController = TextEditingController();
  // final _reTypePasswordController = TextEditingController();

  final RxList<File> _imagesNotifier = <File>[].obs;
  final ValueNotifier<File?> _empPickedImageFileNotifier =
      ValueNotifier<File?>(null);

  List<XFile>? imageList = [];

  XFile? empImage;

  final _scrollController = ScrollController();

  RxList<dynamic>? employeeRole = [].obs;
  RxList<dynamic>? employeeRoleUserwise = [].obs;
  RxList<dynamic>? employeeSociety = [].obs;
  RxList<dynamic>? employeeBlock = [].obs;

  bool passwordObscureText = true;
  bool retypePasswordObscureText = true;

  @override
  void initState() {
    super.initState();
    callEmployeeRoleUserwise();
    callEmployeeSociety();
    callEmployeeBlock();
    // Added a listener to role controller to update email field visibility on role change
    _roleController.addListener(() {
      setState(() {});
    });
  }

  void callEmployeeRole() async {
    EmployeeRoleDropdownModal? response =
        await dioServiceClient.getEmployeeRole();
    if (response?.statuscode == 1) {
      // Roles to exclude based on Constants.userRole
      List<String> excludedRoles = [];

      if (Constants.userRole == "Security Supervisor") {
        excludedRoles = [
          "Super Admin",
          "Facility Manager",
          "Treasury",
          "President",
          "Vice President",
          "Secretary"
        ];
      } else if (Constants.userRole == "Facility Manager") {
        excludedRoles = [
          "Super Admin",
          "Treasury",
          "President",
          "Vice President",
          "Secretary"
        ];
      }

      // Filter roles based on the exclusion list
      employeeRole!.value = response?.data?.subServiceManagerRole
              ?.where((x) =>
                  !excludedRoles.contains(x.subServiceManagerRole.toString()))
              .map((x) => x.subServiceManagerRole.toString())
              .toList() ??
          [];
    }
  }

  void callEmployeeRoleUserwise() async {
    EmployeeRoleUserwiseDropdownModal? response =
        await dioServiceClient.getEmployeeRoleUserwise();
    if (response?.statuscode == 1) {
      employeeRoleUserwise!.value = response?.data?.subServiceManagerRole
              ?.map((x) => x.subServiceManagerRole.toString())
              .toList() ??
          [];
    }
  }

  void callEmployeeSociety() async {
    EmployeeSocietyDropdownModal? response =
        await dioServiceClient.getEmployeeSociety();
    if (response?.statuscode == 1) {
      employeeSociety!.value = response?.data?.empSociety
              ?.map((x) => x.empSociety.toString())
              .toList() ??
          [];
    }
  }

  void callEmployeeBlock() async {
    EmployeeBlockDropdownModal? response =
        await dioServiceClient.getEmployeeBlock();
    if (response?.statuscode == 1) {
      employeeBlock!.value = response?.data?.empBlock
              ?.map((x) => x.empBlock.toString())
              .toList() ??
          [];
    }
  }

  // bool isEmailVisible() {
  //   return !['Plumber', 'Electrician', 'House Keeping']
  //       .contains(_roleController.text);
  // }

  bool isRoleVisible() {
    return !['Treasury', 'President', 'Vice President', 'Secretary']
        .contains(_roleController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Employee Registration'),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 20),
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 60,
                        child: ValueListenableBuilder<File?>(
                          valueListenable: _empPickedImageFileNotifier,
                          builder: (context, file, child) {
                            return CircleAvatar(
                              radius: 60,
                              foregroundImage:
                                  file != null ? FileImage(file) : null,
                            );
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: buildCircle(
                          all: 3,
                          color: Colors.black,
                          child: buildCircle(
                            all: 8,
                            color: Colors.amberAccent,
                            child: GestureDetector(
                              onTap: _showEmpImageSourceDialog,
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
                  controller: _employeeNameController,
                  labelText: 'Employee Name *',
                  hintText: 'Please enter name',
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z\s]+$')),
                  ],
                  validator: (value) =>
                      value!.isEmpty ? 'please enter an employee name' : null,
                  inputType: TextInputType.name,
                  prefixIcon: const Icon(Icons.person),
                ),
                const SizedBox(
                  height: 15,
                ),
                textField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _mobileNoController,
                  labelText: 'Mobile Number *',
                  hintText: 'Please enter mobile number',
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: hasValidMobileNumber,
                  inputType: TextInputType.number,
                  prefixIcon: const Icon(Icons.call),
                  maxLength: 10,
                  counterText: "",
                ),
                const SizedBox(
                  height: 15,
                ),
                textField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _aadharNoController,
                  labelText: 'Aadhar Number *',
                  hintText: 'Please enter aadhar number',
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: validateAadharNumber,
                  inputType: TextInputType.number,
                  prefixIcon: const Icon(Icons.description),
                  maxLength: 12,
                  counterText: "",
                ),
                const SizedBox(
                  height: 15,
                ),
                TextButton.icon(
                  onPressed: _showAlertDialog,
                  label: const Text(
                    'Upload Aadhar',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      letterSpacing: 1.4,
                    ),
                  ),
                  icon: const Icon(
                    Icons.upload_file_outlined,
                    // color: Colors.black,
                  ),
                  iconAlignment: IconAlignment.start,
                ),
                Obx(() {
                  return Visibility(
                    visible: _imagesNotifier
                        .isNotEmpty, // Show GridView only if there are images
                    child: Container(
                      margin: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.0),
                        border: Border.all(
                          color: Colors.grey,
                          width: 2.0,
                        ),
                      ),
                      child: Scrollbar(
                        controller: _scrollController,
                        thumbVisibility: true,
                        thickness: 4.0,
                        child: GridView.builder(
                          controller: _scrollController,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 12 / 16,
                            crossAxisCount: 3,
                            mainAxisSpacing: 4.0,
                          ),
                          padding: const EdgeInsets.all(10.0),
                          itemCount: _imagesNotifier.length,
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      _openFullImageDialog(
                                          _imagesNotifier[index]);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 2.0,
                                        ),
                                      ),
                                      child: Image.file(
                                        _imagesNotifier[index],
                                        fit: BoxFit.cover,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.4,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () {
                                      _removeImage(index);
                                    },
                                    child: const Icon(
                                      Icons.delete_sweep,
                                      color: Color.fromARGB(255, 202, 43, 32),
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(
                  height: 15,
                ),
                Obx(
                  () => dropdownUI(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    context: context,
                    controller: _roleController,
                    formLabel: 'Role',
                    labelText: 'Role *',
                    hintText: 'Select Role',
                    prefixIcon: const Icon(Icons.person),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select role';
                      }
                      return null;
                    },
                    data: employeeRoleUserwise!.value.cast(),
                    // Use employeeRole directly
                    onChanged: (int? value) {},
                  ),
                ),
                // textField(
                //   autovalidateMode: AutovalidateMode.onUserInteraction,
                //   controller: _roleController,
                //   labelText: 'Role *',
                //   hintText: 'Select Role',
                //   onTap: roleDropdown,
                //   validator: (value) =>
                //       value!.isEmpty ? 'please select a role' : null,
                //   readOnly: true,
                //   inputType: TextInputType.none,
                //   prefixIcon: const Icon(Icons.person),
                //   suffixIcon: const Icon(
                //     Icons.arrow_drop_down_circle_outlined,
                //     size: 25.0,
                //   ),
                // ),
                const SizedBox(
                  height: 15,
                ),
                // Email Field (conditionally visible)
                textField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _emailIDController,
                  labelText: 'Email ID',
                  hintText: 'Please enter email id',
                  validator: validateEmail,
                  inputType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email),
                ),
                const SizedBox(
                  height: 15,
                ),
                textField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _societyController..text = Constants.societyName,
                  labelText: 'Society *',
                  hintText: 'Select Society',
                  readOnly: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your society';
                    }
                    return null;
                  },
                  inputType: TextInputType.text,
                  prefixIcon: const Icon(Icons.apartment_rounded),
                ),
                // Obx(
                //   () => dropdownUI(
                //     autovalidateMode: AutovalidateMode.onUserInteraction,
                //     context: context,
                //     controller: _societyController,
                //     formLabel: 'Society',
                //     labelText: 'Society *',
                //     hintText: 'Select Society',
                //     prefixIcon: const Icon(Icons.apartment_rounded),
                //     validator: (value) {
                //       if (value == null || value.isEmpty) {
                //         return 'Please select your society';
                //       }
                //       return null;
                //     },
                //     data: employeeSociety!.value.cast(),
                //     // Use employeeRole directly
                //     onChanged: (int? value) {},
                //   ),
                // ),
                const SizedBox(
                  height: 15,
                ),
                Obx(
                  () => dropdownUI(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    context: context,
                    controller: _blockController,
                    formLabel: 'Block',
                    labelText: 'Block *',
                    hintText: 'Select Block',
                    prefixIcon: const Icon(Icons.apartment_rounded),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select your block';
                      }
                      return null;
                    },
                    data: employeeBlock!.value.cast(),
                    // Use employeeRole directly
                    onChanged: (int? value) {},
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Visibility(
                  visible: isRoleVisible(),
                  child: Column(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Shift Timings',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            letterSpacing: 1.4,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: textField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: _startTimeController,
                              labelText: 'Start Time *',
                              hintText: 'Enter Start Time',
                              onTap: () => timePicker(_startTimeController),
                              validator: (value) => value!.isEmpty
                                  ? 'please enter start time'
                                  : null,
                              readOnly: true,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: textField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: _endTimeController,
                              labelText: 'End Time *',
                              hintText: 'Enter End Time',
                              onTap: () => timePicker(_endTimeController),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter end time';
                                } else if (_startTimeController.text ==
                                    _endTimeController.text) {
                                  return 'End time cant match';
                                }
                                return null;
                              },
                              readOnly: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      textField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _weekOffController,
                        labelText: 'Week Off *',
                        hintText: 'Enter Week Off',
                        onTap: () => weekdayPicker(context, _weekOffController),
                        validator: (value) =>
                            value!.isEmpty ? 'please enter week off' : null,
                        readOnly: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                // Visibility(
                //   visible: isEmailVisible(),
                //   child: Column(
                //     children: [
                //       textField(
                //         autovalidateMode: AutovalidateMode.onUserInteraction,
                //         controller: _setPasswordController,
                //         labelText: 'Set Password',
                //         hintText: 'Enter password',
                //         validator: null,
                //         inputType: TextInputType.visiblePassword,
                //         prefixIcon: const Icon(Icons.lock),
                //         suffixIcon: InkWell(
                //           onTap: togglePasswordView,
                //           child: Padding(
                //             padding: const EdgeInsets.only(right: 5.0),
                //             child: Icon(
                //               passwordObscureText
                //                   ? Icons.visibility_off
                //                   : Icons.visibility,
                //               color: const Color(0xff707070),
                //             ),
                //           ),
                //         ),
                //       ),
                //       const SizedBox(
                //         height: 15,
                //       ),
                //       textField(
                //         autovalidateMode: AutovalidateMode.onUserInteraction,
                //         controller: _reTypePasswordController,
                //         labelText: 'Re-Type Password',
                //         hintText: 'Enter password again',
                //         validator: null,
                //         inputType: TextInputType.visiblePassword,
                //         prefixIcon: const Icon(Icons.lock),
                //         suffixIcon: InkWell(
                //           onTap: toggleRetypePasswordView,
                //           child: Padding(
                //             padding: const EdgeInsets.only(right: 5.0),
                //             child: Icon(
                //               passwordObscureText
                //                   ? Icons.visibility_off
                //                   : Icons.visibility,
                //               color: const Color(0xff707070),
                //             ),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                textButton(
                  widget: const AutoSizeText('Submit'),
                  //fontSize: 20,
                  onPressed: () async {
                    if (empImage == null) {
                      // Show an error message if no image is selected
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
                      return; // Stop further execution if form validation fails
                    }

                    try {
                      var employeeRegistrationResponse = await dioServiceClient.submitEmployee(
                        serviceEngineerName: _employeeNameController.text,
                        phone: _mobileNoController.text,
                        aadharNo: _aadharNoController.text,
                        subServiceManagerRole: _roleController.text,
                        email: _emailIDController.text.isNotEmpty
                            ? _emailIDController.text
                            : null,
                        empSociety: _societyController.text,
                        empBlock: _blockController.text,
                        empStartTime: _startTimeController.text,
                        empEndTime: _endTimeController.text,
                        empWeakOff: _weekOffController.text,
                        imageList: imageList ?? [],
                        image: empImage,
                      );

                      if (employeeRegistrationResponse!.statuscode == 1) {
                        Get.close(1);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const EmployeeRegistrationList()));
                        //Get.off(()=> const EmployeeRegistrationList());
                        //Get.back(result: true);
                        // Get.close(1);
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (BuildContext context) =>
                        //         const EmployeeRegistrationList(),
                        //   ),
                        // );
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.success,
                          title: 'User successfully registered',
                          widget: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ), // Default style
                              children: [
                                const TextSpan(
                                  text:
                                      'Your Approval is pending from the admin.',
                                ),
                                const TextSpan(
                                  text: 'Your Employee Id is - ',
                                ),
                                TextSpan(
                                  text:
                                      '${employeeRegistrationResponse.data?.record!.badgeNo}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        // Display the status message from the response
                        Get.snackbar(
                          "Oops!",
                          employeeRegistrationResponse.statusMessage!,
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
                        "Oops!! Failed to register user",
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );

  Future<void> timePicker(TextEditingController con) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      // Create a dummy DateTime to format the time properly
      DateTime fullDateTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        pickedTime.hour,
        pickedTime.minute,
      );
      con.text = DateFormat('hh:mm a').format(fullDateTime);
    }
  }

  Future<void> weekdayPicker(
      BuildContext context, TextEditingController con) async {
    // List of weekdays
    List<String> weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    // Show the modal bottom sheet for selecting a weekday
    showModalBottomSheet(
      showDragHandle: true,
      enableDrag: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 300, // Set a height for the bottom sheet
          child: Column(
            children: [
              const Text(
                'Select a Day',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20), // Add space
              Expanded(
                child: ListView.builder(
                  itemCount: weekdays.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(weekdays[index]),
                      onTap: () {
                        // Update the TextEditingController with the selected weekday
                        con.text = weekdays[index];
                        Navigator.pop(context); // Close the bottom sheet
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String? hasValidMobileNumber(String? value) {
    final mobileNumberRegex = RegExp(r'^(\+\d{1,3}?)?\d{10}$');
    if (value == null || value.isEmpty) {
      return 'Please enter a valid mobile number';
    } else if (!mobileNumberRegex.hasMatch(value)) {
      return 'Mobile number must be 10 digits';
    }
    return null;
  }

  String? validateEmail(String? value) {
    String pattern = r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]"
        r"(?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?"
        r"(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);

    if (value == null || value.isEmpty) {
      return null;
    }

    if (!regex.hasMatch(value)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  String? validateAadharNumber(String? value) {
    final aadharRegex = RegExp(r'^[2-9]{1}[0-9]{11}$');
    if (value == null || value.isEmpty) {
      return 'Please enter a valid Aadhar number';
    } else if (!aadharRegex.hasMatch(value)) {
      return 'Aadhar number must be 12 digits';
    }
    return null;
  }

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          title: const Text(
            'Add a photo',
            style: TextStyle(
              fontSize: 20,
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
                  _pickImage();
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
                  _pickImages();
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

  Future<File?> _compressImage(File file) async {
    final dir = await getTemporaryDirectory();
    final targetPath = '${dir.path}/compressed_${file.uri.pathSegments.last}';

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 80, // Adjust quality as needed
    );

    return result != null ? File(result.path) : null;
  }

  Future<void> _pickImage() async {
    XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      File originalFile = File(pickedImage.path);

      // Compress the image
      File? compressedImage = await _compressImage(originalFile);

      if (compressedImage != null &&
          await compressedImage.length() < 3 * 1024 * 1024) {
        // Add the compressed image to the list
        imageList?.add(XFile(compressedImage.path));

        final updatedImages = List<File>.from(_imagesNotifier.value)
          ..add(compressedImage);
        _imagesNotifier.value = updatedImages;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          //   content: Text('Image selected and compressed successfully.'),
          // ));
        });
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Image is too large, please try again.'),
          ));
        });
      }
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('No image selected from Camera.'),
        ));
      });
    }
  }

  Future<void> _pickImages() async {
    List<XFile>? pickedImages = await ImagePicker().pickMultiImage();

    if (pickedImages.isNotEmpty) {
      imageList?.addAll(pickedImages);

      final updatedImages = List<File>.from(_imagesNotifier.value)
        ..addAll(pickedImages.map((xFile) => File(xFile.path)));
      _imagesNotifier.value = updatedImages;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Images selected from Gallery.'),
        ));
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('No images selected from Gallery.'),
        ));
      });
    }
  }

  void _openFullImageDialog(File imageFile) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shadowColor: Colors.blueAccent,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
          backgroundColor: Colors.white,
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InteractiveViewer(child: Image.file(imageFile)),
                  // Add any buttons or additional widgets below the image if needed
                ],
              ),
              // Positioned close button at the top-right
              Positioned(
                top: 10.0,
                right: 10.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _removeImage(int index) {
    // Remove the image directly from the RxList
    final removedImage = _imagesNotifier[index];
    _imagesNotifier.removeAt(index);

    // Update the actual advImageList to ensure consistency
    imageList = List<XFile>.from(_imagesNotifier);

    // Show snackbar after removing the image
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Image removed: ${removedImage.path}'),
        // backgroundColor: Colors.amber,
      ),
    );
  }

  void _pickEmpImage(ImageSource source) async {
    empImage = await ImagePicker().pickImage(
      source: source,
      imageQuality: 95,
    );

    if (empImage == null) {
      return;
    }
    /*
    * Below method is added for fix iOS face detection issue and moved commented two line in new method
    * */
    getImageAndDetectFaces(empImage!);

    // bool? isFaceDetected =
    //     await detectHumanFaces(context, File(empImage!.path));
    //
    // if (isFaceDetected)
    //   _empPickedImageFileNotifier.value = File(empImage!.path);
  }

  //iOS face detection fixes start
  Future getImageAndDetectFaces(XFile imageFile) async {
    try {
      if (Platform.isIOS) {
        await Future.delayed(const Duration(milliseconds: 1000));
      }

      List<Face> faces = await processPickedFile(imageFile);

      if (faces.isEmpty) {
        return false;
      }

      double screenWidth = MediaQuery.of(context).size.width;
      double screenHeight = MediaQuery.of(context).size.height;
      final radius = screenWidth * 0.35;
      Rect rectOverlay = Rect.fromLTRB(
        screenWidth / 2 - radius,
        screenHeight / 3.5 - radius,
        screenWidth / 2 + radius,
        screenHeight / 2.5 + radius,
      );

      for (Face face in faces) {
        final Rect boundingBox = face.boundingBox;
        if (boundingBox.bottom < rectOverlay.top ||
            boundingBox.top > rectOverlay.bottom ||
            boundingBox.right < rectOverlay.left ||
            boundingBox.left > rectOverlay.right) {
          return false;
        }
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  processPickedFile(XFile pickedFile) async {
    final path = pickedFile.path;

    InputImage inputImage;
    if (Platform.isIOS) {
      final File? iosImageProcessed = await bakeImageOrientation(pickedFile);
      if (iosImageProcessed == null) {
        return [];
      }
      inputImage = InputImage.fromFilePath(iosImageProcessed.path);
    } else {
      inputImage = InputImage.fromFilePath(path);
    }
    bool? isFaceDetected =
    await detectHumanFaces(context, File(inputImage.filePath??''));

    if (isFaceDetected)
      _empPickedImageFileNotifier.value = File(empImage!.path);

    // List<Face> faces = await faceDetector.processImage(File(empImage!.path));
    // print('Found ${faces.length} faces for picked file');
    // return faces;
  }

  Future<File?> bakeImageOrientation(XFile pickedFile) async {
    if (Platform.isIOS) {
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;
      final filename = DateTime.now().millisecondsSinceEpoch.toString();

      final imglib.Image? capturedImage =
      imglib.decodeImage(await File(pickedFile.path).readAsBytes());

      if (capturedImage == null) {
        return null;
      }

      final imglib.Image orientedImage = imglib.bakeOrientation(capturedImage);

      File imageToBeProcessed = await File('$path/$filename')
          .writeAsBytes(imglib.encodeJpg(orientedImage));

      return imageToBeProcessed;
    }
    return null;
  }
  //iOS face detection fixes end

  void _showEmpImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          title: const Text(
            'Select Employee Photo',
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
                  _pickEmpImage(
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
              // TextButton.icon(
              //   onPressed: () {
              //     Navigator.of(context).pop(); // Close the dialog
              //     _pickEmpImage(
              //       ImageSource.gallery,
              //     );
              //   },
              //   label: const Text(
              //     'Choose from Gallery',
              //   ),
              //   icon: const Icon(
              //     Icons.photo_library,
              //     // color: Colors.amber,
              //   ),
              //   iconAlignment: IconAlignment.start,
              // ),
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
