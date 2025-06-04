import 'dart:developer';

import 'package:biz_infra/CustomWidgets/IntExtensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../CustomWidgets/confirmation_dialog.dart';
import '../../../Model/DomesticHelp/domestic_help_list.dart';
import '../../../Network/dio_service_client.dart';
import '../../../Utils/app_styles.dart';
import '../../../Utils/common_widget.dart';
import '../../../Utils/constants.dart';
import '../domestic_help_profile_screen.dart';
import '../get_pass_screen.dart';

class MyDomesticHelperComponent extends StatelessWidget {
  final DomesticHelper? domesticHelper;
  final VoidCallback? onDeleteCall;
  final VoidCallback? onEditCall;

  MyDomesticHelperComponent({super.key, this.domesticHelper, this.onDeleteCall, this.onEditCall});

  bool? isAllowOut = false;
  String? allowInId;
  String? allowInTime;
  String? allowOutTime;

  @override
  Widget build(BuildContext context) {
    if (domesticHelper == null) {
      return const SizedBox.shrink();
    }

    _updateInOutDetails();

    return Card(
      margin: const EdgeInsets.all(4),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Get.to(() => const DomesticHelpProfileScreen(), arguments: {'recordId': domesticHelper!.id});
              },
              child: Row(
                children: [
                  CircleAvatar(
                    maxRadius: 40,
                    backgroundImage: NetworkImage(domesticHelper!.docUrl!.first),
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
                            Expanded(child: Text(domesticHelper!.domhelpName!, style: Styles.textBoldLabel)),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Constants.primaryColor.withOpacity(0.4)),
                                  child: Text(domesticHelper!.domhelpType!, style: Styles.smallBoldText),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // if (domesticHelper!.domhelpTimeslot != null) const SizedBox(height: 4),
                        // if (domesticHelper!.domhelpTimeslot != null)
                        //   Row(
                        //     children: <Widget>[
                        //       const Icon(Icons.access_time_outlined, color: Colors.grey, size: 16),
                        //       const SizedBox(width: 4),
                        //       Expanded(child: Text(formatTimeString(domesticHelper!.domhelpTimeslot!), style: Styles.textHeadLabel)),
                        //     ],
                        //   ),
                        if (allowInTime != null)
                          Row(
                            children: <Widget>[
                              const Icon(Icons.access_time_outlined, color: Colors.grey, size: 16),
                              Container(
                                width: 5,
                                height: 5,
                                margin: const EdgeInsets.only(left: 4, right: 4),
                                decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                              ),
                              Text(/*printINTime*/ (allowInTime.toString()), style: Styles.textHeadLabel),
                              const Text(' - ', style: Styles.textHeadLabel),
                              allowOutTime != null ? Text(/*printINTime*/ (allowOutTime.toString()), style: Styles.textHeadLabel) : const Text('Still Inside', style: TextStyle(color: Colors.green)),

                              // const SizedBox(width: 12),
                              // DropdownButton<String>(
                              //   isDense: true,
                              //   underline: const SizedBox(),
                              //   hint: const Text('2 more flats', style: Styles.smallText),
                              //   onChanged: (e) {},
                              //   items: [
                              //     'A-101',
                              //     'B-101',
                              //   ]
                              //       .map<DropdownMenuItem<String>>(
                              //         (String item) => DropdownMenuItem<String>(
                              //           value: item,
                              //           child: Text(item),
                              //         ),
                              //       )
                              //       .toList(),
                              // ),
                            ],
                          ),
                        const SizedBox(height: 4),
                        if (domesticHelper!.serviceLocations != null && domesticHelper!.serviceLocations!.isNotEmpty)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.home_outlined, size: 18),
                                  4.width,
                                  Text(domesticHelper!.serviceLocations!.first.flat!, style: Styles.smallBoldText),
                                ],
                              ),
                              4.width,
                              // Dropdown for remaining values
                              if (domesticHelper!.serviceLocations!.length > 1)
                                DropdownButton<String>(
                                  isDense: true,
                                  underline: const SizedBox(),
                                  hint: Text('${domesticHelper!.serviceLocations!.length - 1} more flats', style: Styles.smallText),
                                  onChanged: (String? selectedValue) {},
                                  items: domesticHelper!.serviceLocations!
                                      .skip(1) // Skip the first item
                                      .map<DropdownMenuItem<String>>(
                                        (serviceLocation) => DropdownMenuItem<String>(
                                          value: serviceLocation.flat!,
                                          child: Text(serviceLocation.flat!),
                                        ),
                                      )
                                      .toList(),
                                ),
                            ],
                          ),
                        // _buildCommonListComponent(title: 'Block', value: domesticHelper!.domhelpBlock.toString()),
                        // _buildCommonListComponent(title: 'Society No', value: domesticHelper!.domhelpSociety.toString()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 20, thickness: 0.3),
            Wrap(
              spacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              runAlignment: WrapAlignment.spaceBetween,
              children: [
                if (isAllowOut == true)
                  commonOutlineButton(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: Get.width * 0.02),
                    onCall: () async {
                      bool? res = await Get.to(() => GetPassScreen(domesticHelper: domesticHelper));
                      if (res == true) {
                        Get.to(() => DomesticHelpProfileScreen(), arguments: {'recordId': domesticHelper!.id, 'currentTab': 2});
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.home_work_outlined, size: 20, color: Get.iconColor),
                        const SizedBox(width: 4),
                        if (Constants.userRole == Constants.securitySupervisor) const Text('View Get Pass', style: Styles.smallText) else const Text('Get Pass', style: Styles.smallText)
                      ],
                    ),
                  ),
                commonOutlineButton(
                  onCall: () {
                    launchUrl(Uri.parse(domesticHelper!.domhelpNumber!));
                  },
                  child: Icon(Icons.call_rounded, size: 20, color: Get.iconColor),
                ),
                // commonOutlineButton(
                //   onCall: () {
                //     Share.share('check out my website https://example.com');
                //   },
                //   child: Icon(Icons.share_outlined, size: 20, color: Get.iconColor),
                // ),
                commonOutlineButton(
                  onCall: () {
                    showConfirmationDialog(
                      context,
                      title: 'Are you sure you want to delete ${domesticHelper!.domhelpName}?',
                      subtitle: 'Do you really want to delete ${domesticHelper!.domhelpName}?',
                      onAccept: () async {
                        try {
                          var response = await dioServiceClient.removeDomHelpServiceApi(recordId: domesticHelper!.domestichelpid);
                          if (response!.statuscode == 1 && response.data != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(response.data!.message.toString())),
                            );
                            Get.back();
                            onDeleteCall?.call();
                          }
                        } catch (e) {
                          log('Error deleting helper: $e');
                        }
                      },
                    );
                  },
                  child: const Icon(Icons.delete_forever, size: 20, color: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommonListComponent({required String title, required String? value}) {
    return Row(
      children: [
        Text("$title: ", style: Styles.smallText),
        Text(value != null && value.isNotEmpty ? value : 'NA', style: Styles.textBoldLabel, textAlign: TextAlign.end),
      ],
    );
  }

  void _updateInOutDetails() {
    var inoutDetails = domesticHelper?.inoutDetails;
    if (inoutDetails != null && inoutDetails.isNotEmpty) {
      isAllowOut = inoutDetails.any((detail) => detail.inoutAllowInTime != null && detail.inoutAllowOutTime == null);

      var matchingDetail = inoutDetails.firstWhereOrNull(
        (detail) => detail.inoutAllowInTime != null && detail.inoutAllowOutTime == null,
      );

      if (matchingDetail != null) {
        allowInId = matchingDetail.inoutId;
        allowInTime = matchingDetail.inoutAllowInTime;
        allowOutTime = matchingDetail.inoutAllowOutTime;
      } else {
        allowInTime = inoutDetails.first.inoutAllowInTime;
        allowOutTime = inoutDetails.first.inoutAllowOutTime;
      }
    }
  }
}
