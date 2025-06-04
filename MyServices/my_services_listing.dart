import 'package:biz_infra/CustomWidgets/configurable_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'my_service_profile.dart';

class MyServicesListing extends StatefulWidget {
  const MyServicesListing({super.key});

  @override
  State<MyServicesListing> createState() => _MyServicesListingState();
}

class _MyServicesListingState extends State<MyServicesListing> {
  List<String> name = ["Shanti", "Shyam"];
  List<String> serviceType = ["Maid", "Driver", "Plumber", "Electrician", "Cook"];
  List<String> serviceTime = ["6:00 AM - 8:00 AM", "9:00 AM - 3:00 PM"];
  List<String> serviceTakenBy = ["A-102", "A-101"];
  List<String> serviceTakenBYOtherFlats = ["B-105", "A-103"];

  void _showAddNewServiceSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          // color: Colors.white,
          //padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Add a top space using SizedBox or a Container
                SizedBox(height: MediaQuery.of(context).padding.top + 50), // Adding top padding
                 Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 15.0),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Add New Service",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.close))
                    ],
                    ),
                 ),
                const SizedBox(height: 20),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: serviceType.length,
                    itemBuilder: (context, serviceIndex){
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(serviceType[serviceIndex], textAlign: TextAlign.start,),
                          ),
                          const Divider(),
                        ],
                      );

                    })
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Services"),
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: name.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: (){
                      Get.to(()=>  MyServiceProfile(name: name[index],
                        serviceType: serviceType[index], serviceTime: serviceTime[index],
                        serviceTakenBy: serviceTakenBy[index]));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Align(
                                 alignment: Alignment.bottomRight,
                                    child: Icon(Icons.delete)),
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/home/my_services.png',
                                    height: 60,
                                  ),
                                  const SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Row(
                                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      //   children: [
                                      //     const Icon(Icons.delete),
                                      //   ],
                                      // ),
                                      Text(name[index], style: const TextStyle(fontWeight: FontWeight.bold)),

                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                        decoration: const BoxDecoration(
                                          color: Colors.redAccent,
                                          borderRadius: BorderRadius.all(Radius.circular(30)),
                                        ),
                                        child: Text(serviceType[index], style: const TextStyle(color: Colors.white)),
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          const Icon(Icons.schedule),
                                          const SizedBox(width: 10),
                                          Text(serviceTime[index]),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Icon(Icons.home_outlined),
                                          const SizedBox(width: 10),
                                          Text(serviceTakenBy[index]),
                                          const SizedBox(width: 10),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              DropdownButton<String>(
                                                value: null,
                                                hint: Text('${serviceTakenBYOtherFlats.length} more flats'),
                                                items: serviceTakenBYOtherFlats.map((String item) {
                                                  return DropdownMenuItem<String>(
                                                    value: item,
                                                    child: Text(item),
                                                  );
                                                }).toList(),
                                                onChanged: (value) {},
                                                isExpanded: false,
                                                icon: const Icon(Icons.arrow_drop_down),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                ],
                              ),
                              const Divider(),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.card_membership),
                                  SizedBox(width: 5,),
                                  Text("Gate Pass"),
                                    Spacer(),
                                  Icon(Icons.call),
                                  SizedBox(width: 5,),
                                  Text("Call"),
                                    Spacer(),
                                  Icon(Icons.share),
                                  SizedBox(width: 5,),
                                  Text("Share"),

                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              textButton(
                onPressed: _showAddNewServiceSheet,
                widget: const Text("Add New Services"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
