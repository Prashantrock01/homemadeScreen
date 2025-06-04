import 'package:biz_infra/CustomWidgets/configurable_widgets.dart';
import 'package:biz_infra/Network/dio_service_client.dart';
import 'package:biz_infra/Screens/Polls/polls_edit_creation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/Polls/DetailsPollsModel.dart';
// import '../../Model/Polls/PollsCountStatusModel.dart';

class PollsDetails extends StatefulWidget {
  final String recordId;
  final String pollId;
  const PollsDetails({required this.recordId, required this.pollId, super.key});

  @override
  State<PollsDetails> createState() => _PollsDetailsState();
}


// class _PollsDetailsState extends State<PollsDetails> {
//   DetailsPollsModel? detailsPollsModelData;
//   int likeCount = 0;
//   bool isLoading = true;
//   bool isLiked = false;
//   int? selectedLikeIndex;
//
//
//
//   @override
//   void initState() {
//     super.initState();
//     fetchPollData();
//     handleLike();
//   }
//
//
//   Future<void> fetchPollData() async {
//     setState(() => isLoading = true);
//     try {
//       final pollDetails = await dioServiceClient.pollDetails(
//           recordId: widget.recordId);
//       if (pollDetails != null) {
//         setState(() {
//           detailsPollsModelData = pollDetails;
//           isLoading = false;
//         });
//       }
//     } catch (error) {
//       setState(() => isLoading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error fetching data: $error')),
//       );
//     }
//   }
//
//   Future<void> handleLike() async {
//     if (!isLiked) {
//       try {
//         final response = await dioServiceClient.pollsLike();
//         if (response?.statuscode != null) {
//           setState(() {
//             likeCount++;
//             isLiked = true;
//           });
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Failed to like the poll')),
//           );
//         }
//       } catch (error) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error: $error')),
//         );
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Polls Details'),
//         actions: [
//           PopupMenuButton<String>(
//             onSelected: (String value) {
//               if (value == 'Edit Polls') {
//                 Get.to(() =>
//                     PollsEditCreation(
//                       pollId: widget.recordId,
//                       pollsData: detailsPollsModelData,
//                     ));
//               }
//             },
//             itemBuilder: (BuildContext context) =>
//             [
//               const PopupMenuItem(
//                 value: 'Edit Polls',
//                 child: Text('Edit Polls'),
//               ),
//             ],
//           )
//         ],
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : detailsPollsModelData == null
//           ? const Center(child: Text('No data available.'))
//           : Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: <Widget>[
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text('Total Polls ',
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
//               SizedBox(width: 20),
//               Text(': $likeCount',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),)
//             ],
//           ),
//           SizedBox(height: 10),
//           Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Card(
//               elevation: 10,
//               child: Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Column(
//                   children: [
//                     keyValue('Poll Id',
//                         detailsPollsModelData!.data!.record!.pollNo ?? ''),
//                     SizedBox(height: 10),
//                     keyValue('Poll Type',
//                         detailsPollsModelData!.data!.record!.pollType ?? ''),
//                     SizedBox(height: 10),
//                     keyValue('Poll Topic',
//                         detailsPollsModelData!.data!.record!.pollTopic ?? ''),
//                     SizedBox(height: 10),
//                     keyValue('Description',
//                         detailsPollsModelData!.data!.record!.pollDescription ??
//                             ''),
//                     SizedBox(height: 10),
//                     keyValue('Start Date',
//                         detailsPollsModelData!.data!.record!.pollstartDate ??
//                             ''),
//                     SizedBox(height: 10),
//                     keyValue('End Date',
//                         detailsPollsModelData!.data!.record!.pollendDate ?? ''),
//                     SizedBox(height: 10),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               children: [
//                 showUploadedImages(
//                     detailsPollsModelData!.data!.record!.pollUploadpic ?? []),
//               ],
//             ),
//
//           ),
//         ],
//       ),
//     );
//   }
//
//
//   Widget showUploadedImages(List<dynamic> imageList) {
//     imageList.removeWhere((element) => (element.urlpath ?? '').isEmpty);
//
//     // Get the current date
//     DateTime now = DateTime.now();
//
//     // Parse the end date from the poll data
//     String pollEndDate = detailsPollsModelData?.data?.record?.pollendDate ?? '';
//     DateTime endDate;
//
//     try {
//       endDate = DateFormat("dd MMM yyyy").parse(pollEndDate); // Correct format
//     } catch (e) {
//       print("Error parsing date: $e");
//       endDate = DateTime.now(); // Default value if parsing fails
//     }
//
//
//     // Check if the current date is after the end date
//     bool isPollEnded = now.isAfter(endDate);
//
//     return imageList.isEmpty
//         ? const Text(
//       'No Images Uploaded.',
//       style: TextStyle(),
//     )
//         : Container(
//       padding: const EdgeInsets.all(10.0),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade200,
//         borderRadius: BorderRadius.circular(5),
//       ),
//       child: GridView.builder(
//         itemCount: imageList.length,
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 3,
//         ),
//         itemBuilder: (context, index) {
//           String imageUrl = imageList[index].urlpath ?? '';
//           bool isImageLiked = selectedLikeIndex == index;
//
//           return Column(
//             children: [
//               // Image with grey overlay if poll is ended
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Stack(
//                     children: [
//                       GestureDetector(
//                         onTap: isPollEnded
//                             ? null // Disable tap if poll is ended
//                             : () => _openFullImageDialog(imageUrl),
//                         child: Image.network(
//                           imageUrl,
//                           fit: BoxFit.cover,
//                           loadingBuilder: (context, child, loadingProgress) {
//                             if (loadingProgress == null) return child;
//                             return Center(
//                               child: CircularProgressIndicator(
//                                 value: loadingProgress.expectedTotalBytes != null
//                                     ? loadingProgress.cumulativeBytesLoaded /
//                                     (loadingProgress.expectedTotalBytes ?? 1)
//                                     : null,
//                               ),
//                             );
//                           },
//                           errorBuilder: (context, error, stackTrace) =>
//                           const Icon(Icons.error),
//                         ),
//                       ),
//                       if (isPollEnded)
//                         Container(
//                           color: Colors.black.withOpacity(0.5),
//                           child: Center(
//                             child: Text(
//                               'Poll Is Ended',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//               // Like Button (disabled if poll is ended)
//               IconButton(
//                 onPressed: isPollEnded
//                     ? null // Disable like button if poll is ended
//                     : () {
//                   setState(() {
//                     if (selectedLikeIndex == index) {
//                       selectedLikeIndex = null; // Unlike if already liked
//                     } else {
//                       selectedLikeIndex = index; // Like new image
//                     }
//                   });
//                 },
//                 icon: Icon(
//                   isImageLiked ? Icons.thumb_up : Icons.thumb_up_off_alt,
//                   color: isImageLiked ? Colors.blue : Colors.grey,
//                   size: 25,
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//
//   void _openFullImageDialog(String imageUrl) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return Dialog(
//           clipBehavior: Clip.antiAliasWithSaveLayer,
//           shadowColor: Colors.blueAccent,
//           shape: ContinuousRectangleBorder(
//             borderRadius: BorderRadius.circular(40.0),
//           ),
//           backgroundColor: Colors.white,
//           child: Stack(
//             children: [
//               InteractiveViewer(
//                 child:
//                 Image.network(imageUrl), // Display the image directly
//               ),
//               Positioned(
//                 top: 20.0,
//                 right: 20.0,
//                 child: GestureDetector(
//                   onTap: () {
//                     Navigator.of(context).pop(); // Close the dialog
//                   },
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.black.withOpacity(0.5),
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: Icon(
//                         Icons.close,
//                         color: Colors.white,
//                         size: 24,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
//
class _PollsDetailsState extends State<PollsDetails> {
  DetailsPollsModel? detailsPollsModelData;
  int likeCount = 0;
  bool isLoading = true;
  bool isLiked = false;
  int? selectedLikeIndex;

  @override
  void initState() {
    super.initState();
    fetchPollData();
  }

  Future<void> fetchPollData() async {
    setState(() => isLoading = true);
    try {
      final pollDetails = await dioServiceClient.pollDetails(
          recordId: widget.recordId);
      if (pollDetails != null) {
        setState(() {
          detailsPollsModelData = pollDetails;
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $error')),
      );
    }
  }


  // Future<void> countLike(int index) async {
  //   if (selectedLikeIndex != index) { // Ensuring it toggles for a new selection
  //     try {
  //       final response = await dioServiceClient.pollsLike(pollId: widget.pollId);
  //       if (response != null) {
  //         setState(() {
  //           if (selectedLikeIndex != null) {
  //             likeCount--; // Decrease count if switching selection
  //           }
  //           likeCount++;
  //           isLiked = true;
  //           selectedLikeIndex = index;
  //         });
  //       } else {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('Failed to like the poll')),
  //         );
  //       }
  //     } catch (error) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Error: $error')),
  //       );
  //     }
  //   }
  // }


  Future<void>countLike(int index) async {
    if (!isLiked || selectedLikeIndex != index) {
      try {
        final response = await dioServiceClient.pollsLike(pollId: widget.pollId);
        if (response != null) {
          setState(() {
            if (selectedLikeIndex != null) {
              likeCount--; // Decrease count if another image was previously liked
            }
            likeCount++;
            isLiked = true;
            selectedLikeIndex = index;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to like the poll')),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Polls Details'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              if (value == 'Edit Polls') {
                Get.to(() =>
                    PollsEditCreation(
                      pollId: widget.recordId,
                      pollsData: detailsPollsModelData,
                    ));
              }
            },
            itemBuilder: (BuildContext context) =>
            [
              const PopupMenuItem(
                value: 'Edit Polls',
                child: Text('Edit Polls'),
              ),
            ],
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : detailsPollsModelData == null
          ? const Center(child: Text('No data available.'))
          : Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Total Polls ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              SizedBox(width: 20),
              Text(': $likeCount',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),)
            ],
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    keyValue(key:'Poll No',
                        value:detailsPollsModelData!.data!.record!.pollNo ?? ''),
                    SizedBox(height: 10),
                    keyValue(key:'Poll Type',
                        value:detailsPollsModelData!.data!.record!.pollType ?? ''),
                    SizedBox(height: 10),
                    keyValue(key:'Poll Topic',
                        value:detailsPollsModelData!.data!.record!.pollTopic ?? ''),
                    SizedBox(height: 10),
                    keyValue(key:'Description',
                        value:detailsPollsModelData!.data!.record!.pollDescription ??
                            ''),
                    SizedBox(height: 10),
                    keyValue(key:'Start Date',
                        value: detailsPollsModelData!.data!.record!.pollstartDate ??
                            ''),
                    SizedBox(height: 10),
                    keyValue(key:'End Date',
                        value: detailsPollsModelData!.data!.record!.pollendDate ?? ''),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                showUploadedImages(
                    detailsPollsModelData!.data!.record!.pollUploadpic ?? []),
              ],
            ),

          ),
        ],
      ),
    );
  }

  Widget showUploadedImages(List<dynamic> imageList) {
    imageList.removeWhere((element) => (element.urlpath ?? '').isEmpty);

    // Get the current date
    DateTime now = DateTime.now();

    // Parse the end date from the poll data
    String pollEndDate = detailsPollsModelData?.data?.record?.pollendDate ?? '';
    DateTime endDate;

    try {
      endDate = DateFormat("dd MMM yyyy").parse(pollEndDate); // Correct format
    } catch (e) {
      print("Error parsing date: $e");
      endDate = DateTime.now(); // Default value if parsing fails
    }

    // Check if the current date is after the end date
    bool isPollEnded = now.isAfter(endDate);

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
      child: GridView.builder(
        itemCount: imageList.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: (context, index) {
          String imageUrl = imageList[index].urlpath ?? '';
          bool isImageLiked = selectedLikeIndex == index;

          return Column(
            children: [
              // Image with grey overlay if poll is ended
              Expanded(
                child: SingleChildScrollView(
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: isPollEnded
                            ? null // Disable tap if poll is ended
                            : () => _openFullImageDialog(imageUrl),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error),
                        ),
                      ),
                      if (isPollEnded)
                        Container(
                          color: Colors.black.withOpacity(0.8),
                          child: Center(
                            child: Text(
                              'Poll Is Ended',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              // Like Button (disabled if poll is ended)
              IconButton(
                onPressed: isPollEnded
                    ? null // Disable like button if poll is ended
                    : () {
                  countLike(index); // Call handleLike with the index
                },
                icon: Icon(
                  isImageLiked ? Icons.thumb_up : Icons.thumb_up_off_alt,
                  color: isImageLiked ? Colors.blue : Colors.grey,
                  size: 25,
                ),
              ),
            ],
          );
        },
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
              InteractiveViewer(
                child:
                Image.network(imageUrl), // Display the image directly
              ),
              Positioned(
                top: 50.0,
                right: 20.0,
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
}