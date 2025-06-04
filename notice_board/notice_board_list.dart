import 'package:auto_size_text/auto_size_text.dart';
import 'package:biz_infra/CustomWidgets/CustomLoaders/custom_loader.dart';
import 'package:biz_infra/Model/notice_board/notice_board_listing_modal.dart';
import 'package:biz_infra/Network/dio_service_client.dart';
import 'package:biz_infra/Screens/notice_board/notice_board_creation.dart';
import 'package:biz_infra/Screens/notice_board/notice_board_details.dart';
import 'package:biz_infra/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoticeBoardList extends StatefulWidget {
  const NoticeBoardList({super.key});

  @override
  State<NoticeBoardList> createState() => _NoticeBoardListState();
}

class _NoticeBoardListState extends State<NoticeBoardList> {
  var userRole = Constants.userRole;

  // final DioServiceClient _dioClient = DioServiceClient();

  TextEditingController searchController = TextEditingController();

  Set<String> savedRecords = {};
  bool showOnlySaved = false;
  List<Records> records = [];
  bool isLoading = true;
  bool isLoadingMore = false;
  int currentPage = 1;
  bool hasMoreRecords = true;
  bool _isSearching = false;

  List<Records> allRecords = []; // Original complete list

  final ValueNotifier<bool> showOnlySavedNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _loadSavedRecords();
    _fetchNoticeList(currentPage);
    helpDeskTicketStatus.value = '';
    helpDeskTicketStatus.listen((data) {
      //print('Listening...');
      //print(data.toString());
      refreshHandler();
    });
  }

  Future<void> _loadSavedRecords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      savedRecords = (prefs.getStringList('savedRecords') ?? []).toSet();
    });
  }

  Future<void> _updateSavedRecords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('savedRecords', savedRecords.toList());
  }

  Future<void> _fetchNoticeList(int page) async {
    if (page == 1) setState(() => isLoading = true);
    if (page > 1) setState(() => isLoadingMore = true);

    // Determine the notice type
    final noticeType = helpDeskTicketStatus.isEmpty
        ? "All"
        : helpDeskTicketStatus.value == "Society"
            ? "Society"
            : helpDeskTicketStatus.value == "Commercial"
                ? "Commercial"
                : helpDeskTicketStatus.value == "Events"
                    ? "Events"
                    : "Emergency";

    // Build the filter only if noticeType is not "All"
    final filter = noticeType == "All"
        ? ""
        : helpDeskTicketStatus.isEmpty
            ? "[[\"notice_type\",\"e\",\"$noticeType\"]]"
            : "[[\"notice_type\",\"e\",\"$noticeType\"],[\"ticketstatus\",\"e\",\"${helpDeskTicketStatus.value}\"]]";

    try {
      // Call the API with or without the filter
      final data = await dioServiceClient.getNoticeList(
        page: page,
        filter: filter, // Pass null if no filter is needed
      );

      if (data != null && data.data != null) {
        setState(() {
          if (page == 1) {
            records = data.data!.records!;
            allRecords = List.from(records); // Store the full list
          } else {
            records.addAll(data.data!.records!);
            allRecords.addAll(data.data!.records!);
          }
          hasMoreRecords = data.data!.moreRecords!; // Check for more records
        });
      }
    } catch (e) {
      debugPrint('Error fetching notice list: $e');
    } finally {
      setState(() {
        isLoading = false;
        isLoadingMore = false;
      });
    }
  }

  void clearSearch() {
    searchController.clear();
    setState(() {
      _isSearching = false; // Exit search mode
      records = List.from(allRecords); // Reset to the full list
    });
  }

  void filterRecords(String query) {
    setState(() {
      records = allRecords
          .where((record) =>
              (record.noticeSub != null &&
                  record.noticeSub!
                      .toLowerCase()
                      .contains(query.toLowerCase())) ||
              (record.noticeDescription != null &&
                  record.noticeDescription!
                      .toLowerCase()
                      .contains(query.toLowerCase())) ||
              (record.createdtime != null &&
                  record.createdtime!
                      .toLowerCase()
                      .contains(query.toLowerCase())))
          .toList();
    });
  }

  RxString helpDeskTicketStatus = "".obs;

  List<String> ticketStatusList = [
    'All',
    'Society',
    'Events',
    'Commercial',
    'Emergency',
  ];

  refreshHandler() async {
    currentPage = 1;
    records.clear();
    await _fetchNoticeList(currentPage);
  }

  Future<void> _onRefresh() async {
    setState(() {
      isLoading = true;
      currentPage = 1;
      hasMoreRecords = true;
      records.clear();
    });
    await _fetchNoticeList(currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: _isSearching
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
                          // suffixIcon: IconButton(
                          //   icon: const Icon(Icons.clear, color: Colors.black),
                          //   onPressed: clearSearch,
                          // ),
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
            : const Text('Notice Board'),
        actions: [
          if (_isSearching)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  _isSearching = false;
                  searchController.clear();
                  records = List.from(allRecords); // Reset the list
                });
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                  if (!_isSearching) {
                    clearSearch();
                  }
                });
              },
            ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: statusFilterDialog,
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ValueListenableBuilder<bool>(
                  valueListenable: showOnlySavedNotifier,
                  builder: (context, showOnlySaved, _) {
                    return CategoryButton(
                      label: showOnlySaved ? "All Records" : "Saved",
                      icon: Icons.bookmark,
                      isSelected: !showOnlySaved,
                      count: !showOnlySaved ? savedRecords.length : null,
                      onTap: () {
                        showOnlySavedNotifier.value =
                            !showOnlySavedNotifier.value;

                        // Filter records based on the savedRecords when toggling
                        setState(() {
                          if (showOnlySavedNotifier.value) {
                            // Show only saved records
                            records = allRecords
                                .where((record) =>
                                    savedRecords.contains(record.id))
                                .toList();
                          } else {
                            // Show all records
                            records = List.from(allRecords);
                          }
                        });
                      },
                    );
                  },
                ),
                // CategoryButton(
                //   label: 'Notice Category',
                //   icon: Icons.arrow_drop_down,
                //   isSelected: showOnlySavedNotifier.value,
                //   onTap: openFilterDelegate,
                // ),
              ],
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CustomLoader())
                  : NotificationListener<ScrollNotification>(
                      onNotification: (scrollNotification) {
                        if (scrollNotification is ScrollEndNotification &&
                            scrollNotification.metrics.extentAfter == 0 &&
                            !isLoadingMore &&
                            hasMoreRecords) {
                          currentPage++;
                          _fetchNoticeList(currentPage);
                        }
                        return false;
                      },
                      child: _buildRecordsList(records),
                    ),
            ),
            if (isLoadingMore)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
      floatingActionButton: (Constants.userRole == 'Facility Manager' ||
              Constants.userRole == 'Treasury' ||
              Constants.userRole == 'Super Admin')
          ? FloatingActionButton(
              elevation: 5,
              onPressed: () {
                Get.to(
                  () => const NoticeBoardCreation(),
                  transition: Transition.rightToLeft,
                  popGesture: true,
                );
              },
              child: Image.asset(
                'assets/images/notice_board.png',
                height: 30,
              ),
            )
          : null,
    );
  }

  Widget _buildRecordsList(List<Records> records) {
    final filteredRecords = showOnlySavedNotifier.value
        ? records.where((record) => savedRecords.contains(record.id)).toList()
        : records;

    if (filteredRecords.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/notice.png', height: 100, width: 100),
          const SizedBox(height: 20),
          Text(
            showOnlySavedNotifier.value
                ? "No saved records"
                : "No records available",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[700],
            ),
          ),
        ],
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        itemCount: filteredRecords.length,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Card(
              elevation: 5,
              child: InkWell(
                onTap: () {
                  Get.to(
                    () => NoticeBoardDetails(
                      entryId: filteredRecords[index].id!,
                      noticeId: filteredRecords[index].noticeid!,
                    ),
                    transition: Transition.rightToLeft,
                    popGesture: true,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // if (filteredRecords[index].docUrl != null &&
                      //     filteredRecords[index].docUrl!.isNotEmpty) ...[
                      //   ClipRRect(
                      //     borderRadius: BorderRadius.circular(15),
                      //     child: Image.network(
                      //       filteredRecords[index].docUrl!,
                      //       fit: BoxFit.cover,
                      //       height: 200,
                      //       width: 400,
                      //       loadingBuilder: (BuildContext context, Widget child,
                      //           ImageChunkEvent? loadingProgress) {
                      //         if (loadingProgress == null) {
                      //           return child;
                      //         }
                      //         return Container(
                      //           height: 120,
                      //           width: 400,
                      //           color: Colors.grey[300], // Placeholder color
                      //           child: Center(
                      //             child: CircularProgressIndicator(
                      //               value: loadingProgress.expectedTotalBytes !=
                      //                       null
                      //                   ? loadingProgress.cumulativeBytesLoaded /
                      //                       (loadingProgress.expectedTotalBytes ??
                      //                           1)
                      //                   : null,
                      //             ),
                      //           ),
                      //         );
                      //       },
                      //       errorBuilder: (BuildContext context, Object error,
                      //           StackTrace? stackTrace) {
                      //         return Container();
                      //       },
                      //     ),
                      //   ),
                      // ],
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: AutoSizeText(
                              filteredRecords[index].noticeSub!,
                              softWrap: true,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                             /* IconButton(
                                icon: const Icon(
                                  Icons.share,
                                ),
                                onPressed: () {
                                  Share.share(
                                    '${filteredRecords[index].noticeType}\n\n${filteredRecords[index].noticeSub!}\n\n${filteredRecords[index].noticeDescription!}\n\n${filteredRecords[index].createdtime ?? ''}Read more: ${filteredRecords[index].noticeSub!}',
                                    subject: 'Check out this notice!',
                                  );
                                },
                              ),*/
                              IconButton(
                                icon: Icon(
                                  savedRecords
                                          .contains(filteredRecords[index].id)
                                      ? Icons.bookmark
                                      : Icons.bookmark_outline,
                                  // color: Colors.green,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (savedRecords
                                        .contains(filteredRecords[index].id)) {
                                      savedRecords
                                          .remove(filteredRecords[index].id);
                                    } else {
                                      savedRecords
                                          .add(filteredRecords[index].id!);
                                    }
                                    _updateSavedRecords();
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      AutoSizeText(filteredRecords[index].noticeDescription!),
                      ListTile(
                        minTileHeight: 5,
                        contentPadding: const EdgeInsets.all(1.0),
                        title: AutoSizeText(
                          filteredRecords[index].createdtime ?? '',
                          style: const TextStyle(
                            fontSize: 11.0, fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
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
}

class CategoryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final int? count;
  final VoidCallback onTap;

  const CategoryButton({
    super.key,
    required this.label,
    this.icon,
    required this.isSelected,
    this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(2.0),
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey,
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (icon != null) ...[
              Icon(icon, color: isSelected ? Colors.white : Colors.black),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (count != null) ...[
              const SizedBox(width: 5),
              CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 10,
                child: Text(
                  count.toString(),
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
