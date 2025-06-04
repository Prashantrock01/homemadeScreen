import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Network/dio_service_client.dart';
import '../../Utils/constants.dart';
import 'create_help_desk_ticket.dart';
import 'help_desk_common_area_listing.dart';
import 'help_desk_personal_listing.dart';

RxString helpDeskTicketStatus = "".obs;

class HelpDeskTabBar extends StatefulWidget {
  final int initialTabIndex;
  const HelpDeskTabBar({required this.initialTabIndex, super.key});

  @override
  State<HelpDeskTabBar> createState() => _HelpDeskTabBarState();
}

class _HelpDeskTabBarState extends State<HelpDeskTabBar> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? personalCount = '';
  String? communityCount = '';
  List<String> ticketStatusList = ['All', 'Created', 'In-Progress', 'On Hold', 'Resolve', 'Closed'];
  var userRole = Constants.userRole;

  @override
  void initState() {
    super.initState();
    // Initialize TabController
    _tabController = TabController(length: 2, vsync: this, initialIndex: widget.initialTabIndex);
    // Listen to TabController to reset the filter
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        helpDeskTicketStatus.value = '';
      }
    });
    // Fetch counts
    fetchCounts();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> fetchCounts() async {
    try {
      final personalData =
      await dioServiceClient.getCountList(ticketType: 'Personal', module: 'HelpDesk');
      if (personalData?.data?.totalCount != null) {
        personalCount = personalData!.data!.totalCount!;
      }

      final communityData =
      await dioServiceClient.getCountList(ticketType: 'Common Area', module: 'HelpDesk');
      if (communityData?.data?.totalCount != null) {
        communityCount = communityData!.data!.totalCount!;
      }

      setState(() {});
    } catch (error) {
      Get.snackbar('Error', error.toString());
    }
  }

  statusFilterDialog() {
    int selectedValueIndex = ticketStatusList.indexOf(
        helpDeskTicketStatus.value == '' ? 'All' : helpDeskTicketStatus.value);
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
          contentPadding: const EdgeInsets.only(top: 10.0),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                width: double.maxFinite,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Center(
                        child: AutoSizeText(
                          "Status",
                          style: TextStyle(
                            fontFamily: 'Sfpro',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      const Divider(
                        color: Colors.grey,
                        height: 4.0,
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.4,
                        ),
                        child: Scrollbar(
                          thumbVisibility: true,
                          child: ListView.builder(
                            itemCount: ticketStatusList.length,
                            itemBuilder: (context, index) {
                              return RadioListTile(
                                contentPadding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                                title: AutoSizeText(
                                  ticketStatusList[index],
                                  style: const TextStyle(
                                    fontFamily: 'Sfpro',
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                value: index,
                                groupValue: selectedValueIndex,
                                onChanged: (value) {
                                  setState(() {
                                    selectedValueIndex = index;
                                    helpDeskTicketStatus.value =
                                    ticketStatusList[index] == "All"
                                        ? ""
                                        : ticketStatusList[index];
                                  });
                                  Navigator.pop(context);
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        initialIndex: widget.initialTabIndex,
        child: Scaffold(
          appBar: AppBar(
            bottom:  TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 3,
              tabs: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: AutoSizeText((personalCount == null || personalCount!.isEmpty) ? "Personal" : "Personal ($personalCount)",),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: AutoSizeText((communityCount == null || communityCount!.isEmpty) ?"Common Area" : "Common Area ($communityCount)"),
                ),
              ],
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const AutoSizeText('Help Desk'),
                InkWell(
                  onTap: statusFilterDialog,
                  child: const Icon(Icons.filter_list),
                ),
              ],
            ),
          ),
          body:TabBarView(
            controller: _tabController,
            children: const [
              HelpDeskPersonalListing(),
              HelpDeskCommonAreaListing(),
            ],
          ),
          floatingActionButton:
          Constants.userRole == "Facility Manager"? const SizedBox.shrink():
          FloatingActionButton(
            onPressed: () {
              Get.to(() => const HelpDeskTicketCreation());
            },
            child: const Icon(Icons.support_agent),
          ),
        ),
      ),
    );
  }
}
