import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'bottom_navigation.dart';
import 'coming_soon.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return ComingSoon(
      appBarText: 'Forum',
      leading: true,
      onLeadingIconPressed: () {
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const BottomNavigation(),
          ),
        );      },
    );
  }
}
