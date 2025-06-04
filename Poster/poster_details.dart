import 'package:auto_size_text/auto_size_text.dart';
import 'package:biz_infra/CustomWidgets/configurable_widgets.dart';
import 'package:biz_infra/Model/adv_notice_board/adv_notice_board_details_modal.dart';
import 'package:biz_infra/Network/dio_service_client.dart';
import 'package:biz_infra/Screens/home.dart';
import 'package:biz_infra/Utils/constants.dart';
// import 'package:biz_infra/Utils/debugger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:url_launcher/url_launcher.dart';

class PosterDetails extends StatefulWidget {
  const PosterDetails(
      {super.key, required this.entryId, required this.noticeId});

  final String entryId;
  final String noticeId;

  @override
  State<PosterDetails> createState() => _PosterDetailsState();
}

class _PosterDetailsState extends State<PosterDetails> {
  // final DioServiceClient _dioClient = DioServiceClient();

  Future<AdvNoticeBoardDetailsModal?>? advNoticeFuture;
  String? shareText;

  @override
  void initState() {
    super.initState();
    advNoticeFuture = _fetchAdvNoticeDetails();
  }

  Future<AdvNoticeBoardDetailsModal?> _fetchAdvNoticeDetails() async {
    try {
      final advNoticeDetails =
          await dioServiceClient.getAdvNoticeDetails(recordId: widget.entryId);

      // Check if notice details are available and prepare share text
      if (advNoticeDetails?.data?.record != null) {
        final record = advNoticeDetails!.data!.record;
        final noticeType = record?.advnoticeType ?? '';
        final noticeSub = record?.advnoticeSub ?? '';
        final noticeDesc = record?.advDescription ?? '';
        final noticeCreated = record?.createdtime ?? '';
        final url = record!.advnoticeImageurl ?? '';

        shareText =
            '$noticeType\n\n$noticeSub\n\n$noticeDesc\n\n$noticeCreated\n\n$url';
      }

      return advNoticeDetails;
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
      final response = await dioServiceClient.getAdvNoticeDelete(record: record);
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
        title: const Text('Poster Details'),
        centerTitle: false,
        actions: [
          iconButton(
            _shareNotice,
            const Icon(Icons.share),
          ),
          if (Constants.userRole == 'Facility Manager' ||
              Constants.userRole == 'Super Admin')
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
                      content: Text('Adv Notice deleted successfully.'),
                    ),
                  );
                }
              },
              const Icon(Icons.delete_forever_rounded),
            ),
        ],
      ),
      body: FutureBuilder<AdvNoticeBoardDetailsModal?>(
        future: advNoticeFuture,
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
                          if (record.advnoticeImageurl != null &&
                              record.advnoticeImageurl!.isNotEmpty) ...[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: GestureDetector(
                                onTap: () => _openFullImageDialog(record.advnoticeImageurl![0].urlpath!),
                                child: Image.network(
                                  record.advnoticeImageurl![0].urlpath!,
                                  fit: BoxFit.cover,
                                  height: 200,
                                  width: 400,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return Container(
                                      height: 120,
                                      width: 400,
                                      color:
                                          Colors.grey[300], // Placeholder color
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  (loadingProgress
                                                          .expectedTotalBytes ??
                                                      1)
                                              : null,
                                        ),
                                      ),
                                    );
                                  },
                                  errorBuilder: (BuildContext context,
                                      Object error, StackTrace? stackTrace) {
                                    return Container();
                                  },
                                ),
                              ),
                            ),
                          ],
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  record.advnoticeType ?? '',
                                  softWrap: true,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            record.advnoticeSub ?? '',
                            style: const TextStyle(
                              fontSize: 11,
                            ),
                          ),
                          Text(
                            record.advDescription ?? '',
                            style: const TextStyle(
                              fontSize: 11,
                            ),
                          ),
                          Text(
                            record.advnoticeShare ?? '',
                            style: const TextStyle(
                              fontSize: 11,
                            ),
                          ),
                          if (Constants.userRole == 'Facility Manager' ||
                              Constants.userRole == 'Treasury') ...[
                            keyValues(
                                'Start Date', record.posterstartDate ?? ''),
                            keyValues('End Date', record.posterendDate ?? ''),
                            keyValues('Total Days', record.posterCount ?? ''),
                          ],
                          ListTile(
                            minVerticalPadding: 5,
                            contentPadding: const EdgeInsets.all(1.0),
                            title: Text(
                              record.createdtime ?? '',
                              style: const TextStyle(
                                fontSize: 10.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // if (record.advnoticeProdurl != null &&
                  //     record.advnoticeProdurl!.isNotEmpty) ...[
                  //   customElevatedButton(
                  //     text: 'I\'m interested',
                  //     fontSize: 20,
                  //     onPressed: () async {
                  //       String url = record.advnoticeProdurl ?? '';
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
            style: TextStyle(),
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

  Widget keyValues(String key, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: AutoSizeText(
              key,
              minFontSize: 12.0,
              style: const TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 78, 97, 204),
              ),
              textAlign: TextAlign.left,
            ),
          ),
          const AutoSizeText(
            ':',
            minFontSize: 12.0,
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: AutoSizeText(
              value,
              minFontSize: 12.0,
              style: const TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
