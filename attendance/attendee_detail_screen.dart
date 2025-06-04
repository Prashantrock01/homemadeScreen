import "dart:io";

import "package:biz_infra/CustomWidgets/IntExtensions.dart";
import "package:biz_infra/CustomWidgets/confirmation_dialog.dart";
import "package:biz_infra/Model/WaterTank/AllowInOutModel.dart";
import "package:biz_infra/Network/dio_service_client.dart";
import "package:biz_infra/Utils/app_styles.dart";
import "package:biz_infra/Utils/common_widget.dart";
import "package:biz_infra/Utils/constants.dart";
import "package:flutter/material.dart";
import "package:flutter_easyloading/flutter_easyloading.dart";
import "package:get/get.dart";
import "package:image_picker/image_picker.dart";
import "package:intl/intl.dart";
import "package:table_calendar/table_calendar.dart";

import "../../Model/Attendance/AttendaceDetailModel.dart";
// import "../../Model/Attendance/FaceDetectionModel.dart";
import "../../Model/Attendance/ServiceUserDetailModel.dart";
// import "face_detection_screen.dart";

class AttendeeDetailScreen extends StatefulWidget {
  final String? recordId;
  final String? serviceEngId;
  final String? imageUrl;

  const AttendeeDetailScreen({super.key, this.recordId, this.serviceEngId, this.imageUrl});

  @override
  State<AttendeeDetailScreen> createState() => _AttendeeDetailScreenState();
}

class _AttendeeDetailScreenState extends State<AttendeeDetailScreen> {
  final ImagePicker picker = ImagePicker();
  File? imageFile;
  bool? isSignOut = false;
  bool? isBreakOut = false;
  bool? isSignInVisible = false;
  bool? isLoading = false;
  String? attendanceId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendee Details'),
      ),
      body: Stack(
        children: [
          FutureBuilder(
              future: dioServiceClient.getServiceUserDetailApi(recordId: widget.recordId),
              builder: (context, snap) {
                if (snap.hasData && snap.data != null) {
                  if (snap.data!.data!.record!.attendanceDetails != null) {
                    isSignOut = snap.data!.data!.record!.attendanceDetails!.any((detail) => detail.signinTime != null && detail.signoutTime == null);
                    isBreakOut = snap.data!.data!.record!.attendanceDetails!.any((detail) => detail.signinTime != null && detail.breakInTime != null && detail.breakOutTime == null);
                    isSignInVisible = snap.data!.data!.record!.attendanceDetails!
                        .any((detail) => detail.signinTime != null && detail.breakInTime != null && detail.breakOutTime != null && detail.signoutTime != null);
                  }
                  if (snap.data!.data!.record!.attendanceDetails != null && snap.data!.data!.record!.attendanceDetails!.isNotEmpty) {
                    var matchingDetail = snap.data!.data!.record!.attendanceDetails?.firstWhereOrNull(
                      (detail) => detail.signinTime != null && detail.signoutTime == null,
                    );

                    if (matchingDetail != null) {
                      // allowInId = matchingDetail.inoutId;
                      // allowInTime = matchingDetail.inoutAllowInTime;
                      // allowOutTime = matchingDetail.inoutAllowOutTime;
                      attendanceId = matchingDetail.attendanceId;
                    } else {
                      // allowInTime = snap.data!.data!.record!.inoutDetails!.first.inoutAllowInTime;
                      // allowOutTime = snap.data!.data!.record!.inoutDetails!.first.inoutAllowOutTime;
                    }
                  }
                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                            maxRadius: 70,
                            backgroundImage: snap.data!.data!.record!.empImagefile != null && snap.data!.data!.record!.empImagefile!.isNotEmpty
                                ? NetworkImage(snap.data!.data!.record!.empImagefile!.first.urlpath.toString())
                                : const NetworkImage(''),
                          ),
                          8.height,
                          Text(snap.data!.data!.record!.serviceEngineerName.toString(), style: Styles.textLargeBoldLabel),
                          Text(snap.data!.data!.record!.phone.toString(), style: Styles.textHeadLabel),
                          Text(snap.data!.data!.record!.email.toString(), style: Styles.textHeadLabel),

                          // Text('Maid', style: Styles.smallText),
                        ],
                      ),
                      16.height,
                      if (Constants.userRole == Constants.facilityManager)
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Other Details', style: Styles.textLargeBoldLabel),
                                const Divider(color: Colors.amber),
                                commonWidget(dataKey: 'Shift Timing', dataValue: '${snap.data!.data!.record!.empStarttime} - ${snap.data!.data!.record!.empEndtime}'),
                                commonWidget(dataKey: 'Week Off', dataValue: '${snap.data!.data!.record!.empWeakoff}'),
                                commonWidget(dataKey: 'Total Hour', dataValue: '${snap.data!.data!.record!.totalWorkingHours} Hr'),
                              ],
                            ),
                          ),
                        ),
                      if (Constants.userRole == Constants.facilityManager) 16.height,
                      if (snap.data!.data!.record!.onLeave != '1' && isSignOut == false && (Constants.userRole == Constants.securitySupervisor) && isSignInVisible == false)
                        commonAppButton(
                          context: context,
                          onTap: () async {
                            imageFile = await takePhoto();
                            if (imageFile != null) {
                              faceMatchAndSignIn(
                                  captureImg: imageFile!, currentRecordId: snap.data!.data!.record!.currentRecordId!, dateForSignInOut: 'atten_signindate', timeForBreakNSignOut: 'atten_signintime');
                            }
                          },
                          child: const Text('Sign In'),
                        ),
                      if (snap.data!.data!.record!.onLeave != '1' && isSignOut == true && Constants.userRole == Constants.securitySupervisor && isSignInVisible == false)
                        Column(
                          children: [
                            Row(
                              children: [
                                isBreakOut == false
                                    ? SizedBox(
                                        width: (MediaQuery.of(context).size.width - 40) / 2,
                                        child: commonAppButton(
                                          context: context,
                                          onTap: () async {
                                            showConfirmationDialog(context,
                                                title: 'Are you sure want to Break In?',
                                                subtitle: 'Please confirm if you wish to go for a Break',
                                                color: Colors.red,
                                                icon: Icons.free_breakfast_outlined, onAccept: () async {
                                              Get.back();
                                              imageFile = await takePhoto();
                                              if (imageFile != null) {
                                                faceMatchAndSignIn(
                                                    captureImg: imageFile!,
                                                    currentRecordId: snap.data!.data!.record!.currentRecordId!,
                                                    dateForSignInOut: 'atten_signindate',
                                                    timeForBreakNSignOut: 'atten_breakintime',
                                                    recordId: attendanceId);
                                              }
                                            });
                                          },
                                          child: const Text('Break In'),
                                        ),
                                      )
                                    : SizedBox(
                                        width: MediaQuery.of(context).size.width - 32,
                                        child: commonAppButton(
                                          context: context,
                                          onTap: () async {
                                            showConfirmationDialog(context,
                                                title: 'Are you sure want to Break Out?',
                                                subtitle: 'Please confirm if you wish to return from break',
                                                color: Colors.green,
                                                icon: Icons.free_breakfast_outlined, onAccept: () async {
                                              Get.back();
                                              imageFile = await takePhoto();
                                              if (imageFile != null) {
                                                faceMatchAndSignIn(
                                                    captureImg: imageFile!,
                                                    currentRecordId: snap.data!.data!.record!.currentRecordId!,
                                                    dateForSignInOut: 'atten_signindate',
                                                    timeForBreakNSignOut: 'atten_breakouttime',
                                                    recordId: attendanceId);
                                              }
                                            });
                                          },
                                          child: const Text('Break Out'),
                                        ),
                                      ),
                                if (isBreakOut == false) 8.width,
                                if (isBreakOut == false)
                                  SizedBox(
                                    width: (MediaQuery.of(context).size.width - 40) / 2,
                                    child: commonAppButton(
                                      context: context,
                                      onTap: () async {
                                        showConfirmationDialog(context,
                                            title: 'Are you sure want to Sign Out?',
                                            subtitle: 'Please confirm if you wish to Sign Out For the Day?',
                                            color: Colors.red,
                                            icon: Icons.logout, onAccept: () async {
                                          Get.back();
                                          imageFile = await takePhoto();
                                          if (imageFile != null) {
                                            faceMatchAndSignIn(
                                                captureImg: imageFile!,
                                                currentRecordId: snap.data!.data!.record!.currentRecordId!,
                                                dateForSignInOut: 'atten_signoutdate',
                                                timeForBreakNSignOut: 'atten_signouttime',
                                                recordId: attendanceId);
                                          }
                                        });
                                      },
                                      child: const Text('Sign Out'),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      if (Constants.userRole == Constants.securitySupervisor && snap.data!.data!.record!.attendanceDetails != null && snap.data!.data!.record!.attendanceDetails!.isNotEmpty)
                        Column(
                          children: [
                            const Divider(color: Colors.amber, height: 20),
                            if (snap.data!.data!.record!.onLeave != '1')
                              ListView.separated(
                                shrinkWrap: true,
                                separatorBuilder: (c, i) {
                                  return const Divider();
                                },
                                itemCount: snap.data!.data!.record!.attendanceDetails!.length,
                                itemBuilder: (c, i) {
                                  AttendanceDetails data = snap.data!.data!.record!.attendanceDetails![i];
                                  return timeDisplayCard(signInTime: data.signinTime, signOutTime: data.signoutTime, breakInTime: data.breakInTime, breakOutTime: data.breakOutTime);
                                },
                              ),
                          ],
                        ),
                      if (Constants.userRole == Constants.facilityManager)
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Attendance Details', style: Styles.textLargeBoldLabel),
                                const Divider(color: Colors.amber),
                                TableCalendar(
                                  firstDay: DateTime.utc(2000, 01, 01),
                                  lastDay: DateTime.now(),
                                  focusedDay: DateTime.now(),
                                  currentDay: DateTime.now(),
                                  daysOfWeekStyle: const DaysOfWeekStyle(weekdayStyle: Styles.hintText, weekendStyle: Styles.hintText),
                                  onDaySelected: (selectedDay, focusedDay) {
                                    showDialog(
                                        context: context,
                                        builder: (c) {
                                          return Dialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16.0),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(16.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text('Time Sheet', style: Styles.smallBoldText),
                                                      CloseButton(),
                                                    ],
                                                  ),
                                                  FutureBuilder(
                                                      future: dioServiceClient.getDateWiseSignInOutApi(
                                                          recordID: snap.data!.data!.record!.currentRecordId, selectedDate: DateFormat('yyyy-MM-dd').format(selectedDay)),
                                                      builder: (context, snap) {
                                                        if (snap.hasData && snap.data != null) {
                                                          if (snap.data!.data!.attendanceDetails != null && snap.data!.data!.attendanceDetails!.isNotEmpty) {
                                                            return Column(
                                                              children: [
                                                                // commonWidget(dataKey: 'Total Hour', dataValue: printShortageTime(snap.data!.data!.totalWorkDuration!)),
                                                                // 8.height,
                                                                if (snap.data!.data!.attendanceDetails != null)
                                                                  ListView.separated(
                                                                    shrinkWrap: true,
                                                                    itemCount: snap.data!.data!.attendanceDetails!.length,
                                                                    separatorBuilder: (c, i) {
                                                                      return const Divider();
                                                                    },
                                                                    itemBuilder: (c, i) {
                                                                      AttendanceDetailsModel? attendanceData = snap.data!.data!.attendanceDetails![i];
                                                                      return Column(
                                                                        children: [
                                                                          commonWidget(dataKey: 'Shortage Hr', dataValue: formatDuration(attendanceData.shortageHours!)),
                                                                          8.height,
                                                                          timeDisplayCard(
                                                                              signInTime: attendanceData.signInTime,
                                                                              signOutTime: attendanceData.signOutTime,
                                                                              breakInTime: attendanceData.breakInTime,
                                                                              breakOutTime: attendanceData.breakOutTime),
                                                                          8.height,
                                                                          commonWidget(dataKey: 'Overtime Hr', dataValue: formatDuration(attendanceData.overtimeHours!)),
                                                                        ],
                                                                      );
                                                                    },
                                                                  )
                                                              ],
                                                            );
                                                          } else {
                                                            return const Center(
                                                              child: Text('No Attendance Log is available for this date'),
                                                            );
                                                          }
                                                        } else {
                                                          return const Center(child: CircularProgressIndicator());
                                                        }
                                                      })
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  headerStyle: const HeaderStyle(
                                    formatButtonVisible: false,
                                    titleCentered: true,
                                    leftChevronPadding: EdgeInsets.all(0),
                                    rightChevronPadding: EdgeInsets.all(0),
                                    formatButtonPadding: EdgeInsets.symmetric(horizontal: 16),
                                  ),
                                  calendarStyle: CalendarStyle(
                                    todayDecoration: BoxDecoration(
                                      color: Constants.primaryColor,
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    weekendTextStyle: Styles.textHeadLabel,
                                    defaultTextStyle: Styles.textHeadLabel,
                                    selectedTextStyle: Styles.smallBoldText,
                                    disabledTextStyle: Styles.hintText,
                                    selectedDecoration: const BoxDecoration(
                                      color: Colors.orange, // Highlight selected date with a color
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
          Visibility(
            visible: isLoading == true,
            child: const Center(
              child: CircularProgressIndicator(backgroundColor: Colors.transparent),
            ),
          ),
        ],
      ),
    );
  }

  Widget logComponent({required IconData icon, required String title, required String time, required Color color}) {
    return Row(
      children: [
        Text('$title: ', style: Styles.smallText),
        4.width,
        Text(time, style: Styles.smallBoldText),
      ],
    );
  }

  Widget commonWidget({required String dataKey, required String dataValue}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(dataKey, style: Styles.smallText),
        Text(dataValue, style: Styles.textBoldLabel),
      ],
    );
  }

  Future<File?> takePhoto() async {
    final XFile? captureImg = await ImagePicker().pickImage(source: ImageSource.camera);
    File? imageSelect;
    if (captureImg != null) {
      imageSelect = await compressImage(File(captureImg.path));
      setState(() {});
    }
    return imageSelect;
  }

  Future faceMatchAndSignIn({required String currentRecordId, required File captureImg, required String timeForBreakNSignOut, required String dateForSignInOut, String? recordId}) async {
    EasyLoading.show(status: 'Loading...');
    // isLoading = true;
    // setState(() {});
    var response = await dioServiceClient.faceAttendanceApi(serviceEngineerId: widget.serviceEngId, capturedImage: captureImg, empMatchImg: widget.imageUrl!);

    try {
      if (response!.statuscode == 1 && response.data != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.data!.message!)));
        Map res = {
          dateForSignInOut: DateFormat('dd/MM/yyyy').format(DateTime.now()),
          timeForBreakNSignOut: DateFormat('HH:mm a').format(DateTime.now()),
          "serviceengineerid": currentRecordId,
          "assigned_user_id": Constants.assignedUserId,
        };
        AllowInOutModel? signInResponse =
            await (recordId != null && recordId.isNotEmpty ? dioServiceClient.signInAttendanceApi(value: res, recordID: recordId) : dioServiceClient.signInAttendanceApi(value: res));
        if (signInResponse.statuscode == 1) {
          setState(() {});
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(signInResponse.data!.message!)),
          );
        }
      } else {
        if (response.statuscode == 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.statusMessage!)),
          );
        }
      }
    } catch (e) {
      throw e;
    } finally {
      // isLoading = false;
      // setState(() {});
      EasyLoading.dismiss();
    }
  }

  Widget timeDisplayCard({String? signInTime, String? signOutTime, String? breakInTime, String? breakOutTime}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (signInTime != null && signInTime.isNotEmpty) logComponent(icon: Icons.login, title: 'Sign In', color: Colors.green, time: signInTime),
            if (signOutTime != null && signOutTime.isNotEmpty) logComponent(icon: Icons.logout, title: 'Sign Out', color: Colors.red, time: signOutTime),
          ],
        ),
        8.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (breakInTime != null && breakInTime.isNotEmpty) logComponent(icon: Icons.free_breakfast_outlined, title: 'Break In', color: Colors.green, time: breakInTime),
            if (breakOutTime != null && breakOutTime.isNotEmpty) logComponent(icon: Icons.login, color: Colors.green, title: 'Break Out', time: breakOutTime),
          ],
        ),
      ],
    );
  }
}
