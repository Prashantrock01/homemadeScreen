import 'package:biz_infra/Screens/help_desk/CommentsActivities/comments_activities_details.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:image_picker/image_picker.dart';
import '../../CustomWidgets/configurable_widgets.dart';
import '../../Network/dio_service_client.dart';
import 'guard_messaging/messaging_guard_details.dart';

class MessageGuard extends StatefulWidget {
  final String name;
  final String recordID;
  const MessageGuard({required this.name, required this.recordID, super.key});

  @override
  State<MessageGuard> createState() => _MessageGuardState();
}

class _MessageGuardState extends State<MessageGuard> {
  final messageKey = GlobalKey<FormState>();
  final messageController = TextEditingController();
  RxList<XFile> attachmentFiles = <XFile>[].obs;


  void _showSourceSelection(BuildContext context,
      {required VoidCallback onCamera, required VoidCallback onGallery})
  {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  onCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  onGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickMedia({required String source, required String type}) async {
    final ImagePicker picker = ImagePicker();
    XFile? file;

    try {
      if (type == 'image') {
        file = await picker.pickImage(
          source: source == 'camera' ? ImageSource.camera : ImageSource.gallery,
        );

      } else if (type == 'video') {
        file = await picker.pickVideo(
          source: source == 'camera' ? ImageSource.camera : ImageSource.gallery,
        );
      } else if (type == 'pdf') {
        // Use a file picker for PDFs (e.g., file_picker package)
        final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
        if (result != null) {
          file = XFile(result.files.single.path!);
        }
      }

      if (file != null) {
        // Handle the selected file
        debugPrint('Picked file: ${file.path}');
      }
    } catch (e) {
      debugPrint('Error picking media: $e');
    }
    if(file!=null){
      attachmentFiles.add(file);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Column(
        children: [
          Expanded(
            child: MessageGuardDetails(
              recordID: widget.recordID,
              name: widget.name,
            ),
          ),
          Container(
            color: Colors.grey.shade300,
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Column(
              children: [
                Row(
                  children: [
                    // TextField
                    Expanded(
                      child: textField(
                        controller: messageController,
                        hintText: 'Type a message',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        hintStyle: const TextStyle(color: Colors.black),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      ),
                    ),

                    // Attach file icon
                    IconButton(
                      icon: const Icon(Icons.attach_file, color: Colors.black),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Wrap(
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.image),
                                  title: const Text('Attach Image'),
                                  onTap: () {
                                    Navigator.pop(context); // Close the bottom sheet
                                    _showSourceSelection(
                                      context,
                                      onCamera: () => _pickMedia(source: 'camera', type: 'image'),
                                      onGallery: () => _pickMedia(source: 'gallery', type: 'image'),
                                    );
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.videocam),
                                  title: const Text('Attach Video'),
                                  onTap: () {
                                    Navigator.pop(context); // Close the bottom sheet
                                    _showSourceSelection(
                                      context,
                                      onCamera: () => _pickMedia(source: 'camera', type: 'video'),
                                      onGallery: () => _pickMedia(source: 'gallery', type: 'video'),
                                    );
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.picture_as_pdf),
                                  title: const Text('Attach PDF'),
                                  onTap: () {
                                    Navigator.pop(context); // Close the bottom sheet
                                    _pickMedia(source: 'gallery', type: 'pdf');
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),

                    // Send button
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.black),
                      onPressed: () {
                        dioServiceClient.sendMessageCallGuard(
                          context: context,
                          commentContent: messageController.text,
                          relatedTo: widget.recordID,
                          listOfFiles: attachmentFiles,
                          guardName: widget.name,
                        );
                        messageController.clear();
                        attachmentFiles.clear();
                        // Handle send message action
                      },
                    ),
                  ],
                ),
                Obx(
                      () => ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: attachmentFiles.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Text(attachmentFiles[index].name.toString()),
                            ),
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
                                  attachmentFiles.removeAt(index);
                                },
                                child: const Icon(Icons.close),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
