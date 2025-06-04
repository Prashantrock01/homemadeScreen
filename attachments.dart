import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../CustomWidgets/configurable_widgets.dart';
import '../CustomWidgets/image_view.dart';
import '../CustomWidgets/playVideo.dart';
import '../CustomWidgets/preview_pdf.dart';
import '../Network/dio_service_client.dart';

class UploadAttachmentScreen extends StatefulWidget {
  final RxList<XFile> mediaList;

  const UploadAttachmentScreen({super.key, required this.mediaList,});

  @override
  State<UploadAttachmentScreen> createState() => _UploadAttachmentScreenState();
}

class _UploadAttachmentScreenState extends State<UploadAttachmentScreen> {

  final ImagePicker _picker = ImagePicker();
  // final List<Map<String, String>> attachedFiles = [];
  // RxList<XFile> imageList = <XFile>[].obs;

  Future<void> showMediaOptions() async {
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
              ///Do not remove this
              // ListTile(
              //   leading: const Icon(Icons.video_camera_back),
              //   title: const Text('Upload Video'),
              //   onTap: () {
              //     Navigator.of(context).pop();  // Close the current dialog
              //     _selectMediaSource('video');
              //   },
              // ),
              ListTile(
                leading: const Icon(Icons.picture_as_pdf),
                title: const Text('Upload Owner Document'),
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
    if (mediaType == 'image') {
      pickedFile = await _picker.pickImage(source: source);
    } else if (mediaType == 'video') {
      pickedFile = await _picker.pickVideo(source: source);
    }

    if (pickedFile != null) {
      const int maxSizeInBytes = 3 * 1024 * 1024;
      if ((await pickedFile.length()) > maxSizeInBytes) {
        // Compress if necessary
        if (mediaType == 'image') {
          await dioServiceClient.compressImage(pickedFile.path, maxSizeInBytes);
        } else {
          EasyLoading.show(status: "Compressing...");
          pickedFile = XFile(await dioServiceClient.compressVideo(pickedFile.path) ?? "");
          EasyLoading.dismiss();
        }
      }
      if ((await pickedFile.length()) <= maxSizeInBytes) {
        widget.mediaList.add(pickedFile);
      } else {
        snackBarMessenger("File size exceeds limit.");
      }
    }
  }


  Future<void> _pickDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;
        if (file.size <= 3 * 1024 * 1024) {
          // Add document to imageList
          widget.mediaList.add(XFile(file.path!));
        } else {
          snackBarMessenger("File size exceeds 3MB limit. Please select a smaller file.");
        }
      } else {
        snackBarMessenger("No document selected.");
      }
    } catch (e) {
      snackBarMessenger("Failed to pick document. Please try again.");
    }
  }



  @override
  Widget build(BuildContext context) {
    return  Column(
        children: [
          textButton(
            onPressed: () => showMediaOptions(),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: Size(MediaQuery.of(context).size.width / 2, 35),
              elevation: 5,
            ),
            widget: const AutoSizeText("Upload Documents"),
          ),

          Obx(()=>
              GridView.builder(
                shrinkWrap: true,  // Prevent grid from occupying full available space
                physics: const NeverScrollableScrollPhysics(),  // Prevent scrolling in GridView
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,  // 3 items per row
                  crossAxisSpacing: 8.0,  // Space between items
                  mainAxisSpacing: 8.0,  // Space between rows
                ),
                itemCount: widget.mediaList.length,  // Modify this if you want to show more items
                itemBuilder: (context, index) {
                  String filePath = widget.mediaList[index].path;

                  // Check if the file is an image or video and handle accordingly
                  return Stack(
                    fit: StackFit.expand, // Ensures the Stack takes up the full available space
                    children: [
                      // Main content (image or video thumbnail)
                      GestureDetector(
                        onTap: () {
                          if (filePath.endsWith('.jpg') || filePath.endsWith('.png')) {
                            // Open full-screen image view when an image is tapped
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ImageViewScreen(imageFile: File(filePath), onDelete: () {widget.mediaList.removeAt(index);},),
                              ),
                            );
                          } else if (filePath.endsWith('.mp4')) {
                            // Open full-screen video view when a video is tapped
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
                                builder: (context) =>  PreviewLocalPdf(pdfPath: filePath, onDelete: () {widget.mediaList.removeAt(index);},),
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
                        ) // Show a play button for video thumbnails

                            : filePath.endsWith('.pdf')?
                        Container(
                            color: Colors.grey.shade600,
                            child: const Icon(Icons.picture_as_pdf))
                            : Container(),
                      ),

                      // Delete button positioned in the top-right corner
                      // Positioned(
                      //   top: 8, // Add some spacing from the top
                      //   right: 8, // Add some spacing from the right
                      //   child: InkWell(
                      //     onTap: () {
                      //       widget.mediaList.removeAt(index);
                      //     },
                      //     child: const Icon(
                      //       Icons.delete,
                      //       color: Colors.red,
                      //     ),
                      //   ),
                      // ),
                    ],
                  );

                },
              ),
          ),
        ],
      );
  }
}


class FullScreenImageView extends StatelessWidget {
  final String path;
  final int index;
  final Function(int) deleteImage;

  const FullScreenImageView({super.key, required this.path,    required this.deleteImage, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Full Screen Image"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {

              deleteImage(index);
              Navigator.pop(context); // Close the full-screen view
            },
          ),
        ],
      ),
      body: Center(
        child: Image.file(
          File(path),
          fit: BoxFit.cover, // Make sure the image fits in the screen
        ),
      ),
    );
  }
}
