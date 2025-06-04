import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:biz_infra/Model/society_name_model.dart';
import 'package:biz_infra/Network/dio_service_client.dart';
import 'package:biz_infra/Screens/owner_tenant_registration/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../CustomWidgets/configurable_widgets.dart';
import '../../Model/society_block_model.dart';
import '../../Model/society_number_model.dart';

class SocietyDetailsScreen extends StatefulWidget {
  final String? name;
  final String? phone;
  final String? email;
  final String? password;

  const SocietyDetailsScreen({required this.name, required this.phone, required this.email, required this.password, super.key});

  @override
  SocietyDetailsScreenState createState() => SocietyDetailsScreenState();
}

class SocietyDetailsScreenState extends State<SocietyDetailsScreen> {

  final _formKey = GlobalKey<FormState>();
  String? userType = 'Owner';
  bool isMovingIn = true;
  final societyNameController = TextEditingController();
  final societyNameIDController = TextEditingController();
  final societyBlockController = TextEditingController();
  final societyBlockIDController = TextEditingController();
  final societyNumberController = TextEditingController();
  final societyNumberIDController = TextEditingController();
  final scrollController = ScrollController();

  RxList<dynamic> societyName = [].obs;
  RxList<dynamic> societyNameId = [].obs;
  RxList<dynamic> societyBlock1 = [].obs;
  RxList<dynamic> societyBlockId = [].obs;
  RxList<dynamic> societyNumber = [].obs;
  RxList<dynamic> societyNumberId = [].obs;

  void showThankYouDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              const Text("Thank You!!"),
              Image.asset('assets/images/authenticate_bg.gif'),
            ],
          ),
          content: Text(
            message,
          ),
          actions: <Widget>[
            textButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              widget: const Text("OK"),
            ),
          ],
        );
      },
    );
  }


  @override
  void initState() {
    super.initState();
    callSocietyNames();
  }
  void callSocietyNames() async {
    try{
      SocietyNameModel? response = await dioServiceClient.societyName();
      if (response?.statuscode == 1) {
        societyName.value = response?.data?.accountsData?.map((x)=> x.societyName.toString()).toList() ?? [];
        societyNameId.value = response?.data?.accountsData?.map((x)=> x.id.toString()).toList() ?? [];
      }
    }
    catch(error){
      snackBarMessenger("Failed to fetch society names");
    }

  }

  void callSocietyBlocks(String societyName) async {
    societyBlock1.clear(); // Clear old data

    SocietyBlockModel? response = await dioServiceClient.societyBlock(societyName);

    if (response?.statuscode == 1) {
       if(response!.data!.filteredData!.isNotEmpty){
        societyBlock1.value = response.data?.filteredData?.first.records?.map((x) => x.blockname.toString()).toList() ?? [];
        societyBlockId.value = response.data?.filteredData?.first.records?.map((x) => x.socblocksid.toString()).toList() ?? [];

       }
       else {
         debugger.printInfo(info: response.data.toString());
       }
    }
  }

  void callSocietyNumbers(String societyName,String societyBlock) async {
    SocietyNumberModel? response = await dioServiceClient.societyNumber(societyName,societyBlock);
    if (response?.statuscode == 1) {
     // societyNumber.value = response?.data?.?.map((x) => x.selectSocietyNo.toString()).toList() ?? [];
      if(response!.data!.filteredData!.isNotEmpty){
        societyNumber.value = response.data?.filteredData?.first.records?.map((x) => x.platname.toString()).toList() ?? [];
        societyNumberId.value = response.data?.filteredData?.first.records?.map((x) => x.platid.toString()).toList() ?? [];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Society Details"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/images/society_register.png'),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(()=>
                          dropdownUI(
                            context: context,
                            controller: societyNameController,
                            hintText: 'Select Society Name *',
                            formLabel: 'Society Name',
                            prefixIcon: const Icon(Icons.apartment),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select society name';
                              }
                              return null;
                            },
                            data: societyName.toList().cast<String>(),
                            onChanged: (int? index) {
                              if (index != null) {
                                societyNameController.text = societyName[index];
                                societyNameIDController.text = societyNameId[index];
                                callSocietyBlocks(societyNameId[index]);
                              }
                            },
                          ),
                        ),

                        const SizedBox(height: 20,),
                        Obx(() => GestureDetector(
                          onTap: () {
                            if (societyNameController.text.isEmpty) {
                              Get.snackbar(
                                "Note!",
                                "Please select society name",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.white,
                              );
                            } else if (societyBlock1.isEmpty) {  // Show snackbar if societyBlock is empty
                              Get.snackbar(
                                "No blocks available",
                                "There are no blocks available for the selected society.",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.white,
                                colorText: Colors.black,
                              );
                            }
                          },
                          child: AbsorbPointer(
                            absorbing: societyBlock1.isEmpty || societyNameController.text.isEmpty, // Disable interaction if no blocks
                            child: dropdownUI(
                              context: context,
                              controller: societyBlockController,
                              hintText: 'Select Society Block *',
                              formLabel: 'Society Block',
                              prefixIcon: const Icon(Icons.apartment),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select society block';
                                }
                                return null;
                              },
                              data: societyBlock1.isEmpty
                                  ? [] // Empty list for blocks when there are no available blocks
                                  : societyBlock1.toList().cast<String>(), // Display actual blocks if available
                              onChanged: (int? index) {
                                if (index != null && societyBlock1.isNotEmpty) {  // Only allow interaction if societyBlock is not empty
                                  societyBlockController.text = societyBlock1[index];
                                  societyBlockIDController.text = societyBlockId[index];
                                  callSocietyNumbers(societyNameIDController.text, societyBlockIDController.text);
                                }
                              },
                            ),
                          ),
                        )),

                        const SizedBox(height: 20),

                        Obx(() => GestureDetector(
                          onTap: () {
                            if (societyBlockController.text.isEmpty) {
                              Get.snackbar(
                                "Note!",
                                "Please select Society Block",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.white
                              );
                            }
                          },
                          child: AbsorbPointer(
                            absorbing: societyBlockController.text.isEmpty, // Disable interaction
                            child: dropdownUI(
                              context: context,
                              controller: societyNumberController,
                              hintText: 'Select Society Number *',
                              formLabel: 'Society Number',
                              prefixIcon: const Icon(Icons.apartment),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select society number';
                                }
                                return null;
                              },
                              data: societyNumber.toList().cast<String>(),
                              onChanged: (int? value) {
                                if (value != null) {
                                  societyNumberController.text = societyNumber[value];
                                  societyNumberIDController.text = societyNumberId[value];
                                }
                              },
                            ),
                          ),
                        )),

                        const SizedBox(height: 20),

                        const AutoSizeText("I am an/a"),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile<String>(
                                title: const AutoSizeText('Owner'),
                                value: 'Owner',
                                groupValue: userType,
                                onChanged: (value) {
                                  setState(() {
                                    userType = value;
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<String>(
                                title: const AutoSizeText('Tenant'),
                                value: 'Tenant',
                                groupValue: userType,
                                onChanged: (value) {
                                  setState(() {
                                    userType = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Moving In/Current Resident Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isMovingIn = true;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isMovingIn
                                      ? Colors.amber
                                      : Colors.grey[500],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Column(
                                  children: [
                                    Icon(Icons.local_shipping),
                                    AutoSizeText("Moving In"),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isMovingIn = false;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: !isMovingIn
                                      ? Colors.amber
                                      : Colors.grey[500],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Column(
                                  children: [
                                    Icon(Icons.home),
                                    AutoSizeText("Current Resident"),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            /// Continue Button
            Padding(
              padding: const EdgeInsets.all(15),
              child: textButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                var ownerRegistrationData =   await dioServiceClient.ownerTenantRegistration(
                    ownerTenantName: widget.name, ownerTenantMobile: widget.phone, ownerTenantEmail: widget.email, ownerTenantPassword: widget.password,
                        societyName: societyNameIDController.text, societyBlock: societyBlockIDController.text, societyNumber: societyNumberIDController.text, role: userType, residingType: isMovingIn ? 'Moving In' : 'Current Resident');

                if(ownerRegistrationData?.statuscode == 1){
                  snackBarMessenger(ownerRegistrationData!.data!.message.toString());
                  Get.close(3);
                  Get.to(()=> const LoginScreen());
                  showThankYouDialog("Thank you for registering with us.\nYour registration is currently under review. Please allow us some time to process your details. Once your account is approved, you will be notified, and you will be able to log in.");
                }
                else {
                      if (ownerRegistrationData!.statusMessage!.contains('Mobile number already registered')) {
                        snackBarMessenger('Mobile number already registered');
                      } else if (ownerRegistrationData.statusMessage!.contains('Email already registered')) {
                        snackBarMessenger('Email already registered');
                      }
                    }
                  }
                },
                widget: const AutoSizeText("Continue"),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
