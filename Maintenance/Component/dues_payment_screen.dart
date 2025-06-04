import 'package:biz_infra/CustomWidgets/CustomLoaders/custom_loader.dart';
import 'package:biz_infra/CustomWidgets/IntExtensions.dart';
import 'package:biz_infra/Network/dio_service_client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Model/Maintenance/PaymentDueListModel.dart';
import '../../../Themes/theme_controller.dart';
import '../../../Utils/app_styles.dart';
import '../../../Utils/constants.dart';
import '../payment_screen.dart';

class DuesPaymentScreen extends StatefulWidget {
  final VoidCallback? onBackRefresh;

  const DuesPaymentScreen({super.key, this.onBackRefresh});

  @override
  State<DuesPaymentScreen> createState() => _DuesPaymentScreenState();
}

class _DuesPaymentScreenState extends State<DuesPaymentScreen> {
  final ScrollController scrollController = ScrollController();
  final List<DuePaymentModel> duesData = [];
  bool isLoading = false;
  bool hasMore = true;
  int currentPage = 1;
  final int pageSize = 10;

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
        duesData.clear();
      }

      final response = await dioServiceClient.paymentDueListApi(
        paidValue: 'NotPaid',
        page: currentPage,
      );

      if (response != null && response.data != null && response.data!.records != null && response.data!.records!.isNotEmpty) {
        duesData.addAll(response.data!.records!);
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
      child: duesData.isEmpty && !isLoading
          ? const Center(child: Text('No Maintenance Due remaining'))
          : isLoading
              ? const Center(child: CustomLoader())
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: scrollController,
                  itemCount: duesData.length /*+ (hasMore ? 1 : 0)*/,
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    if (index == duesData.length) {
                      // Show loading indicator at the bottom
                      return const Center(child: CircularProgressIndicator());
                    }

                    final data = duesData[index];
                    return Constants.userRole == Constants.facilityManager ? _buildManagerCard(context, data) : _buildUserCard(context, data);
                  },
                ),
    );
  }

  Widget _buildManagerCard(BuildContext context, DuePaymentModel data) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.payment, color: Constants.primaryColor),
                    const SizedBox(width: 4),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Total Dues for ',
                            style: TextStyle(
                              color: ThemeController.selectedTheme == ThemeMode.dark ? Colors.white : Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: data.payforMonth.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: ThemeController.selectedTheme == ThemeMode.dark ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Text('₹ ${data.paymentAmount!}', style: Styles.textLargeBoldLabel),
              ],
            ),
            8.height,
            Row(
              children: [
                const Icon(Icons.person),
                const SizedBox(width: 4),
                Text(data.payeeName.toString(), style: Styles.textHeadLabel),
              ],
            ),
            8.height,
            Row(
              children: [
                const Icon(Icons.home_work_outlined),
                const SizedBox(width: 4),
                Text(data.relatedBlock.toString(), style: Styles.textHeadLabel),
              ],
            ),
            8.height,
            Row(
              children: [
                const Icon(Icons.home_work_outlined),
                const SizedBox(width: 4),
                Text(data.relatedPlat.toString(), style: Styles.textHeadLabel),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, DuePaymentModel data) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.payment, color: Constants.primaryColor),
                const SizedBox(width: 4),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Total Dues for ',
                        style: TextStyle(
                          color: ThemeController.selectedTheme == ThemeMode.dark ? Colors.white : Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: data.payforMonth.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ThemeController.selectedTheme == ThemeMode.dark ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('₹ ${data.paymentAmount!}', style: Styles.textLargeBoldLabel),
                4.height,
                SizedBox(
                  height: 32,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                      ),
                    ),
                    onPressed: () async {
                      bool? res = await Get.to(() => PaymentScreen(data: data));
                      if (res == true && widget.onBackRefresh != null) {
                        widget.onBackRefresh!();
                      }
                    },
                    child: const Text('Pay'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
