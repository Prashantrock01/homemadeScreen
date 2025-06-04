import 'dart:async';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:biz_infra/CustomWidgets/configurable_widgets.dart';
import 'package:biz_infra/CustomWidgets/preview_pdf.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../CustomWidgets/image_view.dart';
import '../../CustomWidgets/playVideo.dart';
// import '../../Model/HelpDesk/help_desk_details_model.dart';
import '../../Network/dio_service_client.dart';
import '../../CustomWidgets/CustomAudio/audio_player_widget.dart';
// import '../../Themes/custom_theme.dart';
import '../../Utils/constants.dart';
import 'CommentsActivities/comments_activities_details.dart';

class HelpDeskTicketDetailsScreen extends StatefulWidget {
  final String recordId;
  final Function onAnyChanges;

  const HelpDeskTicketDetailsScreen({super.key, required this.recordId, required this.onAnyChanges});

  @override
  State<HelpDeskTicketDetailsScreen> createState() => _HelpDeskTicketDetailsScreenState();
}

class _HelpDeskTicketDetailsScreenState extends State<HelpDeskTicketDetailsScreen> {
  GlobalKey<FormState> helpDeskDetailsForm = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  bool isRatingProvided = false;
  final TextEditingController messageController = TextEditingController();
  RxList<XFile> attachmentFiles = <XFile>[].obs;
  List<String> ticketStatusList = ['In-Progress', 'On Hold', 'Resolve', 'Closed'];
  final TextEditingController ticketStatusController = TextEditingController();
  bool isDropdownReadOnly = false;
  final ImagePicker resolveImagePicker = ImagePicker();
  RxList<File?> resolvedImages = <File?>[].obs;


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
    if (file != null) {
      attachmentFiles.add(file);
    }
  }

  // Method to capture multiple images from the camera
  Future<void> _resolvedImage() async {
    final pickedFile = await resolveImagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      // setState(() {
        resolvedImages.add(File(pickedFile.path));
      // });
    }
  }

  // Method to navigate to the image view screen
  void _viewImageInDialog(BuildContext context, File? imageFile, StateSetter dialogSetState) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageViewScreen(
          imageFile: imageFile!,
          onDelete: () {
            resolvedImages.remove(imageFile);
             dialogSetState(() {}); // Update dialog state after deletion
            Navigator.pop(context); // Close the full-screen view
          },
        ),
      ),
    );
  }


  void _scrollToBottom() {
    Timer(const Duration(milliseconds: 500), () {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: helpDeskDetailsForm,
      child: Scaffold(
        appBar: AppBar(title: const Text('Help Desk Ticket Details'),),
        body: FutureBuilder(
          future: dioServiceClient.getHelpDeskDetails(recordId: widget.recordId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final photos = snapshot.data!.data!.record!.ticUploadimage;
              final voiceRecord = snapshot.data!.data!.record!.ticVoicerecord;

              ticketStatusController.text = snapshot.data!.data!.record!.ticketstatus.toString();
              isDropdownReadOnly = (snapshot.data!.data!.record!.ticketstatus.toString() == "Closed");

              return Column(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                     controller: _scrollController,
                      physics: const ScrollPhysics(),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                (ticketStatusController.text == 'Closed' && (snapshot.data!.data!.record!.smcreatorid.toString().split('x').last == Constants.userUniqueId || Constants.userRole == 'Facility Manager'))
                                    ? Align(
                                        alignment: Alignment.topRight,
                                        child: RatingBarIndicator(
                                          rating: double.parse(snapshot.data!.data!.record!.ticRating.toString()),
                                          itemBuilder: (context, index) => const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          itemCount: 5,
                                          // Total number of stars
                                          itemSize: 20.0,
                                          // Size of each star
                                          direction: Axis.horizontal,
                                        ),
                                      )
                                    : const SizedBox.shrink(),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        "Ticket ID: ${snapshot.data!.data!.record!.ticketNo.toString()}",
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child:
                                     (isDropdownReadOnly || (Constants.userRole != 'Facility Manager' && snapshot.data!.data!.record!.smcreatorid.toString().split('x').last != Constants.userUniqueId))
                                              ? AutoSizeText(snapshot.data!.data!.record!.ticketstatus.toString(),
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      // color: Colors.black
                                                  ),
                                                )
                                              : dropdownUI(
                                        context: context,
                                        selectedValueIndex: (Constants.userRole == 'Owner' && snapshot.data!.data!.record!.smcreatorid.toString().split('x').last == Constants.userUniqueId)
                                            ? -1
                                            : ticketStatusList.indexOf(snapshot.data!.data!.record!.ticketstatus.toString()),
                                        controller: ticketStatusController,
                                        formLabel: 'Ticket Status',
                                       data:getDropdownList(Constants.userRole,snapshot.data!.data!.record!.smcreatorid.toString().split('x').last == Constants.userUniqueId,ticketStatusController.text ),

                                       // (Constants.userRole == 'Owner' &&
                                       //     snapshot.data!.data!.record!.smcreatorid.toString().split('x').last == Constants.userUniqueId)
                                       //     ? ['Closed']
                                       //     : (Constants.userRole == 'Facility Manager' ||
                                       //     Constants.userRole == 'Super Admin' ||
                                       //     Constants.userRole == 'Treasury')
                                       //     ? (ticketStatusController.text == "Resolve")
                                       //     ? ['Closed'] // If "Resolve" is selected, only "Closed" should be available
                                       //     : (snapshot.data!.data!.record!.smcreatorid.toString().split('x').last == Constants.userUniqueId)
                                       //     ? ['In-Progress', 'On Hold', 'Resolve', 'Closed']
                                       //     : ['In-Progress', 'On Hold', 'Resolve']
                                       //     : [],

                                       readOnly: getDropdownList(Constants.userRole,snapshot.data!.data!.record!.smcreatorid.toString().split('x').last == Constants.userUniqueId,ticketStatusController.text ).isEmpty,
                                       // readOnly: isDropdownReadOnly ||
                                       //     (Constants.userRole == 'Owner' && snapshot.data!.data!.record!.smcreatorid.toString().split('x').last != Constants.userUniqueId) ||
                                       //     (Constants.userRole == 'Facility Manager' && ticketStatusController.text == "Resolve"),

                                       onChanged: (int? value) async {
                                          await dioServiceClient.updateHelpDeskTicketStatus(
                                            recordId: snapshot.data!.data!.record!.currentRecordId.toString(),
                                            updateTicketStatus: ticketStatusController.text,
                                            needToSkip: ticketStatusController.text=="Resolve"
                                          );
                                          widget.onAnyChanges();
                                          if (ticketStatusController.text == "Closed" && snapshot.data!.data!.record!.smcreatorid.toString().split('x').last == Constants.userUniqueId) {
                                            setState(() {
                                              isDropdownReadOnly = true;
                                            });

                                            showRatingBarDialog(
                                              context: context,
                                              onSubmit: (int rating) async {
                                                await dioServiceClient.updateHelpDeskTicketRating(
                                                  recordId: snapshot.data!.data!.record!.currentRecordId.toString(),
                                                  rating: rating,
                                                );
                                                widget.onAnyChanges();
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (BuildContext context) => HelpDeskTicketDetailsScreen(
                                                      recordId: widget.recordId,
                                                      onAnyChanges: widget.onAnyChanges,
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          }
                                          else if (Constants.userRole == 'Facility Manager' && (ticketStatusController.text == "Resolve" )) {
                                            showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return PopScope(
                                                  canPop: false,
                                                  child: StatefulBuilder(
                                                    builder: (BuildContext context, StateSetter setState) {
                                                      return AlertDialog(
                                                        title: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            const Text("Ticket Status"),
                                                            //const Spacer(),
                                                            InkWell(
                                                              onTap: () {
                                                                Get.close(1);
                                                                Navigator.pushReplacement(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (BuildContext context) => HelpDeskTicketDetailsScreen(
                                                                      recordId: widget.recordId,
                                                                      onAnyChanges: widget.onAnyChanges,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                              child: const Icon(Icons.close),
                                                            ),
                                                          ],
                                                        ),
                                                        content: Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            const Text("Please upload an image to update ticket status"),
                                                            const SizedBox(height: 20),
                                                            textButton(
                                                              onPressed: () async {
                                                                await _resolvedImage();
                                                                setState(() {});
                                                              },
                                                              widget: const Text('Upload Image'),
                                                            ),
                                                            const SizedBox(height: 20),
                                                            resolvedImages.isNotEmpty
                                                                ? GridView.builder(
                                                                  shrinkWrap: true,
                                                                  physics: const BouncingScrollPhysics(),
                                                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                                    crossAxisCount: 3,
                                                                    crossAxisSpacing: 10,
                                                                    mainAxisSpacing: 10,
                                                                  ),
                                                                  itemCount: resolvedImages.length,
                                                                  itemBuilder: (context, index) {
                                                                    return GestureDetector(
                                                                      onTap: () {
                                                                        _viewImageInDialog(context, resolvedImages[index], setState);
                                                                      },
                                                                      child: Image.file(
                                                                        resolvedImages[index]!,
                                                                        fit: BoxFit.cover,

                                                                      ),
                                                                    );
                                                                  },
                                                                )
                                                                : const Text("No images uploaded"),
                                                          ],
                                                        ),
                                                        actions: [
                                                          textButton(
                                                            onPressed: () async {
                                                              if (resolvedImages.isEmpty) {
                                                                snackBarMessenger("Please upload at least one attachment to update Ticket Status as Resolve");
                                                                return;
                                                              }
                                                              EasyLoading.show();
                                                              for (var file in resolvedImages) {
                                                                if (file != null) {
                                                                  print("Uploading ${file.path}");
                                                                  await dioServiceClient.waterTankUploadImage(
                                                                    recordId: widget.recordId,
                                                                    fieldName: 'resolve_attachment',
                                                                    imageName: file,
                                                                    moduleName: 'HelpDesk',
                                                                  );
                                                                }
                                                              }
                                                              ticketStatusController.text = "Resolve";
                                                              await dioServiceClient.updateHelpDeskTicketStatus(
                                                                recordId: snapshot.data!.data!.record!.currentRecordId.toString(),
                                                                updateTicketStatus: ticketStatusController.text,
                                                              );

                                                              setState(() {
                                                                isDropdownReadOnly = snapshot.data!.data!.record!.smcreatorid.toString().split('x').last != Constants.userUniqueId;
                                                              });
                                                              EasyLoading.dismiss();
                                                              Navigator.pop(context);
                                                              Navigator.pushReplacement(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (BuildContext context) => HelpDeskTicketDetailsScreen(
                                                                    recordId: widget.recordId,
                                                                    onAnyChanges: widget.onAnyChanges,
                                                                  ),
                                                                ),
                                                              );
                                                              widget.onAnyChanges();
                                                            },
                                                            widget: const Text("Submit"),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                );
                                              },
                                            );

                                          }
                                          else {
                                            widget.onAnyChanges();
                                          }
                                        },
                                        dropDownBorder: InputBorder.none,
                                        dropDownEnabledBorder: InputBorder.none,
                                        dropDownFocusedBorder: InputBorder.none,
                                      ),
                                    ),
                                  ],
                                ),

                                keyValue(key:"Ticket Type", value:snapshot.data!.data!.record!.ticType.toString()),
                                keyValue(key:"Category", value:snapshot.data!.data!.record!.ticCategory.toString()),
                                keyValue(key:"Created Date & Time", value:snapshot.data!.data!.record!.createdtime.toString()),
                                keyValue(key:"Description", value:snapshot.data!.data!.record!.ticDescription.toString()),
                                 Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Expanded(
                                      flex: 3,
                                      child: AutoSizeText(
                                        "Location",
                                        minFontSize: 14.0,
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w500),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    const AutoSizeText(
                                      ':',
                                      minFontSize: 14.0,
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      flex: 3,
                                      child: AutoSizeText(
                                        (Constants.userRole == "Owner" && snapshot.data!.data!.record!.ticType.toString() == "Personal")
                                            ? (() {
                                          var pinLocation = snapshot.data!.data!.record!.ticPinLocation;
                                          if (pinLocation != null) {
                                            var parts = pinLocation.split(' ');
                                            return parts.length >= 2
                                                ? "Block: ${parts[1]} No: ${parts.length > 2 ? parts[2] : 'Not Available'}"
                                                : "Block: $pinLocation No: Not Available";
                                          }
                                          return "Location data not available";
                                        })()
                                            : (Constants.userRole == "Owner" && snapshot.data!.data!.record!.ticType.toString() == "Common Area")
                                            ? "Block: ${snapshot.data!.data!.record!.ticPinLocation ?? 'Unknown'}"
                                            : (Constants.userRole != "Owner" && snapshot.data!.data!.record!.ticType.toString() == "Personal")
                                            ? (() {
                                          var pinLocation = snapshot.data!.data!.record!.ticPinLocation;
                                          if (pinLocation != null) {
                                            var parts = pinLocation.split(' ');
                                            return parts.length >= 2
                                                ? "Block: ${parts[1]} No: ${parts.length > 2 ? parts[2] : 'Not Available'}"
                                                : "Block: $pinLocation No: Not Available";
                                          }
                                          return "Location data not available";
                                        })()
                                            : (Constants.userRole != "Owner" && snapshot.data!.data!.record!.ticType.toString() == "Common Area")
                                            ? "Block: ${snapshot.data!.data!.record!.ticPinLocation ?? 'Unknown'}"
                                            : "",

                                        minFontSize: 14.0,
                                        style: const TextStyle(fontSize: 14.0),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ],
                                ),
                                // keyValue("Location", "Block: ${snapshot.data!.data!.record!.ticPinLocation?.split(' ')[0]}, Number: ${snapshot.data!.data!.record!.ticPinLocation?.split(' ')[1]}"),
                                keyValue(key:"Emergency", value:snapshot.data!.data!.record!.ticIsemergency.toString() == '1' ? 'Yes' : 'No'),
                                (ticketStatusController.text == "Resolve" || ticketStatusController.text == "Closed")?
                                keyValue(key:"Resolved Date & Time", value:snapshot.data!.data!.record!.modifiedtime.toString()): const SizedBox.shrink(),
                                keyValue(key:"Assignee", value:snapshot.data!.data!.record!.assignedUserIdLabel.toString()),
                                keyValue(key:"Created By", value:snapshot.data!.data!.record!.smcreatoridLabel.toString()),

                                const SizedBox(height: 10,),
                                if (photos != null && photos.isNotEmpty) ...[
                                  const Text("Attachments", style: TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 5),
                                  GridView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: photos.length,
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                    ),
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () async {
                                          File file = await getFile(photos[index].urlpath.toString(), photos[index].name.toString());
                                          if (photos[index].name!.endsWith('.jpg') || photos[index].name!.endsWith('.png')) {
                                            // Open full-screen image view when an image is tapped
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ImageViewScreen(imageFile: file, imageName: snapshot.data!.data!.record!.ticUploadimage![index].name.toString(), showDownload: true,),
                                              ),
                                            );
                                          } else if (photos[index].name!.endsWith('.mp4')) {
                                            // Open full-screen video view when a video is tapped
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => PlayVideo(file),
                                              ),
                                            );
                                          } else if (photos[index].name!.endsWith('.pdf')) {
                                            // Open full-screen video view when a video is tapped
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => PreviewPdf(pdfUrl: photos[index].urlpath.toString(), pdfName: photos[index].name.toString())),
                                            );
                                          }
                                        },
                                        child: photos[index].name!.endsWith('.jpg') || photos[index].name!.endsWith('.png')
                                            ? Container(
                                          color: Colors.grey.shade600,
                                              child: Image.network(
                                                  photos[index].urlpath!,
                                                  fit: BoxFit.cover,
                                                ),
                                            )
                                            : photos[index].name!.endsWith('.mp4')
                                                ? Container(
                                                    color: Colors.black,
                                                    child: const Icon(
                                                      Icons.play_arrow,
                                                      color: Colors.white,
                                                      size: 50,
                                                    ),
                                                  ) // Show a play button for video thumbnails

                                                : photos[index].name!.endsWith('.pdf')
                                                    ? Container(color: Colors.grey.shade600, child: const Icon(Icons.picture_as_pdf))
                                                    : Container(),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                ],

                                // Voice Record
                                if (voiceRecord != null && voiceRecord.isNotEmpty) ...[
                                  const Text("Voice Record", style: TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 5),
                                  ListView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: voiceRecord.length,
                                    itemBuilder: (context, index) {
                                      return AudioPlayerWidget(audioUrl: voiceRecord[index].urlpath.toString());
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                ],

                                ticketStatusController.text == "Resolve" ? const Text("Resolved Image",style: TextStyle(fontWeight: FontWeight.bold),): const SizedBox.shrink(),
                                // Check if there are images and display them in a grid
                                const SizedBox(height: 5,),
                                snapshot.data?.data?.record?.resolveAttachment != null && snapshot.data!.data!.record!.resolveAttachment!.isNotEmpty
                                    ? GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.data!.record!.resolveAttachment!.length,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3, // 3 images per row
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                  ),
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () async {
                                        File file = await getFile(snapshot.data!.data!.record!.resolveAttachment![index].urlpath.toString(), snapshot.data!.data!.record!.resolveAttachment![index].name.toString());
                                        if (snapshot.data!.data!.record!.resolveAttachment![index].name!.endsWith('.jpg') || snapshot.data!.data!.record!.resolveAttachment![index].name!.endsWith('.png')) {
                                          Navigator.push(context,
                                            MaterialPageRoute(builder: (context) => ImageViewScreen(imageFile: file, imageName: snapshot.data!.data!.record!.resolveAttachment![index].name.toString(), showDownload: true,),),);
                                        } else if (snapshot.data!.data!.record!.resolveAttachment![index].name!.endsWith('.pdf')) {
                                          // Open full-screen video view when a video is tapped
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>PreviewPdf(pdfUrl: snapshot.data!.data!.record!.resolveAttachment![index].urlpath.toString(), pdfName: snapshot.data!.data!.record!.resolveAttachment![index].name.toString())),
                                          );
                                        }
                                      },
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          snapshot.data!.data!.record!.resolveAttachment![index].name!.endsWith('.jpg') || snapshot.data!.data!.record!.resolveAttachment![index].name!.endsWith('.png')
                                              ?  Image.network(
                                            snapshot.data!.data!.record!.resolveAttachment![index].urlpath.toString(),
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                            loadingBuilder: (context, child, loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child; // Image is fully loaded
                                              } else {
                                                return const CircularProgressIndicator(); // Show loader
                                              }
                                            },
                                          ):snapshot.data!.data!.record!.resolveAttachment![index].name!.endsWith('.pdf')
                                              ? const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Icon(Icons.picture_as_pdf),
                                          )
                                              : Container(),

                                        ],
                                      ),
                                    );
                                  },
                                )
                                    : const SizedBox.shrink(),



                              ],
                            ),
                          ),
                          // Comments Activity header
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.05,
                            decoration: BoxDecoration(color: Colors.grey.shade500),
                            child: const Center(child: Text('Comments Activity')),
                          ),

                          const SizedBox(
                            height: 20,
                          ),
                          //messageUI(),
                          //CommentsActivity(recordId: widget.recordId,),
                          CommentsActivityDetailsScreen(
                            recordID: widget.recordId,
                            onChange: widget.onAnyChanges,
                          ),
                        ],
                      ),
                    ),
                  ),


                  // Message input section
                  snapshot.data!.data!.record!.ticketstatus == 'Closed'
                      ? const SizedBox.shrink()
                      : Container(
                          color:  Theme.of(context).brightness == Brightness.light ?Colors.grey.shade300: Colors.grey.shade900,
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
                                      inputType: TextInputType.text,
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      // hintStyle: const TextStyle(color: Colors.black),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                                      onTap: (){
                                        _scrollToBottom();
                                      },
                                    ),
                                  ),

                                  // Attach file icon
                                  IconButton(
                                    icon: Icon(
                                      Icons.attach_file,
                                      color:  Theme.of(context).brightness == Brightness.light ?Colors.grey.shade900: Colors.grey.shade300,
                                    ),
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
                                                  showMediaSourceSelection(
                                                    context,
                                                    onCamera: () => _pickMedia(source: 'camera', type: 'image'),
                                                    onGallery: () => _pickMedia(source: 'gallery', type: 'image'),
                                                  );
                                                },
                                              ),
                                              ///Do not remove this commented code - will be used later
                                              // ListTile(
                                              //   leading: const Icon(
                                              //     Icons.videocam,
                                              //   ),
                                              //   title: const Text('Attach Video'),
                                              //   onTap: () {
                                              //     Navigator.pop(context); // Close the bottom sheet
                                              //     showMediaSourceSelection(
                                              //       context,
                                              //       onCamera: () => _pickMedia(source: 'camera', type: 'video'),
                                              //       onGallery: () => _pickMedia(source: 'gallery', type: 'video'),
                                              //     );
                                              //   },
                                              // ),
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
                                    icon: Icon(
                                      Icons.send,
                                      color:  Theme.of(context).brightness == Brightness.light ?Colors.grey.shade900: Colors.grey.shade300,
                                    ),
                                    onPressed: () async {
                                      await dioServiceClient.sendMessage(
                                          context: context,
                                          commentContent: messageController.text.isEmpty ? ' ' : messageController.text,
                                          relatedTo: widget.recordId, listOfFiles: attachmentFiles, onChange: widget.onAnyChanges);
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
                                    String path = attachmentFiles[index].path;
                                    String extension = path.split('.').last.toLowerCase();

                                    return SizedBox(
                                        height: 50,
                                        width: MediaQuery.of(context).size.width,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                           Expanded(flex: 5, child: Text(attachmentFiles[index].name.toString())),

                                           // Expanded(
                                           //     flex: 5,
                                           //     child: Image.file(File(attachmentFiles[index].path))
                                           // ),


                                        //     Expanded(
                                        //        flex: 5,
                                        //        child: extension == 'jpg' || extension == 'png' || extension == 'jpeg'
                                        //            ? Image.file(File(attachmentFiles[index].path))
                                        //            : extension == 'mp4'
                                        //            ? VideoPlayerWidget(videoFile: File(attachmentFiles[index].path))
                                        //            :extension == 'pdf'
                                        //            ? SfPdfViewer(pdfFile: File(attachmentFiles[index].path))
                                        //            :  Icon(Icons.insert_drive_file, size: 50),
                                        // ),

                                            const SizedBox(height: 30,),
                                            Expanded(
                                              flex: 1,
                                              child: InkWell(
                                                  onTap: () {
                                                    attachmentFiles.removeAt(index);
                                                  },
                                                  child: const Icon(Icons.close)),
                                            ),
                                          ],
                                        ));
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  List<String> getDropdownList(String userRole,bool isCurrentUser, String currentStatus ){
    if(currentStatus=="Closed") return[];
    if(currentStatus=="Resolve"){
     return isCurrentUser?["Closed"]:[];
    }

    if (Constants.userRole == 'Facility Manager'){
        return ['In-Progress', 'On Hold', 'Resolve'];
      }
    else if(Constants.userRole == 'Super Admin' ||Constants.userRole == 'Treasury'){
      return isCurrentUser?['In-Progress', 'On Hold','Closed']:['In-Progress', 'On Hold'];

    }
    else if(isCurrentUser){
      return ["Closed"];
    }
    return [];


  }
}

