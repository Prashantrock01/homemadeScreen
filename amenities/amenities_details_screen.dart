import 'package:biz_infra/CustomWidgets/configurable_widgets.dart';
import 'package:biz_infra/Network/dio_service_client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../CustomWidgets/CustomLoaders/custom_loader.dart';
import 'amenities_detail_booking_screen.dart';

class AmenitiesDetailsScreen extends StatefulWidget {
  final String amenitiesId;
  final String? qrCodeId;
  const AmenitiesDetailsScreen({required this.amenitiesId, this.qrCodeId, super.key,});

  @override
  State<AmenitiesDetailsScreen> createState() => _AmenitiesDetailsScreenState();
}

class _AmenitiesDetailsScreenState extends State<AmenitiesDetailsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Amenities Details"),),
      body: FutureBuilder(
        future: dioServiceClient.getAmenitiesDetails(recordId: widget.amenitiesId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CustomLoader());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(snapshot.data!.data!.record!.amenitiesTitle.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                    const SizedBox(height: 10,),
                    
                                    keyValue(key:"Status", value:snapshot.data!.data!.record!.amenetitesStatus.toString()),
                                    snapshot.data!.data!.record!.amenetitesAvailableDays!.isNotEmpty ? keyValue(key:"Available Days",value:snapshot.data!.data!.record!.amenetitesAvailableDays.toString()): const SizedBox.shrink(),
                                    snapshot.data!.data!.record!.amenitiesLocation!.isNotEmpty ?keyValue(key:"Location",value:snapshot.data!.data!.record!.amenitiesLocation.toString()): const SizedBox.shrink(),

                                    keyValue(key:"Timings",value:"${snapshot.data!.data!.record!.amenitiesStartingtime} - ${snapshot.data!.data!.record!.amenitiesEndingtime}"),

                                    snapshot.data!.data!.record!.amenitiesAvailableSlot!.isNotEmpty ? keyValue(key:"Time Slot Allowed",value:snapshot.data!.data!.record!.amenitiesAvailableSlot.toString(),): const SizedBox.shrink(),
                                    snapshot.data!.data!.record!.amenitiesBooking!.isNotEmpty ? keyValue(key:"Booking Amount",value:"${snapshot.data!.data!.record!.amenitiesBooking} Per Event"): const SizedBox.shrink(),
                                    snapshot.data!.data!.record!.amenitiesCapacity!.isNotEmpty ? keyValue(key:"Maximum Capacity",value:"${snapshot.data!.data!.record!.amenitiesCapacity} Person(s)"): const SizedBox.shrink(),

                                  ]),
                            ),
                          ),
                        ),
                         Card(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (snapshot.data!.data!.record!.amenitiesDesc?.isNotEmpty ?? false) ...[
                                  const Text("Description",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18)),
                                  const SizedBox(height: 10),
                                  Text(snapshot.data!.data!.record!.amenitiesDesc!),
                                  const SizedBox(height: 15),
                                  ],

                                  if (snapshot.data!.data!.record!.amenitiesGuideline?.isNotEmpty ?? false) ...[
                                    const Text(
                                      "Guidelines",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(snapshot.data!.data!.record!.amenitiesGuideline.toString()),
                                    const SizedBox(height: 15),
                                  ]
                                ]
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: textButton(
                      onPressed: () {
                        Get.to(() =>  AmenitiesDetailBookingScreen(
                          amenitiesId: widget.amenitiesId,
                          qrCodeId: widget.qrCodeId.toString(),
                          recordId: snapshot.data!.data!.record!.currentRecordId.toString(),
                          title: snapshot.data!.data!.record!.amenitiesTitle.toString(),
                          bookingAmount: snapshot.data!.data!.record!.amenitiesBooking.toString(),
                        ));
                      },
                      widget: const Text(
                        "Proceed to Reserve"
                      )),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
