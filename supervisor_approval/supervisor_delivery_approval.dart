import 'package:biz_infra/CustomWidgets/configurable_widgets.dart';
import 'package:biz_infra/Network/dio_service_client.dart';
import 'package:biz_infra/Themes/theme_controller.dart';
import 'package:biz_infra/Utils/constants.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart' show ImagePicker, ImageSource;
import 'package:intl/intl.dart' show DateFormat;
import 'package:permission_handler/permission_handler.dart'
    show Permission, PermissionActions, PermissionStatus, openAppSettings;

import 'ringer_popup.dart' show DeliveryApprovalRingerPopup;

class SupervisorDeliveryApproval extends StatefulWidget {
  final bool showAppBar;

  const SupervisorDeliveryApproval({this.showAppBar= true,super.key});

  @override
  State<SupervisorDeliveryApproval> createState() =>
      _SupervisorDeliveryApprovalState();
}

class _SupervisorDeliveryApprovalState
    extends State<SupervisorDeliveryApproval> {
  final _formKey = GlobalKey<FormState>();
  CountryCode _cCode = CountryCode.fromCountryCode('IN');
  final _mobileNoController = TextEditingController();
  final _visitorNameController = TextEditingController();
  final _vehicleNoController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _deliveryCompanyController = TextEditingController();
  final _blockController = TextEditingController();
  final _societyNoController = TextEditingController();
  final _photoAsBytes = ValueNotifier<List<int>>([]);
  late final _companyList = <String>[];
  late final _blockList = <String>[];
  late final _societyNoList = <String>[];

  @override
  void initState() {
    super.initState();
    _getDeliveryCompanies();
    _getBlocks();
    _getSocietyNumbers();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _disposeControllers() {
    _mobileNoController.dispose();
    _visitorNameController.dispose();
    _vehicleNoController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _deliveryCompanyController.dispose();
    _blockController.dispose();
    _societyNoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:widget.showAppBar ? AppBar(
        title: const Text('Delivery Approval'),
      ): null,
      body: SizedBox.expand(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                    ),
                    child: textField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _mobileNoController,
                      hintText: 'Enter Mobile Number *',
                      inputType: TextInputType.number,
                      maxLength: 10,
                      counterText: '',
                      labelText: 'Mobile Number *',
                      filled: true,
                      prefixIcon: CountryCodePicker(
                        initialSelection: _cCode.code,
                        onChanged: (value) {
                          setState(() {
                            _cCode = value;
                          });
                        },
                      ),
                      validator: (value) {
                        final regex = RegExp(r'^[6-9]\d{9}$');
                        if (value == null || value.isEmpty) {
                          return 'Please enter mobile number';
                        } else if (!regex.hasMatch(value)) {
                          return 'Please enter valid mobile number';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 16.0,
                    ),
                    child: textField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _visitorNameController,
                      textCapitalization: TextCapitalization.words,
                      inputType: TextInputType.text,
                      hintText: 'Enter your visitor name *',
                      labelText: 'Visitor Name *',
                      filled: true,
                      prefixIcon: const Icon(Icons.person),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z\s]')),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter visitor name';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 16.0,
                    ),
                    child: textField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _vehicleNoController,
                      textCapitalization: TextCapitalization.words,
                      inputType: TextInputType.text,
                      hintText: 'Enter your vehicle number',
                      labelText: 'Vehicle Number',
                      filled: true,
                      prefixIcon: const Icon(Icons.directions_car_outlined),
                      validator: (value) {
                        final regex =
                            RegExp(r'^[A-Z]{2}\s?\d{2}\s?[A-Z]{2}\s?\d{4}$');
                        if (value == null || value.isEmpty) {
                          return null;
                        } else if (!regex.hasMatch(value)) {
                          return 'Please enter valid vehicle number'
                              '\nEg. AB12CD3456 w/wo spaces';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 16.0,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: textField(
                            controller: _dateController,
                            textCapitalization: TextCapitalization.words,
                            inputType: TextInputType.text,
                            hintText: 'Enter Date *',
                            labelText: 'Date *',
                            filled: true,
                            prefixIcon: const Icon(Icons.today),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter date';
                              }
                              return null;
                            },
                            readOnly: true,
                            onTap: _pickDate,
                          ),
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Expanded(
                          child: textField(
                            controller: _timeController,
                            textCapitalization: TextCapitalization.words,
                            inputType: TextInputType.text,
                            hintText: 'Enter Time *',
                            labelText: 'Time *',
                            filled: true,
                            prefixIcon: const Icon(Icons.schedule),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter time';
                              }
                              return null;
                            },
                            readOnly: true,
                            onTap: _pickTime,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 16.0,
                    ),
                    child: dropdownUI(
                      context: context,
                      controller: _deliveryCompanyController,
                      hintText: 'Select Delivery Company *',
                      formLabel: 'Select Delivery Company *',
                      prefixIcon: const Icon(Icons.apartment),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select delivery company';
                        }
                        return null;
                      },
                      data: _companyList,
                      onChanged: (int? value) {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 16.0,
                    ),
                    child: dropdownUI(
                      context: context,
                      controller: _blockController,
                      hintText: 'Select Block *',
                      formLabel: 'Select Block *',
                      prefixIcon: const Icon(Icons.apartment),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select block';
                        }
                        return null;
                      },
                      data: _blockList,
                      onChanged: (int? value) {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 16.0,
                    ),
                    child: dropdownUI(
                      context: context,
                      controller: _societyNoController,
                      hintText: 'Select Society No. *',
                      formLabel: 'Select Society No. *',
                      prefixIcon: const Icon(Icons.apartment),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select society no.';
                        }
                        return null;
                      },
                      data: _societyNoList,
                      onChanged: (int? value) {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 16.0,
                    ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: ThemeController.selectedTheme == ThemeMode.dark
                            ? Colors.grey.shade800
                            : Colors.grey.shade300,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(
                                    left: 16.0,
                                  ),
                                  child: Text(
                                    'Photo',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                                ValueListenableBuilder(
                                  valueListenable: _photoAsBytes,
                                  builder: (context, photoAsBytes, child) {
                                    return Visibility(
                                      visible: photoAsBytes.isEmpty,
                                      replacement: TextButton.icon(
                                        icon: const Icon(
                                          Icons.delete_forever_rounded,
                                        ),
                                        label: const Text('Delete Photo'),
                                        onPressed: _deletePhoto,
                                      ),
                                      child: TextButton.icon(
                                        icon: const Icon(Icons.add_a_photo),
                                        label: const Text('Take Photo'),
                                        onPressed: _requestCameraAccess,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            const Divider(),
                            ValueListenableBuilder(
                              valueListenable: _photoAsBytes,
                              builder: (context, photoAsBytes, child) {
                                return Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Visibility(
                                    visible: photoAsBytes.isNotEmpty,
                                    replacement: const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text('No Image Selected'),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Image.memory(
                                        Uint8List.fromList(photoAsBytes),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  textButton(
                    onPressed: _onFormSubmit,
                    widget: const Text('Send Approval'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _getDeliveryCompanies() async {
    final result = await dioServiceClient.getDADeliveryCompanyPickList();
    final data = result.data;
    if (data != null) {
      final companies = data.deliverCompany;
      if (companies != null && companies.isNotEmpty) {
        _companyList
            .addAll(companies.map((e) => e.deliverCompany.toString()).toList());
      }
    }
  }

  Future<void> _getBlocks() async {
    final result = await dioServiceClient.getDABlockPickList();
    final data = result.data;
    if (data != null) {
      final blocks = data.deliverBlock;
      if (blocks != null && blocks.isNotEmpty) {
        _blockList
            .addAll(blocks.map((e) => e.deliverBlock.toString()).toList());
      }
    }
  }

  Future<void> _getSocietyNumbers() async {
    final result = await dioServiceClient.getDASocietyNoPickList();
    final data = result.data;
    if (data != null) {
      final societyNumbers = data.deliverSociety;
      if (societyNumbers != null && societyNumbers.isNotEmpty) {
        _societyNoList.addAll(
            societyNumbers.map((e) => e.deliverSociety.toString()).toList());
      }
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      currentDate: now,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1, now.month + 1, 0),
    );
    if (pickedDate != null) {
      _dateController.text = DateFormat('dd/MM/y').format(pickedDate);
    }
  }

  Future<void> _pickTime() async {
    final now = TimeOfDay.now();
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: now,
    );
    if (pickedTime != null && mounted) {
      _timeController.text = pickedTime.format(context);
    }
  }

  Future<void> _requestCameraAccess() async {
    final status = await Permission.camera.status;
    if (status != PermissionStatus.granted) {
      final requestStatus = await Permission.camera.request();
      if (requestStatus != PermissionStatus.granted) {
        await openAppSettings();
      } else {
        _takePhoto();
      }
    } else {
      _takePhoto();
    }
  }

  Future<void> _takePhoto() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      imageQuality: 25,
      source: ImageSource.camera,
    );
    if (pickedImage != null) {
      _photoAsBytes.value = await pickedImage.readAsBytes();
    }
  }

  void _deletePhoto() {
    _photoAsBytes.value = List<int>.empty();
  }

  Future<void> _onFormSubmit() async {
    if (Constants.userRole != 'Security Supervisor') {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
            content: const Text('Only Security Supervisor can create record'),
            title: const Text('Denied'),
          );
        },
      );
      return;
    }
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      final deliverMobile = _mobileNoController.text;
      final deliverName = _visitorNameController.text;
      final deliverVehicleNo = _vehicleNoController.text;
      final deliverDate = _dateController.text;
      final deliverTime = _timeController.text;
      final deliverCompany = _deliveryCompanyController.text;
      final deliverBlock = _blockController.text;
      final deliverSociety = _societyNoController.text;
      final imageBytes = _photoAsBytes.value;
      final success = await dioServiceClient.saveDeliveryApproval(
        deliveryDetails: {
          'deliver_mobile': deliverMobile,
          'deliver_name': deliverName,
          'deliver_vehicleno': deliverVehicleNo,
          'deliver_date': deliverDate,
          'deliver_time': deliverTime,
          'deliver_company': deliverCompany,
          'deliver_block': deliverBlock,
          'deliver_society': deliverSociety,
        },
        imageBytes: imageBytes,
      );
      if (success && mounted) {
        // Navigator.pop(context);
        form.reset();
        _deletePhoto();
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return DeliveryApprovalRingerPopup(
              deliveryName: deliverName,
              deliveryCompany: deliverCompany,
              block: deliverBlock,
              societyNo: deliverSociety,
            );
          },
        );
      } else {
        form.reset();
        _deletePhoto();
      }
    }
  }
}
