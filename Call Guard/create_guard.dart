import 'dart:io';

// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:biz_infra/Screens/Call%20Guard/call_guard_listing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../CustomWidgets/configurable_widgets.dart';
import '../../CustomWidgets/image_view.dart';
import '../../Network/dio_service_client.dart';
import 'guard_directory_listing.dart';

class CreateGuard extends StatefulWidget {
  const CreateGuard({super.key});

  @override
  State<CreateGuard> createState() => CreateGuardState();
}

class CreateGuardState extends State<CreateGuard> {
  final callGuardFormKey = GlobalKey<FormState>();
  final guardNameController = TextEditingController();
  final guardPhoneNumberController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  List<File?> capturedImages = [];
  Future<void> _captureImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        capturedImages.add(File(pickedFile.path));
      });
    }
  }

  // Method to navigate to the image view screen
  void _viewImage(File imageFile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageViewScreen(
          imageFile: imageFile,
          onDelete: () => _deleteImage(imageFile),
        ),
      ),
    );
  }

  // Method to delete a specific image
  void _deleteImage(File imageFile) {
    setState(() {
      capturedImages.remove(imageFile);
    });
    Navigator.pop(context); // Return to previous screen after deletion
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // elevation: 5,
        title: const Text("Call Guard"),
      ),
      body: /*GradientBackground(
        child:*/ Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: callGuardFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Image.asset('assets/images/guard.png', height: MediaQuery.of(context).size.height/2.5,),
                    
                        textField(
                          controller: guardNameController,
                          textInputAction: TextInputAction.next,
                          // fillColor: const Color(0xFFEDEDED),
                          filled: true,
                          labelText: 'Name of the Guard *',
                          hintText: 'Enter Name of the Guard *',
                          // border: OutlineInputBorder(
                          //     borderRadius: BorderRadius.circular(10.0)),
                          prefixIcon: const Icon(Icons.person),
                          validator: (value) {
                            if (guardNameController.text.isEmpty) {
                              return 'Please enter guard name';
                            }
                            return null;
                          },
                        ),


                        const SizedBox(height: 20,),
                    
                        textField(
                          controller: guardPhoneNumberController,
                          textInputAction: TextInputAction.next,
                          inputType: TextInputType.phone,
                          maxLength: 10,
                          counterText: "",
                          filled: true,
                          labelText: 'Contact Number of the Guard *',
                          hintText: 'Enter Contact Number of the Guard *',
                          prefixIcon: const Icon(Icons.call),
                          validator: (value) {
                            if (guardPhoneNumberController.text.isEmpty) {
                              return 'Please enter guard contact number';
                            }
                            return null;
                          },
                        ),

                        // const SizedBox(height: 20,),
                        // textButton(
                        //   onPressed: _captureImage,
                        //   style: ElevatedButton.styleFrom(
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(10),
                        //     ),
                        //     minimumSize: Size(MediaQuery.of(context).size.width / 2, 35),
                        //     elevation: 5,
                        //   ),
                        //   widget: const AutoSizeText("Capture Guard Image"),
                        // ),
                        // const SizedBox(height: 20),
                        // if (capturedImages.isNotEmpty)
                        //   SizedBox(
                        //     height: 200,
                        //     child: GridView.builder(
                        //       gridDelegate:
                        //       const SliverGridDelegateWithFixedCrossAxisCount(
                        //         crossAxisCount: 3,
                        //         crossAxisSpacing: 10,
                        //         mainAxisSpacing: 10,
                        //       ),
                        //       itemCount: capturedImages.length,
                        //       itemBuilder: (context, index) {
                        //         return GestureDetector(
                        //           onTap: () {
                        //             _viewImage(capturedImages[index]!);
                        //           },
                        //           child: Image.file(
                        //             capturedImages[index]!,
                        //             fit: BoxFit.cover,
                        //           ),
                        //         );
                        //       },
                        //     ),
                        //   ),
                      ],
                    ),
                  ),
                ),

                textButton(
                  onPressed: () async{
                    if (callGuardFormKey.currentState!.validate()) {
                      var guardSaveData =  await dioServiceClient.guardSaveRecord(
                          guardName: guardNameController.text,
                          guardMobileNumber: guardPhoneNumberController.text,
                          );

                      if(guardSaveData?.statuscode == 1){
                        Get.off(()=> const GuardDirectoryListing() );
                      }else if (guardSaveData!.statuscode == 0) {
                        final successMessage = guardSaveData.statusMessage ?? "Guard creation failed.";
                        Get.snackbar(
                          "Error",
                          successMessage,
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.redAccent,
                          colorText: Colors.white,
                          margin: const EdgeInsets.all(10),
                          borderRadius: 8,
                        );
                      }
                    }
                    // else{
                    //   if(capturedImages.isEmpty){
                    //     Get.snackbar("No image(s) captured", "Please capture Guard Image");
                    //   }
                   // }
                  },
                  widget: const Text("Create Vendor"),
                ),

              ],
            ),
          ),
        ),
      /*),*/
    );
  }
}
