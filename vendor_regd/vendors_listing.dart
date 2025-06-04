import 'package:biz_infra/CustomWidgets/CustomLoaders/custom_loader.dart';
import 'package:biz_infra/Model/vendors/vendors_listing_model.dart';
import 'package:biz_infra/Network/dio_service_client.dart';
import 'package:biz_infra/Screens/Profile/profile.dart';
import 'package:biz_infra/Screens/vendor_regd/vendor_details.dart';
import 'package:biz_infra/Screens/vendor_regd/vendor_registration.dart';
import 'package:biz_infra/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import 'InfraEmp/infra_emp_profile.dart';

class VendorsListing extends StatefulWidget {
  final bool? isInfraEmp;

  const VendorsListing({super.key, this.isInfraEmp = false});

  @override
  State<VendorsListing> createState() => _VendorsListingState();
}

class _VendorsListingState extends State<VendorsListing> {
  final _vendorsListingLogic = VendorsListingLogic();
  late int _currentPageNo;
  bool _searchMode = false;
  final _searchController = SearchController();

  @override
  void initState() {
    super.initState();
    _currentPageNo = _vendorsListingLogic.currentPageNo;
    _vendorsListingLogic.fetchAndInitializeData(_currentPageNo);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: !widget.isInfraEmp!,
        actions: [
          IconButton(
            icon: Icon(_searchMode ? Icons.close : Icons.search),
            onPressed: _onSearchToggle,
          ),
          PopupMenuButton<int>(
            icon: const Icon(Icons.pin_drop_outlined),
            onSelected: (value) {},
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 1,
                child: Text('1 KM'),
              ),
              const PopupMenuItem(
                value: 3,
                child: Text('3 KM'),
              ),
              const PopupMenuItem(
                value: 5,
                child: Text('5 KM'),
              ),
              const PopupMenuItem(
                value: 7,
                child: Text('7 KM'),
              ),
              const PopupMenuItem(
                value: 10,
                child: Text('10 KM'),
              ),
            ],
          ),
          if (widget.isInfraEmp!)
            Row(
              children: [
                SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    Get.to(() => const InfraEmpProfile());
                  },
                  child: Constants.userImage.isNotEmpty
                      ? CircleAvatar(
                          maxRadius: 16,
                          backgroundImage: NetworkImage(Constants.userImage),
                        )
                      : const Icon(Icons.account_circle, size: 26),
                ),
                SizedBox(width: 16),
              ],
            ),
        ],
        title: _searchMode
            ? TextField(
                controller: _searchController,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Search by Name/Mob No',
                ),
                onChanged: (value) {
                  String query = _searchController.text;
                  _vendorsListingLogic.searchRecords(query);
                },
              )
            : const Text('Vendors'),
      ),
      body: ListenableBuilder(
        listenable: _vendorsListingLogic,
        builder: (context, child) {
          return _vendorsListingLogic.isLoading
              ? const Center(child: CustomLoader())
              : Column(
                  children: [
                    Expanded(
                      child: _vendorsListingLogic.filteredRecords.isEmpty
                          ? const Center(
                              child: Text('No Vendors Found'),
                            )
                          : RefreshIndicator(
                              onRefresh: () async {
                                _currentPageNo = 1;
                                _vendorsListingLogic.refreshVendorsList();
                              },
                              child: NotificationListener(
                                onNotification: _onNotification,
                                child: ListView.builder(
                                  itemBuilder: (context, index) {
                                    final record = _vendorsListingLogic.filteredRecords.elementAt(index);

                                    return VendorDataCard(
                                      id: record.id.toString(),
                                      vendorId: record.vendorid.toString(),
                                      name: record.vendorname.toString(),
                                      mobileNo: record.phone.toString(),
                                      emailId: record.email.toString(),
                                      typeOfServices: record.typeOfServices.toString(),
                                    );
                                  },
                                  itemCount: _vendorsListingLogic.filteredRecords.length,
                                  padding: const EdgeInsets.all(10.0),
                                ),
                              ),
                            ),
                    ),
                    Visibility(
                      visible: _vendorsListingLogic.isLoadingMore,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.0,
                        ),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                  ],
                );
        },
      ),
      floatingActionButton: (Constants.userRole == Constants.marketing)
          ? FloatingActionButton(
              onPressed: () {
                Get.to(
                  () => const VendorRegistration(),
                  popGesture: true,
                  transition: Transition.rightToLeft,
                );
              },
              child: const Icon(Icons.person_add_alt),
            )
          : null,
    );
  }

  bool _onNotification(Notification notification) {
    if (notification is ScrollEndNotification && notification.metrics.extentAfter == 0 && _vendorsListingLogic.canScrollMore) {
      _currentPageNo++;
      _vendorsListingLogic.fetchAndInitializeData(_currentPageNo);
    }
    return false;
  }

  void _onSearchToggle() {
    if (_searchMode) {
      if (_searchController.text.isNotEmpty) {
        _searchController.clear();
        _vendorsListingLogic.refreshVendorsList();
      } else {
        _searchController.clear();
      }
      setState(() => _searchMode = false);
    } else {
      setState(() => _searchMode = true);
    }
  }
}

class VendorDataCard extends StatelessWidget {
  const VendorDataCard({
    super.key,
    required this.id,
    required this.vendorId,
    required this.name,
    required this.mobileNo,
    required this.emailId,
    required this.typeOfServices,
  });

  final String id;
  final String vendorId;
  final String name;
  final String mobileNo;
  final String emailId;
  final String typeOfServices;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: ValueKey(id),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: () {
          Get.to(
            () => VendorDetails(vendorId: id),
            popGesture: true,
            transition: Transition.rightToLeft,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              InfoHeader(
                id: vendorId,
                name: name,
              ),
              const Divider(color: Colors.grey),
              InfoKeyValue(
                infoKey: 'Mobile Number',
                infoValue: mobileNo,
              ),
              InfoKeyValue(
                infoKey: 'Email Id',
                infoValue: emailId,
              ),
              InfoKeyValue(
                infoKey: 'Type Of Services',
                infoValue: typeOfServices,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoHeader extends StatelessWidget {
  const InfoHeader({super.key, required this.id, required this.name});

  final String id;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            const Text(
              'Vendor Id',
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              id,
              style: const TextStyle(
                fontSize: 12.0,
              ),
            ),
          ],
        ),
        Column(
          children: [
            const Text(
              'Name',
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              name,
              style: const TextStyle(
                fontSize: 12.0,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class InfoKeyValue extends StatelessWidget {
  const InfoKeyValue({
    super.key,
    required this.infoKey,
    required this.infoValue,
  });

  final String infoKey;
  final String infoValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            infoKey,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            infoValue,
            style: const TextStyle(
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }
}

class VendorsListingLogic with ChangeNotifier {
  bool isLoading = true;
  bool isLoadingMore = false;
  bool hasMoreRecords = false;
  int currentPageNo = 1;
  List<Records> recordsList = [];
  bool canScrollMore = false;
  List<Records> filteredRecords = [];

  Future<void> fetchAndInitializeData(int pageNo) async {
    if (pageNo == 1) {
      isLoading = true;
      notifyListeners();
    }
    if (pageNo > 1) {
      isLoadingMore = true;
      notifyListeners();
    }
    try {
      final asyncData = await dioServiceClient.getVendorsListing(page: pageNo);
      var data = asyncData.data;
      if (data != null) {
        var moreRecords = data.moreRecords;
        var records = data.records;
        var recordsPerPage = data.recordsPerPage;
        if (records != null && records.isNotEmpty) {
          if (pageNo == 1) {
            recordsList = records;
            filteredRecords = records;
            notifyListeners();
          } else {
            recordsList.addAll(records);
            filteredRecords.addAll(records);
            notifyListeners();
          }
          if (moreRecords != null) {
            hasMoreRecords = moreRecords;
            notifyListeners();
            if (recordsPerPage != null) {
              canScrollMore = (records.length.toString() == recordsPerPage) && hasMoreRecords;
              notifyListeners();
            }
          }
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading = false;
      isLoadingMore = false;
      notifyListeners();
    }
  }

  void refreshVendorsList() {
    if (recordsList.isNotEmpty) {
      recordsList.clear();
      filteredRecords.clear();
      notifyListeners();
    }
    fetchAndInitializeData(currentPageNo);
  }

  void searchRecords(String query) {
    if (query.isEmpty) {
      filteredRecords = List.from(recordsList);
    } else {
      filteredRecords = List<Records>.from(recordsList).where((r) {
        return r.vendorname.toString().toLowerCase().contains(query.toLowerCase()) || r.phone.toString().contains(query);
      }).toList();
    }
    notifyListeners();
  }
}
