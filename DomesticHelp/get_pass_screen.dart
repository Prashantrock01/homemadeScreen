import 'dart:developer';
import 'dart:io';

import 'package:biz_infra/Network/dio_service_client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../Model/Attendance/FaceDetectionModel.dart';
import '../../Model/DomesticHelp/GatePassPickListModel.dart';
import '../../Model/DomesticHelp/domestic_help_list.dart';
import '../../Model/WaterTank/AllowInOutModel.dart';
import '../../Utils/app_styles.dart';
import '../../Utils/common_widget.dart';
import '../../Utils/constants.dart';

class GetPassScreen extends StatefulWidget {
  final DomesticHelper? domesticHelper;

  const GetPassScreen({super.key, this.domesticHelper});

  @override
  State<GetPassScreen> createState() => _GetPassScreenState();
}

class _GetPassScreenState extends State<GetPassScreen> {
  List<String> selectedItem = [];
  List<GatePassHaveGiven>? gatepassHavegiven;
  File? selectedImage;
  File? temporarySelectedImage;

  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    gatePassPickApiCall();
  }

  gatePassPickApiCall() async {
    final GatePassPickListModel? response = await dioServiceClient.gatePassPickListApi();
    if (response!.statusCode == 1) {
      if (response.data != null) {
        gatepassHavegiven = response.data!.gatepassHavegiven;
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Gate Pass'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  maxRadius: 40,
                  backgroundImage: NetworkImage(widget.domesticHelper!.docUrl!.first),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text(widget.domesticHelper!.domhelpName!, style: Styles.textBoldLabel)),
                          Card(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(widget.domesticHelper!.domhelpType!, style: Styles.smallBoldText),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("I have Given...", style: Styles.textHeadLabel),
                const SizedBox(height: 8),
                if (gatepassHavegiven != null && gatepassHavegiven!.isNotEmpty)
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: gatepassHavegiven!.map((e) {
                      final isSelected = selectedItem.contains(e.gatePassHaveGiven!);
                      return ChoiceChip(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        label: Text(e.gatePassHaveGiven!),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              selectedItem.add(e.gatePassHaveGiven!);
                            } else {
                              selectedItem.remove(e.gatePassHaveGiven!);
                            }
                          });
                        },
                        selectedColor: Constants.primaryColor.withOpacity(0.3),
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 16),
                const SizedBox(height: 8),
                TextFormField(
                  controller: controller,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(borderSide: const BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(16.0)),
                    focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(16.0)),
                    enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(16.0)),
                    errorBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.red), borderRadius: BorderRadius.circular(16.0)),
                    disabledBorder: const OutlineInputBorder(),
                    errorMaxLines: 2,
                    labelStyle: Styles.hintText,
                    hintText: 'Other (Optional)',
                    hintStyle: Styles.hintText,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () async {
                        temporarySelectedImage = await showImagePickerDialog(context, () {
                          hideKeyboard(context);
                          setState(() {});
                        });
                        selectedImage = temporarySelectedImage;
                      },
                      style: ButtonStyle(
                        side: const WidgetStatePropertyAll(BorderSide(color: Colors.grey, width: 0.5)),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      ),
                      child: Icon(Icons.image, size: 20, color: Get.iconColor),
                    ),
                  ],
                ),
                if (selectedImage != null)
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: selectedImage!.path.contains('https')
                            ? Image.network(selectedImage!.path, height: 130, width: 150, fit: BoxFit.cover)
                            : Image.file(File(selectedImage!.path), height: 130, width: 150, fit: BoxFit.cover),
                      ),
                      IconButton(
                          onPressed: () {
                            selectedImage = null;
                            setState(() {});
                          },
                          icon: const Icon(Icons.delete, color: Colors.red))
                    ],
                  ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    minimumSize: Size(MediaQuery.of(context).size.width, 45),
                    maximumSize: Size(MediaQuery.of(context).size.width, 45),
                    padding: const EdgeInsets.all(12),
                    shadowColor: Constants.primaryColor,
                    backgroundColor: Constants.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () async {
                    Map req = {
                      "gatepass_havegiven": selectedItem.join(','),
                      "gatepass_description": controller.text,
                      "domestichelpid": widget.domesticHelper!.id,
                      "assigned_user_id": Constants.assignedUserId,
                    };
                    AllowInOutModel response = await dioServiceClient.domesticHelpGatePassApi(value: req);
                    if (response.statuscode == 1) {
                      if (selectedImage != null) {
                        FaceDetectionModel? response1 = await dioServiceClient.uploadAttachmentForGatPass(
                          capturedImageList: selectedImage!,
                          recordId: response.data!.id!,
                        );

                        if (response1 != null && response1.statuscode == 1) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(response1.data?.message ?? 'Success')),
                          );
                        }
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(response.data!.message!)),
                      );
                      Get.back(result: true);
                    }
                  },
                  child: const Text('Send Gate Pass', style: Styles.whiteTextBold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
