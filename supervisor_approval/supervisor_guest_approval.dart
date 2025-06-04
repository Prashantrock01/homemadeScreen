import 'dart:developer';
import 'dart:io';
import 'package:biz_infra/CustomWidgets/configurable_widgets.dart';
import 'package:biz_infra/Network/dio_service_client.dart';
import 'package:biz_infra/Utils/common_widget.dart';
import 'package:biz_infra/Utils/constants.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:permission_handler/permission_handler.dart' show Permission, PermissionActions, PermissionStatus, openAppSettings;
import '../../Model/ResidentDirectory/selected_resident_directory_model.dart';
import '../../Model/society_block_model.dart';
import '../../Model/society_name_model.dart';
import '../../Model/society_number_model.dart';
import 'ringer_popup.dart' show GuestApprovalRingerPopup;

class SupervisorGuestApproval extends StatefulWidget {
  final bool showAppBar;

  const SupervisorGuestApproval({this.showAppBar = true, super.key});

  @override
  State<SupervisorGuestApproval> createState() => _SupervisorGuestApprovalState();
}

class _SupervisorGuestApprovalState extends State<SupervisorGuestApproval> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  CountryCode _cCode = CountryCode.fromCountryCode('IN');
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController visitorNameController = TextEditingController();
  TextEditingController vehicleNoController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController blockController = TextEditingController();
  TextEditingController societyNoController = TextEditingController();
  final _photoAsBytes = ValueNotifier<List<int>>([]);
  List<SocietyBlocks> blockList = [];
  List<SocietyNoModel> societyNoList = [];

  List<ResidentModel>? residentList = [];

  SocietyBlocks? selectedBlock;
  SocietyNoModel? selectedSocietyNo;
  ResidentModel? selectedResident;
  String? selectedSocietyId;

  @override
  void initState() {
    super.initState();
    getBlocks();
    // getSocietyNumbers();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _disposeControllers() {
    mobileNoController.dispose();
    visitorNameController.dispose();
    vehicleNoController.dispose();
    dateController.dispose();
    timeController.dispose();
    blockController.dispose();
    societyNoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar ? AppBar(title: const Text('Guest Approval')) : null,
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: visitorNameController,
              textCapitalization: TextCapitalization.words,
              decoration: defaultInputDecoration(hintText: 'Visitor name', labelText: 'Visitor name', prefix: const Icon(Icons.person)),
              keyboardType: TextInputType.text,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter visitor name';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: mobileNoController,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              decoration: defaultInputDecoration(
                  hintText: 'Mobile Number',
                  labelText: 'Mobile Number',
                  prefix: CountryCodePicker(
                    initialSelection: _cCode.code,
                    onChanged: (value) {
                      setState(() {
                        _cCode = value;
                      });
                    },
                  )),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
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
            const SizedBox(height: 8),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: vehicleNoController,
              textCapitalization: TextCapitalization.words,
              decoration: defaultInputDecoration(labelText: 'Vehicle Number', hintText: 'Vehicle Number', prefix: const Icon(Icons.directions_car_outlined)),
              keyboardType: TextInputType.text,
              validator: (value) {
                final regex = RegExp(r'^[A-Z]{2}\s?\d{2}\s?[A-Z]{2}\s?\d{4}$');
                if (value == null || value.isEmpty) {
                  return null;
                } else if (!regex.hasMatch(value)) {
                  return 'Please enter valid vehicle number'
                      '\nEg. AB12CD3456 w/wo spaces';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<SocietyBlocks>(
              value: selectedBlock,
              hint: const Text('Select block'),
              decoration: defaultInputDecoration(prefix: const Icon(Icons.apartment)),
              validator: (value) {
                if (value == null) {
                  return 'Please Select block';
                }
                return null;
              },
              items: blockList.map((e) {
                return DropdownMenuItem<SocietyBlocks>(
                  value: e,
                  child: Text(e.blockname!),
                );
              }).toList(),
              onChanged: (SocietyBlocks? value) {
                selectedBlock = value;
                setState(() {});
                societyNoList.clear();
                getSocietyNumbers();
              },
            ),
            if (selectedBlock != null)
              Column(
                children: [
                  const SizedBox(height: 8),
                  DropdownButtonFormField<SocietyNoModel>(
                    value: selectedSocietyNo,
                    hint: const Text('Society no.'),
                    decoration: defaultInputDecoration(prefix: const Icon(Icons.apartment)),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select society no.';
                      }
                      return null;
                    },
                    items: societyNoList.map((e) {
                      return DropdownMenuItem<SocietyNoModel>(
                        value: e,
                        child: Text(e.platname!),
                      );
                    }).toList(),
                    onChanged: (SocietyNoModel? value) {
                      selectedSocietyNo = value;
                      setState(() {});
                      getResidentCall();
                    },
                  ),
                ],
              ),
            if (selectedBlock != null && residentList != null)
              Column(
                children: [
                  const SizedBox(height: 8),
                  DropdownButtonFormField<ResidentModel>(
                    value: selectedResident,
                    hint: const Text('Owner/Tenant'),
                    decoration: defaultInputDecoration(prefix: const Icon(Icons.apartment)),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select Owner/Tenant';
                      }
                      return null;
                    },
                    items: residentList!.map((e) {
                      return DropdownMenuItem<ResidentModel>(
                        value: e,
                        child: Text('${e.residentName}(${e.typeResident})'),
                      );
                    }).toList(),
                    onChanged: (ResidentModel? value) {
                      selectedResident = value;
                      setState(() {});
                    },
                  ),
                ],
              ),
            Container(
              // height: 270,
              width: (MediaQuery.of(context).size.width - 40) / 2,
              margin: const EdgeInsets.only(top: 8, bottom: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(16)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Photo', style: TextStyle(fontSize: 16.0)),
                      ValueListenableBuilder(
                        valueListenable: _photoAsBytes,
                        builder: (context, photoAsBytes, child) {
                          return Visibility(
                            visible: photoAsBytes.isEmpty,
                            replacement: TextButton.icon(
                              icon: const Icon(Icons.delete_forever_rounded),
                              label: const Text('Delete Photo'),
                              onPressed: () => _photoAsBytes.value = List<int>.empty(),
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
                      return Visibility(
                        visible: photoAsBytes.isNotEmpty,
                        replacement: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text('No Image Selected'),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.memory(
                            height: 186,
                            Uint8List.fromList(photoAsBytes),
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            textButton(
              onPressed: _onFormSubmit,
              widget: const Text('Send Approval'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getBlocks() async {
    EasyLoading.show(status: 'Loading');
    try {
      SocietyNameModel? response = await dioServiceClient.societyName();
      if (response?.statuscode == 1) {
        selectedSocietyId = response!.data!.accountsData!.first.id;

        final result = await dioServiceClient.societyBlock(response!.data!.accountsData!.first.id!);
        final data = result!.data;
        if (data != null) {
          List<SocietyBlocks>? blocks = data.filteredData!.first.records;
          if (blocks != null && blocks.isNotEmpty) {
            blockList.addAll(blocks.map((e) => e).toList());
          }
        }
        setState(() {});
      }
    } catch (e) {
      log('Error $e');
      rethrow;
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> getSocietyNumbers() async {
    EasyLoading.show(status: 'Loading');
    try {
      final result = await dioServiceClient.societyNumber(selectedSocietyId!, selectedBlock!.socblocksid!);
      final data = result!.data;
      if (data != null) {
        final societyNumbers = data.filteredData!.first.records;
        if (societyNumbers != null && societyNumbers.isNotEmpty) {
          societyNoList.addAll(societyNumbers.map((e) => e).toList());
        }
        setState(() {});
      }
    } catch (e) {
      log("Error $e");
      rethrow;
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> getResidentCall() async {
    EasyLoading.show(status: 'Loading');
    try {
      final result = await dioServiceClient.getSelectedResidentDirectory(selectBlock: selectedBlock!.blockname!);
      final data = result!.data;
      if (data != null) {
        final societyResident = data.records!;
        if (societyResident != null && societyResident.isNotEmpty) {
          residentList!.addAll(societyResident.map((e) => e).toList());
        }

        if (residentList != null && residentList!.length <= 1) {
          selectedResident = residentList!.first;
        }

        setState(() {});
      }
    } catch (e) {
      log("Error $e");
      rethrow;
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> _requestCameraAccess() async {
    final status = await Permission.camera.status;
    if (status != PermissionStatus.granted) {
      final requestStatus = await Permission.camera.request();
      if (requestStatus != PermissionStatus.granted) {
        await openAppSettings();
      } else {
        File? captureImage = await takePhoto(() {
          setState(() {});
        });
        _photoAsBytes.value = await captureImage!.readAsBytes();
      }
    } else {
      File? captureImage = await takePhoto(() {
        setState(() {});
      });
      _photoAsBytes.value = await captureImage!.readAsBytes();
    }
  }

  // Future<void> _takePhoto() async {
  //   final imagePicker = ImagePicker();
  //   final pickedImage = await imagePicker.pickImage(
  //     imageQuality: 25,
  //     source: ImageSource.camera,
  //   );
  //   if (pickedImage != null) {
  //     _photoAsBytes.value = await pickedImage.readAsBytes();
  //   }
  // }

  // void _deletePhoto() {
  //   _photoAsBytes.value = List<int>.empty();
  // }

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
    final form = formKey.currentState;
    if (form != null && form.validate()) {
      final guestMobile = mobileNoController.text;
      final guestName = visitorNameController.text;
      final guestVehicleNo = vehicleNoController.text;
      final guestDate = dateController.text;
      final guestTime = timeController.text;
      final block = blockController.text;
      final societyNo = societyNoController.text;
      final imageBytes = _photoAsBytes.value;
      final success = await dioServiceClient.saveGuestApproval(
        guestDetails: {
          'guest_mobile': guestMobile,
          'guest_name': guestName,
          'guest_vehicle_no': guestVehicleNo,
          'guest_date': guestDate,
          'guest_time': guestTime,
          'block': block,
          'society_no': societyNo,
        },
        imageBytes: imageBytes,
      );
      if (success && mounted) {
        // Navigator.pop(context);
        form.reset();
        _photoAsBytes.value = List<int>.empty();
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return GuestApprovalRingerPopup(
              guestName: guestName,
              block: block,
              societyNo: societyNo,
            );
          },
        );
      } else {
        form.reset();
        _photoAsBytes.value = List<int>.empty();
      }
    }
  }
}
