import 'package:biz_infra/Screens/approval/my_visitors.dart';
import 'package:biz_infra/Themes/theme_controller.dart';
import 'package:biz_infra/Utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

final _isNotSecuritySupervisor = Constants.userRole != 'Security Supervisor';

class GuestApprovalRingerPopup extends StatelessWidget {
  const GuestApprovalRingerPopup({
    super.key,
    required this.guestName,
    required this.block,
    required this.societyNo,
  });

  final String guestName;
  final String block;
  final String societyNo;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return Dialog.fullscreen(
      backgroundColor: ThemeController.selectedTheme == ThemeMode.dark
          ? Colors.black
          : Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              bottom: 10.0,
            ),
            child: SizedBox(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: ThemeController.selectedTheme == ThemeMode.dark
                      ? Colors.grey.shade800
                      : Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.account_circle,
                    size: 40.0,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: media.size.width * 0.8,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: ThemeController.selectedTheme == ThemeMode.dark
                    ? Colors.grey.shade800
                    : Colors.grey.shade200,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 20.0,
                      ),
                      child: Text(
                        _isNotSecuritySupervisor
                            ? 'Guest is waiting at the gate'
                            : 'Wating For Approval',
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.mood,
                          size: 50.0,
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              guestName,
                              style: const TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            Text(
                              '$block - $societyNo',
                              style: const TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: _isNotSecuritySupervisor,
            child: SizedBox(
              width: media.size.width * 0.9,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () => _onDeny(context),
                      child: Column(
                        children: [
                          SizedBox.square(
                            dimension: 40.0,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Colors.red,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const Text('Deny'),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () => _onAccept(context),
                      child: Column(
                        children: [
                          SizedBox.square(
                            dimension: 40.0,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Colors.green,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const Text('Accept'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onDeny(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const MyVisitors(
            initialTabIndex: 3,
          );
        },
      ),
    );
    Fluttertoast.showToast(
      msg: 'Denied by Yashil',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void _onAccept(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const MyVisitors(
            initialTabIndex: 2,
          );
        },
      ),
    );
    Fluttertoast.showToast(
      msg: 'Accepted by Yashil',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

class DeliveryApprovalRingerPopup extends StatelessWidget {
  const DeliveryApprovalRingerPopup({
    super.key,
    required this.deliveryName,
    required this.deliveryCompany,
    required this.block,
    required this.societyNo,
  });

  final String deliveryName;
  final String deliveryCompany;
  final String block;
  final String societyNo;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return Dialog.fullscreen(
      backgroundColor: ThemeController.selectedTheme == ThemeMode.dark
          ? Colors.black
          : Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              bottom: 10.0,
            ),
            child: SizedBox(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: ThemeController.selectedTheme == ThemeMode.dark
                      ? Colors.grey.shade800
                      : Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.local_shipping,
                    size: 40.0,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: media.size.width * 0.8,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: ThemeController.selectedTheme == ThemeMode.dark
                    ? Colors.grey.shade800
                    : Colors.grey.shade200,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 20.0,
                      ),
                      child: Text(
                        _isNotSecuritySupervisor
                            ? 'Delivery staff is waiting at the gate'
                            : 'Waiting For Approval',
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.mood,
                          size: 50.0,
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              deliveryName,
                              style: const TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            Text(
                              '$block - $societyNo',
                              style: const TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            Text(
                              deliveryCompany,
                              style: const TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: _isNotSecuritySupervisor,
            child: SizedBox(
              width: media.size.width * 0.9,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () => _onDeny(context),
                      child: Column(
                        children: [
                          SizedBox.square(
                            dimension: 40.0,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Colors.red,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const Text('Deny'),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () => _onCollectParcel(context),
                      child: Column(
                        children: [
                          SizedBox.square(
                            dimension: 40.0,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Colors.amber,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.inventory_2,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const Text('Collect Parcel'),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () => _onAccept(context),
                      child: Column(
                        children: [
                          SizedBox.square(
                            dimension: 40.0,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Colors.green,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const Text('Approve'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onDeny(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const MyVisitors(
            initialTabIndex: 3,
          );
        },
      ),
    );
    Fluttertoast.showToast(
      msg: 'Denied by Yashil',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void _onCollectParcel(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const MyVisitors(
            initialTabIndex: 1,
          );
        },
      ),
    );
    Fluttertoast.showToast(
      msg: 'Parcel collected at gate',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void _onAccept(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const MyVisitors(
            initialTabIndex: 1,
          );
        },
      ),
    );
    Fluttertoast.showToast(
      msg: 'Accepted by Yashil',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
