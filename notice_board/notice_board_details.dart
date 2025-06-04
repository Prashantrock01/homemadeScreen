import 'package:auto_size_text/auto_size_text.dart';
import 'package:biz_infra/CustomWidgets/configurable_widgets.dart';
import 'package:biz_infra/Model/notice_board/notice_board_details_modal.dart';
import 'package:biz_infra/Network/dio_service_client.dart';
import 'package:biz_infra/Screens/home.dart';
import 'package:biz_infra/Utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class NoticeBoardDetails extends StatefulWidget {
  const NoticeBoardDetails(
      {super.key, required this.entryId, required this.noticeId});

  final String entryId;
  final String noticeId;

  @override
  State<NoticeBoardDetails> createState() => _NoticeBoardDetailsState();
}

class _NoticeBoardDetailsState extends State<NoticeBoardDetails> {
  // final DioServiceClient _dioClient = DioServiceClient();

  Future<NoticeBoardDetailsModal?>? noticeFuture;
  String? shareText;

  @override
  void initState() {
    super.initState();
    noticeFuture = _fetchNoticeDetails();
  }

  Future<NoticeBoardDetailsModal?> _fetchNoticeDetails() async {
    try {
      final noticeDetails =
          await dioServiceClient.getNoticeDetails(recordId: widget.entryId);

      // Check if notice details are available and prepare share text
      if (noticeDetails?.data?.record != null) {
        final record = noticeDetails!.data!.record;
        final noticeType = record?.noticeType ?? '';
        final noticeSub = record?.noticeSub ?? '';
        final noticeDesc = record?.noticeDescription ?? '';
        final noticeCreated = record?.createdtime ?? '';
        final url = record!.noticeProdurl ?? '';

        shareText =
            '$noticeType\n\n$noticeSub\n\n$noticeDesc\n\n$noticeCreated\n\n$url';
      }

      return noticeDetails;
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  void _shareNotice() async {
    if (shareText != null) {
      await Share.share(shareText!, subject: 'Check out this notice!');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No notice details available to share.')),
      );
    }
  }

  Future<void> deleteNoticeRecord(String record) async {
    try {
      final response = await dioServiceClient.getNoticeDelete(record: record);
      if (response != null) {
        // Handle success case, such as showing a success message
        if (kDebugMode) {
          print('Record deleted successfully: ${response.statusMessage}');
        }
      } else {
        // Handle null response, if applicable
        if (kDebugMode) {
          print('No response received.');
        }
      }
    } catch (e) {
      // Handle errors, such as showing an error message
      if (kDebugMode) {
        print('Failed to delete record: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notice Board Details'),
        centerTitle: false,
        actions: [
          iconButton(
            _shareNotice, 
            const Icon(Icons.share),
          ),
          if (Constants.userRole == 'Facility Manager' || Constants.userRole == 'Treasury')
          iconButton(
            () async {
              // Save the context in a variable
              final scaffoldMessenger = ScaffoldMessenger.of(context);

              bool shouldDelete = await _showDeleteConfirmationDialog();
              if (shouldDelete) {
                await deleteNoticeRecord(widget.noticeId);
                Get.offAll(
                  () => const Home(),
                  transition: Transition.rightToLeft,
                  popGesture: true,
                );
                scaffoldMessenger.showSnackBar(
                  const SnackBar(
                    content: Text('Notice deleted successfully.'),
                  ),
                );
              }
            },
            const Icon(Icons.delete_forever_rounded),
          ),
        ],
      ),
      body: FutureBuilder<NoticeBoardDetailsModal?>(
        future: noticeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: const AbsorbPointer(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text('An error occurred: ${snapshot.error}'),
              );
            }

            if (snapshot.hasData && snapshot.data?.data?.record != null) {
              final record = snapshot.data!.data!.record!;

              return Column(
                children: <Widget>[
                  Card(
                    margin: const EdgeInsets.all(14.0),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // if (record.noticeAdvertisement != null &&
                          //     record.noticeAdvertisement!.isNotEmpty) ...[
                          //   ClipRRect(
                          //     borderRadius: BorderRadius.circular(15),
                          //     child: Stack(
                          //       children: [
                          //         const Center(
                          //           child: CircularProgressIndicator(),
                          //         ), // Placeholder that shows initially
                          //         Image.network(
                          //           record.noticeAdvertisement![0].urlpath!,
                          //           fit: BoxFit.cover,
                          //           height: 200,
                          //           width: 400,
                          //           loadingBuilder: (BuildContext context,
                          //               Widget child,
                          //               ImageChunkEvent? loadingProgress) {
                          //             if (loadingProgress == null) {
                          //               return child; // Show the image when loaded
                          //             }
                          //             return Container(); // Return empty container since the CircularProgressIndicator is already there
                          //           },
                          //           errorBuilder: (BuildContext context,
                          //               Object error, StackTrace? stackTrace) {
                          //             return const Center(
                          //               child: Text(
                          //                 'Failed to load image',
                          //               ),
                          //             );
                          //           },
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ],
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: AutoSizeText(
                                  record.noticeType ?? '',
                                  softWrap: true,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10,),
                          AutoSizeText(
                            record.noticeSub ?? '',
                          ),
                          const SizedBox(height: 10,),

                          AutoSizeText(
                            record.noticeDescription ?? '',
                          ),


                          ListTile(
                            minVerticalPadding: 5,
                            contentPadding: const EdgeInsets.all(1.0),
                            title: AutoSizeText(
                              record.createdtime ?? '',
                              style: const TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,

                              ),
                            ),
                          ),
                          if (record.noticeAttachment != null &&
                              record.noticeAttachment!.isNotEmpty) ...[
                            showUploadedImages(
                              record.noticeAttachment ?? [],
                            ),
                          ]
                        ],
                      ),
                    ),
                  ),
                  // if (record.noticeProdurl != null &&
                  //     record.noticeProdurl!.isNotEmpty) ...[
                  //   customElevatedButton(
                  //     text: 'I\'m interested',
                  //     fontSize: 20,
                  //     onPressed: () async {
                  //       String url = record.noticeProdurl ?? '';
                  //       if (url.isEmpty) {
                  //         debugger.printLogs('No product URL available.');
                  //         return;
                  //       }

                  //       Uri uri = Uri.parse(url);
                  //       if (await canLaunchUrl(uri)) {
                  //         await launchUrl(
                  //           uri,
                  //           mode: LaunchMode
                  //               .externalNonBrowserApplication, // Ensure it doesn't open in a browser
                  //         );
                  //       } else {
                  //         debugger.printLogs('Could not launch $url');
                  //       }
                  //     },
                  //   ),
                  // ]
                ],
              );
            } else {
              return const Center(
                child: Text('No data available.'),
              );
            }
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget showUploadedImages(List<dynamic> imageList) {
    imageList.removeWhere((element) => (element.urlpath ?? '').isEmpty);

    return imageList.isEmpty
        ? const Text(
            'No Images Uploaded.',
            style: TextStyle(
            ),
          )
        : Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(5),
            ),
            child: GridView.count(
              crossAxisCount: 3,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              shrinkWrap: true,
              children: List.generate(
                imageList.length,
                (index) {
                  String imageUrl = imageList[index].urlpath ?? '';
                  return GestureDetector(
                    onTap: () async {
                      // Open full image dialog directly without downloading
                      _openFullImageDialog(imageUrl);
                    },
                    child: SizedBox(
                      height: 100, // Set a fixed height for images
                      width: double.infinity, // Take full width
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child; // Show the image when loaded
                          }
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          );
  }

  void _openFullImageDialog(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shadowColor: Colors.blueAccent,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
          backgroundColor: Colors.white,
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InteractiveViewer(
                    child:
                        Image.network(imageUrl), // Display the image directly
                  ),
                ],
              ),
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

  Future<bool> _showDeleteConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Delete Notice'),
              content:
                  const Text('Are you sure you want to delete this notice?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Delete'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        ) ??
        false; // Return false if dialog is dismissed
  }
}
