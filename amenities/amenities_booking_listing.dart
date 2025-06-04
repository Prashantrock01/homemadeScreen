import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../CustomWidgets/CustomLoaders/custom_loader.dart';
import '../../CustomWidgets/configurable_widgets.dart';
import '../../Network/dio_service_client.dart';
import '../../Utils/app_string.dart';
import '../../Utils/constants.dart';

class AmenitiesBookingListing extends StatefulWidget {
  const AmenitiesBookingListing({super.key});

  @override
  State<AmenitiesBookingListing> createState() => _AmenitiesBookingListingState();
}

class _AmenitiesBookingListingState extends State<AmenitiesBookingListing> {

  RxList<dynamic> records = [].obs;
  int page = 1;
  bool isMorePage = true;
  bool isLoading = true;
  final ScrollController _sc = ScrollController();
  final RxBool _showProgress = false.obs;
  RxBool retryData = false.obs;

  fetchMyBookingList({bool isRefresh = false}) async {
    if (page != 1) isLoading = true;
    _showProgress.value = page == 1;

    retryData.value = false;
    try {
      var response = await dioServiceClient.getMyBookingList(true, page: page);
      if (response?.statuscode == 1) {
        records.addAll(response!.data!.bookings!);
        isMorePage = response.data!.moreBookings!;
        page++; // Increment page for pagination
      }
    } catch (e) {
      retryData.value = true;
      isMorePage = false;
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
    await fetchMyBookingList();
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
    fetchMyBookingList();
    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        if (isMorePage) fetchMyBookingList();
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
        title: Constants.userRole == "Facility Manager"? Text("My Facilities Booking"):
        Text("My Amenities Booking"),
      ),

      body: !isConnected
          ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text(noInternetText)),
          ElevatedButton(
            onPressed: () {
              Get.to(() => const AmenitiesBookingListing());
            },
            child: Text(retryText),
          ),
        ],
      ):
      Obx(
            () => _showProgress.isTrue
            ? const Center(child: CustomLoader())
            : retryData.isTrue
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Text(retryToLoadDataText)),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: ()  {
                  fetchMyBookingList();
                  },
                child: Text(retryText)),
          ],
        ) :
            records.isEmpty
                ? const Center(
                child: AutoSizeText(
                  "My Booking is Empty",
                ))
                : RefreshIndicator(
              onRefresh: () {
                return refreshHandler();
              },
              child:

            Obx(
                () =>
                    ListView.builder(
                        shrinkWrap: true,
                        controller: _sc,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: records.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(records[index].amenityTitle.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                                    const SizedBox(height: 10),
                                    keyValue(icon: Icons.calendar_month, key: "Booked For", value: records[index].rawDate.toString()),
                                    const SizedBox(height: 5),
                                    keyValue(icon: Icons.access_time, key: "Booked Slot", value: records[index].bookingTimeslot.replaceAll('|##|', ',') ),
                                    const SizedBox(height: 5),
                                    // keyValue(icon: Icons.location_on_sharp, key: "Unit", value: records[index].amenityLocation.toString()),
                                    // const SizedBox(height: 5),
                                    keyValue(icon: Icons.currency_rupee, key: "Amount", value:records[index].amenityBooking.toString()),
                                    const SizedBox(height: 5),
                                    keyValue(icon: Icons.person, key: "User", value: records[index].createdBy.toString()),

                                    const Divider(),

                                    records[index].status.toString() == "Booking Cancelled"
                                        ? Center(
                                      child: Text(
                                        records[index].status.toString(),
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 16,
                                        ),
                                      ),
                                    )
                                        : Row(
                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                         Flexible(
                                            flex: 2,
                                            child: Text(records[index].status.toString(), style: const TextStyle(fontWeight: FontWeight.bold),)),

                                        records[index].status.toString() == "Booking Cancelled"?
                                        const SizedBox.shrink():

                                        Flexible(
                                           child: textButton(
                                             onPressed: () async{
                                             var bookingData = await dioServiceClient.getCancelMyBooking(true,getRecordId: records[index].bookingId.toString());
                                             if(bookingData?.statuscode == 1) {
                                                snackBarMessenger(bookingData?.statusMessage.toString());
                                                await refreshHandler();
                                              }

                                             },
                                               style: ButtonStyle(
                                                 backgroundColor: WidgetStateProperty.all<Color>(Colors.red),
                                                 foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                                                 minimumSize: WidgetStateProperty.all(Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height*0.045)), // Set button height
                                                 shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                                   RoundedRectangleBorder(
                                                     borderRadius: BorderRadius.circular(14.0),
                                                   ),
                                                 ),
                                               ),
                                               widget: const Text("Cancel")

                                           ),
                                         )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                ),
            );
        }
  }
