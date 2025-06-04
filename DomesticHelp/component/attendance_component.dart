import 'dart:developer';

import 'package:biz_infra/CustomWidgets/IntExtensions.dart';
import 'package:biz_infra/Network/dio_service_client.dart';
import 'package:biz_infra/Screens/WaterTank/display_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../CustomWidgets/configurable_widgets.dart';
import '../../../Utils/app_styles.dart';
import '../../../Utils/constants.dart';

class AttendanceComponent extends StatelessWidget {
  final String? recordId;
  final String? moduleName;

  const AttendanceComponent({this.moduleName, this.recordId});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: TableCalendar(
        firstDay: DateTime.utc(2000, 01, 01),
        lastDay: DateTime.now(),
        focusedDay: DateTime.now(),
        currentDay: DateTime.now(),
        daysOfWeekHeight: 24,
        daysOfWeekStyle: const DaysOfWeekStyle(
          weekdayStyle: Styles.hintText,
          weekendStyle: Styles.hintText,
          decoration: BoxDecoration(), // Ensures no overlapping decoration
        ),
        onDaySelected: (selectedDay, focusedDay) {
          showDialog(
              context: context,
              builder: (c) {
                return timeSheetDialogue(selectedDay);
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
          disabledTextStyle: Styles.smallText,
          selectedDecoration: const BoxDecoration(
            color: Colors.orange, // Highlight selected date with a color
            shape: BoxShape.circle,
          ),
        ),
      ),
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

  Widget logComponent({required IconData icon, required String title, required String time, required Color color, String? imageUrl}) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        // Text('$title: ', style: Styles.smallText),
        4.width,
        Text(time, style: Styles.smallBoldText),
        if (imageUrl != null && imageUrl.isNotEmpty) 4.width,
        if (imageUrl != null && imageUrl.isNotEmpty)
          GestureDetector(
            onTap: () {
              Get.to(() => WaterTankImages(imageFiles: [imageUrl]));
            },
            child: const Icon(Icons.image_outlined, size: 18,color: Constants.primaryColor),
          ),
      ],
    );
  }

  Widget timeSheetDialogue(DateTime selectedDay) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Time Sheet', style: Styles.smallBoldText),
                CloseButton(),
              ],
            ),
            Text(DateFormat('EEEE,dd MMM yyyy').format(selectedDay), style: Styles.smallBoldText),
            8.height,
            FutureBuilder(
              future: dioServiceClient.getDateWiseAllowInOutApi(
                recordID: recordId,
                moduleName: moduleName,
                selectedDate: DateFormat('yyyy-MM-dd').format(selectedDay),
              ),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snap.connectionState == ConnectionState.done) {
                  if (snap.hasData && snap.data != null) {
                    final inoutDetails = snap.data!.data!.inoutDetails;
                    if (inoutDetails != null && inoutDetails.isNotEmpty) {
                      return Column(
                        children: [
                          Column(
                            children: List.generate(
                              inoutDetails.length,
                              (i) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    logComponent(icon: Icons.login, title: 'Sign In', color: Colors.green, time: inoutDetails[i].allowInTime.toString(), imageUrl: inoutDetails[i].inoutImage?.first),
                                    logComponent(
                                        icon: Icons.logout,
                                        title: 'Sign Out',
                                        color: Colors.red,
                                        time: inoutDetails[i].allowOutTime != null ? inoutDetails[i].allowOutTime.toString() : 'Still Inside',
                                        imageUrl: inoutDetails[i].inoutImage != null && inoutDetails[i].inoutImage!.length > 1 ? inoutDetails[i].inoutImage?.last : null),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Center(
                        child: Text('No Attendance Log is available for this date'),
                      );
                    }
                  } else if (snap.hasError) {
                    return Center(
                      child: Text('Error: ${snap.error}'),
                    );
                  }
                }
                return const Center(child: CircularProgressIndicator());
              },
            )
          ],
        ),
      ),
    );
  }
}
