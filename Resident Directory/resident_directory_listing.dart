import 'package:biz_infra/CustomWidgets/CustomLoaders/custom_loader.dart';
import 'package:biz_infra/Network/dio_service_client.dart';
import 'package:biz_infra/Screens/Resident%20Directory/resident_directory_block_details.dart';
import 'package:biz_infra/Screens/Resident%20Directory/resident_directory_creation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import '../../CustomWidgets/configurable_widgets.dart';
import '../../Model/ResidentDirectory/resident_directory_listing.dart';

class ResidentDirectoryListing extends StatefulWidget {
  const ResidentDirectoryListing({super.key});

  @override
  State<ResidentDirectoryListing> createState() => _ResidentDirectoryListingState();
}

class _ResidentDirectoryListingState extends State<ResidentDirectoryListing> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Resident Directory"),
      ),
      body: FutureBuilder(
        future: dioServiceClient.getResidentDirectory(), // Ensure this returns a Future of ResidentDirectoryModel
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while waiting for the data
            return const Center(child: CustomLoader());
          } else if (snapshot.hasError) {
            // Handle any errors
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data != null) {
            // Extract the selectBlock list
            List<SelectBlock>? blocks = snapshot.data!.data?.selectBlock;

            // Check if the list is not null and not empty
            if (blocks != null && blocks.isNotEmpty) {
              return ListView.builder(
                itemCount: blocks.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(() => ResidentDirectoryBlockDetails(
                              blockName: blocks[index].selectBlock ?? ''));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                blocks[index].selectBlock ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  // color: Color(0xff5D5D5D),
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios_sharp,
                                size: 20,
                                // color: Color(0xffF7C51E),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(
                        thickness: 0.5,
                        // color: Color(0xffF7C51E),
                      ),
                    ],
                  );
                },
              );
            } else {
              // Handle case where the list is empty
              return const Center(child: Text('No Resident Directory available'));
            }
          } else {
            // Handle case where there's no data
            return const Center(child: Text('No data available'));
          }
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   tooltip: 'Create Resident Directory',
      //   onPressed: () {
      //     Get.to(() => const ResidentDirectoryCreation());
      //   },
      //   child: const Icon(Icons.apartment, /*color: Colors.white,*/ size: 28),
      //   //child: Image.asset('assets/images/guard_icon.png', height: 35, width: 35,),
      // ),
    );
  }

}
