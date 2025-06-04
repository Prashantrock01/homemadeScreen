import 'package:biz_infra/Controller/DomesticHelpProfileController.dart';
import 'package:biz_infra/CustomWidgets/IntExtensions.dart';
import 'package:biz_infra/Utils/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../CustomWidgets/CustomLoaders/custom_loader.dart';
import '../../CustomWidgets/configurable_widgets.dart';
import '../../Utils/app_styles.dart';
import '../../Utils/constants.dart';
import '../WaterTank/display_image.dart';
import 'component/attendance_component.dart';
import 'component/detail_component.dart';
import 'component/view_gate_pass_component.dart';
import 'gate_pass_history.dart';

class DomesticHelpProfileScreen extends StatefulWidget {
  const DomesticHelpProfileScreen({super.key});

  @override
  _DomesticHelpProfileScreenState createState() => _DomesticHelpProfileScreenState();
}

class _DomesticHelpProfileScreenState extends State<DomesticHelpProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: Get.put(DomesticHelpProfileController()),
        builder: (controller) {
          return WillPopScope(
            onWillPop: () {
              Get.back();
              if (controller.isScan == true) Get.back();
              return Future.value(true);
            },
            child: Scaffold(
              appBar: AppBar(
                title: const Text("Profile"),
                leading: BackButton(
                  onPressed: () {
                    Get.back();
                    if (controller.isScan == true) Get.back();
                  },
                ),
              ),
              body: DefaultTabController(
                  initialIndex: controller.currentTabInd.value,
                  length: 3,
                  child: controller.isShowLoading.isTrue
                      ? const Center(child: CustomLoader())
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Card(
                              margin: const EdgeInsets.all(16),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            if (controller.domesticHelp!.data!.record!.domhelpPic != null) {
                                              Get.to(() => WaterTankImages(imageFiles: [controller.domesticHelp!.data!.record!.domhelpPic!.first.urlpath!]));
                                            }
                                          },
                                          child: CircleAvatar(
                                            maxRadius: 40,
                                            backgroundImage: controller.domesticHelp!.data!.record!.domhelpPic != null && controller.domesticHelp!.data!.record!.domhelpPic!.isNotEmpty
                                                ? NetworkImage(controller.domesticHelp!.data!.record!.domhelpPic!.first.urlpath!)
                                                : const NetworkImage(''),
                                          ),
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
                                                  Expanded(child: Text(controller.domesticHelp!.data!.record!.domhelpName.toString(), style: Styles.textBoldLabel)),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Constants.primaryColor),
                                                        child: Text(controller.domesticHelp!.data!.record!.domhelpType.toString(), style: Styles.smallBoldText),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              if (controller.allowInTime != null)
                                                Row(
                                                  children: <Widget>[
                                                    const Icon(Icons.access_time_outlined, color: Colors.grey, size: 18),
                                                    Container(
                                                      width: 5,
                                                      height: 5,
                                                      margin: const EdgeInsets.only(left: 4, right: 4),
                                                      decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                                                    ),
                                                    Text((controller.allowInTime.toString()), style: Styles.textHeadLabel),
                                                    const Text(' - ', style: Styles.textHeadLabel),
                                                    controller.allowOutTime != null
                                                        ? Text(controller.allowOutTime.toString(), style: Styles.textHeadLabel)
                                                        : const Text('Still Inside', style: TextStyle(color: Colors.green)),
                                                  ],
                                                ),
                                              const SizedBox(height: 4),
                                              GestureDetector(
                                                onTap: Constants.userRole == Constants.ownerModule
                                                    ? () => addRatingDialogue(context, controller.domesticHelp!.data!.record!.currentRecordId!, controller)
                                                    : null,
                                                child: RatingBarIndicator(
                                                  rating: double.parse(controller.domesticHelp!.data!.record!.domhelpRating != null && controller.domesticHelp!.data!.record!.domhelpRating!.isNotEmpty
                                                      ? controller.domesticHelp!.data!.record!.domhelpRating!
                                                      : '0'),
                                                  itemBuilder: (context, index) => const Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                  ),
                                                  unratedColor: Colors.grey,
                                                  itemCount: 5,
                                                  itemSize: 20.0,
                                                  direction: Axis.horizontal,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              if (controller.domesticHelp!.data!.record!.serviceLocations != null && controller.domesticHelp!.data!.record!.serviceLocations!.isNotEmpty)
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(Icons.home_outlined, size: 18),
                                                        4.width,
                                                        Text(controller.domesticHelp!.data!.record!.serviceLocations!.first.flat!, style: Styles.smallBoldText),
                                                      ],
                                                    ),
                                                    4.width,
                                                    // Dropdown for remaining values
                                                    if (controller.domesticHelp!.data!.record!.serviceLocations!.length > 1)
                                                      DropdownButton<String>(
                                                        isDense: true,
                                                        underline: const SizedBox(),
                                                        hint: Text('${controller.domesticHelp!.data!.record!.serviceLocations!.length - 1} more flats', style: Styles.smallText),
                                                        onChanged: (String? selectedValue) {},
                                                        items: controller.domesticHelp!.data!.record!.serviceLocations!
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
                                        ),
                                      ],
                                    ),
                                    const Divider(height: 20, thickness: 0.3),
                                    Wrap(
                                      spacing: 8,
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      alignment: WrapAlignment.center,
                                      runAlignment: WrapAlignment.center,
                                      children: [
                                        if (Constants.userRole == Constants.securitySupervisor &&
                                            controller.allowInTime != null &&
                                            controller.unVerifyCount.value != 0 &&
                                            controller.isAllowInOut == true)
                                          ViewGatePassComponent(),
                                        commonOutlineButton(
                                          onCall: () {
                                            launchUrl(Uri.parse('tel:${controller.domesticHelp!.data!.record!.domhelpNumber}'));
                                          },
                                          child: Icon(Icons.call_rounded, size: 20, color: Get.iconColor),
                                        ),
                                        // commonOutlineButton(
                                        //   onCall: () {
                                        //     Share.share('check out my website https://example.com');
                                        //   },
                                        //   child: Icon(Icons.share_outlined, size: 20, color: Get.iconColor),
                                        // ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (Constants.userRole == Constants.securitySupervisor && controller.unVerifyCount.value == 0 && controller.isAllowInOut == true)
                              Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: textButton(onPressed: () => controller.allowInOut(), widget: Text(controller.isAllowOut.isTrue && controller.allowInId != null ? "Allow Out" : "Allow In"))),
                            Card(
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TabBar(
                                    physics: const NeverScrollableScrollPhysics(),
                                    dividerColor: Colors.transparent,
                                    indicatorPadding: const EdgeInsets.all(4),
                                    labelPadding: const EdgeInsets.symmetric(horizontal: 26),
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    tabAlignment: TabAlignment.center,
                                    isScrollable: true,
                                    indicator: BoxDecoration(
                                      color: Constants.primaryColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    labelColor: Colors.white,
                                    unselectedLabelColor: Colors.grey,
                                    tabs: const [
                                      Tab(text: 'Attendance'),
                                      Tab(text: 'Details'),
                                      Tab(text: 'Gate Pass History'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: TabBarView(
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  SingleChildScrollView(
                                    child: AttendanceComponent(
                                      recordId: controller.domesticHelp!.data!.record!.currentRecordId!,
                                      moduleName: Constants.domesticHelp,
                                    ),
                                  ),
                                  SingleChildScrollView(child: DetailComponent(detail: controller.domesticHelp!.data!.record!)),
                                  GatePassHistory(recordIdl: controller.domesticHelp!.data!.record!.currentRecordId!),
                                ],
                              ),
                            ),
                          ],
                        ) /*FutureBuilder(
                  future: dioServiceClient.getDomesticHelpDetailApi(recordId: widget.recordId),
                  builder: (c, snap) {
                    if (snap.hasData && snap.data != null) {
                      if (snap.data!.data!.record!.inoutDetails != null) {
                        isAllowOut = snap.data!.data!.record!.inoutDetails!.any((detail) => detail.inoutAllowInTime != null && detail.inoutAllowOutTime == null);
                      }
                      if (snap.data!.data!.record!.inoutDetails != null && snap.data!.data!.record!.inoutDetails!.isNotEmpty) {
                        var matchingDetail = snap.data!.data!.record!.inoutDetails?.firstWhereOrNull(
                          (detail) => detail.inoutAllowInTime != null && detail.inoutAllowOutTime == null,
                        );

                        if (matchingDetail != null) {
                          allowInId = matchingDetail.inoutId;
                          allowInTime = matchingDetail.inoutAllowInTime;
                          allowOutTime = matchingDetail.inoutAllowOutTime;
                        } else {
                          allowInTime = snap.data!.data!.record!.inoutDetails!.first.inoutAllowInTime;
                          allowOutTime = snap.data!.data!.record!.inoutDetails!.first.inoutAllowOutTime;
                        }
                      }
                      return Column(
                        children: [
                          Card(
                            margin: const EdgeInsets.all(16),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          if (snap.data!.data!.record!.domhelpPic != null) {
                                            Get.to(() => WaterTankImages(imageFiles: [snap.data!.data!.record!.domhelpPic!.first.urlpath!]));
                                          }
                                        },
                                        child: CircleAvatar(
                                          maxRadius: 40,
                                          backgroundImage: snap.data!.data!.record!.domhelpPic != null && snap.data!.data!.record!.domhelpPic!.isNotEmpty
                                              ? NetworkImage(snap.data!.data!.record!.domhelpPic!.first.urlpath!)
                                              : const NetworkImage(''),
                                        ),
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
                                                Expanded(child: Text(snap.data!.data!.record!.domhelpName.toString(), style: Styles.textBoldLabel)),
                                                Row(
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Constants.primaryColor),
                                                      child: Text(snap.data!.data!.record!.domhelpType.toString(), style: Styles.smallBoldText),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),

                                            if (allowInTime != null)
                                              Row(
                                                children: <Widget>[
                                                  const Icon(Icons.access_time_outlined, color: Colors.grey, size: 18),
                                                  Container(
                                                    width: 5,
                                                    height: 5,
                                                    margin: const EdgeInsets.only(left: 4, right: 4),
                                                    decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                                                  ),
                                                  Text(*/ /*printINTime*/ /* (allowInTime.toString()), style: Styles.textHeadLabel),
                                                  const Text(' - ', style: Styles.textHeadLabel),
                                                  allowOutTime != null
                                                      ? Text(*/ /*printINTime*/ /* (allowOutTime.toString()), style: Styles.textHeadLabel)
                                                      : const Text('Still Inside', style: TextStyle(color: Colors.green)),

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
                                            GestureDetector(
                                              onTap: Constants.userRole == Constants.ownerModule ? () => addRatingDialogue(context, snap.data!.data!.record!.currentRecordId!) : null,
                                              child: RatingBarIndicator(
                                                rating: double.parse(
                                                    snap.data!.data!.record!.domhelpRating != null && snap.data!.data!.record!.domhelpRating!.isNotEmpty ? snap.data!.data!.record!.domhelpRating! : '0'),
                                                itemBuilder: (context, index) => const Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                unratedColor: Colors.grey,
                                                itemCount: 5,
                                                itemSize: 20.0,
                                                direction: Axis.horizontal,
                                              ),
                                            ),
                                            // Row(
                                            //   children: [
                                            //     Icon(Icons.access_time_outlined, color: Colors.grey, size: 16),
                                            //     SizedBox(width: 4),
                                            //     Expanded(child: Text(snap.data!.data!.record!.domhelpTimeslot.toString(), style: Styles.textHeadLabel)),
                                            //   ],
                                            // ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                const Icon(Icons.home_outlined, color: Colors.grey, size: 18),
                                                const SizedBox(width: 4),
                                                Text(
                                                    snap.data!.data!.record!.domhelpSociety != null && snap.data!.data!.record!.domhelpSociety!.isNotEmpty
                                                        ? snap.data!.data!.record!.domhelpSociety!
                                                        : 'NA',
                                                    style: Styles.textHeadLabel),
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
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(height: 20, thickness: 0.3),
                                  Wrap(
                                    spacing: 8,
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    alignment: WrapAlignment.center,
                                    runAlignment: WrapAlignment.center,
                                    children: [
                                      if (Constants.userRole == Constants.securitySupervisor && allowInTime != null && widget.isAllowInOut == true)
                                        ViewGatePassComponent(
                                          recordId: snap.data!.data!.record!.currentRecordId!,
                                          callBack: (c) {
                                            unVerifyCount = c;
                                            setState(() {});
                                            log("unverified count----$unVerifyCount");
                                          },
                                        ),
                                      commonOutlineButton(
                                        onCall: () {
                                          launchUrl(Uri.parse('tel:${snap.data!.data!.record!.domhelpNumber}'));
                                        },
                                        child: Icon(Icons.call_rounded, size: 20, color: Get.iconColor),
                                      ),
                                      commonOutlineButton(
                                        onCall: () {
                                          Share.share('check out my website https://example.com');
                                        },
                                        child: Icon(Icons.share_outlined, size: 20, color: Get.iconColor),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (Constants.userRole == Constants.securitySupervisor && */ /* gatePassList.length == 0 && */ /* widget.isAllowInOut == true)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: isAllowOut == true && allowInId != null
                                  ? textButton(
                                      onPressed: () async {
                                        await dioServiceClient.allowInOutApi(valueRecordId: snap.data!.data!.record!.currentRecordId!, recordID: allowInId, moduleId: Constants.domesticHelpId).then((v) {
                                          if (v.statuscode == 1 && v.data != null) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text(v.data!.message.toString())),
                                            );
                                            Get.back();
                                            if (widget.isScan == true) Get.back();
                                          }
                                        });
                                      },
                                      widget: const Text("Allow Out"))
                                  : textButton(
                                      onPressed: () async {
                                        await dioServiceClient.allowInOutApi(valueRecordId: snap.data!.data!.record!.currentRecordId!, moduleId: Constants.domesticHelpId).then((v) {
                                          if (v.statuscode == 1 && v.data != null) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text(v.data!.message.toString())),
                                            );
                                            Get.back();
                                            if (widget.isScan == true) Get.back();
                                          }
                                        });
                                      },
                                      widget: const Text("Allow In")),
                            ),
                          Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TabBar(
                                  physics: const NeverScrollableScrollPhysics(),
                                  dividerColor: Colors.transparent,
                                  indicatorPadding: const EdgeInsets.all(4),
                                  labelPadding: const EdgeInsets.symmetric(horizontal: 26),
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  tabAlignment: TabAlignment.center,
                                  isScrollable: true,
                                  indicator: BoxDecoration(
                                    color: Constants.primaryColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  labelColor: Colors.white,
                                  unselectedLabelColor: Colors.grey,
                                  tabs: const [
                                    Tab(text: 'Attendance'),
                                    Tab(text: 'Details'),
                                    Tab(text: 'Gate Pass History'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: TabBarView(
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                SingleChildScrollView(
                                  child: AttendanceComponent(
                                    recordId: snap.data!.data!.record!.currentRecordId!,
                                    moduleName: Constants.domesticHelp,
                                  ),
                                ),
                                SingleChildScrollView(child: DetailComponent(detail: snap.data!.data!.record!)),
                                GatePassHistory(recordIdl: snap.data!.data!.record!.currentRecordId!),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }),*/
                  ),
            ),
          );
        });
  }

  void addRatingDialogue(BuildContext context, String recordId, DomesticHelpProfileController controller) {
    double? ratingCount = 0;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(child: Text("Add Rating to Domestic Help", style: Styles.textBoldLabel)),
                    CloseButton(onPressed: () => Navigator.pop(context)),
                  ],
                ),
                const SizedBox(height: 8),
                RatingBar.builder(
                  initialRating: ratingCount!,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                  onRatingUpdate: (rating) {
                    ratingCount = rating;
                    setState(() {});
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.addRating(recordId: recordId, rating: ratingCount!.toDouble()),
                  child: const Text('Add Rating'),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
