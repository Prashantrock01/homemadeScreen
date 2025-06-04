import 'dart:developer';
import 'package:biz_infra/CustomWidgets/IntExtensions.dart';
import 'package:biz_infra/Model/DomesticHelp/AddToFlatModel.dart';
import 'package:biz_infra/Screens/DomesticHelp/component/select_society_n_block_component.dart';
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
import '../domestic_help_creation.dart';
import '../domestic_help_profile_screen.dart';

class DomesticHelpComponent extends StatelessWidget {
  final DomesticHelper? domesticHelper;
  final VoidCallback? onDeleteCall;
  final VoidCallback? onEditCall;
  final VoidCallback? onAddTFlatCall;

  DomesticHelpComponent({
    super.key,
    this.domesticHelper,
    this.onDeleteCall,
    this.onEditCall,
    this.onAddTFlatCall,
  });

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
            _buildProfileSection(context),
            _buildActionSection(context),
          ],
        ),
      ),
    );
  }

  void _updateInOutDetails() {
    var inoutDetails = domesticHelper?.inoutDetails;
    if (inoutDetails != null && inoutDetails.isNotEmpty) {
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

  Widget _buildProfileSection(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        if (domesticHelper?.domhelpApprovalStatus == Constants.accepted) {
          Get.to(() => const DomesticHelpProfileScreen(), arguments: {"recordId": domesticHelper!.id});
        }
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
                    Expanded(
                      child: Text(
                        domesticHelper!.domhelpName.toString(),
                        style: Styles.textBoldLabel,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Constants.primaryColor.withOpacity(0.4),
                      ),
                      child: Text(
                        domesticHelper!.domhelpType.toString(),
                        style: Styles.smallBoldText,
                      ),
                    ),
                  ],
                ),
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
                      Text((allowInTime.toString()), style: Styles.textHeadLabel),
                      const Text(' - ', style: Styles.textHeadLabel),
                      allowOutTime != null ? Text((allowOutTime.toString()), style: Styles.textHeadLabel) : const Text('Still Inside', style: TextStyle(color: Colors.green)),
                    ],
                  ),
                4.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
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
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionSection(BuildContext context) {
    if (domesticHelper?.domhelpApprovalStatus == Constants.pending) {
      return const Column(
        children: [
          Divider(thickness: 0.3),
          Center(
            child: Text(
              'Pending Approval',
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    } else if (domesticHelper?.domhelpApprovalStatus == Constants.rejected) {
      return const Column(
        children: [
          Divider(thickness: 0.3),
          Center(
            child: Text(
              'Rejected',
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
       /* if (Constants.userRole == Constants.owner || Constants.userRole == Constants.tenant || Constants.userRole == Constants.securitySupervisor)*/ const Divider(thickness: 0.3),
        Wrap(
          spacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          runAlignment: WrapAlignment.spaceBetween,
          children: [
            if (Constants.userRole == Constants.owner || Constants.userRole == Constants.tenant) _buildAddToFlatButton(context),
            // _buildShareButton(),
            _buildCallButton(),
            if (Constants.userRole == Constants.securitySupervisor) ...[
              _buildEditButton(context),
              _buildDeleteButton(context),
            ],
          ],
        ),
      ],
    );
  }

  _buildCallButton() {
    return commonOutlineButton(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: Get.width * 0.02),
      onCall: () {
        launchUrl(Uri.parse('tel:${domesticHelper!.domhelpNumber.toString()}'));
      },
      child: Icon(
        Icons.call_rounded,
        size: 18,
        color: Get.iconColor,
      ),
    );
  }

  Widget _buildAddToFlatButton(BuildContext context) {
    return commonOutlineButton(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: Get.width * 0.02),
      onCall: () {
        if (domesticHelper!.isAdded == true && (Constants.userRole == Constants.owner || Constants.userRole == Constants.tenant)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Already Added')),
          );
        } else if (Constants.userRole == Constants.owner || Constants.userRole == Constants.tenant) {
          showConfirmationDialog(
            context,
            title: 'Are you sure want to add to Flat?',
            subtitle: 'This domestic helper will be added to your flat.',
            color: Colors.green,
            icon: Icons.add_business,
            onAccept: () async {
              Map res = {
                "domhelp_type": domesticHelper!.domhelpType,
                "domhelp_name": domesticHelper!.domhelpName,
                "domhelp_number": domesticHelper!.domhelpNumber,
                // "domhelp_block": domesticHelper!.domhelpBlock,
                // "domhelp_society": domesticHelper!.domhelpSociety,
                "domhelp_no": domesticHelper!.domestichelpid,
                "addtoflat": "1",
                "assigned_user_id": Constants.assignedUserId,
              };

              await dioServiceClient.addToFlatApi(recordId: domesticHelper!.id, res: res).then((v) async {
                if (v!.statuscode == 1 && v.data != null) {
                  AddToFlatModel? res = await dioServiceClient.addToFlatDataUpdateApi(domesticHelper!.domestichelpid);
                  if (res!.statuscode == 1 && res.data != null) {
                    Get.back();
                    onAddTFlatCall?.call();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(v.statusMessage.toString())),
                    );
                  }
                }
              });
            },
          );
        } else {
          _selectSocietyBlock(context);
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.home_work_outlined, size: 20, color: Get.iconColor),
          const SizedBox(width: 4),
          Text(domesticHelper!.isAdded == true && (Constants.userRole == Constants.owner || Constants.userRole == Constants.tenant) ? 'Already Added' : 'Add to Flat', style: Styles.smallText),
        ],
      ),
    );
  }

  Widget _buildShareButton() {
    return commonOutlineButton(
      onCall: () {
        Share.share('Check out my website https://example.com');
      },
      child: Icon(
        Icons.share_outlined,
        size: 20,
        color: Get.iconColor,
      ),
    );
  }

  Widget _buildEditButton(BuildContext context) {
    return commonOutlineButton(
      onCall: () async {
        bool? res = await Get.to(
          DomesticHelpCreation(recordId: domesticHelper!.id, isUpdate: true),
        );
        if (res == true) {
          onEditCall?.call();
        }
      },
      child: const Icon(
        Icons.edit,
        size: 20,
        color: Colors.green,
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return commonOutlineButton(
      onCall: () {
        showConfirmationDialog(
          context,
          title: 'Are you sure you want to delete ${domesticHelper!.domhelpName}?',
          subtitle: 'Do you really want to delete ${domesticHelper!.domhelpName}?',
          onAccept: () async {
            try {
              var response = await dioServiceClient.deleteDomesticHelpApi(recordId: domesticHelper!.domestichelpid);
              if (response!.statuscode == 1) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(response.statusMessage.toString())),
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
      child: const Icon(
        Icons.delete_forever,
        size: 20,
        color: Colors.red,
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

  void _selectSocietyBlock(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return const SelectSocietyNBlockComponent();
          },
        );
      },
    );
  }
}
