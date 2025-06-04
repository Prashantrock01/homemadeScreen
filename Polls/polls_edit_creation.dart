import 'dart:io';
import 'package:biz_infra/CustomWidgets/configurable_widgets.dart';
import 'package:biz_infra/Network/dio_service_client.dart';
import 'package:biz_infra/Screens/Polls/polls_listing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '../../Model/Polls/DetailsPollsModel.dart';
import 'package:http/http.dart' as http;

import '../../Model/Polls/polls_creation_model.dart';

class PollsEditCreation extends StatefulWidget {
  const PollsEditCreation({super.key,required this.pollId, required this.pollsData});
final String pollId;
final DetailsPollsModel? pollsData;
  @override
  State<PollsEditCreation> createState() => _PollsEditCreationState();
}

class _PollsEditCreationState extends State<PollsEditCreation> {
 // final DioServiceClient _dioServiceClient = DioServiceClient();
  final createPolls = GlobalKey<FormState>();
  final pollTypeController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final pollsTopicController = TextEditingController();
  final descriptionController = TextEditingController();
  final _scrollOneController = ScrollController();

  final List<String> pollTypeList = ['Normal', 'Election'];
  //List<String> listOfExistingImageRecord = [];
  final RxList<File> _imagesNotifier = <File>[].obs;
  List<XFile>? imageList = [];
 // List<File?> capturedImages = [];
  final ImagePicker userImagePicker = ImagePicker();
  List<String> listOfExistingImagesRecord = [];
  final _scrollController = ScrollController();
  String selectedPollType = 'Normal';

  @override
  void initState(){
    super.initState();
    fetchData();
  }


  fetchData() async {
    try {
      if (widget.pollsData != null) {
        EasyLoading.show();
        pollTypeController.text = widget.pollsData!.data!.record!.pollType!;
        startDateController.text =
        widget.pollsData!.data!.record!.pollstartDate!;
        endDateController.text = widget.pollsData!.data!.record!.pollendDate!;
        pollsTopicController.text = widget.pollsData!.data!.record!.pollTopic!;
        descriptionController.text =
        widget!.pollsData!.data!.record!.pollDescription!;

    List<PollUploadpic>? listOfImages =
        widget.pollsData!.data!.record!.pollUploadpic;
    listOfImages ??= [];
    listOfExistingImagesRecord = [];
    for (int i = 0; i < listOfImages.length; i++) {
      final uri = Uri.parse(listOfImages[i].urlpath.toString());
      final res = await http.get(uri);
      var bytes = res.bodyBytes;
      final temp = await getTemporaryDirectory();
      final path = '${temp.path}/${listOfImages[i].name}';
      if (File(path).existsSync()) {
        File(path).deleteSync();
        // print("ISDELETED${File(path).existsSync().toString()}");
      }
      File(path).writeAsBytesSync(bytes, mode: FileMode.write);
      _imagesNotifier.add(File(path));
      listOfExistingImagesRecord
          .add(listOfImages[i].attachmentsid.toString());
    }
    EasyLoading.dismiss();
  }
}
    catch(e){
      EasyLoading.dismiss;
      }
  }
  @override
  Widget build(BuildContext context) {
    return
    Scaffold(
      appBar: AppBar(
        title: Text('Edit Polls '),
      ),
      body: SingleChildScrollView(
        child: Form(
        key: createPolls,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            // Visibility(
            //   visible: _imagesNotifier
            //       .isNotEmpty, // Show GridView only if there are images
            //   child: Container(
            //     margin: const EdgeInsets.all(10.0),
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(7.0),
            //       border: Border.all(
            //         color: Colors.grey,
            //         width: 2.0,
            //       ),
            //     ),
            //     child: Scrollbar(
            //       controller: _scrollController,
            //       thumbVisibility: true,
            //       thickness: 4.0,
            //       child: GridView.builder(
            //         controller: _scrollController,
            //         scrollDirection: Axis.vertical,
            //         shrinkWrap: true,
            //         gridDelegate:
            //         const SliverGridDelegateWithFixedCrossAxisCount(
            //           childAspectRatio: 12 / 16,
            //           crossAxisCount: 3,
            //           mainAxisSpacing: 4.0,
            //         ),
            //         padding: const EdgeInsets.all(10.0),
            //         itemCount: _imagesNotifier.length,
            //         itemBuilder: (context, index) {
            //           return Stack(
            //             children: [
            //               Padding(
            //                 padding: const EdgeInsets.all(4.0),
            //                 child: GestureDetector(
            //                   onTap: () {
            //                     _openFullImageDialog(
            //                         _imagesNotifier[index]);
            //                   },
            //                   child: Container(
            //                     decoration: BoxDecoration(
            //                       borderRadius:
            //                       BorderRadius.circular(4.0),
            //                       border: Border.all(
            //                         color: Colors.grey,
            //                         width: 2.0,
            //                       ),
            //                     ),
            //                     child: Image.file(
            //                       _imagesNotifier[index],
            //                       fit: BoxFit.cover,
            //                       width: MediaQuery.of(context)
            //                           .size
            //                           .width *
            //                           0.4,
            //                       height: MediaQuery.of(context)
            //                           .size
            //                           .height *
            //                           0.4,
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //               Positioned(
            //                 top: 10,
            //                 right: 8,
            //                 child: GestureDetector(
            //                   onTap: () {
            //                     _removeImage(index);
            //                   },
            //                   child: const Icon(
            //                     Icons.delete_sweep,
            //                     color: Color.fromARGB(255, 202, 43, 32),
            //                     size: 30,
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           );
            //         },
            //       ),
            //     ),
            //   ),
            // ),

          const SizedBox(
            height: 15,
          ),

                  dropdownUI(
                  context: context,
                  controller: pollTypeController,
                  hintText: 'Select Poll Type',
                  labelText: 'Select Poll Type',
                  prefixIcon: Icon(Icons.poll),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'Please Select Poll Type';
                    }
                    return null;
                  },
                  data: pollTypeList,
                  onChanged: (int? index)
                  {
                    setState(() {
                      selectedPollType = pollTypeList[index!];
                    }
                    );
                  },
                  ),
              const SizedBox(height: 20),
              textField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: startDateController,
                hintText: 'Start Date',
                labelText: 'Start Date',
                suffixIcon: Icon(Icons.date_range_rounded),
                validator: (value){
                  if(value == null || value.isEmpty){
                    return ' Please Enter Start Date';
                  }
                  return null;
                },
               onTap: () => datePicker(startDateController),
                readOnly: true
              ),
              SizedBox(height: 20),
              textField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: endDateController,
                hintText: 'End Date',
                labelText: 'End Date',
                validator: (value){
                  if(value == null || value.isEmpty){
                    return 'Please Enter End Date';
                  }
                  return null;
                },
                suffixIcon: Icon(Icons.date_range_rounded),
                onTap: ()=>datePicker(endDateController),
                readOnly: true
              ),
              SizedBox(height: 20),
              textField(
                controller: pollsTopicController,
                hintText: 'Edit Polls Topic',
                labelText: 'Enter Polls Topic',
               validator: (value){
                  if(value == null || value.isEmpty){
                    return 'Please Enter Polls Topic';
                  }
                  return null;
               },
               textInputAction: TextInputAction.next,
                inputType: TextInputType.text
              ),
              SizedBox(height: 20),
              textField(
                controller: descriptionController,
                hintText: 'Edit Description',
                labelText: 'Edit Description',
                validator: (value){
                  if(value == null || value.isEmpty){
                    return 'Please Enter Description';
                  }
                  return null;
                },
                minLines: 4,
                inputType: TextInputType.text,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 20),
            
              TextButton.icon(
                onPressed: _showAlertDialog,
                label: const Text(
                  'Upload Image',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    letterSpacing: 1.4,
                  ),
                ),
                icon: const Icon(
                  Icons.camera_alt,
                ),
                iconAlignment: IconAlignment.start,
              ),

              Obx(() {
                return Visibility(
                  visible: _imagesNotifier
                      .isNotEmpty, // Show GridView only if there are images
                  child: Container(
                    margin: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.0),
                      border: Border.all(
                        color: Colors.grey,
                        width: 2.0,
                      ),
                    ),

                    child: Scrollbar(
                      controller: _scrollOneController,
                      thumbVisibility: true,
                      thickness: 4.0,
                      child: GridView.builder(
                        controller: _scrollOneController,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 12 / 16,
                          crossAxisCount: 3,
                          mainAxisSpacing: 4.0,
                        ),

                        padding: const EdgeInsets.all(10.0),
                        itemCount: _imagesNotifier.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: GestureDetector(
                                  onTap: () {
                                    _openFullImageDialog(
                                        _imagesNotifier[index]
                                    );
                                  },

                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(4.0),
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 2.0,
                                      ),
                                    ),
                                    child: Image.file(
                                      _imagesNotifier[index],
                                      fit: BoxFit.cover,
                                      width:
                                      MediaQuery.of(context).size.width *
                                          0.4,
                                      height:
                                      MediaQuery.of(context).size.height *
                                          0.4,
                                    ),
                                  ),
                                ),
                              ),

                              Positioned(
                                top: 10,
                                right: 8,
                                child: GestureDetector(
                                  onTap: () {
                                    _removeImage(index);
                                  },
                                  child: const Icon(
                                    Icons.delete_sweep,
                                    color: Color.fromARGB(255, 202, 43, 32),
                                    size: 30,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                );
              }
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      ),
         bottomNavigationBar: Padding(
     padding: const EdgeInsets.all(10.0),
      child: customElevatedButton(
        text: 'Edit Poll',
        fontSize: 20,
        onPressed: () async {
          print('fghjk');
          print( widget.pollId);
          final scaffoldMessenger = ScaffoldMessenger.of(context);

          if (!createPolls.currentState!.validate()) {
            return; // Stop further execution if form is invalid
          }

          try {
            PollsCreationModel? res =
            await dioServiceClient.createPass(
              poll_type: pollTypeController.text,
                        pollstart_date: startDateController.text,
                        pollend_date: endDateController.text,
                        poll_topic: pollsTopicController.text,
                        poll_description:descriptionController.text,
              imageList: imageList,
              recordId: widget.pollId,
              listOfImageRecordToBeDelated: listOfExistingImagesRecord,
            );

            scaffoldMessenger.showSnackBar(
              const SnackBar(
                content: Text('Successfully edited listed item.'),
              ),
            );

            if (res!.statuscode == 1) {
              Get.close(2);
              Navigator.pushReplacement(
                context,
               MaterialPageRoute(
                 builder: (BuildContext context) => const PollsListing(),
               ),
              );
            } else {
              Get.snackbar(
                "Oops!",
                res.statusMessage!,
                snackPosition: SnackPosition.TOP,
                margin: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 50),
                borderRadius: 10,
                backgroundColor: Colors.redAccent,
                colorText: Colors.white,
              );
            }
          } catch (e) {
            Get.snackbar(
              "Oops!! Failed to list item",
              e.toString(),
              snackPosition: SnackPosition.TOP,
              margin:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              borderRadius: 10,
              backgroundColor: Colors.redAccent,
              colorText: Colors.white,
            );
          }
        },
      ),
    ),
    );
  //  );
  }
  Future<void> datePicker(TextEditingController con) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      con.text = DateFormat('dd/MM/yyyy').format(pickedDate);
    }
  }

  // Future<bool> onWillPop() async {
  //   return await showModalBottomSheet<bool>(
  //     context: context,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (BuildContext context) {
  //       return Padding(
  //         padding: const EdgeInsets.all(16.0),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             const Text(
  //               'Leaving Already?',
  //               style: TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.black,
  //               ),
  //             ),
  //             const SizedBox(height: 10),
  //             Container(
  //               padding: const EdgeInsets.all(16.0),
  //               decoration: BoxDecoration(
  //                 color: const Color.fromARGB(255, 221, 213, 213),
  //                 borderRadius: BorderRadius.circular(20),
  //                 boxShadow: [
  //                   BoxShadow(
  //                     color: Colors.black.withOpacity(0.1),
  //                     blurRadius: 10,
  //                     offset: const Offset(0, 4),
  //                   ),
  //                 ],
  //               ),
  //               child: Column(
  //                 children: <Widget>[
  //                   const Text(
  //                     'Are you sure you want to leave?',
  //                     style: TextStyle(
  //                       fontSize: 16,
  //                       fontWeight: FontWeight.bold,
  //                       color: Colors.grey,
  //                     ),
  //                     textAlign: TextAlign.center,
  //                   ),
  //                   const SizedBox(height: 20),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                     children: [
  //                       TextButton(
  //                         onPressed: () {
  //                           Get.close(3);
  //                           Navigator.pushReplacement(
  //                             context,
  //                             MaterialPageRoute(
  //                               builder: (BuildContext context) =>
  //                               const PollsListing(),
  //                             ),
  //                           );
  //                         }, // Stay on the page
  //                         child: const Text(
  //                           'Yes',
  //                           style: TextStyle(
  //                             fontSize: 16,
  //                             color: Colors.black,
  //                           ),
  //                         ),
  //                       ),
  //                       ElevatedButton(
  //                         style: ElevatedButton.styleFrom(
  //                           backgroundColor: Colors.green,
  //                           shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(12),
  //                           ),
  //                           padding: const EdgeInsets.symmetric(
  //                             horizontal: 24,
  //                             vertical: 12,
  //                           ),
  //                           side: const BorderSide(
  //                             color: Colors.grey,
  //                             width: 0.5,
  //                           ),
  //                         ),
  //                         onPressed: () =>
  //                             Navigator.pop(context), // Leave the page
  //                         child: const Text(
  //                           'Keep Posting',
  //                           style: TextStyle(
  //                             fontSize: 16,
  //                             color: Colors.white,
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   ) ??
  //       false; // Default to false if the bottom sheet is dismissed
  // }

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)
            ),
          ),
          title: const Text(
            'Add a photo',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  _pickImage();
                },
                label: const Text(
                  'Take a Photo',
                ),
                icon: const Icon(
                  Icons.camera,
                ),
                iconAlignment: IconAlignment.start,
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  _pickImages();
                },
                label: const Text(
                  'Choose from Gallery',
                ),
                icon: const Icon(
                  Icons.photo_library,
                ),
                iconAlignment: IconAlignment.start,
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                label: const Text(
                  'Cancel',
                ),
                icon: const Icon(
                  Icons.cancel,
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage() async {
    XFile? pickedImage =
    await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      File originalFile = File(pickedImage.path);

      // Compress the image
      File? compressedImage = await _compressImage(originalFile);

      if (compressedImage != null &&
          await compressedImage.length() < 3 * 1024 * 1024) {
        // Add the compressed image to the list
        imageList?.add(XFile(compressedImage.path));

        final updatedImages = List<File>.from(_imagesNotifier.value)
          ..add(compressedImage);
        _imagesNotifier.value = updatedImages;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Image selected and compressed successfully.'),
          ));
        });
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Image is too large, please try again.'),
          ));
        });
      }
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('No image selected from Camera.'),
        ));
      });
    }
  }

  Future<void> _pickImages() async {
    if (selectedPollType == 'Normal' && _imagesNotifier.isNotEmpty) {
      // If Normal is selected and there's already an image, show a message or return
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Only one image is allowed for Normal polls')
        ),
      );
      return;
    }

    List<XFile>? pickedImages = await ImagePicker().pickMultiImage();

    if (pickedImages.isNotEmpty) {
      if (selectedPollType == 'Normal' && pickedImages.length > 1) {
        // If Normal is selected and user tries to pick multiple images, show a message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Only one image is allowed for Normal polls')
          ),
        );
        return;
      }

      imageList?.addAll(pickedImages);
      final updatedImages = List<File>.from(_imagesNotifier.value)
        ..addAll(pickedImages.map((xFile) => File(xFile.path)
        )
        );
      _imagesNotifier.value = updatedImages;
    }
  }

  Future<File?> _compressImage(File file) async {
    final dir = await getTemporaryDirectory();
    final targetPath = '${dir.path}/compressed_${file.uri.pathSegments.last}';

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 80, // Adjust quality as needed
    );

    return result != null ? File(result.path) : null;
  }

  void _openFullImageDialog(File imageFile) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shadowColor: Colors.blueAccent,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InteractiveViewer(child: Image.file(imageFile)),
                  // Add any buttons or additional widgets below the image if needed
                ],
              ),
              // Positioned close button at the top-right
              Positioned(
                top: 10.0,
                right: 10.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _removeImage(int index) {
    // Remove the image directly from the RxList
    final removedImage = _imagesNotifier[index];
    _imagesNotifier.removeAt(index);

    // Update the actual image list to ensure consistency
    imageList = List<XFile>.from(_imagesNotifier);

  }


}
