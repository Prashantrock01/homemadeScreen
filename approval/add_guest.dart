import 'dart:async';

import 'package:biz_infra/CustomWidgets/configurable_widgets.dart';
import 'package:biz_infra/Screens/approval/invite_guest.dart';
import 'package:biz_infra/Utils/debugger.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/route_manager.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../Themes/theme_controller.dart';

class AddGuest extends StatefulWidget {
  const AddGuest({super.key});

  @override
  State<AddGuest> createState() => _AddGuestState();
}

class _AddGuestState extends State<AddGuest> with SingleTickerProviderStateMixin {
  late final TextEditingController _contactName;
  late final TextEditingController _contactNumber;
  late final TextEditingController _contactSearch;
  final _mobileNoFocus = FocusNode();
  late final TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  CountryCode cc = CountryCode.fromCountryCode('IN');
  final _contactPicker = ContactPickerNotifier();

  List<ConnectivityResult>? _connectionStatus; // Make it nullable
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;


  /// Initialize connectivity status
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (_) {
      return;
    }

    if (!mounted) return;
    _updateConnectionStatus(result);
  }

  /// Update the internet connection status
  void _updateConnectionStatus(List<ConnectivityResult> result) {
    setState(() {
      _connectionStatus = result;
    });
  }

  void _goToFirstTab() {
    _tabController.animateTo(0);
  }

  void _addGuest() {
    if (_tabController.index == 0) {
      final form = _formKey.currentState;
      if (form != null && form.validate()) {
        Get.to(
          () => InviteGuest(
            name: _contactName.text,
            number: '${cc.dialCode}${_contactNumber.text}',
          ),
          popGesture: true,
          transition: Transition.rightToLeft,
        );
      }
    } else if (_tabController.index == 1) {
      if (_contactPicker.contactIndex.value != -1) {
        if (_contactPicker.cNumber.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(
                '"${_contactPicker.cName}" doesn\'t contain a number. '
                'Select any other.',
              ),
              duration: const Duration(milliseconds: 1500),
            ),
          );
        } else {
          Get.to(
            () => InviteGuest(
              name: _contactPicker.cName,
              number: _contactPicker.cNumber,
            ),
            popGesture: true,
            transition: Transition.rightToLeft,
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Please select any one contact.'),
            duration: Duration(milliseconds: 1500),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _contactName = TextEditingController();
    _contactNumber = TextEditingController();
    _contactSearch = TextEditingController();
    _tabController = TabController(length: 2, vsync: this);
    _contactPicker.getReadPermisionStatus();
    initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
          (List<ConnectivityResult> results) {
        _updateConnectionStatus(results);
      },
    );
  }

  @override
  void dispose() {
    _contactName.dispose();
    _contactNumber.dispose();
    _contactSearch.dispose();
    _mobileNoFocus.dispose();
    _tabController.dispose();
    _contactPicker.disposeContacts();
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Guest'),
      ),
      body: _connectionStatus == null
          ? const Center(child: CircularProgressIndicator()) // Show loader initially
          : _connectionStatus!.contains(ConnectivityResult.none)
          ? checkInternetConnection(initConnectivity)
          :  SizedBox.expand(
        child: Column(
          children: [
            // Container(
            //   color: ThemeController.selectedTheme == ThemeMode.dark
            //       ? Colors.white
            //       : Colors.black,
            //   padding: const EdgeInsets.symmetric(
            //     horizontal: 16.0,
            //     vertical: 8.0,
            //   ),
            //   width: double.maxFinite,
            //   child: Text(
            //     'Frequent Visitors',
            //     style: TextStyle(
            //       color: ThemeController.selectedTheme == ThemeMode.light
            //           ? Colors.white
            //           : Colors.black,
            //     ),
            //   ),
            // ),
            // Container(
            //   height: 150.0,
            //   padding: const EdgeInsets.all(10.0),
            //   width: double.maxFinite,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Column(
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Image.asset(
            //             'assets/images/repeat_grid19.png',
            //             color: Colors.amber.shade200,
            //             fit: BoxFit.contain,
            //             height: 80.0,
            //             width: 160.0,
            //           ),
            //           const Padding(
            //             padding: EdgeInsets.only(
            //               top: 10.0,
            //             ),
            //             child: Text(
            //               'Your frequently invited\n'
            //               'guests will be shown here',
            //               textAlign: TextAlign.center,
            //             ),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
            SizedBox(
              width: double.maxFinite,
              child: Container(
                decoration: BoxDecoration(
                  color: ThemeController.selectedTheme == ThemeMode.dark
                      ? Colors.white
                      : Colors.black,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Text(
                  'Invite Guest By',
                  style: TextStyle(
                    color: ThemeController.selectedTheme == ThemeMode.light
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            ),
            TabBar(
              controller: _tabController,
              indicatorColor: Colors.deepOrange,
              tabs: const [
                Tab(
                  child: Text(
                    'Number',
                    style: TextStyle(
                      // color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Contact',
                    style: TextStyle(
                      // color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              controller: _contactName,
                              decoration: InputDecoration(
                                border: commonBorder,
                                enabledBorder: commonEnableBorder,
                                focusedBorder: commonFocusedBorder,
                                hintText: 'Contact Name',
                                labelText: 'Name',
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[A-Za-z\s]+'),
                                )
                              ],
                              keyboardType: TextInputType.name,
                              onFieldSubmitted: (value) {
                                FocusScope.of(context)
                                    .requestFocus(_mobileNoFocus);
                              },
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field is required';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: _contactNumber,
                              decoration: InputDecoration(
                                border: commonBorder,
                                enabledBorder: commonEnableBorder,
                                focusedBorder: commonFocusedBorder,
                                hintText: 'Contact Number',
                                labelText: 'Mobile No.',
                                prefixIcon: CountryCodePicker(
                                  initialSelection: cc.code,
                                  onChanged: (value) {
                                    setState(() {
                                      cc = value;
                                    });
                                  },
                                ),
                              ),
                              focusNode: _mobileNoFocus,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                final regex = RegExp(r'^[6-9]\d{9}$');
                                if (value == null || value.isEmpty) {
                                  return 'This field is required';
                                } else if (!regex.hasMatch(value)) {
                                  return 'Please enter valid contact number';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListenableBuilder(
                    listenable: _contactPicker,
                    builder: (context, child) {
                      return Visibility(
                        visible: _contactPicker.readPermission,
                        replacement: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'We need permission to\naccess your contacts',
                              textAlign: TextAlign.center,
                            ),
                            TextButton(
                              onPressed: _contactPicker.grantReadPermission,
                              child: const Text(
                                'Allow Access',
                                style: TextStyle(
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                            const Text('or'),
                            TextButton(
                              onPressed: _goToFirstTab,
                              child: const Text(
                                'Invite by Number',
                                style: TextStyle(
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                          ],
                        ),
                        child: ValueListenableBuilder(
                          valueListenable: _contactPicker.contactIndex,
                          builder: (context, contactIndex, child) {
                            if (_contactPicker.isLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                    vertical: 6.0,
                                  ),
                                  child: TextField(
                                    controller: _contactSearch,
                                    decoration: InputDecoration(
                                      border: commonBorder,
                                      enabledBorder: commonEnableBorder,
                                      focusedBorder: commonFocusedBorder,
                                      hintText: 'Search Contacts...',
                                      prefixIcon: const Icon(Icons.search),
                                      suffixIcon: _textContentIsNotEmpty
                                          ? IconButton(
                                              icon: const Icon(Icons.cancel),
                                              onPressed: _clearSearchField,
                                            )
                                          : null,
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'([A-Za-z\s]|[0-9])*'),
                                      ),
                                    ],
                                    onChanged: _searchContacts,
                                    textInputAction: TextInputAction.search,
                                  ),
                                ),
                                Expanded(
                                  child: ListView.separated(
                                    itemBuilder: (context, index) {
                                      final cid =
                                          _contactPicker.contactList[index];
                                      debugger.printLogs('Contact:----- $cid');

                                      return CheckboxListTile(
                                        controlAffinity:
                                            ListTileControlAffinity.trailing,
                                        key: ValueKey(cid.id),
                                        onChanged: (value) {
                                          if (value != null) {
                                            _contactPicker.updateSelection(
                                              currIndex: index,
                                              upIndex: contactIndex,
                                              name: cid.displayName,
                                              number: cid.phones.isNotEmpty
                                                  ? cid.phones.first.number.isNotEmpty
                                                      ? cid.phones.first.number
                                                      : ''
                                                  : '',
                                            );
                                          }
                                        },
                                        secondary: const Icon(
                                          Icons.account_circle,
                                          size: 40.0,
                                        ),
                                        subtitle: Text(
                                          cid.phones.isNotEmpty
                                            ? cid.phones.first.number.isNotEmpty
                                                ? cid.phones.first.number
                                                : ''
                                            : '',
                                        ),
                                        title: Text(cid.displayName),
                                        value: index == contactIndex,
                                      );
                                    },
                                    itemCount:
                                        _contactPicker.contactList.length,
                                    separatorBuilder: (context, index) {
                                      return const Divider();
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          bottom: 16.0,
          left: 16.0,
          right: 16.0,
        ),
        child: ElevatedButton(
          onPressed: _addGuest,
          style: ButtonStyle(
            padding: const WidgetStatePropertyAll(
              EdgeInsets.all(10.0),
            ),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          child: const Text('Add Guest'),
        ),
      ),
    );
  }

  bool get _textContentIsNotEmpty => _contactSearch.text.isNotEmpty;

  void _searchContacts(String value) {
    _contactPicker.search(value);
  }

  void _clearSearchField() {
    _contactSearch.clear();
    _contactPicker.fetchContacts();
  }
}

class ContactPickerNotifier extends ChangeNotifier {
  bool isLoading = false;
  final contactIndex = ValueNotifier(-1);
  bool readPermission = false;
  List<Contact> contactList = List<Contact>.empty();
  String cName = '';
  String cNumber = '';

  Future<void> getReadPermisionStatus() async {
    final status = await Permission.contacts.status;
    readPermission = status.isGranted;
    notifyListeners();
    fetchContacts();
  }

  Future<void> grantReadPermission() async {
    final requestStatus = await Permission.contacts.request();
    if (requestStatus == PermissionStatus.granted) {
      readPermission = requestStatus.isGranted;
      notifyListeners();
      fetchContacts();
    } else if (requestStatus == PermissionStatus.denied) {
      readPermission = requestStatus.isGranted;
      notifyListeners();
    } else {
      readPermission = requestStatus.isGranted;
      notifyListeners();
      await openAppSettings();
    }
  }

  Future<void> fetchContacts() async {
    if (readPermission) {
      isLoading = true;
      notifyListeners();
      contactList = await FlutterContacts.getContacts(withProperties: true);
      notifyListeners();
      // contactList.removeWhere((contact) {
      //   return contact.phones.isEmpty ||
      //       contact.phones.first.normalizedNumber.isEmpty;
      // });
      // notifyListeners();
      isLoading = false;
      notifyListeners();
    }
  }

  void updateSelection({
    required int currIndex,
    required int upIndex,
    required String name,
    required String number,
  }) {
    contactIndex.value = upIndex != currIndex ? currIndex : -1;
    notifyListeners();
    if (contactIndex.value != -1) {
      cName = name;
      cNumber = number;
      notifyListeners();
    }
  }

  Future<void> search(String value) async {
    if (value.isNotEmpty) {
      if (contactIndex.value != -1) {
        contactIndex.value = -1;
        notifyListeners();
      }
      final contacts = await FlutterContacts.getContacts(withProperties: true);
      // contacts.removeWhere((contact) {
      //   return contact.phones.isEmpty ||
      //       contact.phones.first.normalizedNumber.isEmpty;
      // });
      // notifyListeners();
      contactList = contacts.where((contact) {
        return contact.displayName
                .toLowerCase()
                .contains(value.toLowerCase()) ||
            contact.phones.first.number.contains(value);
      }).toList();
      notifyListeners();
    } else {
      if (contactIndex.value != -1) {
        contactIndex.value = -1;
        notifyListeners();
      }
      final contacts = await FlutterContacts.getContacts(withProperties: true);
      contactList = contacts;
      notifyListeners();
      // contactList.removeWhere((contact) {
      //   return contact.phones.isEmpty ||
      //       contact.phones.first.normalizedNumber.isEmpty;
      // });
      // notifyListeners();
    }
  }

  void disposeContacts() {
    if (contactList.isNotEmpty) {
      contactList.clear();
      notifyListeners();
    }
  }
}
