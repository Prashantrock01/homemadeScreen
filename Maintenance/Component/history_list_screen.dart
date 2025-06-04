import 'dart:io';

import 'package:biz_infra/CustomWidgets/CustomLoaders/custom_loader.dart';
import 'package:biz_infra/CustomWidgets/IntExtensions.dart';
import 'package:biz_infra/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../Model/Maintenance/PaymentDueListModel.dart';
import '../../../Network/dio_service_client.dart';
import '../../../Utils/app_styles.dart';
import '../../WaterTank/display_image.dart';

class HistoryListScreen extends StatefulWidget {
  const HistoryListScreen({super.key});

  @override
  State<HistoryListScreen> createState() => _HistoryListScreenState();
}

class _HistoryListScreenState extends State<HistoryListScreen> {
  final ScrollController scrollController = ScrollController();
  final List<DuePaymentModel> historyData = [];
  bool isLoading = false;
  bool hasMore = true;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    fetchData();
    // scrollController.addListener(onScroll);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchData({bool isRefresh = false}) async {
    if (isLoading) return;

    if (!isRefresh) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      if (isRefresh) {
        currentPage = 1;
        hasMore = true;
        historyData.clear();
      }

      final response = await dioServiceClient.paymentDueListApi(
        paidValue: 'Paid',
        page: currentPage,
      );

      if (response != null && response.data != null && response.data!.records != null && response.data!.records!.isNotEmpty) {
        historyData.addAll(response.data!.records!);
        hasMore = response.data!.moreRecords!; // No more data to load
      } else {
        hasMore = false;
      }

      currentPage++;
    } catch (e) {
      debugPrint('Error fetching data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void onScroll() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200 && hasMore && !isLoading) {
      fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => fetchData(isRefresh: true),
      child: historyData.isEmpty && !isLoading
          ? const Center(child: Text('No Maintenance History'))
          : isLoading
              ? const Center(child: CustomLoader())
              : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  controller: scrollController,
                  itemCount: historyData.length /*+ (hasMore ? 1 : 0)*/,
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    if (index == historyData.length) {
                      // Show loading indicator at the bottom
                      return const Center(child: CircularProgressIndicator());
                    }

                    final data = historyData[index];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Transaction: ${data.transactionid}', style: Styles.hintText),
                            const SizedBox(height: 8),
                            if (Constants.userRole == Constants.facilityManager)
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      const Text('Payee Name:'),
                                      const SizedBox(width: 4),
                                      Text(data.payeeName.toString(), style: Styles.textBoldLabel),
                                    ],
                                  ),
                                  8.height,
                                  Row(
                                    children: [
                                      const Text('Block:'),
                                      const SizedBox(width: 4),
                                      Text(data.relatedBlock.toString(), style: Styles.textBoldLabel),
                                    ],
                                  ),
                                  8.height,
                                  Row(
                                    children: [
                                      const Text('Flat:'),
                                      const SizedBox(width: 4),
                                      Text(data.relatedPlat.toString(), style: Styles.textBoldLabel),
                                    ],
                                  ),
                                ],
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('₹ ${data.paymentAmount.toString()}', style: Styles.textLargeBoldLabel),
                                TextButton(
                                  onPressed: () {
                                    if (data.docUrl != null) {
                                      Get.to(() => WaterTankImages(imageFiles: data.docUrl!));
                                    }
                                  },
                                  child: const Row(
                                    children: [
                                      Icon(Icons.image),
                                      SizedBox(width: 4),
                                      Text('View Recipe', style: TextStyle(fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  data.paymentStatus.toString(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(formateTime(data.modifiedtime.toString()), style: Styles.hintText),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  String formateTime(String date) {
    DateFormat inputFormat = DateFormat("dd MMM yyyy | hh:mm a");
    DateTime dateTime = inputFormat.parse(date);
    DateFormat outputFormat = DateFormat("dd MMM, yyyy hh:mm a");
    return outputFormat.format(dateTime);
  }
}
