import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import '../../CustomWidgets/CustomLoaders/custom_loader.dart';
import '../../CustomWidgets/configurable_widgets.dart';
import '../../Network/dio_service_client.dart';
import '../../Utils/constants.dart';
import 'help_desk_details_screen.dart';
import 'help_desk_tab.dart';

class HelpDeskCommonAreaListing extends StatefulWidget {
  const HelpDeskCommonAreaListing({super.key});

  @override
  HelpDeskCommonAreaListingState createState() => HelpDeskCommonAreaListingState();
}

class HelpDeskCommonAreaListingState extends State<HelpDeskCommonAreaListing> {

  RxList<dynamic> records = [].obs;
  int page = 1;
  bool isMorePage = true;
  bool isLoading = true;
  final ScrollController _sc = ScrollController();
  final RxBool _showProgress = false.obs;
  RxBool retryData = false.obs;
  bool isCreatedByMe = false;


  String getFilter(){
    return
      isCreatedByMe ?  helpDeskTicketStatus.isEmpty ? "[[\"tic_type\",\"e\",\"Common Area\"],[\"smcreatorid\",\"e\",\"${Constants.userName}\"]]": "[[\"tic_type\",\"e\",\"Common Area\"],[\"ticketstatus\",\"e\",\"$helpDeskTicketStatus\"],[\"smcreatorid\",\"e\",\"${Constants.userName}\"]]":
      helpDeskTicketStatus.isEmpty ? "[[\"tic_type\",\"e\",\"Common Area\"]]": "[[\"tic_type\",\"e\",\"Common Area\"],[\"ticketstatus\",\"e\",\"$helpDeskTicketStatus\"]]";
  }

  fetchCommunityHelpDesk() async {
    page != 1 ? isLoading = true : _showProgress.value = true;
    retryData.value = false;
    try {
      var response = await dioServiceClient.getHelpDeskList(page: page++, filter: getFilter());
      if (response?.statuscode == 1) {
        setState(() {
          for (int i = 0; i < response!.data!.records!.length; i++) {
            records.add(response.data!.records![i]);
          }
          isMorePage = response.data!.moreRecords!;
        });
      }
    }
    catch (e) {
        retryData.value = true;
    }
    _showProgress.value = false;
  }

  checkConnectivity() async {
    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
    setState(() {
      isConnected = connectivityResult.contains(ConnectivityResult.mobile) || connectivityResult.contains(ConnectivityResult.wifi) || connectivityResult.contains(ConnectivityResult.ethernet);

    });
  }

  refreshHandler() async {
    page = 1;
    records.clear();
    await fetchCommunityHelpDesk();
  }

  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
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
    fetchCommunityHelpDesk();
    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        if (isMorePage) fetchCommunityHelpDesk();
      }
    });
    helpDeskTicketStatus.listen((data){
      refreshHandler();
    });
  }



  @override
  Widget build(BuildContext context) {
    return !isConnected
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                  child: Text(
                      "No internet connection. Please try again later.")),
              ElevatedButton(
                  onPressed: () {
                    Get.to(() => const HelpDeskTabBar(initialTabIndex: 1));
                  },
                  child: const Text("Retry")),
            ],
          )
        : Obx(() => _showProgress.isTrue
            ? const Center(child: CustomLoader())
            : retryData.isTrue
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Center(child: Text("Retry to load the data")),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Get.to(() => const HelpDeskTabBar(initialTabIndex: 1));
                          },
                          child: const Text("Retry")),
                    ],
                  )
                : records.isEmpty ? Center(
                        child: AutoSizeText(
                          Constants.userRole == 'Owner'?  "Common Area Help Desk List is Empty": "Help Desk List is Empty",
                      ))
                    : RefreshIndicator(
                        onRefresh: () {
                          return refreshHandler();
                        },
                        child: SingleChildScrollView(
                          child: Obx(
                            () => ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                controller: _sc,
                                itemCount: records.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    onTap: () {
                                      Get.to(() => HelpDeskTicketDetailsScreen(
                                            onAnyChanges: refreshHandler, recordId: records[index].id.toString(),));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: Text("Ticket ID: ${records[index].ticketNo.toString()}",
                                                      overflow: TextOverflow.ellipsis,
                                                      style: const TextStyle(fontWeight: FontWeight.bold),),),
                                                  records[index].ticketstatus.toString() == 'Closed'
                                                      ? Expanded(
                                                          flex: 1,
                                                          child:
                                                              RatingBarIndicator(
                                                            rating: (records[index].ticRating.isEmpty || records[index].ticRating == null)? 0: double.parse(
                                                                records[index].ticRating),
                                                            itemBuilder: (context, index) =>
                                                                const Icon(Icons.star,
                                                                  color: Colors.amber,
                                                            ),
                                                            itemCount: 5,
                                                            itemSize: 20.0,
                                                            direction: Axis.horizontal,
                                                          ),
                                                        )
                                                      : const SizedBox.shrink(),
                                                  Text(
                                                    records[index].ticketstatus.toString(),
                                                    style: const TextStyle(
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              keyValue(key:"Ticket Type", value: records[index].ticType.toString()),
                                              keyValue(key:"Category", value:records[index].ticCategory.toString()),
                                              keyValue(key: "Pin Location", value: "Block: ${records[index].ticPinLocation}"),
                                              keyValue(key:"Emergency", value:records[index].ticIsemergency .toString() =="1" ? "Yes" : "No"),
                                              keyValue(key:"Date & Time",value:records[index].createdtime.toString()),
                                              keyValue(key:"Description", value:records[index].ticDescription .toString()),
                                              keyValue(key:"Assigned Person", value:records[index].assignedPerson.toString()),
                                              keyValue(key:"Created By", value:records[index].createdBy.toString()),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                      ));
  }
}
