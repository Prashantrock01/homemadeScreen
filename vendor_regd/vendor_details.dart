import 'package:biz_infra/CustomWidgets/CustomLoaders/custom_loader.dart';
import 'package:biz_infra/Network/dio_service_client.dart';
import 'package:biz_infra/Screens/vendor_regd/vendor_registration.dart';
import 'package:flutter/material.dart';
import 'package:biz_infra/Screens/vendor_regd/vendors_listing.dart'
    show InfoKeyValue;
import 'package:get/route_manager.dart';

class VendorDetails extends StatefulWidget {
  const VendorDetails({super.key, required this.vendorId});

  final String vendorId;

  @override
  State<VendorDetails> createState() => _VendorDetailsState();
}

class _VendorDetailsState extends State<VendorDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: _openDetailsInEditMode,
            child: const Text('Edit'),
          ),
        ],
        title: const Text('Vendor Details'),
      ),
      body: FutureBuilder(
          future: dioServiceClient.getVendorsDetails(vendorId: widget.vendorId),
          builder: (context, snapshot) {
            late Widget child;
            if (snapshot.connectionState == ConnectionState.waiting) {
              child = const Center(
                child: CustomLoader(),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                debugPrint(snapshot.error.toString());
                child = const Center(child: Text('Something went wrong'));
              } else if (snapshot.hasData) {
                final asyncData = snapshot.data;

                if (asyncData != null) {
                  final data = asyncData.data;
                  if (data != null) {
                    final record = data.record;
                    if (record != null) {
                      child = Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: double.maxFinite,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Vendor',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        InfoKeyValue(
                                          infoKey: 'Vendor Name',
                                          infoValue:
                                              record.vendorname.toString(),
                                        ),
                                        InfoKeyValue(
                                          infoKey: 'Vendor No.',
                                          infoValue: record.vendorNo.toString(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Divider(color: Colors.grey),
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Other Information',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        InfoKeyValue(
                                          infoKey: 'Mobile Number',
                                          infoValue: record.phone.toString(),
                                        ),
                                        InfoKeyValue(
                                          infoKey: 'Email Id',
                                          infoValue: record.email.toString(),
                                        ),
                                        InfoKeyValue(
                                          infoKey: 'Pincode',
                                          infoValue:
                                              record.postalcode.toString(),
                                        ),
                                        InfoKeyValue(
                                          infoKey: 'City',
                                          infoValue: record.city.toString(),
                                        ),
                                        InfoKeyValue(
                                          infoKey: 'District',
                                          infoValue: record.district.toString(),
                                        ),
                                        InfoKeyValue(
                                          infoKey: 'State',
                                          infoValue: record.state.toString(),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  'Address',
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  record.address.toString(),
                                                  style: const TextStyle(
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  'Type Of Services',
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  record.typeOfServices
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Divider(color: Colors.grey),
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'IDs & Attachment(s)',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        InfoKeyValue(
                                          infoKey: 'Id Proof',
                                          infoValue: record.idproof.toString(),
                                        ),
                                        SizedBox(
                                          width: double.maxFinite,
                                          child: Visibility(
                                            visible: record
                                                .uploadidproof!.isNotEmpty,
                                            replacement: const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                'No Attachment(s)',
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                            ),
                                            child: GridView.count(
                                              crossAxisCount: 3,
                                              crossAxisSpacing: 8.0,
                                              mainAxisSpacing: 8.0,
                                              shrinkWrap: true,
                                              children: record.uploadidproof!
                                                  .map((element) {
                                                return GestureDetector(
                                                  onTap: () async {
                                                    await _previewImage(
                                                        element.urlpath!);
                                                  },
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: Image.network(
                                                      element.urlpath!,
                                                      fit: BoxFit.cover,
                                                      loadingBuilder: (context,
                                                          child,
                                                          loadingProgress) {
                                                        if (loadingProgress ==
                                                            null) {
                                                          return child;
                                                        }
                                                        int? totalbytes =
                                                            loadingProgress
                                                                .expectedTotalBytes;
                                                        int bytesLoaded =
                                                            loadingProgress
                                                                .cumulativeBytesLoaded;
                                                        return Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            value: totalbytes !=
                                                                    null
                                                                ? bytesLoaded /
                                                                    totalbytes
                                                                : null,
                                                          ),
                                                        );
                                                      },
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        return const Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .broken_image_outlined,
                                                              color: Colors.red,
                                                              size: 25.0,
                                                            ),
                                                            Text('No Preview')
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  }
                }
              }
            }
            return child;
          }),
    );
  }

  void _openDetailsInEditMode() {
    Get.off(
      () => VendorRegistration(
        updateMode: true,
        recordId: widget.vendorId,
      ),
      popGesture: true,
      transition: Transition.rightToLeft,
    );
  }

  Future<void> _previewImage(String imgUrl) async {
    if (!mounted) return;

    return await showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog.fullscreen(
          child: InteractiveViewer(
            child: Image.network(imgUrl),
          ),
        );
      },
    );
  }
}
