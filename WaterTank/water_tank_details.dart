import 'dart:io';

// import 'package:auto_size_text/auto_size_text.dart';
import 'package:biz_infra/CustomWidgets/IntExtensions.dart';
import 'package:biz_infra/CustomWidgets/image_view.dart';
import 'package:biz_infra/Network/dio_service_client.dart';
import 'package:biz_infra/Screens/WaterTank/water_tank_list.dart';
import 'package:biz_infra/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../CustomWidgets/configurable_widgets.dart';
import '../../CustomWidgets/preview_pdf.dart';
import '../../Model/WaterTank/water_tank_details_model.dart';
import '../../Utils/app_styles.dart';
import '../../Utils/common_widget.dart';
import '../DomesticHelp/component/attendance_component.dart';
import 'water_tank_edit.dart';

class WaterTankDetails extends StatefulWidget {
  final String waterTankId;
  final String? waterTankStatusInfo;

  final bool? isAllowInOut;
  final bool? isScan;

  const WaterTankDetails({
    super.key,
    required this.waterTankId,
    this.waterTankStatusInfo,
    this.isAllowInOut = false,
    this.isScan = false,
  });

  @override
  State<WaterTankDetails> createState() => _WaterTankDetailsState();
}

class _WaterTankDetailsState extends State<WaterTankDetails> {
  WaterTankDetailModel? waterTankDetailModelData;
  File? dailyImage;
  bool? isAllowOut = false;
  String? allowInId;
  String? allowInTime;
  String? allowOutTime;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
          Get.back();
          if (widget.isScan == true) Get.back();
          return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Water Tank Details"),
          leading: BackButton(
            onPressed: () {
              Get.back();
              if (widget.isScan == true) Get.back();
            },
          ),
          actions: (widget.waterTankStatusInfo == 'Canceled' || widget.waterTankStatusInfo == 'Approval pending')
              ? []
              : Constants.userRole == Constants.facilityManager
                  ? []
                  : <Widget>[
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert),
                        onSelected: (String value) async {
                          switch (value) {
                            case 'Cancel':
                              try {
                                var cancelData = await dioServiceClient.cancelWaterTank(record: widget.waterTankId.split('x').last);
                                if (cancelData?.statuscode == 1 && cancelData?.statusMessage == "Record Canceled Successfully") {
                                  Get.off(() => const WaterTankList());
                                } else {
                                  snackBarMessenger("Failed to cancel water tank");
                                }
                              } catch (e) {
                                snackBarMessenger("An error occurred: $e");
                              }
                              break;

                            case 'Renew':
                              Get.to(() => WaterTankEditScreen(
                                    waterTankId: widget.waterTankId,
                                    waterTankData: waterTankDetailModelData,
                                    isRenew: true,
                                  ));
                              break;

                            case 'Edit':
                              Get.to(() => WaterTankEditScreen(
                                    waterTankId: widget.waterTankId,
                                    waterTankData: waterTankDetailModelData,
                                    isRenew: false,
                                  ));
                              break;
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          if (widget.waterTankStatusInfo == 'Ongoing' || widget.waterTankStatusInfo == 'Initiated') {
                            return [
                              const PopupMenuItem<String>(
                                value: 'Cancel',
                                child: Text('Cancel'),
                              ),
                              const PopupMenuItem<String>(
                                value: 'Edit',
                                child: Text('Edit'),
                              ),
                            ];
                          } else if (widget.waterTankStatusInfo == 'Expired') {
                            // Display only "Renew" option if status is "Expired"
                            return [
                              const PopupMenuItem<String>(
                                value: 'Renew',
                                child: Text('Renew'),
                              ),
                            ];
                          } else {
                            // If status is "Canceled" or any other unexpected value, no items should be displayed
                            return [];
                          }
                        },
                      ),
                    ],
        ),
        body: FutureBuilder(
          future: dioServiceClient.getWaterTankDetails(recordId: widget.waterTankId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              waterTankDetailModelData = snapshot.data;
              // waterTankDetailModelData!.data!.record!.wtStatusinfo.toString();
              final photos = snapshot.data!.data!.record!.wttakePhoto;
              if (waterTankDetailModelData!.data!.record!.inoutDetails != null) {
                isAllowOut = waterTankDetailModelData!.data!.record!.inoutDetails!.any((detail) => detail.inoutAllowInTime != null && detail.inoutAllowOutTime == null);
              }
              if (waterTankDetailModelData!.data!.record!.inoutDetails != null && waterTankDetailModelData!.data!.record!.inoutDetails!.isNotEmpty) {
                var matchingDetail = waterTankDetailModelData!.data!.record!.inoutDetails?.firstWhereOrNull(
                  (detail) => detail.inoutAllowInTime != null && detail.inoutAllowOutTime == null,
                );

                if (matchingDetail != null) {
                  allowInId = matchingDetail.inoutId;
                  allowInTime = matchingDetail.inoutAllowInTime;
                  allowOutTime = matchingDetail.inoutAllowOutTime;
                } else {
                  allowInTime = waterTankDetailModelData!.data!.record!.inoutDetails!.first.inoutAllowInTime;
                  allowOutTime = waterTankDetailModelData!.data!.record!.inoutDetails!.first.inoutAllowOutTime;
                }
              }

              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          keyValue(key:"Supplier Name", value:snapshot.data!.data!.record!.wtsuplierName.toString()),
                          const SizedBox(height: 5),
                          keyValue(key:"Water Tanker Capacity", value:"${snapshot.data!.data!.record!.wtcapacity} Ltrs"),
                          const SizedBox(height: 5),
                          keyValue(key:"Contact Number", value:snapshot.data!.data!.record!.wtcontactNumber.toString()),
                          const SizedBox(height: 5),
                          keyValue(key:"Validity Period", value:"${snapshot.data!.data!.record!.wtchooseDate} - ${snapshot.data!.data!.record!.wtendDate}"),
                          const SizedBox(height: 5),
                          keyValue(key:"Status", value:snapshot.data!.data!.record!.wtStatusinfo.toString()),
                          const SizedBox(height: 5),
                          if (allowInTime != null)
                            keyValue(
                              key: 'Time',
                              value: '',
                              child: Row(
                                children: [
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
                            ),
                          // Row(
                          //   children: <Widget>[
                          //     const Expanded(
                          //       flex: 2,
                          //       child: AutoSizeText(
                          //         'Time',
                          //         minFontSize: 14.0,
                          //         style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
                          //         textAlign: TextAlign.left,
                          //       ),
                          //     ),
                          //     const AutoSizeText(':'),
                          //     const SizedBox(width: 10),
                          //     Expanded(
                          //       flex: 3,
                          //       child: Row(
                          //         children: [
                          //           Container(
                          //             width: 5,
                          //             height: 5,
                          //             margin: const EdgeInsets.only(left: 4, right: 4),
                          //             decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                          //           ),
                          //           Text( (allowInTime.toString()), style: Styles.textHeadLabel),
                          //           const Text(' - ', style: Styles.textHeadLabel),
                          //           allowOutTime != null
                          //               ? Text((allowOutTime.toString()), style: Styles.textHeadLabel)
                          //               : const Text('Still Inside', style: TextStyle(color: Colors.green)),
                          //         ],
                          //       ),
                          //     ),
                          //   ],
                          // ),

                          (photos == null || photos.isEmpty)
                              ? const SizedBox.shrink()
                              : const Text(
                                  "Owner's Image",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                          photos != null && photos.isNotEmpty
                              ? GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: photos.length,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3, // 3 images per row
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                  ),
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () async {
                                        File file = await getFile(photos[index].urlpath.toString(), photos[index].name.toString());
                                        if (photos[index].name!.endsWith('.jpg') || photos[index].name!.endsWith('.png')) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ImageViewScreen(
                                                imageFile: file,
                                                imageName: photos[index].name.toString(),
                                                showDownload: true,
                                              ),
                                            ),
                                          );
                                        } else if (photos[index].name!.endsWith('.pdf')) {
                                          // Open full-screen video view when a video is tapped
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => PreviewPdf(pdfUrl: photos[index].urlpath.toString(), pdfName: photos[index].name.toString())),
                                          );
                                        }
                                      },
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          photos[index].name!.endsWith('.jpg') || photos[index].name!.endsWith('.png')
                                              ? Image.network(
                                                  photos[index].urlpath.toString(),
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  loadingBuilder: (context, child, loadingProgress) {
                                                    if (loadingProgress == null) {
                                                      return child; // Image is fully loaded
                                                    } else {
                                                      return const CircularProgressIndicator(); // Show loader
                                                    }
                                                  },
                                                )
                                              : photos[index].name!.endsWith('.pdf')
                                                  ? const Padding(
                                                      padding: EdgeInsets.all(8.0),
                                                      child: Icon(Icons.picture_as_pdf),
                                                    )
                                                  : Container(),
                                        ],
                                      ),
                                    );
                                  },
                                )
                              : const SizedBox.shrink(),

                          const SizedBox(height: 10),
                          (snapshot.data?.data?.record?.wtUploadAttachment == null || snapshot.data!.data!.record!.wtUploadAttachment!.isEmpty)
                              ? const SizedBox.shrink()
                              : const Text(
                                  "Documents",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                          snapshot.data?.data?.record?.wtUploadAttachment != null && snapshot.data!.data!.record!.wtUploadAttachment!.isNotEmpty
                              ? GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.data!.record!.wtUploadAttachment?.length,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3, // 3 images per row
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                  ),
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () async {
                                        File file = await getFile(
                                            snapshot.data!.data!.record!.wtUploadAttachment![index].urlpath.toString(), snapshot.data!.data!.record!.wtUploadAttachment![index].name.toString());
                                        if (snapshot.data!.data!.record!.wtUploadAttachment![index].name!.endsWith('.jpg') ||
                                            snapshot.data!.data!.record!.wtUploadAttachment![index].name!.endsWith('.png')) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ImageViewScreen(
                                                imageFile: file,
                                                imageName: snapshot.data!.data!.record!.wtUploadAttachment![index].name.toString(),
                                                showDownload: true,
                                              ),
                                            ),
                                          );
                                        } else if (snapshot.data!.data!.record!.wtUploadAttachment![index].name!.endsWith('.pdf')) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => PreviewPdf(
                                                    pdfUrl: snapshot.data!.data!.record!.wtUploadAttachment![index].urlpath.toString(),
                                                    pdfName: snapshot.data!.data!.record!.wtUploadAttachment![index].name.toString())),
                                          );
                                        }
                                      },
                                      child: snapshot.data!.data!.record!.wtUploadAttachment![index].name!.endsWith('.jpg') ||
                                              snapshot.data!.data!.record!.wtUploadAttachment![index].name!.endsWith('.png')
                                          ? Image.network(
                                              snapshot.data!.data!.record!.wtUploadAttachment![index].urlpath.toString(),
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: double.infinity,
                                              loadingBuilder: (context, child, loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return child; // Image is fully loaded
                                                } else {
                                                  return const CircularProgressIndicator();
                                                }
                                              },
                                            )
                                          : snapshot.data!.data!.record!.wtUploadAttachment![index].name!.endsWith('.pdf')
                                              ? const Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Icon(Icons.picture_as_pdf),
                                                )
                                              : Container(),
                                    );
                                  },
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                    if (widget.isAllowInOut == true)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: textButton(
                            onPressed: () async {
                              dailyImage = await takePhoto(() {
                                setState(() {});
                              });
                              if (dailyImage != null) {
                                await dioServiceClient.allowInOutApi(valueRecordId: snapshot.data!.data!.record!.currentRecordId, recordID: allowInId, moduleId: Constants.waterTankId).then((v) async {
                                  if (v.statuscode == 1 && v.data != null) {
                                    Get.back();
                                    if (widget.isScan == true) Get.back();
                                    await dioServiceClient.allowInImgForWaterTank(recordId: v.data!.id, imageName: dailyImage).then((c) async {
                                      if (c != null && c.statuscode == 1) {
                                        Get.back();
                                      }
                                    });
                                    Get.snackbar(
                                      "Success",
                                      v.data!.message!,
                                      snackPosition: SnackPosition.TOP,
                                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                                      borderRadius: 10,
                                      backgroundColor: Colors.green,
                                      colorText: Colors.white,
                                    );
                                  }
                                });
                              }
                            },
                            widget: Text(isAllowOut == true && allowInId != null ? "Allow Out" : "Allow In")),
                      ),
                    AttendanceComponent(
                      recordId: waterTankDetailModelData!.data!.record!.currentRecordId!,
                      moduleName: Constants.waterTank,
                    ),
                    16.height,
                  ],
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
