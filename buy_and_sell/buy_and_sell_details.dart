import 'package:biz_infra/Model/buy_and_sell/buy_and_sell_details_modal.dart';
import 'package:biz_infra/Network/dio_service_client.dart';
import 'package:biz_infra/Screens/buy_and_sell/buy_and_sell_list.dart';
import 'package:biz_infra/Screens/buy_and_sell/chat_with_seller.dart';
import 'package:biz_infra/Screens/buy_and_sell/listing_category_creation/buy_and_sell_edit_creation.dart';
import 'package:biz_infra/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class BuyAndSellDetails extends StatefulWidget {
  const BuyAndSellDetails(
      {super.key, required this.entryId, required this.sold, required this.userId});

  final String entryId;
  final String sold;
  final String userId;

  @override
  State<BuyAndSellDetails> createState() => _BuyAndSellDetailsState();
}

class _BuyAndSellDetailsState extends State<BuyAndSellDetails> {
  BuyAndSellDetailsModal? buyAndSellDetailModelData;

  ScrollController similarItems = ScrollController();

  final ValueNotifier<bool> buyAndSellNotifier = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buy and Sell Details'),
        actions: [
          if (widget.sold != '1')
          if (widget.userId == Constants.userUniqueId)
            TextButton(
              onPressed: () {
                Get.to(
                  () => BuyAndSellEditCreation(
                    buyAndSellId: widget.entryId,
                    buyAndSellData: buyAndSellDetailModelData,
                  ),
                  transition: Transition.rightToLeft,
                  popGesture: true,
                );
              },
              child: const Text('Edit'),
            )
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future:
              dioServiceClient.getBuyAndSellDetails(recordId: widget.entryId),
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
                buyAndSellDetailModelData = snapshot.data!;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ImageSlideshow(
                      width: double.infinity,
                      height: 200,
                      initialPage: 0,
                      indicatorRadius: 4,
                      indicatorColor: Colors.green,
                      indicatorBackgroundColor: Colors.white,
                      autoPlayInterval: buyAndSellDetailModelData!
                                  .data!.record!.buysellUploadpic!.length >
                              1
                          ? 6000
                          : null,
                      isLoop: buyAndSellDetailModelData!
                              .data!.record!.buysellUploadpic!.length >
                          1,
                      children: buyAndSellDetailModelData!
                              .data!.record!.buysellUploadpic!.isNotEmpty
                          ? buyAndSellDetailModelData!
                              .data!.record!.buysellUploadpic!
                              .map((pic) {
                              return GestureDetector(
                                onTap: () => _openFullImageDialog(pic.urlpath!),
                                child: Image.network(
                                  pic.urlpath!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/buy_and_sell/placeholder.png', // Placeholder image path
                                      fit: BoxFit.cover,
                                    );
                                  },
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      color: Colors.grey[300],
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }).toList()
                          : [
                              Image.asset(
                                'assets/buy_and_sell/placeholder.png', // Default placeholder
                                fit: BoxFit.cover,
                              ),
                            ],
                      onPageChanged: (value) {
                        debugPrint('Page changed: $value');
                      },
                    ),
                    Card(
                      margin: const EdgeInsets.all(10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 4,
                      child: Column(
                        children: [
                          ListTile(
                            title: const Text(
                              'Item Details',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.share,
                              ),
                              onPressed: () {
                                Share.share(
                                  '',
                                  subject: 'Check out this sell!',
                                );
                              },
                            ),
                          ),
                          keyValues(
                            'List Category',
                            buyAndSellDetailModelData!
                                    .data!.record!.buysellCategory ??
                                '',
                          ),
                          keyValues(
                            'Title',
                            buyAndSellDetailModelData!
                                    .data!.record!.buysellTitle ??
                                '',
                          ),
                          keyValues(
                            'Specification',
                            buyAndSellDetailModelData!
                                    .data!.record!.buysellSpecification ??
                                '',
                          ),
                          keyValues(
                            'Purchase Year',
                            buyAndSellDetailModelData!
                                    .data!.record!.buysellYear ??
                                '',
                          ),
                          keyValues(
                            'Purchase Price',
                            (double.tryParse(buyAndSellDetailModelData!.data!
                                                .record!.buysellPurchasePrice
                                                ?.toString() ??
                                            '0')
                                        ?.truncate() ??
                                    0)
                                .toString(),
                          ),
                          keyValues(
                            'Type of Sell',
                            buyAndSellDetailModelData!
                                    .data!.record!.buysellSelltype ??
                                '',
                          ),
                          keyValues(
                            'Selling Price',
                            (buyAndSellDetailModelData!
                                        .data!.record!.buysellCost!.isEmpty ||
                                    buyAndSellDetailModelData!
                                            .data!.record!.buysellCost ==
                                        '0.00')
                                ? 'N/A'
                                : (double.tryParse(buyAndSellDetailModelData!
                                                .data!.record!.buysellCost!)
                                            ?.truncate() ??
                                        0)
                                    .toString(),
                          ),
                          keyValues(
                            'Negotiable',
                            buyAndSellDetailModelData!
                                        .data!.record!.buysellNegotiate ==
                                    '1'
                                ? 'Yes'
                                : 'No',
                          ),
                        ],
                      ),
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable: buyAndSellNotifier,
                      builder: (context, checkboxValue, _) {
                        return Card(
                          margin: const EdgeInsets.all(10.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 4,
                          child: CheckboxListTile(
                            checkboxShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            value: buyAndSellDetailModelData!
                                    .data!.record!.buysellissold ==
                                '1',
                            onChanged: (bool? value) async {
                              buyAndSellNotifier.value =
                                  value ?? false; // Update the ValueNotifier

                              try {
                                final res =
                                    await dioServiceClient.getBuyAndSellSold(
                                  buySellSold: buyAndSellNotifier.value ? 1 : 0,
                                  recordId: widget.entryId,
                                );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Successfully sold')),
                                );

                                if (res?.statuscode == 1) {
                                  Get.close(1); // Close the current page
                                  Get.off(() =>
                                      const BuyAndSellList()); // Navigate to the list page
                                } else {
                                  Get.snackbar(
                                    "Oops!",
                                    res?.statusMessage ??
                                        "Something went wrong",
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
                                  "Oops!! Failed to list item",
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
                            title: const Text('Item Sold'),
                          ),
                        );
                      },
                    ),
                    if (buyAndSellDetailModelData!
                            .data!.record!.buysellissold !=
                        '1')
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            minimumSize: const Size(225, 40),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                          ),
                          onPressed: () {
                            Get.to(
                              () => ChatWithSeller(entryId: widget.entryId),
                              transition: Transition.rightToLeft,
                              popGesture: true,
                            );
                          },
                          child: const Text(
                            'Chat with seller',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
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
      ),
    );
  }

  Widget keyValues(String key, String value) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        bottom: 2,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: AutoSizeText(
              key,
              minFontSize: 15.0,
              style: const TextStyle(
                fontSize: 15.0,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          const Expanded(
            child: AutoSizeText(
              ':',
              minFontSize: 15.0,
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: AutoSizeText(
              value,
              minFontSize: 15.0,
              style: const TextStyle(
                fontSize: 15.0,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
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

  Widget propertyCard({
    required String imageUrl,
    required String title,
    required String price,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Stack(
          children: [
            // Image container
            Container(
              width: 120,
              height: 170,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                    8), // Ensures the image respects the border radius
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/placeholder.png', // Path to your placeholder image
                      fit: BoxFit.cover,
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey[300], // Background color while loading
                      child: const Center(
                        child: CircularProgressIndicator(), // Loading indicator
                      ),
                    );
                  },
                ),
              ),
            ),
            // Text container
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(8),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text:
                            "$title\n", // Ensures title wraps on multiple lines
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                          overflow:
                              TextOverflow.ellipsis, // Truncate if necessary
                        ),
                      ),
                      TextSpan(
                        text: price,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            overflow: TextOverflow.visible),
                      ),
                    ],
                  ),
                  maxLines: 3,
                  overflow: TextOverflow
                      .ellipsis, // Ensure the entire container respects ellipsis
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
