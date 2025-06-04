import 'package:auto_size_text/auto_size_text.dart';
import 'package:biz_infra/Model/employee_registration/employee_registration_details_modal.dart';
import 'package:biz_infra/Network/dio_service_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EmployeeRegistrationDetails extends StatefulWidget {
  const EmployeeRegistrationDetails({super.key, required this.entryId});

  final String entryId;

  @override
  State<EmployeeRegistrationDetails> createState() =>
      _EmployeeRegistrationDetailsState();
}

class _EmployeeRegistrationDetailsState
    extends State<EmployeeRegistrationDetails> {
  //final DioServiceClient _dioClient = DioServiceClient();

  Future<EmployeeRegistrationDetailsModal?>? noticeFuture;

  @override
  void initState() {
    super.initState();
    noticeFuture = _fetchDetails();
  }

  Future<EmployeeRegistrationDetailsModal?> _fetchDetails() async {
    try {
      return await dioServiceClient.getEmployeeRegistrationDetails(
          recordId: widget.entryId);
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Employee Registration Details'),
      ),
      body: FutureBuilder<EmployeeRegistrationDetailsModal?>(
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

              return Card(
                elevation: 5,
                margin: const EdgeInsets.all(14.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ticketIdValue(
                      'Employee ID',
                      record.badgeNo ?? '',
                      (record.empImagefile == null || record.empImagefile!.isEmpty)
                          ? ''
                          : record.empImagefile?[0].urlpath ?? '',
                    ),
                    const Divider(
                      thickness: 2.0,
                      color: Colors.grey,
                    ),
                    keyValues(
                      'Employee Name',
                      record.serviceEngineerName ?? '',
                    ),
                    keyValues('Mobile Number', record.phone ?? ''),
                    keyValues('Email ID',
                        record.email!.isEmpty ? 'N/A' : record.email!),
                    keyValues('Aadhar Number', record.aadharNo ?? ''),
                    keyValues('Role', record.subServiceManagerRole ?? ''),
                    keyValues('Society', record.empSociety ?? ''),
                    keyValues('Block', record.empBlock ?? ''),
                    buildCenterText('Shift Timing'),
                    keyValues(
                        'Start Time',
                        record.empStarttime!.isEmpty
                            ? 'N.A'
                            : record.empStarttime!),
                    keyValues(
                        'End Time',
                        record.empEndtime!.isEmpty
                            ? 'N.A'
                            : record.empEndtime!),
                    keyValues(
                        'Week Off',
                        record.empWeakoff!.isEmpty
                            ? 'N.A'
                            : record.empWeakoff!),
                    buildCenterText('Uploaded Aadhar'),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: showUploadedImages(
                        record.empAdharpic ?? [],
                      ),
                    )
                  ],
                ),
              );
            } else {
              return const Center(
                child: Text(
                  'No data available.',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
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

  Widget ticketIdValue(String key, String value, String imageUrl) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
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
            flex: 2,
            child: AutoSizeText(
              value,
              minFontSize: 12.0,
              style: const TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 214, 85, 76),
              ),
              textAlign: TextAlign.left,
            ),
          ),
          imageUrl.isEmpty
              ? const SizedBox(height: 0)
              : Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: GestureDetector(
                    onTap: () {
                      _openFullImageDialog(imageUrl);
                    },
                    // child: CircleAvatar(
                    //   radius: 20,
                    //   child: Image.network(
                    //     imageUrl,
                    //     loadingBuilder: (context, child, loadingProgress) {
                    //       if (loadingProgress == null) return child;
                    //       return const Center(
                    //         child: SizedBox(
                    //           height: 15,
                    //           width: 15,
                    //           child: CircularProgressIndicator(
                    //             strokeWidth: 1.5,
                    //           ),
                    //         ),
                    //       );
                    //     },
                    //     errorBuilder: (context, error, stackTrace) {
                    //       return const Icon(
                    //         Icons.error,
                    //         color: Colors.red,
                    //       );
                    //     },
                    //     fit: BoxFit.fill,
                    //   ),
                    // ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: NetworkImage(imageUrl),
                          onBackgroundImageError: (error, stackTrace) {
                            if (kDebugMode) {
                              print("Image loading error: $error");
                            }
                          },
                          child: imageUrl.isEmpty
                              ? const Icon(
                                  Icons.error,
                                  color: Colors.red,
                                )
                              : null,
                        ),
                        // CircularProgressIndicator
                        FutureBuilder(
                          future:
                              precacheImage(NetworkImage(imageUrl), context),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.5,
                                ),
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
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

  Widget buildCenterText(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text.toUpperCase(),
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget showUploadedImages(List<dynamic> imageList) {
    imageList.removeWhere((element) => (element.urlpath ?? '').isEmpty);

    return imageList.isEmpty
        ? const Text(
            'No Images Uploaded.',
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
}
