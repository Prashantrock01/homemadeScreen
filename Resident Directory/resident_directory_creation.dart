import 'package:biz_infra/CustomWidgets/configurable_widgets.dart';
import 'package:biz_infra/Screens/Resident%20Directory/resident_directory_listing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResidentDirectoryCreation extends StatefulWidget {
  const ResidentDirectoryCreation({super.key});

  @override
  State<ResidentDirectoryCreation> createState() => _ResidentDirectoryCreationState();
}

class _ResidentDirectoryCreationState extends State<ResidentDirectoryCreation> {
  final residentDirectoryFormKey = GlobalKey<FormState>();
  final residentNameController = TextEditingController();
  final residentPhoneController = TextEditingController();

  String selectedBlock = "";
  String selectedSocietyNumber = "";
  String selectedResident = "";

  void _onDropdownChanged(String value, String type) {
    setState(() {
      if (type == 'block') {
        selectedBlock = value;
      } else if (type == 'societyNumber') {
        selectedSocietyNumber = value;
      } else if (type == 'resident') {
        selectedResident = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // elevation: 5,
        title: const Text("Resident Directory"),
      ),
      body: /*GradientBackground(
        child:*/ Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: residentDirectoryFormKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/images/resident_directory.png',
                    height: MediaQuery.of(context).size.height / 3,
                  ),
                  textField(
                    controller: residentNameController,
                    textInputAction: TextInputAction.next,
                    // fillColor: const Color(0xFFEDEDED),
                    filled: true,
                    labelText: 'Name of the Resident *',
                    hintText: 'Enter Name of the Resident *',
                    // border: OutlineInputBorder(
                    //   borderRadius: BorderRadius.circular(10.0),
                    // ),
                    prefixIcon: const Icon(Icons.person),
                    validator: (value) {
                      if (residentNameController.text.isEmpty) {
                        return 'Please enter resident name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  textField(
                    controller: residentPhoneController,
                    textInputAction: TextInputAction.next,
                    // fillColor: const Color(0xFFEDEDED),
                    filled: true,
                    labelText: 'Resident Mobile Number *',
                    hintText: 'Enter Resident Mobile Number *',
                    // border: OutlineInputBorder(
                    //   borderRadius: BorderRadius.circular(10.0),
                    // ),
                    prefixIcon: const Icon(Icons.call),
                    inputType: TextInputType.phone,
                    validator: (value) {
                      if (residentPhoneController.text.isEmpty) {
                        return 'Please enter resident mobile number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // dropdownUI(
                  //   context: context,
                  //   data: ["A", "B", "C", "D", "Common Area"],
                  //   formLabel: "Block",
                  //   hintText: "Select Block",
                  //   prefixIcon: const Icon(Icons.apartment),
                  //   //selectedValue: selectedBlock,
                  // //  onChanged: (value) => _onDropdownChanged(value, 'block'),
                  //   validator: (value) {
                  //     if (selectedBlock.isEmpty) {
                  //       return 'Please select a block';
                  //     }
                  //     return null;
                  //   },
                  // ),
                  const SizedBox(height: 20),
                  // dropdownUI(
                  //   context: context,
                  //   data: ["A-101", "A-102", "A-103", "A-104"],
                  //   formLabel: "Society Number",
                  //   hintText: "Select Society Number",
                  //   prefixIcon: const Icon(Icons.apartment),
                  //  // selectedValue: selectedSocietyNumber,
                  //   //onChanged: (value) => _onDropdownChanged(value, 'societyNumber'),
                  //   validator: (value) {
                  //     if (selectedSocietyNumber.isEmpty) {
                  //       return 'Please select a society number';
                  //     }
                  //     return null;
                  //   },
                  // ),
                  const SizedBox(height: 20),
                  // dropdownUI(
                  //   context: context,
                  //   data: ["Owner", "Resident"],
                  //   formLabel: "Resident",
                  //   hintText: "Select Resident",
                  //   prefixIcon: const Icon(Icons.key),
                  //   //selectedValue: selectedResident,
                  //   //onChanged: (value) => _onDropdownChanged(value, 'resident'),
                  //   validator: (value) {
                  //     if (selectedResident.isEmpty) {
                  //       return 'Please select a resident type';
                  //     }
                  //     return null;
                  //   },
                  // ),
                  const SizedBox(height: 20),
                  textButton(
                    onPressed: () {
                      if (residentDirectoryFormKey.currentState!.validate()) {
                        // Clear fields after submission
                        residentNameController.clear();
                        residentPhoneController.clear();
                        setState(() {
                          selectedBlock = "";
                          selectedSocietyNumber = "";
                          selectedResident = "";
                        });

                        // Navigate to the Resident Directory Listing page
                        Get.to(() => const ResidentDirectoryListing());
                      }
                    },
                    widget: const Text("Create Resident"),
                  ),
                ],
              ),
            ),
          ),
        ),
      /*),*/
    );
  }
}
