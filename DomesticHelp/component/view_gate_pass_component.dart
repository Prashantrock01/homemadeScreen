import 'dart:developer';

import 'package:biz_infra/Controller/DomesticHelpProfileController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../CustomWidgets/configurable_widgets.dart';
import '../../../Model/DomesticHelp/GatePassCountModel.dart';
import '../../../Utils/app_styles.dart';
import '../../../Utils/common_widget.dart';
import '../../WaterTank/display_image.dart';

class ViewGatePassComponent extends StatelessWidget {
  ViewGatePassComponent({super.key});

  @override
  Widget build(BuildContext context) {
    DomesticHelpProfileController controller = Get.find<DomesticHelpProfileController>();
    return GetBuilder(
        init: controller,
        builder: (controller) {
          return commonOutlineButton(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            onCall: () {
              viewGatePassListDialogue(context, controller);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.home_work_outlined, size: 20, color: Get.iconColor),
                const SizedBox(width: 4),
                const Text('View Gate Pass', style: Styles.smallText),
              ],
            ),
          );
        });
  }

  // Method to show the list of gate passes
  void viewGatePassListDialogue(BuildContext context, DomesticHelpProfileController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Obx(() {
          return Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("View Gate Pass", style: Styles.textBoldLabel),
                        CloseButton(onPressed: () => Get.back()),
                      ],
                    ),
                  ),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(8),
                      itemCount: controller.gatePassList.length,
                      itemBuilder: (context, index) {
                        GatepassList gatePass = controller.gatePassList[index];
                        return Card(
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                            title: Text(gatePass.ownerName ?? ""),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${gatePass.ownerBlock}, ${gatePass.ownerFlat}, ${gatePass.ownerSociety}"),
                                Text(
                                  "Created on : ${gatePass.createdTime!}",
                                ),
                              ],
                            ),
                            onTap: () {
                              viewGatePassDialogue(context, gatePass, controller, () {
                                if (controller.unVerifyCount.value == 0) {
                                  Get.back();
                                }
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  // Method to show the details of a specific gate pass
  void viewGatePassDialogue(BuildContext context, GatepassList gatePass, DomesticHelpProfileController controller, Function onCall) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("View Gate Pass", style: Styles.textBoldLabel),
                    CloseButton(onPressed: () => Get.back()),
                  ],
                ),
                const SizedBox(height: 8),
                Text("They Give : ${gatePass.gatepassHavegiven}", style: Styles.textHeadLabel),
                if (gatePass.gatepassDescription != null && gatePass.gatepassDescription!.isNotEmpty) Text("Description : ${gatePass.gatepassDescription}", style: Styles.textHeadLabel),
                if (gatePass.gatepassAttachment!.isNotEmpty)
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () {
                            Get.to(() => WaterTankImages(imageFiles: [gatePass.gatepassAttachment!.first]));
                          },
                          child: Image.network(gatePass.gatepassAttachment!.first, height: 200),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),
                Center(
                  child: textButton(
                    onPressed: () => controller.verifyGatePass(gatePass, () {
                      Get.back();
                      onCall();
                    }),
                    widget: const Text('Verify'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
