import 'package:biz_infra/Network/dio_service_client.dart';
import 'package:biz_infra/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Model/DomesticHelp/gatePassHistoryListModel.dart';
import '../../Utils/app_styles.dart';
import '../WaterTank/display_image.dart';

class GatePassHistory extends StatefulWidget {
  final String? recordIdl;

  const GatePassHistory({this.recordIdl});

  @override
  State<GatePassHistory> createState() => _GatePassHistoryState();
}

class _GatePassHistoryState extends State<GatePassHistory> {
  final ScrollController scrollController = ScrollController();
  final List<GatePassModel> gatePassRecords = [];
  bool isLoading = false;
  bool hasMoreData = true;
  int page = 1;

  @override
  void initState() {
    super.initState();
    fetchGatePasses();

    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !isLoading && hasMoreData) {
        fetchGatePasses();
      }
    });
  }

  Future<void> fetchGatePasses() async {
    setState(() {
      isLoading = true;
    });

    final response = await dioServiceClient.gatePassListApi(page: page.toString(), isVerify: Constants.userRole == Constants.securitySupervisor ? '1' : '0', recordId: widget.recordIdl);
    if (response != null && response.data != null && response.data!.records != null) {
      setState(() {
        gatePassRecords.addAll(response.data!.records!);
        hasMoreData = response.data!.moreRecords!;
        if (hasMoreData) page++;
      });
    } else {
      setState(() {
        hasMoreData = false;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return gatePassRecords.isEmpty && isLoading
        ? const Center(child: CircularProgressIndicator())
        : gatePassRecords.isEmpty && !isLoading
            ? const Center(
                child: Text('Gate Pass List Is Empty', style: Styles.smallText),
              )
            : ListView.builder(
                controller: scrollController,
                itemCount: gatePassRecords.length + (isLoading && hasMoreData ? 1 : 0),
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, i) {
                  if (i == gatePassRecords.length && isLoading && hasMoreData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (i >= gatePassRecords.length) {
                    return const SizedBox.shrink();
                  }

                  final data = gatePassRecords[i];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (data.gatepassHavegiven != null)
                            Row(
                              children: [
                                const Text('Parcel is: ', style: Styles.smallBoldText, textAlign: TextAlign.center),
                                Text(data.gatepassHavegiven!, style: Styles.textHeadLabel, textAlign: TextAlign.center),
                              ],
                            ),
                          Row(
                            children: [
                              const Text('Created on: ', style: Styles.smallBoldText, textAlign: TextAlign.center),
                              Text(data.createdtime!, style: Styles.textHeadLabel, textAlign: TextAlign.center),
                            ],
                          ),
                          Row(
                            children: [
                              const Text('Verify Status: ', style: Styles.smallBoldText, textAlign: TextAlign.center),
                              Text(data.gatepassIsverify == '1' ? 'Verify' : 'Pending',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: data.gatepassIsverify == '1' ? Colors.green : Colors.red,
                                    fontStyle: FontStyle.normal,
                                  ),
                                  textAlign: TextAlign.center),
                            ],
                          ),
                          if (data.gatepassDescription != null) Text(data.gatepassDescription!, style: Styles.textHeadLabel, textAlign: TextAlign.center),
                          if (data.docUrl != null && data.docUrl!.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                Get.to(() => WaterTankImages(imageFiles: data.docUrl!));
                              },
                              child: Image.network(
                                data.docUrl!.first,
                                width: (MediaQuery.of(context).size.width - 72) / 2,
                                height: 100,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
