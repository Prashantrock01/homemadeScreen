import 'dart:async';
import 'dart:developer';
import 'package:biz_infra/CustomWidgets/CustomLoaders/custom_loader.dart';
import 'package:biz_infra/Model/pre_approval/guest_approval_list_model.dart';
import 'package:biz_infra/Network/dio_service_client.dart';
import 'package:biz_infra/Screens/approval/notify_gate.dart';
import 'package:biz_infra/Utils/app_styles.dart';
import 'package:biz_infra/Utils/constants.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:url_launcher/url_launcher.dart';
import '../../CustomWidgets/configurable_widgets.dart';
import 'invite_guest.dart' show InviteGuest, displayPassDialog;

class MyVisitors extends StatefulWidget {
  final bool showAppBar;

  final int? initialTabIndex;
  final String? guestId;
  final bool? isScanOrPass;

  const MyVisitors({this.showAppBar = true, super.key, this.initialTabIndex = 0, this.guestId, this.isScanOrPass = false});

  @override
  State<MyVisitors> createState() => _MyVisitorsState();
}

class _MyVisitorsState extends State<MyVisitors> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  bool? isScnOrPass = false;
  String? isGuestId;
  final _tabs = [
    'guest approved',
    /*'delivery approved',*/ 'past' /*, 'denied'*/
  ];
  final _guestLogic = GuestApprovedLogic();
  final _pastGuestLogic = GuestApprovedLogic();

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: widget.initialTabIndex!,
      length: _tabs.length,
      vsync: this,
    );
    if (Constants.userRole != Constants.securitySupervisor) {
      _guestLogic.fetchAndInitializeData(_guestLogic.currentPageNo);
    }
    isScnOrPass = widget.isScanOrPass;
    isGuestId = widget.guestId;
    _pastGuestLogic.fetchAndInitializeData(_pastGuestLogic.currentPageNo, searchParams: true);

    initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
          (List<ConnectivityResult> results) {
        _updateConnectionStatus(results);
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              actions: [
                SearchAnchor(
                  viewHintText: 'Search Visitor...',
                  builder: (context, controller) {
                    return IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: controller.openView,
                    );
                  },
                  suggestionsBuilder: (context, controller) {
                    return _guestLogic.recordsList.where((found) {
                      return found.visitorName!.toLowerCase().contains(controller.text);
                    }).map((record) {
                      return VisitorsApproved(
                        name: record.visitorName ?? 'Name is empty',
                        number: record.visitorMobile ?? 'Mobile no. is empty',
                        todayDate: record.todaysDate ?? '',
                        startTime: record.visitorStartingtime ?? '',
                        valid: record.visitorValid ?? '',
                        date: record.todaysDate.toString(),
                        qrImagePath: record.qrcode ?? '',
                        otp: record.passcode.toString(),
                        vid: record.id.toString(),
                        gal: _guestLogic,
                        assignedName: record.assignedPerson ?? '',
                        block: record.ownerBlock ?? '',
                        flateNum: record.ownerFlat ?? '',
                        recordId: record.id.toString(),
                        isVisitorIn: record.visitorIn.toString(),
                      );
                    }).toList();
                  },
                ),
              ],
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: Colors.deepOrange,
                // isScrollable: true,
                // tabAlignment: TabAlignment.start,
                tabs: _tabs.map((tabName) {
                  return Tab(
                    child: Text(
                      tabName.toUpperCase(),
                      style: const TextStyle(
                        // color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
              ),
              title: const Text('Visitors'),
            )
          : null,
      body: _connectionStatus == null
          ? const Center(child: CircularProgressIndicator()) // Show loader initially
          : _connectionStatus!.contains(ConnectivityResult.none)
          ? checkInternetConnection(initConnectivity)
          :  Column(
        children: [
          Visibility(
            visible: !widget.showAppBar,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.deepOrange,
              // isScrollable: true,
              // tabAlignment: TabAlignment.start,
              onTap: (c) {
                isScnOrPass = false;
                isGuestId = null;
                setState(() {});
                log("message----$isScnOrPass");
              },
              tabs: _tabs.map((tabName) {
                return Tab(
                  child: Text(
                    tabName.toUpperCase(),
                    style: const TextStyle(
                      // color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // Guest Approved
                Constants.userRole == Constants.securitySupervisor
                    ? isGuestId == null && isScnOrPass == false
                        ? BlankPage(
                            assetImage: 'assets/images/novisitors.png',
                            title: 'No visitors inside',
                            subtitle: 'You can issue gate pass for current visitors only',
                            buttonVisible: Constants.userRole != Constants.securitySupervisor,
                            onBtnPressed: () {
                              Get.off(
                                () => const NotifyGate(),
                                popGesture: true,
                                transition: Transition.rightToLeft,
                              );
                            })
                        : GuestApproveDialogue(
                            guestID: widget.guestId,
                            onCall: () {
                              _tabController.animateTo(1);
                              _pastGuestLogic.fetchAndInitializeData(_pastGuestLogic.currentPageNo, searchParams: true);
                            },
                          )
                    : RefreshIndicator(
                        onRefresh: () async {
                          _guestLogic.refreshGuestList();
                        },
                        child: GuestApproved(logic: _guestLogic),
                      ),
                /* // Delivery Approved
                const BlankPage(
                  assetImage: 'assets/images/slide18.png',
                  title: 'No parcel found',
                  subtitle: 'Looks like currently no parcel available for you',
                  buttonVisible: false,
                ),*/
                // Past
                RefreshIndicator(
                  onRefresh: () async {
                    _pastGuestLogic.refreshPastGuestList();
                  },
                  child: GuestApproved(
                    logic: _pastGuestLogic,
                  ),
                ),
                // Denied
                // const BlankPage(
                //   assetImage: 'assets/images/novisitors.png',
                //   title: 'No visitors inside',
                //   subtitle: 'You can issue gate pass for current visitors only',
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class VisitorsApproved extends StatelessWidget {
  const VisitorsApproved({
    super.key,
    required this.name,
    required this.number,
    required this.todayDate,
    required this.startTime,
    required this.valid,
    required this.date,
    required this.qrImagePath,
    required this.otp,
    required this.vid,
    required this.gal,
    required this.recordId,
    required this.assignedName,
    required this.flateNum,
    required this.block,
    required this.isVisitorIn,
  });

  final String name;
  final String number;
  final String todayDate;
  final String startTime;
  final String valid;
  final String date;
  final String qrImagePath;
  final String otp;
  final String vid;
  final GuestApprovedLogic gal;
  final String recordId;
  final String assignedName;
  final String flateNum;
  final String block;
  final String isVisitorIn;

  void _rescheduleApproval() {
    final sDate = DateTime.parse(todayDate);
    final parseDate = DateFormat('dd MMM y').format(sDate);
    Get.to(
      () => InviteGuest(
        name: name,
        number: number,
        recordId: recordId,
        sDate: parseDate,
        sTime: startTime,
        vldTime: valid,
      ),
      popGesture: true,
      transition: Transition.leftToRight,
    );
  }

  Future<void> _cancelApproval() async {
    final id = vid.split('x').last;
    final result = await dioServiceClient.cancelGuestInvite(id: id);
    if (result.containsKey('data')) {
      final data = result['data'];
      if (data.containsKey('deleted')) {
        final deleted = data['deleted'];
        if (deleted.containsKey('result')) {
          final delResult = deleted['result'];
          if (delResult) {
            gal.refreshGuestList();
          }
        }
      }
    }
  }

  String get _validTimeInterval {
    // Use DateFormat to parse the date with the expected format
    final dateFormat = DateFormat('dd MMM yyyy HH:mm:ss'); // Adjust the format as needed
    final start = dateFormat.parse('$_startDate $startTime');

    // Calculate the end time by adding the duration
    final duration = int.parse(valid.split(' ').first);
    final end = start.add(Duration(hours: duration));

    // Format the start and end times for display
    final startFormatted = DateFormat('hh:mm a').format(start);
    final endFormatted = DateFormat('hh:mm a').format(end);

    return '$startFormatted - $endFormatted';
  }

  Future<void> _callContact() async {
    final contactUri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(contactUri)) {
      launchUrl(contactUri);
    }
  }

  String get _startDate {
    final sdate = DateTime.parse(todayDate);
    return DateFormat('dd MMM y').format(sdate);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      // color: Colors.white70,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: const Icon(
                    Icons.person,
                    size: 60.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.orange.shade700,
                        ),
                        margin: const EdgeInsets.symmetric(
                          vertical: 8.0,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          child: Text(
                            'guest'.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 5.0,
                        ),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.schedule,
                                size: 20.0,
                              ),
                            ),
                            Text(_validTimeInterval),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Icon(
                              Icons.today,
                              size: 20.0,
                            ),
                          ),
                          Text(_startDate),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 5.0,
                        ),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.person,
                                size: 20.0,
                              ),
                            ),
                            Text(assignedName),
                          ],
                        ),
                      ),
                      if (flateNum.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 5.0,
                          ),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  Icons.blinds_closed,
                                  size: 20.0,
                                ),
                              ),
                              Text(flateNum),
                            ],
                          ),
                        ),
                      if (block.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 5.0,
                          ),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  Icons.blinds_closed,
                                  size: 20.0,
                                ),
                              ),
                              Text(block),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                if ((Constants.userRole == Constants.owner || Constants.userRole == 'Tenant') && isVisitorIn == '0')
                  Expanded(
                    child: Container(
                      alignment: Alignment.topRight,
                      padding: const EdgeInsets.only(
                        bottom: 40.0,
                      ),
                      child: MenuAnchor(
                        alignmentOffset: const Offset(-60.0, -40.0),
                        builder: (context, controller, child) {
                          return IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: () {
                              if (controller.isOpen) {
                                controller.close();
                              } else {
                                controller.open();
                              }
                            },
                          );
                        },
                        menuChildren: [
                          MenuItemButton(
                            onPressed: _rescheduleApproval,
                            child: const Text('Reschedule'),
                          ),
                          MenuItemButton(
                            onPressed: _cancelApproval,
                            child: const Text('Cancel'),
                          ),
                        ],
                        style: const MenuStyle(
                          padding: WidgetStatePropertyAll(EdgeInsets.zero),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            if ((Constants.userRole == Constants.owner || Constants.userRole == 'Tenant') && isVisitorIn == '0') const Divider(color: Colors.grey),
            if ((Constants.userRole == Constants.owner || Constants.userRole == 'Tenant') && isVisitorIn == '0')
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.share),
                    label: const Text('Share Passcode'),
                    onPressed: () {
                      displayPassDialog(
                        context: context,
                        qrImagePath: qrImagePath,
                        passcode: otp,
                        validDate: _startDate,
                        validTime: startTime,
                        validInterval: valid,
                      );
                    },
                  ),
                  const SizedBox(
                    width: 1.0,
                    height: 40.0,
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: Colors.grey),
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.call),
                    label: const Text('Call'),
                    onPressed: _callContact,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class BlankPage extends StatelessWidget {
  const BlankPage({
    super.key,
    required this.assetImage,
    required this.title,
    required this.subtitle,
    this.buttonVisible = true,
    this.buttonIcon = Icons.add,
    this.buttonTitle = 'Invite Visitors',
    this.onBtnPressed,
  });

  final String assetImage;
  final String title;
  final String subtitle;
  final bool buttonVisible;
  final IconData buttonIcon;
  final String buttonTitle;
  final VoidCallback? onBtnPressed;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: 30.0,
          ),
          child: Image.asset(
            assetImage,
            width: media.size.width * 0.75,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
          ),
          child: Text(
            subtitle,
          ),
        ),
        Visibility(
          visible: buttonVisible,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 100.0,
            ),
            child: SizedBox(
              width: media.size.width * 0.85,
              child: ElevatedButton.icon(
                icon: Icon(buttonIcon),
                label: Text(buttonTitle),
                onPressed: onBtnPressed,
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class GuestApproved extends StatefulWidget {
  const GuestApproved({super.key, required this.logic});

  final GuestApprovedLogic logic;

  @override
  State<GuestApproved> createState() => _GuestApprovedState();
}

class _GuestApprovedState extends State<GuestApproved> {
  int _currentPageNo = 1;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.logic,
      builder: (context, child) {
        return Visibility(
          visible: !widget.logic.isLoading,
          replacement: const Center(
            child: CustomLoader(),
          ),
          child: Column(
            children: [
              Expanded(
                child: NotificationListener(
                  onNotification: (notification) {
                    if (notification is ScrollEndNotification && notification.metrics.extentAfter == 0 && widget.logic.canScrollMore) {
                      _currentPageNo++;
                      widget.logic.fetchAndInitializeData(_currentPageNo);
                    }
                    return false;
                  },
                  child: Visibility(
                    visible: widget.logic.recordsList.isNotEmpty,
                    replacement: BlankPage(
                      assetImage: 'assets/images/novisitors.png',
                      subtitle: 'It seems no visitors inside or'
                          ' no records can be found',
                      title: 'Empty Records',
                      buttonVisible: Constants.userRole != Constants.securitySupervisor,
                      onBtnPressed: () {
                        Get.off(
                          () => const NotifyGate(),
                          popGesture: true,
                          transition: Transition.rightToLeft,
                        );
                      },
                    ),
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        final record = widget.logic.recordsList.elementAt(index);

                        return VisitorsApproved(
                          name: record.visitorName ?? 'Name is empty',
                          number: record.visitorMobile ?? 'Mobile no. is empty',
                          todayDate: record.todaysDate ?? '',
                          startTime: record.visitorStartingtime ?? '',
                          valid: record.visitorValid ?? '',
                          date: record.todaysDate.toString(),
                          qrImagePath: record.qrcode ?? '',
                          otp: record.passcode.toString(),
                          vid: record.id ?? '',
                          gal: widget.logic,
                          assignedName: record.assignedPerson ?? '',
                          block: record.ownerBlock ?? '',
                          flateNum: record.ownerFlat ?? '',
                          recordId: record.id.toString(),
                          isVisitorIn: record.visitorIn.toString(),
                        );
                      },
                      itemCount: widget.logic.recordsList.length,
                      padding: const EdgeInsets.all(10.0),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: widget.logic.isLoadingMore,
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
          ),
        );
      },
    );
  }
}

class GuestApproveDialogue extends StatefulWidget {
  final String? guestID;

  final Function? onCall;

  const GuestApproveDialogue({super.key, this.guestID, this.onCall});

  @override
  State<GuestApproveDialogue> createState() => _GuestApproveDialogueState();
}

class _GuestApproveDialogueState extends State<GuestApproveDialogue> {
  String _validTimeInterval({String? todayDate, String? startTimes, String? valid}) {
    String fullDateTime = "$todayDate $startTimes";

    DateTime startTime = DateFormat("dd MMM yyyy HH:mm:ss").parse(fullDateTime);

    final duration = int.parse(valid!.split(' ').first);

    DateTime endTime = startTime.add(Duration(hours: duration));

    String formattedStartTime = DateFormat.jm().format(startTime);
    String formattedEndTime = DateFormat.jm().format(endTime);
    String timeRange = "$formattedStartTime to $formattedEndTime";
    return timeRange;
  }

  bool checkTime(DateTime givenTime) {
    DateTime now = DateTime.now();

    if (now.isAfter(givenTime)) {
      //print("The given time has started.");
      return true;
    } else {
      log('Note: Your In time is "$givenTime", So you are not allow in now, if you want then please ask to your invited to reschedule your invite');

      //print("The given time has not started yet.");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: dioServiceClient.getVisitorDetailApi(recordId: widget.guestID),
      builder: (context, snap) {
        if (snap.hasData) {
          if (snap.data != null) {
            log('-------${snap.data!.data!.record!.visitorIn}');
            if (snap.data!.data!.record!.visitorIn == '0') {
              return Center(
                // Centers the content on the screen
                child: Card(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 350, // Adjust width
                      maxHeight: 400, // Adjust height
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Center(
                          //   child: Container(
                          //     decoration: BoxDecoration(
                          //       border: Border.all(color: Colors.grey),
                          //       shape: BoxShape.circle,
                          //     ),
                          //     padding: const EdgeInsets.all(8.0),
                          //     child: const Icon(Icons.person, size: 60.0),
                          //   ),
                          // ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.person, size: 20.0),
                                  const SizedBox(width: 8),
                                  Text(snap.data!.data!.record!.visitorName!, style: Styles.textBoldLabel),
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: Colors.orange.shade700,
                                ),
                                margin: const EdgeInsets.symmetric(vertical: 8.0),
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                child: Text(
                                  'guest'.toUpperCase(),
                                  style: const TextStyle(color: Colors.white, fontSize: 12.0),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.schedule, size: 20.0),
                              const SizedBox(width: 8),
                              Text(_validTimeInterval(
                                startTimes: snap.data!.data!.record!.visitorStartingtime!,
                                todayDate: snap.data!.data!.record!.todaysDate!,
                                valid: snap.data!.data!.record!.visitorValid,
                              )),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.today, size: 20.0),
                              const SizedBox(width: 8),
                              Text(snap.data!.data!.record!.todaysDate!),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.person, size: 20.0),
                              const SizedBox(width: 8),
                              Text(snap.data!.data!.record!.assignedUserIdLabel!, style: Styles.textBoldLabel),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.home_work_outlined, size: 20.0),
                              const SizedBox(width: 8),
                              Text(snap.data!.data!.record!.ownerFlat!, style: Styles.textBoldLabel),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.home_work_outlined, size: 20.0),
                              const SizedBox(width: 8),
                              Text(snap.data!.data!.record!.ownerBlock!, style: Styles.textBoldLabel),
                            ],
                          ),
                          const SizedBox(height: 16),
                          if (Constants.userRole == Constants.securitySupervisor &&
                              checkTime(DateFormat("dd MMM yyyy hh:mm").parse("${snap.data!.data!.record!.todaysDate!} ${snap.data!.data!.record!.visitorStartingtime!}")))
                            Center(
                              child: SizedBox(
                                width: 250,
                                child: textButton(
                                  onPressed: () async {
                                    Map res = {
                                      "visitor_name": snap.data!.data!.record!.visitorName,
                                      "visitor_mobile": snap.data!.data!.record!.visitorMobile,
                                      "todays_date": snap.data!.data!.record!.todaysDate,
                                      "visitor_startingtime": snap.data!.data!.record!.visitorStartingtime,
                                      "visitor_valid": snap.data!.data!.record!.visitorValid,
                                      "visitor_in": "1",
                                      "assigned_user_id": snap.data!.data!.record!.assignedUserId!
                                    };
                                    await dioServiceClient.allowInOutVisitorApi(value: res, moduleId: Constants.visitorId, recordID: snap.data!.data!.record!.currentRecordId).then((v) {
                                      widget.onCall!();
                                    });
                                    // });
                                  },
                                  widget: const Text("Allow In"),
                                ),
                              ),
                            )
                          else
                            Text(
                              'Note: Your check-in time is ${snap.data!.data!.record!.todaysDate!} at ${_validTimeInterval(
                                startTimes: snap.data!.data!.record!.visitorStartingtime!,
                                todayDate: snap.data!.data!.record!.todaysDate!,
                                valid: snap.data!.data!.record!.visitorValid,
                              )}.As Security supervisor please create Guest approval for this guest',
                              style: const TextStyle(color: Colors.red, fontSize: 14),
                            )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return const Center(child: Text('This Guest is Already In side'));
            }
          } else {
            return const Center(child: Text('No Guest Found'));
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class GuestApprovedLogic with ChangeNotifier {
  bool isLoading = true;
  bool isLoadingMore = false;
  bool hasMoreRecords = false;
  int currentPageNo = 1;
  List<Records> recordsList = [];
  bool canScrollMore = false;

  Future<void> fetchAndInitializeData(int pageNo, {bool? searchParams = false}) async {
    if (pageNo == 1) {
      isLoading = true;
      notifyListeners();
    }
    if (pageNo > 1) {
      isLoadingMore = true;
      notifyListeners();
    }
    try {
      final asyncData = await dioServiceClient.fetchApprovedGuest(page: pageNo, searchParams: searchParams);
      var data = asyncData.data;
      if (data != null) {
        var moreRecords = data.moreRecords;
        var records = data.records;
        var recordsPerPage = data.recordsPerPage;
        if (records != null && records.isNotEmpty) {
          if (pageNo == 1) {
            recordsList = records;
            notifyListeners();
          } else {
            recordsList.addAll(records);
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

  void refreshGuestList() {
    recordsList.clear();
    notifyListeners();
    fetchAndInitializeData(currentPageNo);
  }

  void refreshPastGuestList() {
    recordsList.clear();
    notifyListeners();
    fetchAndInitializeData(currentPageNo, searchParams: true);
  }
}
