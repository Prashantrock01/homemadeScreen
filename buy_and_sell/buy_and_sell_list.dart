import 'package:auto_size_text/auto_size_text.dart';
import 'package:biz_infra/CustomWidgets/CustomLoaders/custom_loader.dart';
import 'package:biz_infra/Model/buy_and_sell/buy_and_sell_listing_modal.dart';
import 'package:biz_infra/Network/dio_service_client.dart';
import 'package:biz_infra/Screens/buy_and_sell/buy_and_sell_details.dart';
import 'package:biz_infra/Screens/buy_and_sell/listing_category_creation/buy_and_sell_creation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyAndSellList extends StatefulWidget {
  const BuyAndSellList({super.key});

  @override
  State<BuyAndSellList> createState() => _BuyAndSellListState();
}

class _BuyAndSellListState extends State<BuyAndSellList> {
  final ValueNotifier<List<Records>> recordsNotifier =
      ValueNotifier<List<Records>>([]);
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<bool> hasMoreRecords = ValueNotifier<bool>(true);
  final ValueNotifier<bool> isSearching = ValueNotifier<bool>(false);
  final ValueNotifier<List<Records>> filteredRecordsNotifier =
      ValueNotifier<List<Records>>([]);

  int currentPage = 1;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchBuyAndSellRecords();

    // Add a listener to the scroll controller to detect when user reaches the bottom
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !isLoading.value) {
        fetchBuyAndSellRecords();
      }
    });

    // Listen to helpDeskTicketStatus and trigger refreshHandler
    helpDeskTicketStatus.listen((data) {
      refreshHandler();
    });
  }

  RxString helpDeskTicketStatus = "".obs;

  List<String> ticketStatusList = [
    'All',
    'Properties',
    'Car & Bike',
    'Electronics and Appliances',
    'Furniture',
    'Items for Sale'
  ];

  Future<void> refreshHandler() async {
    currentPage = 1;
    recordsNotifier.value = [];
    hasMoreRecords.value = true;
    await fetchBuyAndSellRecords();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchBuyAndSellRecords() async {
    if (isLoading.value || !hasMoreRecords.value) return;

    final buyAndSellType = helpDeskTicketStatus.isEmpty
        ? "All"
        : helpDeskTicketStatus.value == "Properties"
            ? "Properties"
            : helpDeskTicketStatus.value == "Car & Bike"
                ? "Car & Bike"
                : helpDeskTicketStatus.value == "Electronics and Appliances"
                    ? "Electronics and Appliances"
                    : helpDeskTicketStatus.value == "Furniture"
                        ? "Furniture"
                        : helpDeskTicketStatus.value == "Items for Sale"
                            ? "Items for Sale"
                            : "All";

    // Build the filter only if buyAndSellType is not "All"
    final filter = buyAndSellType == "All"
        ? ""
        : helpDeskTicketStatus.isEmpty
            ? "[[\"buysell_category\",\"e\",\"$buyAndSellType\"]]"
            : "[[\"buysell_category\",\"e\",\"$buyAndSellType\"],[\"ticketstatus\",\"e\",\"${helpDeskTicketStatus.value}\"]]";

    try {
      isLoading.value = true;

      final BuyAndSellListingModal? result =
          await dioServiceClient.getBuyAndSellList(page: currentPage, filter: filter);

      if (result != null && result.data != null) {
        final newRecords = result.data!.records ?? [];

        if (newRecords.isNotEmpty) {
          recordsNotifier.value = [...recordsNotifier.value, ...newRecords];
          currentPage++;
        }

        hasMoreRecords.value = result.data!.moreRecords ?? false;
      } else {
        hasMoreRecords.value = false;
      }
    } catch (e) {
      debugPrint('Error fetching records: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _onRefresh() async {
    // Reset to the initial state before fetching new data
    currentPage = 1;
    recordsNotifier.value = [];
    hasMoreRecords.value = true;
    await fetchBuyAndSellRecords();
  }

  void clearSearch() {
    searchController.clear();
    isSearching.value = false;
    filteredRecordsNotifier.value = List.from(recordsNotifier.value);
  }

  void filterRecords(String query) {
    final lowerCaseQuery = query.toLowerCase();
    filteredRecordsNotifier.value = recordsNotifier.value.where((record) {
      return (record.buysellTitle != null &&
              record.buysellTitle!.toLowerCase().contains(lowerCaseQuery)) ||
          (record.buysellPurchasePrice != null &&
              record.buysellPurchasePrice!
                  .toLowerCase()
                  .contains(lowerCaseQuery));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder<bool>(
          valueListenable: isSearching,
          builder: (context, searching, child) {
            return searching
                ? Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            decoration: const InputDecoration(
                              hintText: 'Search by title',
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.black54),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 12.0),
                            ),
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 16.0),
                            onChanged: (query) {
                              if (query.isNotEmpty) {
                                filterRecords(query);
                              } else {
                                clearSearch();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                : const Text('Buy and Sell');
          },
        ),
        actions: [
          ValueListenableBuilder(
            valueListenable: isSearching,
            builder: (context, isSearch, _) {
              return IconButton(
                icon: Icon(isSearch ? Icons.clear : Icons.search),
                onPressed: () {
                  setState(() {
                    isSearch
                        ? clearSearch()
                        : isSearching.value =
                            true; // Clear search or enable search mode
                  });
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: statusFilterDialog,
          ),
        ],
      ),
      body: Stack(children: [
        Column(
          children: [
            Expanded(
              child: ValueListenableBuilder<List<Records>>(
                valueListenable: isSearching.value
                    ? filteredRecordsNotifier
                    : recordsNotifier,
                builder: (context, record, child) {
                  return RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: GridView.builder(
                      controller:
                          _scrollController, // Attach the scroll controller
                      padding: const EdgeInsets.all(6.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                        childAspectRatio: 0.92,
                      ),
                      itemCount:
                          record.length, // Add an extra item for the loader
                      itemBuilder: (context, index) {
                        double screenWidth = MediaQuery.of(context).size.width;
                        double imageHeight = screenWidth * 0.30;
                        double imageWidth = screenWidth * 0.45;

                        final buyItem = record[index];

                        return InkWell(
                          onTap: () {
                            Get.to(
                              () => BuyAndSellDetails(
                                entryId: buyItem.id!,
                                sold: buyItem.buysellissold!,
                                userId: buyItem.smownerid!,
                              ),
                              transition: Transition.rightToLeft,
                              popGesture: true,
                            );
                          },
                          child: Stack(children: [
                            Container(
                              width: screenWidth * 0.5,
                              margin: const EdgeInsets.all(10.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.network(
                                      buyItem.docUrl ?? '',
                                      width: imageWidth,
                                      height: imageHeight,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                          'assets/buy_and_sell/placeholder.png',
                                          width: imageWidth,
                                          height: imageHeight,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Container(
                                          width: imageWidth,
                                          height: imageHeight,
                                          color: Colors.grey[300],
                                          child: const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      },
                                    ),
                                    Container(
                                      color: const Color.fromARGB(
                                              255, 138, 135, 135)
                                          .withOpacity(0.5),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      width: double.infinity,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            '₹${double.tryParse(buyItem.buysellPurchasePrice?.toString() ?? '0')?.truncate() ?? 0}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                          Text(
                                            buyItem.buysellTitle ?? '',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (buyItem.buysellissold ==
                                '1') // Show badge only when not '0'
                              const Positioned(
                                top: 5,
                                right: 5,
                                child: Badge(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  backgroundColor: Colors.red,
                                  label: Text(
                                    'SOLD',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  largeSize: 10,
                                ),
                              ),
                          ]),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        ValueListenableBuilder<bool>(
          valueListenable: isLoading,
          builder: (context, loading, child) {
            return loading && recordsNotifier.value.isEmpty
                ? const Center(
                    child: CustomLoader(),
                  )
                : const SizedBox.shrink();
          },
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        backgroundColor: Colors.green,
        elevation: 5,
        onPressed: () {
          Get.to(
            () => const BuyAndSellCreation(),
            transition: Transition.rightToLeft,
            popGesture: true,
          );
        },
        child: const Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
      ),
      // bottomNavigationBar: Container(
      //   decoration: const BoxDecoration(
      //     border: Border(
      //       top: BorderSide(color: Colors.grey, width: 2),
      //     ),
      //   ),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       Padding(
      //         padding: const EdgeInsets.all(2.0),
      //         child: ElevatedButton.icon(
      //           style: ElevatedButton.styleFrom(
      //             side: const BorderSide(
      //               color: Colors.grey,
      //               width: 0.5,
      //             ),
      //           ),
      //           onPressed: () {
      //             showSortModal(context);
      //           },
      //           label: const Text(
      //             'Sort By',
      //           ),
      //           icon: const Icon(
      //             Icons.sort,
      //           ),
      //           iconAlignment: IconAlignment.end,
      //         ),
      //       ),
      //       const SizedBox(width: 10),
      //       const Icon(
      //         Icons.vertical_distribute_outlined,
      //       ),
      //       const SizedBox(width: 10),
      //       Padding(
      //         padding: const EdgeInsets.all(2.0),
      //         child: ElevatedButton.icon(
      //           style: ElevatedButton.styleFrom(
      //             side: const BorderSide(
      //               width: 0.5,
      //             ),
      //           ),
      //           onPressed: statusFilterDialog,
      //           label: const Text(
      //             'Filter',
      //           ),
      //           icon: const Icon(
      //             Icons.filter_alt_rounded,
      //           ),
      //           iconAlignment: IconAlignment.end,
      //         ),
      //       )
      //     ],
      //   ),
      // ),
    );
  }

  statusFilterDialog() {
    int selectedValueIndex = ticketStatusList.indexOf(
        helpDeskTicketStatus.value == '' ? 'All' : helpDeskTicketStatus.value);
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
          contentPadding: const EdgeInsets.only(top: 10.0),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Center(
                          child: AutoSizeText(
                            "Notice Type",
                            style: TextStyle(
                              fontFamily: 'Sfpro',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    const Divider(
                      color: Colors.grey,
                      height: 4.0,
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.4,
                      ),
                      child: Scrollbar(
                        thumbVisibility: true,
                        child: ListView.builder(
                          itemCount: ticketStatusList.length,
                          itemBuilder: (context, index) {
                            return RadioListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 5.0,
                              ),
                              title: AutoSizeText(
                                ticketStatusList[index],
                                style: const TextStyle(
                                  fontFamily: 'Sfpro',
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              value: index,
                              groupValue: selectedValueIndex,
                              onChanged: (value) {
                                setState(() {
                                  selectedValueIndex = index;
                                  //filter = ticketStatusList[index];
                                });

                                helpDeskTicketStatus.value =
                                    ticketStatusList[index] == "All"
                                        ? ""
                                        : ticketStatusList[index];

                                // onChanged(index);
                                Navigator.pop(context);
                                //onChanged(index); // Call the callback to update the parent state
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    // Align(
                    //   alignment: AlignmentDirectional.bottomEnd,
                    //   child: Container(
                    //     padding: const EdgeInsets.all(15),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.end,
                    //       children: [
                    //         SizedBox(
                    //           width: 100,
                    //           height: 40,
                    //           child: ElevatedButton(
                    //             onPressed: () {
                    //               Navigator.of(context).pop();
                    //             },
                    //             style: ButtonStyle(
                    //               shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    //                 RoundedRectangleBorder(
                    //                   borderRadius: BorderRadius.circular(10.0),
                    //                 ),
                    //               ),
                    //             ),
                    //             child: const AutoSizeText(
                    //               'OK',
                    //               style: TextStyle(fontSize: 14.0),
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void showSortModal(BuildContext context) {
    final List<Map<String, dynamic>> options = [
      {'label': 'Price : Low to High', 'value': 0},
      {'label': 'Price : High to Low', 'value': 1},
      {'label': 'Newest First', 'value': 2},
      {'label': 'Sort by distance', 'value': 3},
    ];

    int? selectedValue; // To track the selected radio button

    showModalBottomSheet<void>(
      sheetAnimationStyle: AnimationStyle(
        curve: Curves.easeInToLinear,
        duration: const Duration(milliseconds: 800),
      ),
      showDragHandle: true,
      enableDrag: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SizedBox(
              height: 340,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Sort By',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const Divider(thickness: 2.0),
                    Expanded(
                      child: ListView.builder(
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  options[index]['label'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                Radio<int>(
                                  value: options[index]['value'],
                                  groupValue: selectedValue,
                                  onChanged: (int? value) {
                                    setState(() {
                                      selectedValue = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: ElevatedButton(
                            onPressed: () {
                              final selectedOption = options.firstWhere(
                                (opt) => opt['value'] == selectedValue,
                                orElse: () => {'label': 'None', 'value': null},
                              );
                              print(
                                  'Selected Option: ${selectedOption['label']}');
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              side: const BorderSide(
                                color: Colors.grey,
                                width: 0.5,
                              ),
                            ),
                            child: const Text(
                              'Apply',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              side: const BorderSide(
                                color: Colors.grey,
                                width: 0.5,
                              ),
                            ),
                            child: const Text('Clear'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  final ScrollController _categoryScroll = ScrollController();

  void showFilterModal(BuildContext context) {
    final List<Map<String, dynamic>> options = [
      {'label': 'Properties', 'value': 0},
      {'label': 'Cars & Bikes', 'value': 1},
      {'label': 'Electronics & Appliances', 'value': 2},
      {'label': 'Furniture', 'value': 3},
      {'label': 'Items for sale', 'value': 4},
      {'label': 'Parking Space', 'value': 5},
    ];

    int? selectedValue; // To track the selected radio button

    showModalBottomSheet<void>(
      sheetAnimationStyle: AnimationStyle(
        curve: Curves.easeInToLinear,
        duration: const Duration(milliseconds: 800),
      ),
      showDragHandle: true,
      enableDrag: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SizedBox(
              height: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Select Category',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const Divider(thickness: 2.0),
                    Expanded(
                      child: Scrollbar(
                        controller: _categoryScroll,
                        thickness: 4.0,
                        thumbVisibility: true,
                        child: ListView.builder(
                          itemCount: options.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    options[index]['label'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  Radio<int>(
                                    value: options[index]['value'],
                                    groupValue: selectedValue,
                                    onChanged: (int? value) {
                                      setState(() {
                                        selectedValue = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
