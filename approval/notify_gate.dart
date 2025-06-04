import 'dart:async';
import 'package:biz_infra/Screens/approval/add_guest.dart';
import 'package:biz_infra/Themes/theme_controller.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';

import '../../CustomWidgets/configurable_widgets.dart';

class NotifyGate extends StatefulWidget {
  const NotifyGate({super.key});

  @override
  State<NotifyGate> createState() => _NotifyGateState();
}

class _NotifyGateState extends State<NotifyGate> {

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
    initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
          (List<ConnectivityResult> results) {
        _updateConnectionStatus(results);
      },
    );
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notify Gate'),
      ),
      body:_connectionStatus == null
          ? const Center(child: CircularProgressIndicator()) // Show loader initially
          : _connectionStatus!.contains(ConnectivityResult.none)
          ? checkInternetConnection(initConnectivity)
          :  SizedBox.expand(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: double.maxFinite,
                child: Container(
                  decoration: BoxDecoration(
                    color: ThemeController.selectedTheme == ThemeMode.dark ? Colors.white : Colors.black,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Text(
                    'i am expecting...'.toUpperCase(),
                    style: TextStyle(
                      color: ThemeController.selectedTheme == ThemeMode.light ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                child: Column(
                  children: [
                    // NotifyOptionTile(
                    //   iconImage: 'assets/images/delivary.png',
                    //   subtitle: 'Pre-approved expected delivery entry',
                    //   title: 'Delivery',
                    //   pageRoute: PreApproveDelivery(),
                    // ),
                    // // TileDivider(),
                    // Divider(),
                    NotifyOptionTile(
                      iconImage: 'assets/images/guest.png',
                      subtitle: 'Pre-approved expected guest entry',
                      title: 'Guest',
                      pageRoute: AddGuest(),
                    ),
                  ],
                ),
              ),
              // Container(
              //   color: ThemeController.selectedTheme == ThemeMode.dark ? Colors.white : Colors.black,
              //   padding: const EdgeInsets.symmetric(
              //     horizontal: 16.0,
              //     vertical: 8.0,
              //   ),
              //   width: double.maxFinite,
              //   child: Text(
              //     'I have given somthing to...',
              //     style: TextStyle(
              //       color: ThemeController.selectedTheme == ThemeMode.light ? Colors.white : Colors.black,
              //     ),
              //   ),
              // ),
              // const SizedBox(
              //   child: Column(
              //     children: [
              //       NotifyOptionTile(
              //         iconImage: 'assets/images/myguest.png',
              //         title: 'My Guests',
              //         subtitle: 'Guest inside currently',
              //         pageRoute: MyVisitors(),
              //       ),
              //       // TileDivider(),
              //       Divider(),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotifyOptionTile extends StatefulWidget {
  const NotifyOptionTile({
    super.key,
    required this.iconImage,
    required this.subtitle,
    required this.title,
    required this.pageRoute,
  });

  final String iconImage;
  final String subtitle;
  final String title;
  final Widget pageRoute;

  @override
  State<NotifyOptionTile> createState() => _NotifyOptionTileState();
}

class _NotifyOptionTileState extends State<NotifyOptionTile> {
  void _navigateToAddGuest() {
    Get.to(
      () => widget.pageRoute,
      popGesture: true,
      transition: Transition.rightToLeft,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 1.0,
      ),
      child: ListTile(
        leading: Image.asset(
          widget.iconImage,
          height: 48.0,
          width: 48.0,
        ),
        onTap: _navigateToAddGuest,
        subtitle: Text(
          widget.subtitle,
          style: const TextStyle(
            fontSize: 12.0,
          ),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 15.0,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          size: 40.0,
        ),
      ),
    );
  }
}

class TileDivider extends StatelessWidget {
  const TileDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 0.5,
      width: double.maxFinite,
      child: DecoratedBox(
        decoration: BoxDecoration(),
      ),
    );
  }
}
