import 'package:biz_infra/Network/dio_service_client.dart';
import 'package:biz_infra/Screens/EmergencyDirectory/emergency_directory_listing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../CustomWidgets/configurable_widgets.dart';

class CreateEmergencyDirectory extends StatefulWidget {
  const CreateEmergencyDirectory({super.key});

  @override
  State<CreateEmergencyDirectory> createState() => _CreateEmergencyDirectoryState();
}

class _CreateEmergencyDirectoryState extends State<CreateEmergencyDirectory> {
  final emergencyFormKey = GlobalKey<FormState>();
  final TextEditingController emergencyNameController = TextEditingController();
  final TextEditingController emergencyMobileNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Emergency Directory")),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: emergencyFormKey,
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: Image.asset("assets/images/emergency_illustration.png"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          textField(
                            controller: emergencyNameController,
                            textInputAction: TextInputAction.next,
                            contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                            labelText: 'Emergency Name *',
                            hintText: 'Enter Emergency Name *',
                            textCapitalization: TextCapitalization.words,
                            prefixIcon: const Icon(Icons.person),
                            validator: (value) {
                              if (emergencyNameController.text.isEmpty) {
                                return 'Please enter emergency name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          textField(
                            controller: emergencyMobileNumberController,
                            inputType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            labelText: "Emergency Mobile Number *",
                            hintText: 'Enter Emergency Mobile Number',
                            prefixIcon: const Icon(Icons.phone),
                            validator: (value) {
                              if (value == null) {
                                return 'Please enter Mobile number';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0, left: 15, right: 15),
            child: textButton(
              widget: const Text('Create Emergency Directory'),
              onPressed: () async{
                if (emergencyFormKey.currentState!.validate()) {
                var emergencyDirectoryData = await  dioServiceClient.saveEmergencyDirectory(emergencyDirectoryName: emergencyNameController.text, emergencyDirectoryNumber: emergencyMobileNumberController.text);
                 if(emergencyDirectoryData?.statuscode ==1){
                   snackBarMessenger(emergencyDirectoryData!.statusMessage.toString());
                   Get.off(() => const EmergencyDirectoryListing());
                 }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
