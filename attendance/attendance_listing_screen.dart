import 'dart:developer';

import 'package:biz_infra/CustomWidgets/CustomLoaders/custom_loader.dart';
import 'package:biz_infra/CustomWidgets/IntExtensions.dart';
import 'package:biz_infra/Model/Attendance/AttendanceListModel.dart';
import 'package:biz_infra/Network/dio_service_client.dart';
import 'package:biz_infra/Screens/attendance/attendee_detail_screen.dart';
import 'package:biz_infra/Utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttendanceListingScreen extends StatefulWidget {
  final bool showAppBar;

  const AttendanceListingScreen({this.showAppBar = true, super.key});

  @override
  State<AttendanceListingScreen> createState() => _AttendanceListingScreenState();
}

class _AttendanceListingScreenState extends State<AttendanceListingScreen> {
  List<Records> attendanceList = [];
  AttendanceListModel attendanceListModel = AttendanceListModel();

  int page = 1;
  bool? isMorePage = true;
  bool isLoading = false;
  ScrollController scrollController = ScrollController();
  final RxBool _showProgress = false.obs;
  bool retryData = false;

  @override
  void initState() {
    callApi();
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (isMorePage!) {
          page++;
          setState(() {});
          callApi();
        }
      }
    });
  }

  callApi({int? p}) async {
    page != 1 ? isLoading = true : _showProgress.value = true;
    retryData = false;
    try {
      var response = await dioServiceClient.getAttendanceList(p ?? page);
      if (response?.statuscode == 1) {
        setState(() {
          for (int i = 0; i < response!.data!.records!.length; i++) {
            attendanceList.add(response.data!.records![i]);
          }
          isMorePage = response.data!.moreRecords;
        });
      }
    } catch (e) {
      retryData = true;
      print("Error:  ${e.toString()}");
    }
    _showProgress.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar ? AppBar(title: const Text('Attendance List')) : null,
      body: _showProgress.isTrue
          ? const Center(child: CustomLoader())
          : attendanceList.isEmpty
              ? const Center(
                  child: Text("Attendance List is Empty", style: Styles.textBoldLabel),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    page = 1;
                    attendanceList.clear();
                    await callApi(p: 1);
                    setState(() {});
                  },
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: List.generate(attendanceList.length, (i) {
                          Records data = attendanceList[i];
                          return GestureDetector(
                            onTap: () {
                              Get.to(() => AttendeeDetailScreen(recordId: data.id, serviceEngId: data.serviceengineerid, imageUrl: data.docUrl));
                            },
                            child: SizedBox(
                              width: (MediaQuery.of(context).size.width - 40) / 2,
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      CircleAvatar(maxRadius: 45, backgroundImage: NetworkImage(data.docUrl.toString())),
                                      8.height,
                                      Text(data.serviceEngineerName.toString(), style: Styles.textLargeBoldLabel),
                                      if (data.email != null && data.email!.isNotEmpty)
                                        Column(
                                          children: [
                                            4.height,
                                            Text(data.email!, style: Styles.smallText, textAlign: TextAlign.center),
                                          ],
                                        )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      Visibility(
                        visible: isMorePage!,
                        child: const Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Center(
                            child: CircularProgressIndicator(backgroundColor: Colors.transparent),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
