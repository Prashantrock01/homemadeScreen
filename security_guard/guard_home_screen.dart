import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controller/AppUpdateController.dart';
import '../../Themes/theme_controller.dart';
import '../../Utils/constants.dart';
import '../DomesticHelp/component/domestic_list_component.dart';
import '../DomesticHelp/component/domestic_type_list_filter_component.dart';

import '../WaterTank/water_tank_list.dart';
import '../approval/my_visitors.dart';
import '../attendance/attendance_listing_screen.dart';
import '../Profile/employee_profile.dart';
import '../registration/employee_registration/employee_registration_list.dart';
import 'guard_enter_screen.dart';

class GuardHomeScreen extends StatefulWidget {
  const GuardHomeScreen({super.key});

  @override
  State<GuardHomeScreen> createState() => _GuardHomeScreenState();
}

class _GuardHomeScreenState extends State<GuardHomeScreen> {
  final ThemeController _controller = Get.put(ThemeController());
  int? currentInd = 0;
  String? myVisitorTabInd;
  List<Widget> widgetList = [];

  @override
  void initState() {
    super.initState();
    Get.put(AppUpdateController());
  }

  Future<bool> _onWillPop() async {
    if (currentInd != 0) {
      // Navigate back to the home tab if not already there
      setState(() {
        currentInd = 0;
      });
      return false; // Prevent the default back action
    } else {
      // Show exit confirmation dialog
      return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Exit App'),
              content: const Text('Are you sure you want to exit the app?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false), // Dismiss the dialog
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true), // Allow the exit
                  child: const Text('Exit'),
                ),
              ],
            ),
          ) ??
          false; // Return false if dialog is dismissed without a choice
    }
  }

  @override
  Widget build(BuildContext context) {
    widgetList = [
      GuardEnterScreen(
        onCallBck: (i, s) {
          setState(() {
            currentInd = i;
            myVisitorTabInd = s;
          });
        },
      ),
      const EmployeeRegistrationList(showAppBar: false),
      const AttendanceListingScreen(showAppBar: false),
      const DomesticListComponent(isAllHelper: true),
      const WaterTankList(showAppBar: false),
      // const SupervisorGuestApproval(showAppBar: false),
      // const SupervisorDeliveryApproval(showAppBar: false),
      MyVisitors(showAppBar: false, guestId: myVisitorTabInd, isScanOrPass: myVisitorTabInd != null),
    ];
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        // drawer: const NavDrawer(),
        appBar: AppBar(
          centerTitle: true,
          title: Text(Constants.appBarNameList[currentInd!]),
          elevation: 0,
          actions: [
            if (currentInd == Constants.appBarNameList.indexOf('Domestic Help'))
              IconButton(
                onPressed: () {
                  _showAddNewServiceSheet();
                },
                icon: const Icon(Icons.filter_alt_rounded),
              ),
            if (currentInd == 0)
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
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EmployeeProfileScreen()),
                );
              },
              icon: const Icon(Icons.account_circle_rounded),
            ),
            // const SizedBox(width: 8),
          ],
        ),

        body: widgetList[currentInd!],

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentInd!,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Constants.primaryColor,
          iconSize: 24,

          // Adjusted for better visual balance
          selectedFontSize: 10,
          unselectedFontSize: 10,
          onTap: (c) {
            currentInd = c;
            myVisitorTabInd = null;
            setState(() {});
          },
          items: const [
            BottomNavigationBarItem(
              icon: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.qr_code_scanner),
                  SizedBox(height: 4), // Space between icon and text
                  Text('Security \nScan', textAlign: TextAlign.center, style: TextStyle(fontSize: 10), maxLines: 2),
                ],
              ),
              label: '', // Label is empty since it's handled above
            ),
            // BottomNavigationBarItem(
            //   icon: Column(
            //     mainAxisSize: MainAxisSize.min,
            //     children: [
            //       Icon(Icons.assignment),
            //       SizedBox(height: 4),
            //       Text('Employee Register', textAlign: TextAlign.center, style: TextStyle(fontSize: 10), maxLines: 2),
            //     ],
            //   ),
            //   label: '',
            // ),
            BottomNavigationBarItem(
              icon: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person),
                  SizedBox(height: 4),
                  Text('Facility Attendance', textAlign: TextAlign.center, style: TextStyle(fontSize: 10), maxLines: 2),
                ],
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.help),
                  SizedBox(height: 4),
                  Text('Domestic \nHelp', textAlign: TextAlign.center, style: TextStyle(fontSize: 10), maxLines: 2),
                ],
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.water_drop),
                  SizedBox(height: 4),
                  Text('Water \nTank', textAlign: TextAlign.center, style: TextStyle(fontSize: 10), maxLines: 2),
                ],
              ),
              label: '',
            ),
            /*  BottomNavigationBarItem(
              icon: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.diversity_2),
                  SizedBox(height: 4),
                  Text('Guest \nApproval', textAlign: TextAlign.center, style: TextStyle(fontSize: 10)),
                ],
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.delivery_dining),
                  SizedBox(height: 4),
                  Text('Delivery \nApproval', textAlign: TextAlign.center, style: TextStyle(fontSize: 10)),
                ],
              ),
              label: '',
            ),*/
            BottomNavigationBarItem(
              icon: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.people),
                  SizedBox(height: 4),
                  Text('Visitor', textAlign: TextAlign.center, style: TextStyle(fontSize: 10), maxLines: 2),
                ],
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }

  void _showAddNewServiceSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return const DomesticTypeListFilterComponent();
      },
    );
  }
}
