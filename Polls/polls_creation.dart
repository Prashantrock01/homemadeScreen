import 'dart:io';
import 'package:biz_infra/Network/dio_service_client.dart';
import 'package:biz_infra/Screens/Polls/polls_listing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '../../CustomWidgets/configurable_widgets.dart';

class PollsCreation extends StatefulWidget {
  const PollsCreation({
    super.key,
    required String appBarText,
    required bool leading,
  });

  @override
  State<PollsCreation> createState() => _PollsCreationState();
}

class _PollsCreationState extends State<PollsCreation> {
  final createPolls = GlobalKey<FormState>();
  final pollTypeController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final pollTopicController = TextEditingController();
  final descriptionController = TextEditingController();
  final _scrollOneController = ScrollController();

  final RxList<File> _imagesNotifier = <File>[].obs;
  List<XFile>? imageList = [];
  final ImagePicker userImagePicker = ImagePicker();
  final List<String> pollTypeList = ['Normal', 'Election'];
  String selectedPollType = 'Normal';

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

  void _removeImage(int index) {
    // Remove the image directly from the RxList
    final removedImage = _imagesNotifier[index];
    _imagesNotifier.removeAt(index);

    // Update the actual image list to ensure consistency
    imageList = List<XFile>.from(_imagesNotifier);

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
                  InteractiveViewer(child: Image.file(imageFile)
                  ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Polls'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Form(
            key: createPolls,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // dropdownUI(
                //   context: context,
                //   controller: pollTypeController,
                //   hintText: 'Select Poll Type *',
                //   formLabel: 'Poll Type',
                //   prefixIcon: const Icon(Icons.poll),
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Please select Poll Type';
                //     }
                //     return null;
                //   },
                //   data: pollTypeList,
                //   onChanged: (int? index) {
                //   },
                // ),
                dropdownUI(
                  context: context,
                  controller: pollTypeController,
                  hintText: 'Select Poll Type *',
                  formLabel: 'Poll Type',
                  prefixIcon: const Icon(Icons.poll),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select Poll Type';
                    }
                    return null;
                  },
                  data: pollTypeList,
                  onChanged: (int? index) {
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
                  hintText: 'Please Select Start Date',
                  labelText: 'Start Date',
                  suffixIcon: const Icon(Icons.calendar_month),
                  onTap: () => datePicker(startDateController),
                  validator: (value)=> value!.isEmpty? 'Please Enter Start Date': null,
                  readOnly: true,
                ),

                const SizedBox(height: 20),
                textField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: endDateController,
                  hintText: 'Please Select End Date',
                  labelText: 'End Date',
                  suffixIcon: const Icon(Icons.calendar_month),
                  onTap: () => datePicker(endDateController),
                  validator: (value)=> value!.isEmpty ? 'Please Enter End Date': null,
                  readOnly:  true,
                ),

                const SizedBox(height: 20),

                // Text Field for Poll Topic
                textField(
                  controller: pollTopicController,
                  inputType: TextInputType.text,
                  validator: (value) => value!.isEmpty? 'Please Enter Polls Topic' : null,
                  textInputAction: TextInputAction.next,
                  hintText: 'Enter Polls Topic',
                  labelText: 'Enter Polls Topic',
                ),

                const SizedBox(height: 20),

                // Text Field for Description
                textField(
                  controller: descriptionController,
                  inputType: TextInputType.text,
                  validator: (value) => value!.isEmpty? 'Please Enter Description': null,
                  hintText: 'Description',
                  labelText: 'Description',
                  textInputAction: TextInputAction.next,
                  maxLines: 4,
                ),

                const SizedBox(height: 20),

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

                  textButton(
                      onPressed:() async {
                        print("Printing all datas");
                        print(pollTopicController.text);
                        if(createPolls.currentState!.validate() ){
                          var createPolls = await dioServiceClient.createPass(
                            poll_topic:pollTopicController.text,
                            poll_description: descriptionController.text,
                            poll_type: pollTypeController.text,
                            pollstart_date: startDateController.text,
                            pollend_date: endDateController.text,
                              // pollsImage: [],
                            imageList: imageList ?? []

                          );
                          if (createPolls?.statuscode == 1) {
                            Get.off(()=>const PollsListing(
                              // appBarText: 'appBarText', leading: true, showAppBar:true,
                            )
                            );
                          }
                        }
                      },

                      widget: const Text('Submit',style: TextStyle(fontSize: 20),
                      )
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

