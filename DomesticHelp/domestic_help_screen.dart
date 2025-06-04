import 'dart:developer';

import 'package:biz_infra/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Utils/app_styles.dart';
import 'component/domestic_list_component.dart';
import 'component/domestic_type_list_filter_component.dart';
import 'domestic_help_creation.dart';

class DomesticHelpScreen extends StatefulWidget {
  const DomesticHelpScreen({super.key});

  @override
  State<DomesticHelpScreen> createState() => _DomesticHelpScreenState();
}

class _DomesticHelpScreenState extends State<DomesticHelpScreen> with SingleTickerProviderStateMixin {
  int currentIndex = 0;

  late TabController _tabController;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _pageController = PageController(initialPage: 0);

    _tabController.addListener(() {
      if (_tabController.index != currentIndex) {
        setState(() {
          currentIndex = _tabController.index;
        });
        _pageController.jumpToPage(currentIndex); // Sync page view on tap
        print("Current Tab Index (Tap): $currentIndex");
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Domestic Help'),
      ),
      body: (Constants.userRole == Constants.facilityManager)
          ? const DomesticListComponent(isAllHelper: true)
          : Column(
              children: [
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TabBar(
                    controller: _tabController,
                    dividerColor: Colors.transparent,
                    onTap: (index) {
                      setState(() {
                        currentIndex = index;
                      });
                      _pageController.jumpToPage(index); // Sync page view on tab
                    },
                    indicatorPadding: const EdgeInsets.all(4),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelStyle: Styles.textBoldLabel,
                    unselectedLabelColor: Colors.grey,
                    tabs: const [
                      Tab(text: 'All Services'),
                      Tab(text: 'My Services'),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        currentIndex = index;
                        _tabController.animateTo(index); // Sync TabBar on swipe
                      });
                    },
                    children: [
                      DomesticListComponent(
                        isAllHelper: true,
                        onBackCall: () {
                          if (mounted) {
                            setState(() {
                              currentIndex = 1;
                              _pageController.jumpToPage(1);
                              _tabController.animateTo(1);
                            });
                          }
                        },
                      ),
                      const DomesticListComponent(),
                    ],
                  ),
                ),
              ],
            ),
      bottomNavigationBar: currentIndex == 0
          ? Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  padding: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: showAddNewServiceSheet,
                child: Text('All New Services', style: Get.isDarkMode ? Styles.textBoldLabel : Styles.whiteTextBold),
              ),
            )
          : const SizedBox(),
    );
  }

  void showAddNewServiceSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return const DomesticTypeListFilterComponent();
      },
    );
  }
}
