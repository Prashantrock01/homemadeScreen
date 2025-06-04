import 'package:auto_size_text/auto_size_text.dart';
import 'package:biz_infra/CustomWidgets/CustomLoaders/custom_loader.dart';
import 'package:biz_infra/Model/employee_registration/employee_registration_list_modal.dart';
import 'package:biz_infra/Network/dio_service_client.dart';
import 'package:biz_infra/Screens/registration/employee_registration/employee_registration.dart';
import 'package:biz_infra/Screens/registration/employee_registration/employee_registration_details.dart';
import 'package:biz_infra/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmployeeRegistrationList extends StatefulWidget {
  final bool showAppBar;

  const EmployeeRegistrationList({
    super.key,
    this.showAppBar = true,
  });

  @override
  State<EmployeeRegistrationList> createState() => _EmployeeRegistrationListState();
}

class _EmployeeRegistrationListState extends State<EmployeeRegistrationList> {
  //final DioServiceClient _dioClient = DioServiceClient();
  final ScrollController _scrollController = ScrollController();

  TextEditingController searchController = TextEditingController();

  List<Records> records = [];
  bool isLoading = true;
  bool isMoreLoading = false;
  int currentPage = 1;
  bool hasMoreRecords = true;
  bool _isSearching = false;

  List<Records> allRecords = []; // Original complete list

  @override
  void initState() {
    super.initState();
    _fetchEmployeeList(currentPage);
    _scrollController.addListener(_onScroll);
  }

  Future<void> _fetchEmployeeList(int page) async {
    try {
      final employeeList = await dioServiceClient.getEmployeeRegistrationList(page: page);
      if (employeeList != null && employeeList.data?.records != null) {
        setState(() {
          if (page == 1) {
            records = employeeList.data!.records!;
            allRecords = List.from(records);
          } else {
            records.addAll(employeeList.data!.records!);
            allRecords.addAll(employeeList.data!.records!);
          }
          isLoading = false;
          isMoreLoading = false;
          hasMoreRecords = employeeList.data!.moreRecords ?? false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        isMoreLoading = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !isMoreLoading && hasMoreRecords) {
      setState(() {
        isMoreLoading = true;
        currentPage++;
      });
      _fetchEmployeeList(currentPage);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    setState(() {
      isLoading = true;
      currentPage = 1;
      hasMoreRecords = true;
      records.clear();
    });
    await _fetchEmployeeList(currentPage);
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
              (record.badgeNo != null && record.badgeNo!.toLowerCase().contains(query.toLowerCase())) ||
              (record.serviceEngineerName != null && record.serviceEngineerName!.toLowerCase().contains(query.toLowerCase())) ||
              (record.subServiceManagerRole != null && record.subServiceManagerRole!.toLowerCase().contains(query.toLowerCase())))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[200],
      appBar: widget.showAppBar
          ? AppBar(
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
                                hintText: 'Search by Emp Id',
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.black54),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 12.0,
                                  horizontal: 12.0,
                                ),
                              ),
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                              ),
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
                  : const Text('Employees'),
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
              ],
            )
          : null,
      body: isLoading
          ? const Center(child: CustomLoader())
          : records.isEmpty
              ? Center(
                  child: Text(
                    'No employee records available.',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                )
              : Container(
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: _onRefresh,
                          child: ListView.builder(
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: records.length,
                            itemBuilder: (context, index) {
                              final employee = records[index];

                              // print("Display all Employee Data");
                              // print(employee.phone);
                              // print(employee.aadharNo);

                              return Column(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      // if (employee.approvalStatus?.trim() !=
                                      //     '') {
                                      Get.to(
                                        () => EmployeeRegistrationDetails(
                                          entryId: employee.id!,
                                        ),
                                        transition: Transition.rightToLeft,
                                        popGesture: true,
                                      );
                                      // }
                                    },
                                    child: Card(
                                      elevation: 5,
                                      margin: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: <Widget>[
                                          ticketIdValue('Employee ID', employee.badgeNo ?? ''),
                                          const Divider(
                                            thickness: 2.0,
                                            color: Colors.grey,
                                          ),
                                          keyValues('Employee Name', employee.serviceEngineerName ?? ''),
                                          keyValues('Mobile Number', employee.phone ?? ''),
                                          keyValues('Aadhar Number', employee.aadharNo ?? ''),
                                          keyValues('Role', employee.subServiceManagerRole ?? ''),
                                          keyValues('Society', employee.empSociety ?? ''),
                                          keyValues('Block', employee.empBlock ?? ''),
                                          // if (employee.approvalStatus !=
                                          //     'Accepted') ...[
                                          //   Row(
                                          //     mainAxisAlignment:
                                          //         MainAxisAlignment.end,
                                          //     children: [
                                          //       Padding(
                                          //         padding:
                                          //             const EdgeInsets.all(5.0),
                                          //         child: Badge(
                                          //           padding:
                                          //               const EdgeInsets.all(
                                          //                   5.0),
                                          //           label: Text(
                                          //             style: const TextStyle(
                                          //               fontWeight:
                                          //                   FontWeight.bold,
                                          //             ),
                                          //             (employee.approvalStatus
                                          //                         ?.isEmpty ??
                                          //                     true)
                                          //                 ? 'Approval Pending'
                                          //                 : employee
                                          //                         .approvalStatus ??
                                          //                     '',
                                          //           ),
                                          //         ),
                                          //       ),
                                          //     ],
                                          //   )
                                          // ]
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                      if (isMoreLoading)
                        const Padding(
                          padding: EdgeInsets.all(10),
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  ),
                ),
      floatingActionButton: (Constants.userRole == Constants.facilityManager ||
              Constants.userRole == Constants.superAdmin ||
              Constants.userRole == Constants.treasury ||
              Constants.userRole == Constants.securitySupervisor ||
              Constants.userRole == Constants.admin)
          ? FloatingActionButton(
              elevation: 5,
              onPressed: () {
                Get.to(
                  () => const EmployeeRegistration(),
                  transition: Transition.rightToLeft,
                  popGesture: true,
                );
              },
              child: const Icon(Icons.person_add_outlined, size: 30),
            )
          : null,
    );
  }

  Widget ticketIdValue(String key, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 0,
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
            ' :',
            minFontSize: 12.0,
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            flex: 0,
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
}
