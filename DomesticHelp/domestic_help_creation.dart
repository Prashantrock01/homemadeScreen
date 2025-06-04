import 'dart:developer';
import 'dart:io';

import 'package:biz_infra/Model/DomesticHelp/DomesticHelpTypeModel.dart';
import 'package:biz_infra/Model/DomesticHelp/time_slot_model.dart';
import 'package:biz_infra/Network/dio_service_client.dart';

// import 'package:biz_infra/Themes/theme_controller.dart';
import 'package:country_code_picker/country_code_picker.dart';

// import 'package:country_pickers/country.dart';
// import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';

// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
import '../../Model/DomesticHelp/DomesticBlockModel.dart';
import '../../Model/DomesticHelp/DomesticDocumentModel.dart';
import '../../Model/DomesticHelp/domestic_help_detail_model.dart';
import '../../Model/DomesticHelp/domestic_help_society_model.dart';
import '../../Model/DomesticHelp/save_domestic_help_model.dart';
import '../../Utils/app_styles.dart';
import '../../Utils/common_widget.dart';
import '../../Utils/constants.dart';

class DomesticHelpCreation extends StatefulWidget {
  final bool? isUpdate;
  final String? recordId;

  DomesticHelpCreation({this.recordId, this.isUpdate = false});

  @override
  _DomesticHelpCreationState createState() => _DomesticHelpCreationState();
}

class _DomesticHelpCreationState extends State<DomesticHelpCreation> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isUpdate = false;

  List<dynamic> _faces = [];

  String? approvalStatus = Constants.pending;
  final RxBool _showProgress = false.obs;
  List<String> domesticList = [];
  String? selectedDomestic;

  String selectedCountryCode = '+91';
  String selectedCountryIso = 'IN';

  // List<documentModel> documentTypeList = [
  //   documentModel(docName: 'Aadhaar Card', docRegex: RegExp(r'^\d{12}$')),
  //   documentModel(docName: 'Pan Card', docRegex: RegExp(r'^[A-Z]{5}\d{4}[A-Z]$')),
  //   documentModel(docName: 'Voter ID', docRegex: RegExp(r'^[A-Z]{2}\d{7}$')),
  //   documentModel(docName: 'Driving Licence', docRegex: RegExp(r'^[A-Z]{2}\d{2}\s\d{11}$')),
  // ];

  List<String> documentTypeList = [];
  String? selectedDocumentType;

  List<String> availableSelectedTimeSlot = [];
  List<String> workSelectedTimeSlot = [];

  List<String> blockList = [];

  // String? selectedBlock;

  List<String> societyNoList = [];

  // String? selectedSocietyNo;

  File? image;
  String? imagePic;
  File? selectedFrontDocImage;
  String? frontDocImage;
  File? selectedBackDocImage;
  String? backDocImage;

  TextEditingController nameController = TextEditingController();
  TextEditingController mobController = TextEditingController();
  TextEditingController docNumController = TextEditingController();

  // TextEditingController vehicleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _showProgress.value = true;
    getAllDropDownData();
  }

  getAllDropDownData() async {
    await getDomesticHelpType();
    await getDomesticHelpSociety();
    await getDomesticHelpBlock();
    await getDomesticHelpDocument();
    await getRecordDetail();
  }

  getDomesticHelpType() async {
    try {
      DomesticHelpTypeModel? response = await dioServiceClient.getDomesticHelpTypeApi();
      if (response!.statuscode == 1) {
        if (response.data!.domhelpType != null) {
          for (var e in response.data!.domhelpType!) {
            domesticList.add(e.domhelpType.toString());
            setState(() {});
          }
        }
      }
    } catch (e) {
      return e;
    }
  }

  getDomesticHelpSociety() async {
    try {
      DomesticSocietyModel? response = await dioServiceClient.getDomesticHelpSocietyApi();
      if (response!.statuscode == 1) {
        if (response.data!.domhelpSociety != null) {
          for (var e in response.data!.domhelpSociety!) {
            societyNoList.add(e.domhelpSociety.toString());
            setState(() {});
          }
        }
      }
    } catch (e) {
      return e;
    }
  }

  getDomesticHelpBlock() async {
    try {
      DomesticBlockModel? response = await dioServiceClient.getDomesticHelpBlockApi();
      if (response!.statuscode == 1) {
        if (response.data!.domhelpBlock != null) {
          for (var e in response.data!.domhelpBlock!) {
            blockList.add(e.domhelpBlock.toString());
            setState(() {});
          }
        }
      }
    } catch (e) {
      return e;
    }
  }

  getDomesticHelpDocument() async {
    try {
      DomesticDocumentModel? response = await dioServiceClient.getDomesticHelpDocApi();
      if (response?.statuscode == 1) {
        if (response!.data?.domhelpDocType != null) {
          for (var e in response.data!.domhelpDocType!) {
            documentTypeList.add(e.domhelpDocType.toString());
            setState(() {});
          }
        }
      }
    } catch (e) {
      log("Error: $e");
    }
    _showProgress.value = false;
    setState(() {});
  }

  getRecordDetail() async {
    if (widget.isUpdate == true) {
      try {
        DomesticDetailModel? response = await dioServiceClient.getDomesticHelpDetailApi(recordId: widget.recordId);
        if (response!.statuscode == 1) {
          selectedDomestic = response.data!.record!.domhelpType.toString();
          nameController.text = response.data!.record!.domhelpName.toString();

          await separateCountryCode(response.data!.record!.domhelpNumber!);
          selectedDocumentType = response.data!.record!.domhelpDocType!.toString();
          docNumController.text = response.data!.record!.domhelpDocnumber!.toString();
          // vehicleController.text = response.data!.record!.domhelpVehicleno.toString();
          availableSelectedTimeSlot = response.data!.record!.domhelpTimeslot!.replaceAll('[', '').replaceAll(']', '').split(', ');
          // selectedBlock = response.data!.record!.domhelpBlock;
          // selectedSocietyNo = response.data!.record!.domhelpSociety;
          if (response.data!.record!.domhelpDocUpload != null && response.data!.record!.domhelpDocUpload!.isNotEmpty) {
            if (response.data!.record!.domhelpDocUpload!.length > 0) {
              frontDocImage = response.data!.record!.domhelpDocUpload![0].urlpath;
            } else {
              print("Front document image not available.");
            }

            if (response.data!.record!.domhelpDocUpload!.length > 1) {
              backDocImage = response.data!.record!.domhelpDocUpload![1].urlpath;
            } else {
              print("Back document image not available.");
            }
          } else {
            print("The domhelpDocUpload list is null or empty.");
          }

          approvalStatus = response.data!.record!.domhelpApprovalStatus.toString();
          if (response.data!.record!.domhelpPic != null && response.data!.record!.domhelpPic!.isNotEmpty) imagePic = response.data!.record!.domhelpPic!.first.urlpath.toString();
          setState(() {});

          // selectedCountryIso = CountryPickerUtils
          //     .getCountryByPhoneCode(selectedCountryCode
          //     .split('+')
          //     .last
          //     .toString())
          //     .isoCode;
          setState(() {});
        }
      } catch (e) {
        throw e;
        return e;
      }
    }
    _showProgress.value = false;
  }

  Future onSubmit() async {
    if (formKey.currentState!.validate()) {
      _showProgress.value = true;
      setState(() {});
      try {
        Map req = {
          "domhelp_type": selectedDomestic,
          "domhelp_name": nameController.text,
          "domhelp_number": selectedCountryCode + mobController.text,
          "domhelp_doc_type": selectedDocumentType,
          "domhelp_docnumber": docNumController.text,
          // "domhelp_vehicleno": vehicleController.text,
          "domhelp_doc_upload": selectedFrontDocImage != null ? selectedFrontDocImage!.path : frontDocImage,
          "domhelp_pic": image != null ? image!.path : imagePic,
          "domhelp_timeslot": availableSelectedTimeSlot.toString(),
          // "domhelp_block": selectedBlock,
          // "domhelp_society": selectedSocietyNo,
          "assigned_user_id": Constants.assignedUserId,
          "domhelp_approval_status": approvalStatus,
        };

        SaveDomesticHelpModel? response = await dioServiceClient.createDomesticHelpApi(request: req, recordID: widget.recordId);
        if (response!.statuscode == 1) {
          if (selectedFrontDocImage != null) await dioServiceClient.uploadAttachmentDomesticDocHelp(recordId: response.data!.id, imageName: selectedFrontDocImage!.path);
          if (selectedBackDocImage != null) await dioServiceClient.uploadAttachmentDomesticDocHelp(recordId: response.data!.id, imageName: selectedBackDocImage!.path);
          if (image != null) await dioServiceClient.uploadAttachmentDomesticProfileHelp(recordId: response.data!.id, imageName: image!.path);
          log('Image Uploaded');
          isUpdate = true;
          setState(() {});
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.statusMessage.toString()),
            ),
          );

          Get.back(result: isUpdate);
        }
      } catch (e) {
        isUpdate = false;
        return e;
      }

      _showProgress.value = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Domestic Help'),
      ),
      body: Form(
        key: formKey,
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                DropdownButtonFormField<String>(
                  isDense: true,
                  hint: const Text('Type Of Domestic'),
                  decoration: defaultInputDecoration(prefixIcon: Icons.person, radius: 16),
                  value: selectedDomestic,
                  onChanged: (e) {
                    selectedDomestic = e;
                    setState(() {});
                  },
                  validator: (value) {
                    if ((value ?? '').trim().isEmpty) {
                      return 'Please select Type Of Domestic';
                    }
                    return null;
                  },
                  items: domesticList
                      .map<DropdownMenuItem<String>>(
                        (String item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: nameController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if ((value ?? '').trim().isEmpty) {
                      return 'Please enter the name';
                    }
                    return null;
                  },
                  decoration: defaultInputDecoration(
                    labelText: 'Name',
                    hintText: 'Name',
                    radius: 16,
                    prefixIcon: Icons.person,
                  ),
                ),
                const SizedBox(height: 8),
                phoneNumberInput(),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  isDense: true,
                  hint: const Text('Document Type'),
                  decoration: defaultInputDecoration(prefixIcon: Icons.file_copy, radius: 16),
                  value: selectedDocumentType,
                  onChanged: (e) {
                    setState(() {
                      selectedDocumentType = e;
                      selectedFrontDocImage = null;
                      selectedBackDocImage = null;
                    });
                  },
                  validator: (value) {
                    if ((value ?? '').trim().isEmpty) {
                      return 'Please select Type Of Document Type';
                    }
                    return null;
                  },
                  items: documentTypeList
                      .map<DropdownMenuItem<String>>(
                        (String item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(item.toString()),
                        ),
                      )
                      .toList(),
                ),
                if (selectedDocumentType != null)
                  Column(
                    children: [
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            height: 170,
                            width: (MediaQuery.of(context).size.width - 40) / 2,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(16)),
                            child: frontDocImage != null || selectedFrontDocImage != null
                                ? Column(
                                    children: [
                                      frontDocImage != null ? Image.network(frontDocImage!, height: 105, width: 150) : Image.file(File(selectedFrontDocImage!.path), height: 105, width: 150),
                                      const SizedBox(height: 8),
                                      removeImageButton(onCall: () {
                                        selectedFrontDocImage = null;
                                        frontDocImage = null;
                                      })
                                    ],
                                  )
                                : GestureDetector(
                                    onTap: () async {
                                      selectedFrontDocImage = await showImagePickerDialog(context, () {
                                        setState(() {});
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        const Icon(Icons.add),
                                        const SizedBox(width: 2),
                                        Expanded(child: Text('FrontSide $selectedDocumentType')),
                                      ],
                                    ),
                                  ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            height: 170,
                            width: (MediaQuery.of(context).size.width - 40) / 2,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(16)),
                            child: backDocImage != null || selectedBackDocImage != null
                                ? Column(
                                    children: [
                                      backDocImage != null ? Image.network(backDocImage!, height: 105, width: 150) : Image.file(File(selectedBackDocImage!.path), height: 105, width: 150),
                                      const SizedBox(height: 8),
                                      removeImageButton(onCall: () {
                                        selectedBackDocImage = null;
                                        backDocImage = null;
                                      })
                                    ],
                                  )
                                : GestureDetector(
                                    onTap: () async {
                                      selectedBackDocImage = await showImagePickerDialog(context, () {
                                        setState(() {});
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        const Icon(Icons.add),
                                        const SizedBox(width: 2),
                                        Expanded(child: Text('BackSide $selectedDocumentType')),
                                      ],
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                const SizedBox(height: 8),
                if (selectedDocumentType != null)
                  TextFormField(
                    controller: docNumController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textCapitalization: TextCapitalization.characters,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny('-'),
                      FilteringTextInputFormatter.deny('.'),
                      FilteringTextInputFormatter.deny(','),
                    ],
                    keyboardType: selectedDocumentType == 'Aadhaar Card' ? TextInputType.number : TextInputType.text,
                    validator: (value) {
                      // Trim any extra whitespace
                      final trimmedValue = (value ?? '').trim();

                      // Check if the field is empty
                      if (trimmedValue.isEmpty) {
                        return 'Please enter the Document Number';
                      }

                      // Aadhaar Card validation: Should not match if invalid
                      if (selectedDocumentType == 'Aadhaar Card' && !RegExp(r'^\d{12}$').hasMatch(trimmedValue)) {
                        return 'Please enter a valid Aadhaar Card number (12 digits)';
                      }

                      // PAN Card validation
                      if (selectedDocumentType == 'PAN Card' && !RegExp(r'^[A-Z]{5}\d{4}[A-Z]$').hasMatch(trimmedValue)) {
                        return 'Please enter a valid PAN Card number (e.g., ABCDE1234F)';
                      }

                      // Voter ID validation
                      if (selectedDocumentType == 'Voter ID' && !RegExp(r'^[A-Z]{2}\d{7}$').hasMatch(trimmedValue)) {
                        return 'Please enter a valid Voter ID number (e.g., AB1234567)';
                      }

                      // Driving Licence validation
                      if (selectedDocumentType == 'Driving Licence' && !RegExp(r'^[A-Z]{2}\d{2}\s\d{11}$').hasMatch(trimmedValue)) {
                        return 'Please enter a valid Driving Licence number (e.g., AB12 12345678901)';
                      }

                      // If everything is valid
                      return null;
                    },
                    decoration: defaultInputDecoration(labelText: 'Document Number', hintText: 'Document Number', prefixIcon: Icons.numbers, radius: 16),
                  ),
                const SizedBox(height: 8),
                Container(
                  height: 150,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(16)),
                  child: imagePic != null || image != null
                      ? Row(
                          children: [
                            imagePic != null ? Image.network(imagePic!, height: 130, width: 150) : Image.file(File(image!.path), height: 130, width: 150),
                            const SizedBox(width: 16),
                            removeImageButton(onCall: () {
                              image = null;
                              imagePic = null;
                            })
                          ],
                        )
                      : SizedBox(
                          height: 45,
                          width: 200,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () async {
                              hideKeyboard(context);
                              final imageCap = await takePhoto(() {
                                setState(() {});
                              });
                              bool? isFaceDetected = await detectHumanFaces(context, imageCap!);
                              if (isFaceDetected) image = imageCap;
                              setState(() {});
                            },
                            child: const Text('Take Photo Of Person', style: Styles.smallText),
                          ),
                        ),
                ),
                const SizedBox(height: 8),
                // TextFormField(
                //   // controller: vehicleController,
                //   autovalidateMode: AutovalidateMode.onUserInteraction,
                //   keyboardType: TextInputType.text,
                //   textCapitalization: TextCapitalization.characters,
                //   validator: (value) {
                //     var regex = RegExp(r'^[A-Z]{2}\s?[0-9]{2}\s?[A-Z]{2}\s?[0-9]{1,4}$');
                //     if (!regex.hasMatch(value!)) {
                //       return 'Please enter a valid vehicle number (e.g., MH 12 AB 1234)';
                //     }
                //     return null;
                //   },
                //   decoration: defaultInputDecoration(
                //     labelText: 'Vehicle Number',
                //     hintText: 'Vehicle Number',
                //     prefixIcon: Icons.numbers_outlined,
                //     radius: 16,
                //   ),
                // ),
                // const SizedBox(height: 8),
                GestureDetector(
                  onTap: showAvailabilityTimeSelectionDialog,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time_outlined, color: Colors.grey, size: 22),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            availableSelectedTimeSlot.isEmpty ? 'Availability Time Slot' : availableSelectedTimeSlot.join(", "),
                            style: Styles.hintText,
                            // overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // if (availableSelectedTimeSlot != null && availableSelectedTimeSlot.isNotEmpty)
                //   Column(
                //     children: [
                //       const SizedBox(height: 8),
                //       GestureDetector(
                //         onTap: showSelectedTimeSelectionDialog,
                //         child: Container(
                //           padding: const EdgeInsets.all(12),
                //           decoration: BoxDecoration(
                //             border: Border.all(color: Colors.grey),
                //             borderRadius: BorderRadius.circular(16),
                //           ),
                //           child: Row(
                //             children: [
                //               const Icon(Icons.access_time_outlined, color: Colors.grey, size: 22),
                //               const SizedBox(width: 10),
                //               Expanded(
                //                 child: Text(
                //                   workSelectedTimeSlot.isEmpty ? 'Work Time Slot' : workSelectedTimeSlot.join(", "),
                //                   style: Styles.hintText,
                //                   // overflow: TextOverflow.ellipsis,
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // if (widget.isUpdate == false)
                //   Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       const SizedBox(height: 8),
                //       DropdownButtonFormField<String>(
                //         isDense: true,
                //         hint: const Text('Block', style: Styles.hintText),
                //         decoration: defaultInputDecoration(prefixIcon: Icons.home_work_outlined, radius: 16),
                //         value: selectedBlock,
                //         onChanged: (e) {
                //           selectedBlock = e;
                //           setState(() {});
                //         },
                //         validator: (value) {
                //           if ((value ?? '').trim().isEmpty) {
                //             return 'Please select Block';
                //           }
                //           return null;
                //         },
                //         items: blockList
                //             .map<DropdownMenuItem<String>>(
                //               (String item) => DropdownMenuItem<String>(
                //                 value: item,
                //                 child: Text(item),
                //               ),
                //             )
                //             .toList(),
                //       ),
                //       const SizedBox(height: 8),
                //       DropdownButtonFormField<String>(
                //         isDense: true,
                //         hint: const Text('Society No', style: Styles.hintText),
                //         decoration: defaultInputDecoration(prefixIcon: Icons.numbers_outlined, radius: 16),
                //         value: selectedSocietyNo,
                //         onChanged: (e) {
                //           selectedSocietyNo = e;
                //           setState(() {});
                //         },
                //         items: societyNoList
                //             .map<DropdownMenuItem<String>>(
                //               (String item) => DropdownMenuItem<String>(
                //                 value: item,
                //                 child: Text(item),
                //               ),
                //             )
                //             .toList(),
                //       ),
                //       const SizedBox(height: 8),
                //     ],
                //   ),
              ],
            ),
            Visibility(visible: _showProgress.isTrue, child: const Center(child: CircularProgressIndicator()))
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 5,
            padding: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () {
            if (formKey.currentState!.validate()) {
              if ((selectedFrontDocImage != null || frontDocImage != null) && (selectedBackDocImage != null || backDocImage != null) && (image != null || imagePic != null)) {
                onSubmit();
              } else {
                if ((selectedFrontDocImage == null && frontDocImage == null) || (selectedBackDocImage == null && backDocImage == null)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please upload the required document images")),
                  );
                } else if (image == null && imagePic == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please take a photo of the person")),
                  );
                }
              }
            }
          },
          child: Text('${widget.isUpdate == true ? 'Update' : 'Create'} Domestic Help', style: Styles.textBoldLabel),
        ),
      ),
    );
  }

  Widget removeImageButton({Function? onCall}) {
    return SizedBox(
      height: 35,
      width: 120,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shadowColor: Constants.primaryColor,
          backgroundColor: Constants.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () {
          onCall!();
          setState(() {});
        },
        child: const Text('Remove', style: Styles.smallText),
      ),
    );
  }

  Widget phoneNumberInput() {
    return TextFormField(
      controller: mobController,
      keyboardType: TextInputType.phone,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) {
        if ((value ?? '').trim().isEmpty) {
          return 'Please enter mobile number';
        } else if (value!.length > 10 || value.length < 10) {
          return 'Mobile number is invalid';
        }
        return null;
      },
      decoration: defaultInputDecoration(
        hintText: 'Mobile number',
        prefix: CountryCodePicker(
          initialSelection: selectedCountryCode,
          dialogBackgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
          onChanged: (value) {
            setState(() {
              selectedCountryCode = value.code!;
            });
          },
        ),
      ),
      // prefix: InkWell(
      //   onTap: () {
      //     log("message");
      //     showDialog(
      //       context: context,
      //       builder: (context) => Theme(
      //         data: Theme.of(context).copyWith(primaryColor: Colors.pink),
      //         child: CountryPickerDialog(
      //             titlePadding: const EdgeInsets.all(8.0),
      //             searchCursorColor: Colors.pinkAccent,
      //             searchInputDecoration: const InputDecoration(hintText: 'Search...'),
      //             isSearchable: true,
      //             title: const Text('Select your phone code'),
      //             onValuePicked: (Country country) => setState(
      //                   () {
      //                     _selectedCountryCode = '+${country.phoneCode}'; // Update phone code
      //                     _selectedCountryIso = country.isoCode; // Update ISO code for flag
      //                   },
      //                 ),
      //             priorityList: [
      //               CountryPickerUtils.getCountryByIsoCode('IN'),
      //               CountryPickerUtils.getCountryByIsoCode('US'),
      //             ],
      //             itemBuilder: _buildDialogItem),
      //       ),
      //     );
      //   },
      //   child: Container(
      //     padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      //     margin: const EdgeInsets.only(right: 8.0),
      //     child: Row(
      //       mainAxisSize: MainAxisSize.min,
      //       children: [
      //         Row(
      //           children: [
      //             CountryPickerUtils.getDefaultFlagImage(
      //               CountryPickerUtils.getCountryByIsoCode(_selectedCountryIso),
      //             ),
      //             const Icon(Icons.arrow_drop_down),
      //           ],
      //         ),
      //         const SizedBox(width: 8),
      //         Text(_selectedCountryCode, style: const TextStyle(fontSize: 16)),
      //       ],
      //     ),
      //   ),
      // ),
      // )
      // ,
    );
  }

  // Widget _buildDialogItem(Country country) => Row(
  //       children: <Widget>[
  //         CountryPickerUtils.getDefaultFlagImage(country),
  //         const SizedBox(width: 8.0),
  //         Text("+${country.phoneCode}"),
  //         const SizedBox(width: 8.0),
  //         Flexible(child: Text(country.name)),
  //       ],
  //     );

  void showAvailabilityTimeSelectionDialog() async {
    List<String> temporaryList = availableSelectedTimeSlot;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 16),
              title: const Text("Select Availability Time slot"),
              content: SingleChildScrollView(
                child: FutureBuilder<TimeSlotModel?>(
                    future: dioServiceClient.getTimeSlotApi(),
                    builder: (context, snap) {
                      if (snap.hasData && snap.data != null) {
                        return snap.data!.data!.domhelpTimeslot != null
                            ? Wrap(
                                spacing: 8.0,
                                children: snap.data!.data!.domhelpTimeslot!.map((e) {
                                  final isSelected = temporaryList.contains(e.domhelpTimeslot!);
                                  return ChoiceChip(
                                    label: Text(e.domhelpTimeslot!),
                                    selected: isSelected,
                                    onSelected: (selected) {
                                      setDialogState(() {
                                        if (selected) {
                                          temporaryList.add(e.domhelpTimeslot!);
                                        } else {
                                          temporaryList.remove(e.domhelpTimeslot!);
                                        }
                                      });
                                    },
                                    selectedColor: Constants.primaryColor.withOpacity(0.3),
                                  );
                                }).toList(),
                              )
                            : const Text('Time Slot is empty', style: Styles.smallBoldText);
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }),
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(side: BorderSide(width: 1, color: Get.iconColor!), borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    foregroundColor: Get.iconColor,
                  ),
                  child: Text("Cancel", style: TextStyle(color: Get.iconColor)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Constants.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    availableSelectedTimeSlot = temporaryList;
                    workSelectedTimeSlot.clear();

                    setState(() {});
                    Navigator.pop(context);
                  },
                  child: const Text("Confirm"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Future<File> showImagePickerDialog(BuildContext context) async {
  //   File? image;
  //   await showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text("Choose an option", style: Styles.textBoldLabel),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             ListTile(
  //               leading: const Icon(Icons.camera_alt),
  //               title: const Text("Capture Image"),
  //               onTap: () async {
  //                 image = await takePhoto();
  //
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //             ListTile(
  //               leading: const Icon(Icons.photo_library),
  //               title: const Text("Pick from Gallery"),
  //               onTap: () async {
  //                 image = await pickImage();
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  //
  //   return image!;
  // }
  //
  // Future<File> pickImage() async {
  //   final XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  //   File? selectedDocImage;
  //   if (pickedFile != null) {
  //     selectedDocImage = await compressImage(File(pickedFile.path));
  //     setState(() {});
  //   }
  //   return selectedDocImage!;
  // }
  //
  // Future<File?> takePhoto() async {
  //   final XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
  //   File? imageSelect;
  //   if (pickedFile != null) {
  //     imageSelect = await compressImage(File(pickedFile.path));
  //     setState(() {});
  //   }
  //   return imageSelect;
  // }

  Future? separateCountryCode(String fullNumber) {
    final regex = RegExp(r'^(\+\d+)(\d{10})$');
    final match = regex.firstMatch(fullNumber);

    if (match != null) {
      String countryCode = match.group(1)!;
      String phoneNumber = match.group(2)!;

      selectedCountryCode = countryCode;
      mobController.text = phoneNumber;
      log("selected Country $countryCode");
      log("selected phoneNumber $phoneNumber");
    } else {}
    return null;
  }
}
