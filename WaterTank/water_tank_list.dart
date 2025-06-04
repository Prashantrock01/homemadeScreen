import 'dart:developer';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:biz_infra/Network/dio_service_client.dart';
import 'package:biz_infra/Screens/WaterTank/water_tank_details.dart';
import 'package:biz_infra/Screens/WaterTank/water_tanker.dart';
import 'package:biz_infra/Themes/theme_controller.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../CustomWidgets/CustomLoaders/custom_loader.dart';
import '../../CustomWidgets/configurable_widgets.dart';
import '../../Utils/app_string.dart';
import '../../Utils/constants.dart';
import 'Component/commonSharePasscodeDialogue.dart';

class WaterTankList extends StatefulWidget {
  final bool showAppBar;

  const WaterTankList({this.showAppBar = true, super.key});

  @override
  State<WaterTankList> createState() => _WaterTankListState();
}

class _WaterTankListState extends State<WaterTankList> {
  var userRole = Constants.userRole;
  RxList<dynamic> recordList = [].obs;
  int page = 1;
  bool isMorePage = true;
  bool isLoading = false;
  final ScrollController _sc = ScrollController();
  final RxBool _showProgress = false.obs;
  RxBool retryData = false.obs;
  String? waterTankIdForCancel;

  fetchWaterTankList({bool isRefresh = false}) async {
    if (!isRefresh) {
      if (page == 1) {
        _showProgress.value = true; // Show loader only on the first load
      } else {
        isLoading = true; // Show pagination loader
      }
    }

    retryData.value = false;

    try {
      var response = await dioServiceClient.getWaterTankList(true, page: page);
      if (response?.statuscode == 1 && response!.data!.records!.isNotEmpty) {
        waterTankIdForCancel = response.data!.records!.first.watertankid.toString();
        if (isRefresh) {
          recordList.clear(); // Clear old data when refreshing
        }
        recordList.addAll(response.data!.records!);
        isMorePage = response.data!.moreRecords ?? false;
        log("is more pages-----$isMorePage");
      } else {
        recordList.clear();
      }
    } catch (e) {
      retryData.value = true;
    }
    _showProgress.value = false;
    isLoading = false;
  }

  checkConnectivity() async {
    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
    setState(() {
      isConnected = connectivityResult.contains(ConnectivityResult.mobile) || connectivityResult.contains(ConnectivityResult.wifi) || connectivityResult.contains(ConnectivityResult.ethernet);
    });
  }

  @override
  void initState() {
    super.initState();

    checkConnectivity();
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> connectivityResult) {
      if (mounted) {
        setState(() {
          isConnected = connectivityResult.contains(ConnectivityResult.mobile) || connectivityResult.contains(ConnectivityResult.wifi) || connectivityResult.contains(ConnectivityResult.ethernet);
        });
      } else {
        isConnected = connectivityResult.contains(ConnectivityResult.mobile) || connectivityResult.contains(ConnectivityResult.wifi) || connectivityResult.contains(ConnectivityResult.ethernet);
      }
    });

    fetchWaterTankList();
    _sc.addListener(() {
      if (_sc.position.pixels >= _sc.position.maxScrollExtent&& !isLoading) {
        if (isMorePage) {
          page++;
          isLoading = true;
          setState(() {});
          fetchWaterTankList();
        }
      }
    });
  }

  refreshHandler() async {
    page = 1;
    await fetchWaterTankList(isRefresh: true);
    setState(() {});
  }

  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: widget.showAppBar ? AppBar(title: AutoSizeText(waterTankText)) : null,
        body: !isConnected
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: Text(noInternetText)),
                  ElevatedButton(
                    onPressed: () {
                      Get.to(() => const WaterTankList());
                    },
                    child: Text(retryText),
                  ),
                ],
              )
            : Obx(
                () => retryData.isTrue
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(child: Text(retryToLoadDataText)),
                          const SizedBox(height: 10),
                          ElevatedButton(
                              onPressed: () async {
                                await refreshHandler();
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(builder: (context) => const WaterTankList()),
                                // );
                              },
                              child: Text(retryText)),
                        ],
                      )
                    : _showProgress.isTrue
                        ? const Center(child: CustomLoader())
                        : recordList.isEmpty
                            ? Center(child: AutoSizeText(waterTankEmptyText))
                            : RefreshIndicator(
                                onRefresh: () async {
                                  await refreshHandler();
                                },
                                child: Obx(
                                  () => SingleChildScrollView(
                                    controller: _sc,
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    child: Column(
                                      children: [
                                        ListView.builder(
                                          physics: const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: recordList.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            return Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: InkWell(
                                                onTap: () {
                                                  Get.to(() => WaterTankDetails(waterTankId: recordList[index].id.toString(), waterTankStatusInfo: recordList[index].wtStatusinfo.toString()));
                                                },
                                                child: Card(
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                                                    child: Column(
                                                      children: [
                                                        Align(
                                                          alignment: Alignment.centerRight,
                                                          child: Container(
                                                              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                                                              decoration: BoxDecoration(
                                                                color: ThemeController.selectedTheme == ThemeMode.dark ? Colors.black38 : Colors.black38,
                                                                borderRadius: BorderRadius.circular(20),
                                                              ),
                                                              child: Text(
                                                                recordList[index].wtStatusinfo.toString(),
                                                                style: TextStyle(fontSize: 12, color: ThemeController.selectedTheme == ThemeMode.light ? Colors.white : Colors.white),
                                                              )),
                                                        ),
                                                        keyValue(key:supplierNameText, value:recordList[index].wtsuplierName.toString()),
                                                        keyValue(key:waterTankCapacityText, value:"${recordList[index].wtcapacity} Ltrs"),

                                                        keyValue(
                                                            key:contactNumberText,
                                                            value: recordList[index].wtcontactNumber.toString(), color: Colors.blue,
                                                            onPress: (){
                                                              launchUrl(Uri.parse("tel:${recordList[index].wtcontactNumber.toString()}"));
                                                            }),

                                                        keyValue(key:startDateText, value:recordList[index].wtchooseDate.toString()),
                                                        keyValue(key:endDateText, value:recordList[index].wtendDate.toString()),
                                                        (Constants.userRole == 'Facility Manager')
                                                            ? (recordList[index].wtStatusinfo == canceledText || recordList[index].wtStatusinfo == expiredText)
                                                                ? const SizedBox.shrink()
                                                                // : const Divider(),
                                                                : (recordList[index].wtStatusinfo == canceledText || recordList[index].wtStatusinfo == expiredText)
                                                                    ? const SizedBox(height: 0)
                                                                    : recordList[index].wtStatusinfo.toString() == approvalPendingText
                                                                        ? Column(
                                                                            children: [
                                                                              Divider(color: Colors.grey.shade300),
                                                                              AutoSizeText(
                                                                                waitingForApprovalText,
                                                                                style: const TextStyle(color: Colors.red),
                                                                              ),
                                                                            ],
                                                                          )
                                                                        : GestureDetector(
                                                                            onTap: () {
                                                                              showQRCodeDialog(context, recordList[index].qrcode.toString(), recordList[index].passcode.toString(),
                                                                                  ("${recordList[index].wtchooseDate} To ${recordList[index].wtendDate}"));
                                                                            },
                                                                            child: Column(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                Divider(
                                                                                  color: Colors.grey.shade300,
                                                                                ),
                                                                                iconTextWidget(Icons.share, sharePasscodeText, alignment: MainAxisAlignment.center),
                                                                              ],
                                                                            ),
                                                                          )
                                                            : const SizedBox.shrink(),
                                                        // isMorePage
                                                        //     ? (index == recordList.length - 1)
                                                        //         ? const CircularProgressIndicator()
                                                        //         : const SizedBox(height: 0)
                                                        //     : const SizedBox(height: 0),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        Visibility(
                                          visible: isMorePage,
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
                                ),
                              ),
              ),
        floatingActionButton: userRole == securitySupervisorText
            ? FloatingActionButton(
                onPressed: () async {
                  bool? res = await Get.to(() => const WaterTanker());
                  if (res == true) {
                    refreshHandler();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/images/tanker.png'),
                ),
              )
            : const SizedBox.shrink());
  }
}
