import 'package:auto_size_text/auto_size_text.dart';
import 'package:biz_infra/CustomWidgets/CustomLoaders/custom_loader.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../CustomWidgets/configurable_widgets.dart';
import '../../Network/dio_service_client.dart';
import '../../Utils/app_string.dart';
import 'amenities_booking_listing.dart';
import 'amenities_details_screen.dart';

class AmenitiesListingScreen extends StatefulWidget {
  const AmenitiesListingScreen({super.key});

  @override
  State<AmenitiesListingScreen> createState() => _AmenitiesListingScreenState();
}

class _AmenitiesListingScreenState extends State<AmenitiesListingScreen> {

  RxList<dynamic> records = [].obs;
  int page = 1;
  bool isMorePage = true;
  bool isLoading = true;
  final ScrollController _sc = ScrollController();
  final RxBool _showProgress = false.obs;
  RxBool retryData = false.obs;

  fetchAmenitiesList({bool isRefresh = false}) async {
    page != 1 ? isLoading = true : _showProgress.value = true;
    retryData.value = false;
    try {
      var response = await dioServiceClient.getAmenitiesList(true, page: page);
      ///need to uncomment below line once it is implemented form backend & remove above line.
      //var response = await dioServiceClient.getHelpDeskList(page: page++, filter: helpDeskTicketStatus.isEmpty ? "[[\"tic_type\",\"e\",\"Personal\"],[\"smcreatorid\",\"e\",\"${Constants.userId}\"]]": "[[\"tic_type\",\"e\",\"Personal\"],[\"smcreatorid\",\"e\",\"${Constants.userId}\"],[\"ticketstatus\",\"e\",\"${helpDeskTicketStatus.value}\"]]");
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
    // page = 1;
    // await fetchAmenitiesList(isRefresh: true);
    // setState(() {});

    page = 1;
    records.clear();
    await fetchAmenitiesList();
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

    // fetchAmenitiesList();
    // _sc.addListener(() {
    //   if (_sc.position.pixels >= _sc.position.maxScrollExtent&& !isLoading) {
    //     if (isMorePage) {
    //       page++;
    //       isLoading = true;
    //       setState(() {});
    //       fetchAmenitiesList();
    //     }
    //   }
    // });
    fetchAmenitiesList();
    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        if (isMorePage) fetchAmenitiesList();
      }
    });

  }


  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Amenities"),
            ElevatedButton.icon(
              onPressed: () => Get.to(() => const AmenitiesBookingListing()),
              label: const Text("My Bookings"),
            ),
          ],
        ),


      ),
      body: !isConnected
          ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text(noInternetText)),
          ElevatedButton(
            onPressed: () {
              Get.to(() => const AmenitiesListingScreen());
            },
            child: Text(retryText),
          ),
        ],
      )
          :Obx(
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
            : records.isEmpty
            ? const Center(child: AutoSizeText("Amenities List is Empty"))
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
                    itemCount: records.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: InkWell(
                          onTap: () {
                            Get.to(() => AmenitiesDetailsScreen(amenitiesId: records[index].id.toString(), qrCodeId: records[index].qrcodeid.toString()));
                          },
                          child:
                          Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child: ListTile(
                              onTap: () => Get.to(() => AmenitiesDetailsScreen(amenitiesId: records[index].id.toString(), qrCodeId: records[index].qrcodeid.toString(),)),
                              title: Text(records[index].amenitiesTitle.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Available Days: ${records[index].amenetitesAvailableDays}"),
                                  Text("Timings: ${records[index].amenitiesStartingtime?.substring(0, 5)} - ${records[index].amenitiesEndingtime?.substring(0, 5)}"),
                                  Text("Status: ${records[index].amenetitesStatus}"),
                                ],
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
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


      // FutureBuilder<AmenitiesListingModel?>(
      //   future: _amenitiesFuture,
      //   builder: (BuildContext context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const Center(child: CustomLoader());
      //     } else if (snapshot.hasError) {
      //       return Center(
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             const Text("Something went wrong!", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      //             const SizedBox(height: 10),
      //             ElevatedButton.icon(
      //               onPressed: _refreshAmenities,
      //               icon: const Icon(Icons.refresh),
      //               label: const Text("Retry"),
      //             ),
      //           ],
      //         ),
      //       );
      //     } else if (!snapshot.hasData || snapshot.data!.data!.records!.isEmpty) {
      //       return const Center(child: AutoSizeText("Amenities list is empty"));
      //     } else {
      //       return ListView.builder(
      //         itemCount: snapshot.data!.data!.records!.length,
      //         itemBuilder: (BuildContext context, int index) {
      //           var record = snapshot.data!.data!.records![index];
      //           return Padding(
      //             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      //             child: Card(
      //               elevation: 5,
      //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      //               child: ListTile(
      //                 onTap: () => Get.to(() => AmenitiesDetailsScreen(amenitiesId: record.id.toString())),
      //                 title: Text(record.amenitiesTitle.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
      //                 subtitle: Column(
      //                   crossAxisAlignment: CrossAxisAlignment.start,
      //                   children: [
      //                     Text("Available Days: ${record.amenetitesAvailableDays}"),
      //                     Text("Timings: ${record.amenitiesStartingtime?.substring(0, 5)} - ${record.amenitiesEndingtime?.substring(0, 5)}"),
      //                     Text("Status: ${record.amenetitesStatus}"),
      //                   ],
      //                 ),
      //                 trailing: const Icon(Icons.arrow_forward_ios, size: 18),
      //               ),
      //             ),
      //           );
      //         },
      //       );
      //     }
      //   },
      // ),
    );
  }
}
