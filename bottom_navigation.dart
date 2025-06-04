import 'package:biz_infra/Screens/dashboard.dart';
import 'package:biz_infra/Screens/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/AppUpdateController.dart';
import '../Utils/constants.dart';
import 'Call Guard/guard_directory_listing.dart';
import 'Profile/employee_profile.dart';
import 'Profile/profile.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  final ValueNotifier<int> _selectedIndexNotifier = ValueNotifier<int>(0);

  final List<Widget> _pages = [
    const Home(),
    const DashboardScreen(),
    const GuardDirectoryListing(),
    // (Constants.userRole == 'Super Admin' ||
    //         Constants.userRole == 'Treasury' ||
    //         Constants.userRole == 'Vice President' ||
    //         Constants.userRole == 'President' ||
    //         Constants.userRole == 'Secretary' ||
    //         Constants.userRole == 'Facility Manager' ||
    //         Constants.userRole == 'Security Supervisor' ||
    //         Constants.userRole == 'admin'||
    //         Constants.userRole == 'Plumber'||
    // )
    //     ? const EmployeeProfileScreen()
    //     : const ProfileScreen(),
    (Constants.userRole == 'Owner' || Constants.userRole == 'Tenant') ? const ProfileScreen() : const EmployeeProfileScreen(),
  ];

  Future<bool> _onWillPop() async {
    if (_selectedIndexNotifier.value != 0) {
      // Reset to the Home screen
      _selectedIndexNotifier.value = 0;
      return Future.value(false); // Prevent app from exiting
    }

    final exitApp = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Are you sure you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Exit'),
          ),
        ],
      ),
    );

    // If exitApp is false or null, prevent the pop (return nothing)
    return exitApp == true;
  }

  @override
  void initState() {
    Get.put(AppUpdateController()); // Initialize the controller

    super.initState();
  }

  @override
  void dispose() {
    _selectedIndexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: ValueListenableBuilder<int>(
          valueListenable: _selectedIndexNotifier,
          builder: (context, selectedIndex, child) {
            return _pages[selectedIndex];
          },
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4), // Shadow color with opacity
                blurRadius: 10, // Blur radius for the shadow
                offset: const Offset(0, -2), // Offset for the shadow
              ),
            ],
          ),
          child: ValueListenableBuilder<int>(
            valueListenable: _selectedIndexNotifier,
            builder: (context, selectedIndex, child) {
              return BottomNavigationBar(
                showUnselectedLabels: true,
                type: BottomNavigationBarType.fixed,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.house,
                      size: 24,
                    ),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.forum,
                      size: 24,
                    ),
                    label: 'Forum',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.engineering,
                      size: 24,
                    ),
                    label: 'Guard',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.account_circle_sharp,
                      size: 24,
                    ),
                    label: 'Profile',
                  ),
                ],
                currentIndex: selectedIndex,
                onTap: (index) {
                  _selectedIndexNotifier.value = index;
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
