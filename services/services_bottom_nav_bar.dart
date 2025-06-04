import 'package:biz_infra/Screens/services/my_bookings.dart';
import 'package:biz_infra/Screens/services/services_home.dart';
import 'package:biz_infra/Screens/services/support.dart';
import 'package:biz_infra/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class ServiceBottomNavBar extends StatefulWidget {
  const ServiceBottomNavBar({super.key});

  @override
  State createState() => _ServiceBottomNavBarState();
}

class _ServiceBottomNavBarState extends State<ServiceBottomNavBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const ServicesHome(),
    const MyBookings(),
    const Support()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
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
        child: StylishBottomBar(
          items: [
            BottomBarItem(
              icon: const Icon(
                Icons.home,
                size: 24,
              ),
              selectedColor: Constants.primaryColor,
              unSelectedColor: Colors.black,
              title: const Text('Home', style: TextStyle(fontSize: 10.0)),
            ),
            BottomBarItem(
              icon: const Icon(
                Icons.calendar_month_outlined,
                size: 24,
              ),
              selectedColor: Constants.primaryColor,
              unSelectedColor: Colors.black,
              title: const Text('My Bookings', style: TextStyle(fontSize: 10.0)),
            ),
            BottomBarItem(
              icon: const Icon(
                Icons.question_mark_outlined,
                size: 24,
              ),
              selectedColor: Constants.primaryColor,
              unSelectedColor: Colors.black,
              title: const Text('Support', style: TextStyle(fontSize: 10.0)),
            ),
          ],
          hasNotch: true,
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          option: AnimatedBarOptions(
            barAnimation: BarAnimation.transform3D,
            iconSize: 30,
            opacity: 0.3,
          ),
        ),
      ),
    );
  }
}