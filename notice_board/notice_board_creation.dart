// ignore_for_file: invalid_use_of_protected_member

import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:biz_infra/CustomWidgets/configurable_widgets.dart';
import 'package:biz_infra/Model/notice_board/dropdowns/notice_share_dropdown_modal.dart';
import 'package:biz_infra/Model/notice_board/dropdowns/notice_type_dropdown_modal.dart';
import 'package:biz_infra/Model/notice_board/notice_board_creation_modal.dart';
import 'package:biz_infra/Network/dio_service_client.dart';
import 'package:biz_infra/Screens/notice_board/notice_board_list.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class NoticeBoardCreation extends StatefulWidget {
  const NoticeBoardCreation({super.key});

  @override
  State<NoticeBoardCreation> createState() => _NoticeBoardCreationState();
}

class _NoticeBoardCreationState extends State<NoticeBoardCreation> {
  // final DioServiceClient _dioClient = DioServiceClient();

  final _formKey = GlobalKey<FormState>();

  final _noticeTypeController = TextEditingController();
  final _subjectController = TextEditingController();
  final _noticeDescriptionController = TextEditingController();
  final _chooseController = TextEditingController();

  // Assuming _imagesNotifier is converted to a RxList<File>
  final RxList<File> _imagesNotifier = <File>[].obs;
  // final RxList<File> _advImagesNotifier = <File>[].obs;

  // final _scrollController = ScrollController();
  final _scrollOneController = ScrollController();

  List<XFile>? imageList = [];
  List<XFile>? advImageList = [];

  List<ConnectivityResult>? _connectionStatus; // Make it nullable
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  /// Initialize connectivity status
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (_) {
      return;
    }

    if (!mounted) return;
    _updateConnectionStatus(result);
  }

  /// Update the internet connection status
  void _updateConnectionStatus(List<ConnectivityResult> result) {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  void initState() {
    super.initState();
    callNoticeType();
    callNoticeShare();
    initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
          (List<ConnectivityResult> results) {
        _updateConnectionStatus(results);
      },
    );
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  RxList<dynamic>? noticeType = [].obs;
  RxList<dynamic>? noticeShare = [].obs;

  void callNoticeType() async {
    NoticeTypeDropdownModal? response = await dioServiceClient.getNoticeType();
    if (response?.statuscode == 1) {
      noticeType!.value = response?.data?.noticeType
              ?.map((x) => x.noticeType.toString())
              .toList() ??
          [];
    }
  }

  void callNoticeShare() async {
    NoticeShareDropdownModal? response =
        await dioServiceClient.getNoticeShare();
    if (response?.statuscode == 1) {
      noticeShare!.value = response?.data?.noticeShare
              ?.map((x) => x.noticeShare.toString())
              .toList() ??
          [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notice Board'),
      ),
      body:  _connectionStatus == null
          ? const Center(child: CircularProgressIndicator()) // Show loader initially
          : _connectionStatus!.contains(ConnectivityResult.none)
          ? checkInternetConnection(initConnectivity)
          : SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 4.0,
            ),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 15,
                ),
                Obx(
                  () => dropdownUI(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    context: context,
                    controller: _noticeTypeController,
                    formLabel: 'Notice Type',
                    labelText: 'Notice Type *',
                    hintText: 'Please select notice type',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select notice type';
                      }
                      return null;
                    },
                    data: noticeType!.value.cast(),
                    onChanged: (int? value) {},
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                textField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _subjectController,
                  labelText: 'Subject *',
                  hintText: 'Write subject',
                  validator: (value) =>
                      value!.isEmpty ? 'please write subject' : null,
                  readOnly: false,
                  minLines: 1,
                  maxLines: 5,
                  inputType: TextInputType.text,
                ),
                const SizedBox(
                  height: 15,
                ),
                textField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _noticeDescriptionController,
                  labelText: 'Notice Description *',
                  hintText: 'Write description',
                  validator: (value) =>
                      value!.isEmpty ? 'please write subject' : null,
                  readOnly: false,
                  minLines: 1,
                  maxLines: 5,
                  inputType: TextInputType.text,
                ),
                const SizedBox(
                  height: 15,
                ),
                Obx(
                  () => dropdownUI(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    context: context,
                    controller: _chooseController,
                    formLabel: 'Choose whom to share with',
                    labelText: 'Choose whom to share with *',
                    hintText: 'Please select your choice',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select whom to share';
                      }
                      return null;
                    },
                    data: noticeShare!.value.cast(),
                    onChanged: (int? value) {},
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                // TextButton.icon(
                //   onPressed: _showAdvAlertDialog,
                //   label: const Text(
                //     'Advertisement Attachment',
                //     style: TextStyle(
                //       decoration: TextDecoration.underline,
                //       letterSpacing: 1.4,
                //     ),
                //   ),
                //   icon: const Icon(
                //     Icons.upload_file_outlined,
                //   ),
                //   iconAlignment: IconAlignment.start,
                // ),
                // Obx(() {
                //   return Visibility(
                //     visible: _advImagesNotifier
                //         .isNotEmpty, // Show GridView only if there are images
                //     child: Container(
                //       margin: const EdgeInsets.all(10.0),
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(7.0),
                //         border: Border.all(
                //           color: Colors.grey,
                //           width: 2.0,
                //         ),
                //       ),
                //       child: Scrollbar(
                //         controller: _scrollController,
                //         thumbVisibility: true,
                //         thickness: 4.0,
                //         child: GridView.builder(
                //           controller: _scrollController,
                //           scrollDirection: Axis.vertical,
                //           shrinkWrap: true,
                //           gridDelegate:
                //               const SliverGridDelegateWithFixedCrossAxisCount(
                //             childAspectRatio: 12 / 16,
                //             crossAxisCount: 3,
                //             mainAxisSpacing: 4.0,
                //           ),
                //           padding: const EdgeInsets.all(10.0),
                //           itemCount: _advImagesNotifier.length,
                //           itemBuilder: (context, index) {
                //             return Stack(
                //               children: [
                //                 Padding(
                //                   padding: const EdgeInsets.all(4.0),
                //                   child: GestureDetector(
                //                     onTap: () {
                //                       _openFullImageDialog(
                //                           _advImagesNotifier[index]);
                //                     },
                //                     child: Container(
                //                       decoration: BoxDecoration(
                //                         borderRadius:
                //                             BorderRadius.circular(4.0),
                //                         border: Border.all(
                //                           color: Colors.grey,
                //                           width: 2.0,
                //                         ),
                //                       ),
                //                       child: Image.file(
                //                         _advImagesNotifier[index],
                //                         fit: BoxFit.cover,
                //                         width:
                //                             MediaQuery.of(context).size.width *
                //                                 0.4,
                //                         height:
                //                             MediaQuery.of(context).size.height *
                //                                 0.4,
                //                       ),
                //                     ),
                //                   ),
                //                 ),
                //                 Positioned(
                //                   top: 10,
                //                   right: 8,
                //                   child: GestureDetector(
                //                     onTap: () {
                //                       _advRemoveImage(index);
                //                     },
                //                     child: const Icon(
                //                       Icons.delete_sweep,
                //                       color: Color.fromARGB(255, 202, 43, 32),
                //                       size: 30,
                //                     ),
                //                   ),
                //                 ),
                //               ],
                //             );
                //           },
                //         ),
                //       ),
                //     ),
                //   );
                // }),
                TextButton.icon(
                  onPressed: _showAlertDialog,
                  label: const Text(
                    'Upload Attachment',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      letterSpacing: 1.4,
                    ),
                  ),
                  icon: const Icon(
                    Icons.upload_file_outlined,
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
                                          _imagesNotifier[index]);
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
                }),
                const SizedBox(
                  height: 15,
                ),
                textButton(
                  widget: const AutoSizeText('Submit'),

                  onPressed: () async {
                    final scaffoldMessenger = ScaffoldMessenger.of(context);

                    if (!_formKey.currentState!.validate()) {
                      return; // Stop further execution if form is invalid
                    }

                    try {
                      NoticeBoardCreationModal? res =
                          await dioServiceClient.submitNotice(
                        noticeType: _noticeTypeController.text,
                        noticeSub: _subjectController.text,
                        noticeDescription: _noticeDescriptionController.text,
                        noticeShare: _chooseController.text,
                        imageList: imageList ?? [], // Combined list of images
                      );

                      scaffoldMessenger.showSnackBar(
                        const SnackBar(
                          content: Text('Successfully created a notice.'),
                        ),
                      );

                      if (res!.statuscode == 1) {
                        Get.close(1);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const NoticeBoardList(),
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
                        "Oops!! Failed to create a notice",
                        e.toString(),
                        snackPosition: SnackPosition.TOP,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 50),
                        borderRadius: 10,
                        backgroundColor: Colors.redAccent,
                        colorText: Colors.white,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? hasValidUrl(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    String pattern =
        r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/+#-]*[\w@?^=%&amp;/+#-])?';
    RegExp regExp = RegExp(pattern);

    if (!regExp.hasMatch(value)) {
      return 'Please enter a valid URL';
    }

    return null;
  }

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
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

  // void _showAdvAlertDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         shape: const RoundedRectangleBorder(
  //           borderRadius: BorderRadius.all(Radius.circular(20.0)),
  //         ),
  //         title: const Text(
  //           'Add a Advertisement',
  //           style: TextStyle(
  //             fontSize: 20,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //         content: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           mainAxisSize: MainAxisSize.min,
  //           children: <Widget>[
  //             TextButton.icon(
  //               onPressed: () {
  //                 Navigator.of(context).pop(); // Close the dialog
  //                 _advPickImages(ImageSource.gallery);
  //               },
  //               label: const Text(
  //                 'Choose from Gallery',
  //               ),
  //               icon: const Icon(
  //                 Icons.photo_library,
  //               ),
  //               iconAlignment: IconAlignment.start,
  //             ),
  //             TextButton.icon(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //               label: const Text(
  //                 'Cancel',
  //               ),
  //               icon: const Icon(
  //                 Icons.cancel,
  //               ),
  //             )
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

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
    List<XFile>? pickedImages = await ImagePicker().pickMultiImage();

    if (pickedImages.isNotEmpty) {
      imageList?.addAll(pickedImages);

      final updatedImages = List<File>.from(_imagesNotifier.value)
        ..addAll(pickedImages.map((xFile) => File(xFile.path)));
      _imagesNotifier.value = updatedImages;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Images selected from Gallery.'),
        ));
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('No images selected from Gallery.'),
        ));
      });
    }
  }

  // Future<void> _advPickImages(ImageSource source) async {
  //   advImageList = await ImagePicker().pickMultiImage();

  //   if (advImageList!.isNotEmpty) {
  //     final updatedImages = List<File>.from(_advImagesNotifier)
  //       ..addAll(advImageList!.map((xFile) => File(xFile.path)));
  //     _advImagesNotifier.value = updatedImages;

  //     // Call ScaffoldMessenger after async operation completes
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text('Images selected from Gallery!'),
  //       ));
  //     });
  //   } else {
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text('No images selected from Gallery.'),
  //       ));
  //     });
  //   }
  // }

  void _removeImage(int index) {
    // Remove the image directly from the RxList
    final removedImage = _imagesNotifier[index];
    _imagesNotifier.removeAt(index);

    // Update the actual image list to ensure consistency
    imageList = List<XFile>.from(_imagesNotifier);

    // Show snackbar after removing the image
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text('Image removed: ${removedImage.path}'),
    //   ),
    // );
  }

  // void _advRemoveImage(int index) {
  //   // Remove the image directly from the RxList
  //   final removedImage = _advImagesNotifier[index];
  //   _advImagesNotifier.removeAt(index);

  //   // Update the actual advImageList to ensure consistency
  //   advImageList = List<XFile>.from(_advImagesNotifier);

  //   // Show snackbar after removing the image
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text('Image removed: ${removedImage.path}'),
  //     ),
  //   );
  // }

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

  Widget customElevatedButton({
    required String text,
    double? fontSize,
    Color? backgroundColor,
    Color? textColor,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: const Size.fromWidth(200),
          elevation: 5,
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
