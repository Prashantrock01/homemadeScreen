import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:biz_infra/CustomWidgets/IntExtensions.dart';
import 'package:biz_infra/Model/announcement_modal.dart';
import 'package:biz_infra/Model/notice_board/notice_board_count_modal.dart';
import 'package:biz_infra/Network/dio_service_client.dart';
import 'package:biz_infra/Screens/Polls/polls_listing.dart';
import 'package:biz_infra/Screens/WaterTank/water_tank_list.dart';
import 'package:biz_infra/Screens/amenities/amenities_listing_screen.dart';
import 'package:biz_infra/Screens/attendance/attendance_listing_screen.dart';
import 'package:biz_infra/Screens/emergency/raise_sos_alert.dart';
import 'package:biz_infra/Screens/notice_board/notice_board_list.dart';
import 'package:biz_infra/Screens/registration/employee_registration/employee_registration_list.dart';
// import 'package:biz_infra/Screens/vendor_regd/vendors_listing.dart';
import 'package:biz_infra/Themes/theme_controller.dart';
import 'package:biz_infra/Utils/constants.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../CustomWidgets/configurable_widgets.dart';
import '../Utils/app_images.dart';
import '../Utils/app_styles.dart';
import 'DomesticHelp/domestic_help_screen.dart';
import 'EmergencyDirectory/emergency_directory_listing.dart';
import 'Maintenance/payment_list_screen.dart';
// import 'advertisement_full_screen.dart';
import 'buy_and_sell/buy_and_sell_list.dart';
// import 'emergency/raise_sos_alert.dart';
// import 'poster/poster_list.dart';
// import 'poster/poster_list.dart';
import 'Resident Directory/resident_directory_listing.dart';
import 'approval/my_visitors.dart';
import 'approval/notify_gate.dart';
import 'coming_soon.dart';
import 'help_desk/help_desk_tab.dart';

enum AdType { image, video, youtube }

class Advertisement {
  const Advertisement({
    required this.url,
    required this.adType,
    required this.controller,
  });

  final String url;
  final AdType adType;
  final dynamic controller;
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ValueNotifier<int> _currentPageNotifier = ValueNotifier<int>(0);
  final ValueNotifier<List<String>> _imageUrlsNotifier = ValueNotifier<List<String>>([]);

  late Future<NoticeBoardCountModal?> notificationCount;
  final ValueNotifier<int> _badgeCountNotifier = ValueNotifier<int>(0);
  final ValueNotifier<int> _advBadgeCountNotifier = ValueNotifier<int>(0);
  final ValueNotifier<int> helpDeskCountNotifier = ValueNotifier<int>(0);
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(true);
  final ThemeController _controller = Get.put(ThemeController());

  List<ConnectivityResult>? _connectionStatus; // Make it nullable
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  // final ScrollController _scrollController = ScrollController();


  List<Advertisement> adv = [];

  Future<void> _initVideos(int index) async {
    if (adv.isNotEmpty) {
      Advertisement ad = adv[index];
      AdType mediaType = ad.adType;
      dynamic ctrl = ad.controller;
      if (mediaType == AdType.video && ctrl is VideoPlayerController) {
        ctrl.initialize().then((_) {
          ctrl.play();
          setState(() {});
        });
      } else if (mediaType == AdType.youtube && ctrl is YoutubePlayerController) {
        ctrl.addListener(() {});
        ctrl.play();
      }
    }
  }

  void _pauseVideos() {
    if (adv.isNotEmpty) {
      for (final ad in adv) {
        var ctrl = ad.controller;
        if (ad.adType == AdType.video && ctrl is VideoPlayerController) {
          ctrl.pause();
        } else if (ad.adType == AdType.youtube && ctrl is YoutubePlayerController) {
          ctrl.pause();
        }
      }
    }
  }

  void _disposeAdvControllers() {
    for (final ad in adv) {
      var ctrl = ad.controller;
      if (ad.adType == AdType.video && ctrl is VideoPlayerController) {
        ctrl.dispose();
      } else if (ad.adType == AdType.youtube && ctrl is YoutubePlayerController) {
        ctrl.dispose();
      }
    }
  }

  void _updateCurrentPlayer(int index) {
    var ad = adv[index];
    var ctrl = ad.controller;
    if (ctrl is VideoPlayerController) {
      if (ctrl.value.isPlaying) {
        ctrl.pause();
      } else {
        ctrl.play();
      }
    } else if (ctrl is YoutubePlayerController) {
      if (ctrl.value.isPlaying) {
        ctrl.pause();
      } else {
        ctrl.play();
      }
    }
  }

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
    // Fetch the notification count when the widget is initialized
    _fetchNoticeCount();
    _fetchAdvNoticeCount();
    _fetchAnnouncement();
    fetchHelpDeskCount();
    _initVideos(_currentPageNotifier.value);
    initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
          (List<ConnectivityResult> results) {
        _updateConnectionStatus(results);
      },
    );
  }

  @override
  void dispose() {
    _currentPageNotifier.dispose();
    _controller.dispose();
    _disposeAdvControllers();
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  void deactivate() {
    super.deactivate();
    _pauseVideos();
  }

  Future<void> _fetchNoticeCount() async {
    try {
      final noticeBoardCount = await dioServiceClient.getNoticeCount();
      final count = int.tryParse(noticeBoardCount!.data!.newCount!) ?? 0;
      _badgeCountNotifier.value = count;
    } catch (e) {
      // Handle error, log or show a message as needed
      _badgeCountNotifier.value = 0;
    }
  }

  Future<void> _fetchAdvNoticeCount() async {
    try {
      final advNoticeBoardCount = await dioServiceClient.getAdvNoticeCount();
      final count = int.tryParse(advNoticeBoardCount!.data!.newCount!) ?? 0;
      _advBadgeCountNotifier.value = count;
    } catch (e) {
      // Handle error, log or show a message as needed
      _advBadgeCountNotifier.value = 0;
    }
  }

  Future<void> fetchHelpDeskCount() async {
    try {
      print("Fetching Help Desk Count...");
      final helpDeskCount = await dioServiceClient.getCountList(module: "HelpDesk");

      if (helpDeskCount == null || helpDeskCount.data == null || helpDeskCount.data!.newCount == null) {
        print("Invalid API response");
        helpDeskCountNotifier.value = 0;
        return;
      }

      print("API Response: ${helpDeskCount.data!.newCount}");

      final count = int.tryParse(helpDeskCount.data!.newCount!) ?? 0;
      print("Parsed Count: $count");

      helpDeskCountNotifier.value = count;
      print("Updated Notifier Value: ${helpDeskCountNotifier.value}");
    } catch (e) {
      print("Error fetching count: $e");
      helpDeskCountNotifier.value = 0;
    }
  }

  Future<void> _fetchAnnouncement() async {
    _isLoading.value = true;
    try {
      final AnnouncementModal? announcement = await dioServiceClient.getAnnouncement();

      // Check if response is valid
      if (announcement != null && announcement.statuscode == 1 && announcement.data != null) {
        final mediaList = announcement.data!.records;

        if (mediaList != null && mediaList.isNotEmpty) {
          for (final media in mediaList) {
            if (media.docUrl?.isNotEmpty ?? false) {
              if (media.docUrl!.endsWith('.mp4')) {
                adv.add(Advertisement(
                  url: media.docUrl!,
                  adType: AdType.video,
                  controller: VideoPlayerController.networkUrl(
                    Uri.parse(media.docUrl!),
                    videoPlayerOptions: VideoPlayerOptions(),
                  ),
                ));
              } else {
                adv.add(Advertisement(
                  url: media.docUrl!,
                  adType: AdType.image,
                  controller: ObjectKey(media.docUrl),
                ));
              }
            }

            // Handle YouTube URL safely
            if (media.annosYoutubeurl?.isNotEmpty ?? false) {
              final youtubeId = YoutubePlayer.convertUrlToId(media.annosYoutubeurl!);
              if (youtubeId != null) {
                adv.add(Advertisement(
                  url: media.annosYoutubeurl!,
                  adType: AdType.youtube,
                  controller: YoutubePlayerController(
                    initialVideoId: youtubeId,
                    flags: const YoutubePlayerFlags(
                      autoPlay: false,
                      disableDragSeek: true,
                      enableCaption: false,
                      showLiveFullscreenButton: false,
                    ),
                  ),
                ));
              }
            }
          }
        } else {
          if (kDebugMode) print('No media found in the list.');
          _imageUrlsNotifier.value = [];
        }
      } else {
        if (kDebugMode) print('Failed to fetch announcement data: ${announcement?.statusMessage}');
        _imageUrlsNotifier.value = [];
      }
    } catch (e) {
      if (kDebugMode) print('Error fetching announcements: $e');
      _imageUrlsNotifier.value = [];
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // final media = MediaQuery.of(context);
    // String displayName = Constants.societyName ?? Constants.userRole;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: _buildBlockAndFlatDetails(buttonText: Constants.societyName),
        //Constants.societyBlock = loginData.data!.profileInfo!.empBlock ?? loginData.data!.profileInfo!.relatedBlock ?? '';

        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Obx(
                () => IconButton(
                  tooltip: 'Theme Change',
                  onPressed: () {
                    _controller.switchTheme();
                    Get.changeThemeMode(_controller.currentTheme.value);
                  },
                  icon: Icon(_controller.currentTheme.value == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 5.0,
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8.0),
                  onTap: () {
                    Get.to(
                      () => const RaiseSOSAlert(),
                      transition: Transition.rightToLeft,
                      popGesture: true,
                    );
                  },
                  child: Image.asset(
                    'assets/home/sos.png',
                    fit: BoxFit.contain,
                    height: 30.0,
                    width: 30.0,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
      // Drawer not needed, remove this completely
      // drawer: const NavDrawer(),
      body:_connectionStatus == null
          ? const Center(child: CircularProgressIndicator()) // Show loader initially
          : _connectionStatus!.contains(ConnectivityResult.none)
          ? checkInternetConnection(initConnectivity)
          :  SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //All Modules
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildCircleAvatarWithText('assets/home/gate_updates.png', 'My Activities', () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        title: const Text(
                          'My Activities',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        children: <Widget>[
                          SizedBox(
                            width: double.maxFinite,
                            child: GridView.count(
                              primary: false,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              crossAxisCount: 3,
                              shrinkWrap: true,
                              children: <Widget>[
                                if (Constants.userRole == Constants.owner || Constants.userRole == "Super Admin" || Constants.userRole == 'Tenant')
                                  _buildDailogWithText(
                                    'assets/home/invite_visitor.png',
                                    'Pre-Approval',
                                    () {
                                      Navigator.of(context).pop();
                                      Get.to(
                                        () => const NotifyGate(),
                                        transition: Transition.rightToLeft,
                                        popGesture: true,
                                        preventDuplicates: false,
                                      );
                                    },
                                  ),
                                _buildDailogWithText(
                                  'assets/home/invite_visitor.png',
                                  'Visitor',
                                  () {
                                    Navigator.of(context).pop();
                                    Get.to(
                                      () => const MyVisitors(),
                                      transition: Transition.rightToLeft,
                                      popGesture: true,
                                    );
                                  },
                                ),
                                _buildDailogWithText(
                                  'assets/home/invite_visitor.png',
                                  'Domestic Help',
                                  () {
                                    Navigator.of(context).pop();
                                    Get.to(
                                      () => const DomesticHelpScreen(),
                                      transition: Transition.rightToLeft,
                                      popGesture: true,
                                    );
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      );
                    },
                  );
                }),
                _buildCircleAvatarWithText(
                  'assets/home/society.png',
                  'My Community',
                  () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return SimpleDialog(
                          title: const Text(
                            'My Community',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          children: <Widget>[
                            SizedBox(
                              width: double.maxFinite,
                              child: GridView.count(
                                primary: false,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                crossAxisCount: 3,
                                shrinkWrap: true,
                                children: <Widget>[
                                  _buildDailogWithText(
                                    'assets/home/invite_visitor.png',
                                    'Directory',
                                    () {
                                      Navigator.of(context).pop();
                                      Get.to(
                                        () => const ResidentDirectoryListing(),
                                        transition: Transition.rightToLeft,
                                        popGesture: true,
                                      );
                                    },
                                  ),
                                  _buildDailogWithText(
                                    'assets/home/amenities.png',
                                    'Amenities',
                                    () {
                                      Navigator.of(context).pop();
                                      Get.to(
                                            () => const AmenitiesListingScreen(),
                                        transition: Transition.rightToLeft,
                                        popGesture: true,
                                      );
                                    },
                                  ),
                                  _buildDailogWithText(
                                    'assets/home/buy_and_sell.png',
                                    'Buy & Sell',
                                        () {
                                      Navigator.of(context).pop();
                                      Get.to(
                                            () => const BuyAndSellList(),
                                        transition: Transition.rightToLeft,
                                        popGesture: true,
                                      );
                                    },
                                  ),
                                  _buildDailogWithText('assets/home/discussion_board.png', 'Polls', () {
                                    Navigator.of(context).pop();
                                    Get.to(
                                          () => const PollsListing(),
                                      transition: Transition.rightToLeft,
                                      popGesture: true,
                                    );
                                  })
                                ],
                              ),
                            )
                          ],
                        );
                      },
                    );
                  },
                ),
                _buildCircleAvatarWithText(
                  'assets/home/bills.png',
                  'My Bills',
                  () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            insetPadding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const Center(
                                    child: Text(
                                      'My Bills',
                                      textAlign: TextAlign.center,
                                      style: Styles.textBoldLabel,
                                    ),
                                  ),
                                  16.height,
                                  Wrap(
                                    alignment: WrapAlignment.start,
                                    crossAxisAlignment: WrapCrossAlignment.start,
                                    runAlignment: WrapAlignment.start,
                                    children: <Widget>[
                                      _buildDailogWithText(
                                        'assets/home/ic_payment.png',
                                        'Maintenance',
                                        () {
                                          Navigator.of(context).pop();
                                          Get.to(
                                            () => const PaymentListScreen(),
                                            transition: Transition.rightToLeft,
                                            popGesture: true,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ));
                      },
                    );
                  },
                ),
                _buildCircleAvatarWithText(
                  'assets/home/siren.png',
                  'Emergency',
                  () {
                    Get.to(
                      () => const EmergencyDirectoryListing(),
                      transition: Transition.rightToLeft,
                      popGesture: true,
                    );
                  },
                )
              ],
            ),
            //Services you need

                    // Services you need
                    //   Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Services you need',
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // More Button
                          // TextButton(
                          //   onPressed: () {
                          //     _scrollController.animateTo(
                          //       _scrollController.position.maxScrollExtent,
                          //       // Scroll to right
                          //       duration: const Duration(milliseconds: 500),
                          //       curve: Curves.easeOut,
                          //     );
                          //   },
                          //   child: const Text('view more', style: TextStyle(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.bold),),
                          // ),
                      //   ],
                      // ),
                      const SizedBox(height: 10),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: SingleChildScrollView(
                         // controller: _scrollController, // Assign the ScrollController
                          padding: const EdgeInsets.only(top: 12),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ValueListenableBuilder<int>(
                                valueListenable: _badgeCountNotifier,
                                builder: (context, badgeCount, _) {
                                  return _buildContainerWithText(
                                    'assets/home/notices.png',
                                    'Notices',
                                    () async {
                                      _badgeCountNotifier.value = 0;
                                      await Get.to(
                                        () => const NoticeBoardList(),
                                        transition: Transition.rightToLeft,
                                        popGesture: true,
                                      );
                                    },
                                    badgeCount: badgeCount,
                                  );
                                },
                              ),
                              ValueListenableBuilder(
                                valueListenable: helpDeskCountNotifier,
                                builder: (context, badgeCount, _) {
                                  return _buildContainerWithText(
                                    'assets/home/myhelp.png',
                                    'Help Desk',
                                    () async {
                                      helpDeskCountNotifier.value = 0;
                                      await Get.to(
                                        () => const HelpDeskTabBar(
                                          initialTabIndex: 0,
                                        ),
                                        transition: Transition.rightToLeft,
                                        popGesture: true,
                                      );
                                    },
                                    badgeCount: badgeCount,
                                  );
                                },
                              ),
                              if (Constants.userRole == 'Facility Manager' ||
                                  Constants.userRole == 'Security Supervisor' ||
                                  Constants.userRole == 'Super Admin' ||
                                  Constants.userRole == 'admin' ||
                                  Constants.userRole == 'Treasury')
                                _buildContainerWithText(
                                  'assets/home/employee.png',
                                  'Employee',
                                  () {
                                    Get.to(
                                      () => const EmployeeRegistrationList(),
                                      transition: Transition.rightToLeft,
                                      popGesture: true,
                                    );
                                  },
                                ),
                              if (Constants.userRole ==
                                      Constants.facilityManager ||
                                  Constants.userRole == 'Treasury' ||
                                  Constants.userRole == "Super Admin")
                                _buildContainerWithText(
                                  icAttendance,
                                  'Attendance',
                                  () {
                                    Get.to(
                                      () => const AttendanceListingScreen(),
                                      transition: Transition.rightToLeft,
                                      popGesture: true,
                                    );
                                  },
                                ),
                              if (Constants.userRole ==
                                      Constants.facilityManager ||
                                  Constants.userRole == 'Treasury' ||
                                  Constants.userRole == "Super Admin")
                                _buildContainerWithText(
                                  icWaterTanker,
                                  'Water Tanker',
                                  () {
                                    Get.to(
                                      () => const WaterTankList(),
                                      transition: Transition.rightToLeft,
                                      popGesture: true,
                                    );
                                  },
                                ),

                            ],
                          ),
                        ),
                      ),

                      //Discover Me
            _buildCarouselSlider(),

            const SizedBox(
              height: 15,
            ),
            //Home Services
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Infra Services ( Coming Soon )',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              children: [
                Image.asset(
                  'assets/home/biz_infra.png',
                  height: 18,
                ),
                const SizedBox(width: 4),
                const Text.rich(
                  TextSpan(
                    text: 'by ', // Default text style
                    style: TextStyle(
                      //color: Constants.secondaryTextWhite,
                      fontSize: 12,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'InfraEye',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ), // Bold text
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),

            SizedBox(
              // height: media.size.height * 0.35,
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                primary: false,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 4,
                shrinkWrap: true,
                children: <Widget>[
                  _buildServicesWithText(
                    'assets/home_services/cab_facility.png',
                    'Cab Facility',
                    () {
                      Get.to(() => const ComingSoon(appBarText: 'Cab Facility', leading: true));
                    },
                  ),
                  _buildServicesWithText(
                    'assets/home_services/fabrication.png',
                    'Fabrication',
                    () {
                      List<Map<String, String>> fabricationItems = [
                        {'image': 'assets/home_services/ms_fabrication.png', 'title': 'MS Fabrication'},
                        {'image': 'assets/home_services/aluminium_fabrication.png', 'title': 'Aluminium Fabrication'},
                      ];
                      subServiceDialog(context, 'Fabrication', fabricationItems);
                    },
                  ),
                  _buildServicesWithText(
                    'assets/home_services/repair-tools.png',
                    'Repair & Maintenance',
                    () {
                      List<Map<String, String>> fabricationItems = [
                        {'image': 'assets/home_services/deep_cleaning.png', 'title': 'Deep cleaning'},
                        {'image': 'assets/home_services/paint-roller.png', 'title': 'Painting'},
                        {'image': 'assets/home_services/electrician.png', 'title': 'Electrician'},
                        {'image': 'assets/home_services/plumber.png', 'title': 'Plumber'},
                        {'image': 'assets/home_services/carpenter.png', 'title': 'Carpenter'},
                      ];
                      subServiceDialog(context, 'Repair and Maintenance', fabricationItems);
                    },
                  ),
                  _buildServicesWithText(
                    'assets/home_services/hospital.png',
                    'Medical',
                    () {
                      List<Map<String, String>> fabricationItems = [
                        {'image': 'assets/home_services/hospital.png', 'title': 'Hospital'},
                        {'image': 'assets/home_services/labs.png', 'title': 'Lab'},
                      ];
                      subServiceDialog(context, 'Medical', fabricationItems);
                    },
                  ),
                  _buildServicesWithText(
                    'assets/home_services/insecticide.png',
                    'Pest Control Service',
                    () {
                      Get.to(() => const ComingSoon(appBarText: 'Pest Control Service', leading: true));
                    },
                  ),
                  _buildServicesWithText(
                    'assets/home_services/moving-home.png',
                    'Packers & Movers',
                    () {
                      Get.to(() => const ComingSoon(appBarText: 'Packers & Movers', leading: true));
                    },
                  ),
                  _buildServicesWithText(
                    'assets/home_services/booking.png',
                    'Restaurant Table Booking',
                    () {
                      Get.to(() => const ComingSoon(appBarText: 'Restaurant Table Booking', leading: true));
                    },
                  ),
                  _buildServicesWithText(
                    'assets/home_services/reservation.png',
                    'Parking Lot Booking',
                    () {
                      Get.to(() => const ComingSoon(appBarText: 'Parking Lot Booking', leading: true));
                    },
                  ),
                  _buildServicesWithText(
                    'assets/home_services/staircase.png',
                    'Interior Designing',
                    () {
                      Get.to(() => const ComingSoon(appBarText: 'Interior Designing', leading: true));
                    },
                  ),
                  _buildServicesWithText(
                    'assets/home_services/construction.png',
                    'Home Renovation',
                    () {
                      Get.to(() => const ComingSoon(appBarText: 'Home Renovation', leading: true));
                    },
                  ),
                  _buildServicesWithText(
                    'assets/home_services/ticket.png',
                    'Ticket Booking',
                    () {
                      List<Map<String, String>> fabricationItems = [
                        {'image': 'assets/home_services/bus_ticket.png', 'title': 'Bus Ticket Booking'},
                        {'image': 'assets/home_services/movie_ticket.png', 'title': 'Movie Ticket Booking'},
                        {'image': 'assets/home_services/flight_ticket.png', 'title': 'Flight Ticket Booking'},
                        {'image': 'assets/home_services/hotel_booking.png', 'title': 'Hotel Booking'},
                      ];
                      subServiceDialog(context, 'Ticket Booking', fabricationItems);
                    },
                  ),
                  _buildServicesWithText(
                    'assets/home_services/grooming.png',
                    'Grooming',
                    () {
                      Get.to(() => const ComingSoon(appBarText: 'Grooming', leading: true));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlockAndFlatDetails({required String buttonText}) {
    return PopupMenuButton(
      offset: const Offset(0, 0),
      position: PopupMenuPosition.under,
      child: TextButton.icon(
        onPressed: null,
        icon: const Icon(
          Icons.keyboard_arrow_down,
          size: 10.5,
        ),
        label: Text(buttonText),
        iconAlignment: IconAlignment.end,
      ),
      itemBuilder: (context) => [
        // Shows the Block and Flat Number with details
        PopupMenuItem(
          child: _buildCustomDropdownItem(),
        ),
      ],
    );
  }

  Widget _buildCustomDropdownItem() {
    return ListTile(
      leading: CircleAvatar(
        radius: 16,
        child: Constants.userImage.isEmpty || Constants.userImage == 'null'
            ? const Icon(
                Icons.person,
                size: 16,
              )
            : Image.network(Constants.userImage),
      ),
      title: Text(
        '${Constants.societyName} ${Constants.societyBlock} ${Constants.societyNumber}',
        overflow: TextOverflow.visible,
        softWrap: true,
      ),
      subtitle: Text(
        "${Constants.userName}, ${Constants.userRole}",
        overflow: TextOverflow.visible,
        softWrap: true,
      ),
    );
  }

  Widget _buildCircleAvatarWithText(String imagePath, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 80,
        height: 100,
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: const Color.fromARGB(255, 228, 221, 221),
              radius: 26.0,
              child: Image.asset(
                imagePath,
                height: 30,
              ),
            ),
            const SizedBox(
              height: 4.0,
            ), // Spacing between the avatar and the text
            Builder(
              builder: (context) {
                final screenHeight = MediaQuery.of(context).size.height;
                final fontSize = screenHeight * 0.01135; // Adjust the multiplier as needed
                return Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContainerWithText(
    String imagePath,
    String label,
    VoidCallback onTap, {
    int? badgeCount, // Optional parameter for badge count
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: SizedBox(
          width: 80,
          height: 100,
          child: Column(
            children: [
              badgeCount != null && badgeCount > 0
                  ? Badge.count(
                      count: badgeCount,
                      child: Container(
                        width: 55, // Width of the rectangle
                        height: 60, // Height of the rectangle
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 228, 221, 221),
                          shape: BoxShape.rectangle, // Makes the container rounded
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Center(
                          child: Image.asset(imagePath, height: 36),
                        ),
                      ),
                    )
                  : Container(
                      width: 55, // Width of the rectangle
                      height: 60, // Height of the rectangle
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 228, 221, 221),
                        shape: BoxShape.rectangle, // Makes the container rounded
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Center(
                        child: Image.asset(imagePath, height: 36),
                      ),
                    ),
              const SizedBox(
                height: 4.0, // Spacing between the container and the text
              ),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarouselSlider() {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Advertisement',
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        ValueListenableBuilder(
          valueListenable: _isLoading,
          builder: (context, isLoading, child) {
            return ValueListenableBuilder<List<String>>(
              valueListenable: _imageUrlsNotifier,
              builder: (context, imageUrls, child) {
                if (isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (adv.isEmpty) {
                  return const Center(child: Text('No media available'));
                }
                return Column(
                  children: [
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 130.0,
                        initialPage: 0,
                        enableInfiniteScroll: adv.length > 1,
                        autoPlay: adv.length > 1,
                        autoPlayInterval: const Duration(seconds: 5),
                        autoPlayAnimationDuration: const Duration(milliseconds: 800),
                        autoPlayCurve: Curves.easeIn,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                        onPageChanged: (index, reason) {
                          _currentPageNotifier.value = index;
                          _updateCurrentPlayer(index);
                        },
                      ),
                      items: adv.map((item) {
                        return GestureDetector(
                          onTap: () {
                            // Get.to(
                            //       () => FullScreenView(advertisement: item),
                            //   transition: Transition.fadeIn,
                            // );
                          },
                          child: Builder(
                            builder: (BuildContext context) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: (item.adType == AdType.youtube)
                                      ? YoutubePlayer(controller: item.controller)
                                      : (item.adType == AdType.video)
                                      ? VideoPlayer(item.controller..initialize())
                                      : Image.network(
                                    item.url,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                    if (adv.length > 1)
                      ValueListenableBuilder<int>(
                        valueListenable: _currentPageNotifier,
                        builder: (context, value, child) {
                          return AnimatedSmoothIndicator(
                            activeIndex: value,
                            count: adv.length,
                            effect: const ExpandingDotsEffect(
                              dotHeight: 8,
                              dotWidth: 8,
                              activeDotColor: Constants.primaryColor,
                              dotColor: Colors.grey,
                            ),
                          );
                        },
                      ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildDailogWithText(String imagePath, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(imagePath, height: 36),
          const SizedBox(
            height: 4.0,
          ), // Spacing between the avatar and the text
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesWithText(String imagePath, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child:
          // Obx(
          // () =>
          SizedBox(
        width: 20, // Width of the circle
        height: 10, // Height of the circle
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, height: 30),
            const SizedBox(
              height: 4.0,
            ), // Spacing between the avatar and the text
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
      //),
    );
  }

  Future subServiceDialog(BuildContext context, String title, List<Map<String, String>> items) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 18),
              ),
              const Divider(color: Colors.grey),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite, // Ensure it expands to fit the dialog width
            child: GridView.builder(
              shrinkWrap: true,
              // Automatically adjusts height based on content
              physics: const NeverScrollableScrollPhysics(),
              // Prevent scrolling inside the GridView
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Number of items per row
                crossAxisSpacing: 10, // Spacing between columns
                mainAxisSpacing: 10, // Spacing between rows
                childAspectRatio: 0.8, // Adjust to control the width/height ratio
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    Get.to(() => ComingSoon(
                          appBarText: items[index]['title'].toString(),
                          leading: false,
                        ));
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        items[index]['image'] ?? '',
                        height: 40,
                        fit: BoxFit.contain,
                      ),
                      Flexible(
                        child: AutoSizeText(
                          items[index]['title'] ?? '',
                          style: const TextStyle(fontSize: 10),
                          textAlign: TextAlign.center,
                          maxLines: 2, // Limit the text to 2 lines
                          overflow: TextOverflow.ellipsis, // Handle text overflow
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close the dialog
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
