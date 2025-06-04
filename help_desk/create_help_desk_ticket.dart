import 'dart:io';
import 'package:biz_infra/CustomWidgets/CustomAudio/audio_recorder.dart';
import 'package:biz_infra/CustomWidgets/configurable_widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../CustomWidgets/CustomAudio/local_audio_player_widget.dart';
import '../../CustomWidgets/image_view.dart';
import '../../CustomWidgets/playVideo.dart';
import '../../CustomWidgets/preview_pdf.dart';
import '../../Model/HelpDesk/helpDesk_category_model.dart';
import '../../Model/HelpDesk/helpDesk_pinLocation_model.dart';
import '../../Model/HelpDesk/help_desk_role_based_assigned_list_model.dart';
import '../../Network/dio_service_client.dart';
import '../../Utils/constants.dart';
import 'help_desk_tab.dart';

class HelpDeskTicketCreation extends StatefulWidget {
  const HelpDeskTicketCreation({super.key});

  @override
  State<HelpDeskTicketCreation> createState() => _HelpDeskTicketCreationState();
}

class _HelpDeskTicketCreationState extends State<HelpDeskTicketCreation> {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController ticketTypeController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController pinLocationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  RxList<dynamic> ticketTypeList = [].obs;
  RxList<dynamic> categoryList = [].obs;
  RxList<dynamic>? pinLocationList = [].obs;
  final RxBool isLocationReadOnly = false.obs;

  final RxBool _isUrgent = false.obs;
  final ImagePicker _picker = ImagePicker();
  XFile? _pickedFile;

  RxList<XFile> voiceRecordList = <XFile>[].obs;
  RxList<XFile> imageList = <XFile>[].obs;

  fetchTicketType() async{
    ticketTypeList.clear();
    HelpDeskRoleBasedAssignedListModel? ticketTypeResponse = await dioServiceClient.getTicketType();
    if(ticketTypeResponse?.statuscode == 1){
      if(ticketTypeResponse!.data!.ticType!.isNotEmpty){
        ticketTypeList.value = ticketTypeResponse.data?.ticType?.map((x) => x.ticType.toString()).toList() ?? [];
      }
    }
  }

  //To fetch category in Drop Down
  void fetchCategory(String ticketType) async {
    categoryList.clear();
    HelpDeskCategoryModel? response = await dioServiceClient.category(dependentValue: ticketType);
    if (response?.statuscode == 1) {
      if(response!.data!.ticCategory!.isNotEmpty){
        categoryList.value = response.data?.ticCategory?.map((x) => x.ticCategory.toString()).toList() ?? [];
      }
    }
  }

  //To fetch Location in Drop Down
  void fetchPinLocation() async {
    HelpDeskPinLocationModel? response = await dioServiceClient.pinLocation();
    if (response?.statuscode == 1) {
      pinLocationList!.value = response?.data?.ticPinLocation
          ?.map((x) => x.ticPinLocation.toString()).toList() ?? [];
    }
  }


  Future<void> _showMediaOptions() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Upload Media'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Upload Image'),
                onTap: () {
                  Navigator.of(context).pop();  // Close the current dialog
                  _selectMediaSource('image');  // Show the media source dialog for image
                },
              ),
              ListTile(
                leading: const Icon(Icons.video_camera_back),
                title: const Text('Upload Video'),
                onTap: () {
                  Navigator.of(context).pop();  // Close the current dialog
                  _selectMediaSource('video');  // Show the media source dialog for video
                },
              ),
              ListTile(
                leading: const Icon(Icons.picture_as_pdf),
                title: const Text('Upload Document'),
                onTap: () async {
                  Navigator.of(context).pop(); // Close the current dialog
                  await _pickDocument(); // Handle document upload
                },
              ),

            ],
          ),
        );
      },
    );
  }

  Future<void> _pickDocument() async {
    try {
      // Use FilePicker to pick PDF files
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.isNotEmpty) {
        // Get the picked file
        PlatformFile file = result.files.first;

        if (file.size <= 3 * 1024 * 1024) {
          // File is within allowed size
          imageList.add(XFile(file.path.toString()));
          //print('Picked file: ${file.name}, Size: ${file.size} bytes');
          // Perform your upload or processing logic here
        } else {
          snackBarMessenger(
            "File size exceeds 3MB limit. Please select a smaller file.",
          );
        }
      } else {
        //print('No document selected.');
      }
    } catch (e) {
      //print('Error picking document: $e');
      snackBarMessenger("Failed to pick document. Please try again.");
    }

  }


  // Method to select source (Camera or Gallery) for media
  Future<void> _selectMediaSource(String mediaType) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('From Camera'),
                onTap: () {
                  Navigator.of(context).pop();  // Close the current dialog
                  _pickMedia(mediaType, ImageSource.camera);  // Pick media from camera
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('From Gallery'),
                onTap: () {
                  Navigator.of(context).pop();  // Close the current dialog
                  _pickMedia(mediaType, ImageSource.gallery);  // Pick media from gallery
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickMedia(String mediaType, ImageSource source) async {
    XFile? pickedFile;

    // Pick either image or video based on mediaType
    if (mediaType == 'image') {
      pickedFile = await _picker.pickImage(source: source);
    } else if (mediaType == 'video') {
      pickedFile = await _picker.pickVideo(source: source);
    }

    if (pickedFile != null) {
      _pickedFile = pickedFile;
    } else {
      //print('No media selected.');
    }
    if (pickedFile != null) {
      const int maxSizeInBytes = 3 * 1024 * 1024;
     if ((await pickedFile.length()) > maxSizeInBytes){
      // print("Compressing file......");
       if(mediaType=='image'){
         await dioServiceClient.compressImage(pickedFile.path, maxSizeInBytes);
       }
       else{
         //await dioServiceClient.compressVideoWithFFmpeg(pickedFile.path);
         EasyLoading.show(status: "Compressing...");
         pickedFile = XFile(await dioServiceClient.compressVideo(pickedFile.path)??"");
         EasyLoading.dismiss();
       }
     }
if((await pickedFile.length()) <= maxSizeInBytes){
       imageList.add(pickedFile);
}
else{
  var curSize = await pickedFile.length() ;
  snackBarMessenger("File size is more than $maxSizeInBytes bytes (Currently $curSize)");
}

    }

  }


  @override
  void initState() {
    super.initState();
    fetchTicketType();
    fetchPinLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Ticket"),),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Obx(() => dropdownUI(
                            context: context,
                            controller: ticketTypeController,
                            hintText: 'Select Ticket Type *',
                            formLabel: 'Select Ticket Type',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select Ticket Type';
                              }
                              return null;
                            },
                            data: ticketTypeList.toList().cast<String>(),
                            onChanged: (int? index) {
                              if (index != null) {
                                ticketTypeController.text = ticketTypeList[index];
                                if ((Constants.userRole == "Owner" || Constants.userRole == "Tenant") && ticketTypeController.text == 'Personal') {
                                  pinLocationController.clear();
                                  // pinLocationController.text = "Society Block: ${Constants.societyBlock} Society Number: ${Constants.societyNumber.isEmpty ? '' : ("Society Block: ${Constants.societyNumber}")}";
                                 // pinLocationController.text = "Block: ${Constants.societyBlock}; Society No: ${Constants.societyNumber}";
                                  pinLocationController.text = "Block: ${Constants.societyBlock}; Society No: ${Constants.societyNumber}";
                                  isLocationReadOnly.value = true;
                                } else if (ticketTypeController.text == 'Common Area') {
                                  pinLocationController.clear();
                                  isLocationReadOnly.value = false;
                                }
                                fetchCategory(ticketTypeController.text);
                              }
                            },
                          )),

                      const SizedBox(height: 20),

                      Obx(() =>
                          GestureDetector(
                              onTap: (){
                            if (ticketTypeController.text.isEmpty) {
                              Get.snackbar(
                                "Note!",
                                "Please select ticket type",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.white,
                              );
                            }
                            },
                              child: AbsorbPointer(
                                absorbing: categoryList.isEmpty || ticketTypeController.text.isEmpty,
                                child: dropdownUI(
                                 context: context,
                                   controller: categoryController,
                                     hintText: 'Select Category *',
                                     formLabel: 'Select Category',
                                       validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select Category';
                                }
                                return null;
                              },
                              data: categoryList.toList().cast<String>(),
                                  onChanged: (int? index) {},
                                ),
                              ),
                            ),
                      ),


                      const SizedBox(height: 20),
                      // Builder(
                      //   builder: (context) {
                      //     print("This is printed in the Column!");
                      //     return SizedBox.shrink(); // Return an empty widget or any other widget
                      //   },
                      // ),

                      Obx(() => dropdownUI(
                        context: context,
                        controller: pinLocationController,
                        hintText: isLocationReadOnly.value
                            ? "Block: ${Constants.societyBlock}; Society No: ${Constants.societyNumber}"
                            : 'Select location *',
                        formLabel: 'Select location',
                        validator: (value) {
                          if (!isLocationReadOnly.value && (value == null || value.isEmpty)) {
                            return 'Please select Location';
                          }
                          return null;
                        },
                        data: isLocationReadOnly.value
                            ? [] // Provide an empty list when readonly
                            : pinLocationList?.toList().cast<String>(), // Use dropdown options when not readonly
                        onChanged: isLocationReadOnly.value
                            ? (_) {} // No-op function to avoid type mismatch
                            : (int? index) {
                          if (index != null) {
                            pinLocationController.text = pinLocationList![index];

                          }
                        },
                        readOnly: isLocationReadOnly.value, // Disable dropdown completely if readonly is true
                      )),

                      const SizedBox(height: 20),
                      textField(
                        controller: descriptionController,
                        hintText: 'Enter Description',
                        inputType: TextInputType.text,
                        maxLines: 4,
                        counterText: '',
                        validator: (value) {
                          if ((value ?? '').trim().isEmpty) {
                            return 'Please enter Description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Obx(()=> Checkbox(
                                value: _isUrgent.value,
                                onChanged: (bool? value) {
                                  _isUrgent.value = value ?? false;
                                  },
                              ),
                            ),
                            const Text('Emergency'),
                            const Spacer(),
                            const SizedBox(width: 10.0),

                            //Voice Recording
                           // VoiceRecorderWidget(onRecordingComplete: (XFile? file)=>{if(file!=null)voiceRecordList.add(file)}),

                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return PopScope(
                                      canPop: false,
                                      child: AlertDialog(
                                      //  backgroundColor: Colors.blueGrey[100],
                                        title: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text("Voice Recorder"),
                                            InkWell(
                                              onTap: () {
                                                Navigator.pop(context); // Close dialog
                                              },
                                              child: const Icon(Icons.close),
                                            ),
                                          ],
                                        ),

                                        content: Container(
                                          constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context).size.width * 0.8,
                                            maxHeight: MediaQuery.of(context).size.height * 0.3,
                                          ),
                                          child: VoiceRecorderWidget(
                                            onRecordingComplete: (XFile? file) {
                                              if (file != null) {
                                                // Add the file to your list here
                                                setState(() {
                                                  voiceRecordList.add(file); // Add the file to the list
                                                });
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.mic),
                            ),


                            const SizedBox(width: 10),
                            IconButton(
                              icon: const Icon(Icons.attach_file,
                                  color: Colors.green, size: 20.0),
                              onPressed: () {
                                _showMediaOptions();
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20,),

                    Obx(()=>ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: voiceRecordList.length ,
                        itemBuilder: (context, index){
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(voiceRecordList[index].name),
                                  InkWell(
                                    onTap: (){
                                      File(voiceRecordList[index].path).delete();
                                      voiceRecordList.removeAt(index);
                                    },
                                      child: const Icon(Icons.close)),
                                ],
                              ),
                              LocalAudioPlayerWidget(audioPath: voiceRecordList[index].path),
                            ],),
                          ),
                        );
                        })),



                      Obx(()=>
                         GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,  ),
                          itemCount: imageList.length,
                          itemBuilder: (context, index) {
                            String filePath = imageList[index].path;

                            return Stack(
                              fit: StackFit.expand,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (filePath.endsWith('.jpg') || filePath.endsWith('.png')) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ImageViewScreen(imageFile: File(filePath)),
                                        ),
                                      );
                                    } else if (filePath.endsWith('.mp4')) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PlayVideo(File(filePath)),
                                        ),
                                      );
                                    }
                                    else if (filePath.endsWith('.pdf')){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>  PreviewLocalPdf(pdfPath: filePath,),
                                        ),
                                      );
                                    }
                                  },
                                  child: filePath.endsWith('.jpg') || filePath.endsWith('.png')
                                      ? Image.file(
                                    File(filePath),
                                    fit: BoxFit.cover,
                                  )
                                      : filePath.endsWith('.mp4')
                                      ? Container(
                                    color: Colors.black,
                                    child: const Icon(
                                      Icons.play_arrow,
                                      color: Colors.white,
                                      size: 50,
                                    ),
                                  ) : filePath.endsWith('.pdf')?
                                  Container(
                                    color: Colors.grey.shade600,
                                      child: const Icon(Icons.picture_as_pdf))
                                      : Container(),
                                ),

                                // Delete button positioned in the top-right corner
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: InkWell(
                                    onTap: () {
                                      imageList.removeAt(index);
                                    },
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            );
                            },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              textButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    var helpDeskSaveData = await dioServiceClient.helpDeskSaveRecord(
                      tic_type: ticketTypeController.text,
                      tic_category: categoryController.text,
                      tic_pin_location: pinLocationController.text,
                      tic_description: descriptionController.text,
                      tic_isemergency: _isUrgent.isTrue ? '1' : '0',
                      voiceRecordingList: voiceRecordList,
                      imageList: imageList
                    );

                    if (helpDeskSaveData?.statuscode == 1) {
                      Get.close(1);
                      // ticketTypeController.text == "Personal"?
                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const HelpDeskTabBar(initialTabIndex: 0,),),):
                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const HelpDeskTabBar(initialTabIndex: 1,),),);
                      // snackBarMessenger("Successfully Created a Common Area Ticket!");
                      if (ticketTypeController.text == "Personal") {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => const HelpDeskTabBar(initialTabIndex: 0),
                          ),
                        );
                        snackBarMessenger("Successfully Created a Personal Ticket!");
                      }else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => const HelpDeskTabBar(initialTabIndex: 1),
                          ),
                        );
                        snackBarMessenger("Successfully Created a Common Area Ticket!");
                      }
                    }
                  }
                },
                widget: const Text('Create Ticket'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



