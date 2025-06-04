import 'package:biz_infra/CustomWidgets/IntExtensions.dart';
import 'package:biz_infra/Utils/app_styles.dart';
import 'package:biz_infra/Utils/common_widget.dart';
import 'package:flutter/material.dart';

import '../../Utils/constants.dart';
import 'Component/dues_payment_screen.dart';
import 'Component/history_list_screen.dart';

class PaymentListScreen extends StatefulWidget {
  const PaymentListScreen({super.key});

  @override
  State<PaymentListScreen> createState() => _PaymentListScreenState();
}

class _PaymentListScreenState extends State<PaymentListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController; // Mark as `late`

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // Initialize here
    _tabController.addListener(() {
      setState(() {}); // Update the UI when tab index changes
    });
  }

  @override
  void dispose() {
    _tabController.dispose(); // Dispose to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payments'),
        centerTitle: true,
        // actions: [
        //   // if (_tabController.index == 1) // Access safely after initialization
        //   //   PopupMenuButton<String>(
        //   //     onSelected: (value) {
        //   //       ScaffoldMessenger.of(context).showSnackBar(
        //   //         SnackBar(content: Text('Selected: $value')),
        //   //       );
        //   //     },
        //   //     itemBuilder: (BuildContext context) {
        //   //       return [
        //   //         const PopupMenuItem(
        //   //           value: 'Paid',
        //   //           child: Text('Paid'),
        //   //         ),
        //   //         const PopupMenuItem(
        //   //           value: 'Failed',
        //   //           child: Text('Failed'),
        //   //         ),
        //   //       ];
        //   //     },
        //   //     child: const Icon(Icons.filter_alt_rounded),
        //   //   ),
        // ],
        bottom: TabBar(
          controller: _tabController,
          dividerColor: Colors.transparent,
          indicatorPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
            color: Constants.primaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
          labelColor: Colors.white,
          labelStyle: Styles.whiteTextBold,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'DUES'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          DuesPaymentScreen(
            onBackRefresh: () {
              _tabController.animateTo(1); // Switch to the second tab
            },
          ),
          const HistoryListScreen(),
        ],
      ),
    );
  }
}
