import 'dart:async';
import 'dart:ui' show ImageByteFormat;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:biz_infra/Network/dio_service_client.dart';
// import 'package:biz_infra/Network/end_points.dart';
import 'package:biz_infra/Screens/approval/my_visitors.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:share_plus/share_plus.dart';

import '../../CustomWidgets/configurable_widgets.dart';
import '../../Themes/theme_controller.dart';
import '../../Utils/constants.dart';
// import '../../Utils/constants.dart';

class InviteGuest extends StatefulWidget {
  final String name;
  final String number;
  final String? recordId;
  final String? sDate;
  final String? sTime;
  final String? vldTime;

  const InviteGuest({
    super.key,
    required this.name,
    required this.number,
    this.recordId,
    this.sDate,
    this.sTime,
    this.vldTime,
  });

  @override
  State<InviteGuest> createState() => _InviteGuestState();
}

class _InviteGuestState extends State<InviteGuest> {
  List<ConnectivityResult>? _connectionStatus; // Make it nullable
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;


  // selected date
  final _selectedDate1 = ValueNotifier<String>('');

  // selected time
  final _selectedTime1 = ValueNotifier<String>('');

  // selected duration
  final _selectedDuration1 = ValueNotifier<String>('');
  final _selectedDurationIndex = ValueNotifier<int>(-1);
  final _durations = <String>[
    '1 Hour',
    '2 Hour',
    '4 Hour',
    '8 Hour',
    '12 Hour',
    '24 Hour',
  ];

  DateTime _getDate(String dt) {
    final cd = DateTime.now();
    if (dt.toLowerCase() == 'today') {
      return cd;
    } else if (dt.toLowerCase() == 'tomorrow') {
      return cd.add(const Duration(days: 1));
    } else {
      return DateFormat('dd MMM y').parse(dt);
    }
  }

  DateTime _getTime(String t) {
    return DateFormat('hh:mm a').parse(t);
  }

  bool get _isCorrectDateTimeDuration {
    final now = DateTime.now();
    final isToday = _selectedDate1.value.toLowerCase() == 'today';
    final laterTime = _getTime(_selectedTime1.value)
        .copyWith(year: now.year, month: now.month, day: now.day);
    final isLaterTime = (laterTime.hour * 60 + laterTime.minute) >=
        (now.hour * 60 + now.minute);
    final indexNotNegative = _selectedDurationIndex.value != -1;
    if (isToday && isLaterTime && indexNotNegative) {
      return true;
    } else if (!isToday && indexNotNegative) {
      return true;
    }
    return false;
  }

  Future<void> _inviteGuest() async {
    if (_isCorrectDateTimeDuration) {
      final dt = _getDate(_selectedDate1.value);
      final tod = _getTime(_selectedTime1.value);
      final result1 = await dioServiceClient.addInviteGuest(
        name: widget.name,
        mobile: widget.number,
        date: DateFormat('dd-MM-y').format(dt),
        time: DateFormat('HH:mm:ss').format(tod),
        validity: _durations.elementAt(_selectedDurationIndex.value),
        recordId: widget.recordId,
      );
      if (result1.statuscode == 1 && widget.recordId == null) {
        final visitor = result1.data;
        if (visitor != null) {
          final id = visitor.id!.split('x').last;
          final result2 = await dioServiceClient.generateVisitorPasscode(
            visitorId: id,
            visitorName: widget.name,
            visitorMobile: widget.number,
          );
          if (result2.statuscode == 1) {
            final code = result2.data;
            if (code != null) {
              _gotoMyVisitorsListing();
              _invitation(
                code.qrcodePath!,
                code.passcode!,
                DateFormat('dd MMM y').format(dt),
                DateFormat('HH:mm:ss').format(tod),
                _selectedDuration1.value,
              );
            }
          }
        }
      } else {
        _gotoMyVisitorsListing();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Please pick a time later than the current time.'),
        ),
      );
    }
  }

  void _gotoMyVisitorsListing() {
    Get.close(1);
    Get.off(
      () => const MyVisitors(),
      popGesture: true,
      transition: Transition.rightToLeft,
    );
  }

  void _invitation(
    String qrImagePath,
    String otp,
    String passDate,
    String passTime,
    String interval,
  )
  {
    displayPassDialog(
      context: context,
      qrImagePath: qrImagePath,
      passcode: otp,
      validDate: passDate,
      validTime: passTime,
      validInterval: interval,
    );
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      currentDate: now,
      firstDate: now,
      initialDate: now,
      lastDate: DateTime(now.year + 1, now.month),
    );
    if (pickedDate != null) {
      if (pickedDate.day == now.day) {
        _selectedDate1.value = 'Today';
      } else if (pickedDate.day == now.add(const Duration(days: 1)).day) {
        _selectedDate1.value = 'Tomorrow';
      } else {
        _selectedDate1.value = DateFormat('dd MMM y').format(pickedDate);
      }
    }
  }

  Future<void> _selectTime() async {
    final now = TimeOfDay.now();
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: now,
    );
    if (pickedTime != null && mounted) {
      final isToday = _selectedDate1.value.toLowerCase() == 'today';
      final currentTimeInMinutes = now.hour * 60 + now.minute;
      final pickedTimeInMinutes = pickedTime.hour * 60 + pickedTime.minute;
      if (isToday && pickedTimeInMinutes >= currentTimeInMinutes) {
        _selectedTime1.value = pickedTime.format(context);
      } else if (!isToday) {
        _selectedTime1.value = pickedTime.format(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Please pick a time later than the current time.'),
          ),
        );
      }
    }
  }

  Future<void> _selectDuration() async {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return Material(
          child: SizedBox(
            width: double.maxFinite,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ValueListenableBuilder(
                valueListenable: _selectedDurationIndex,
                builder: (context, sDIndex, child) {
                  return GridView.count(
                    childAspectRatio: 2,
                    crossAxisCount: 3,
                    hitTestBehavior: HitTestBehavior.deferToChild,
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    children: _durations.indexed.map((element) {
                      return ChoiceChip(
                        label: Text(
                          element.$2,
                          style: const TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                        onSelected: (value) {
                          if (sDIndex != element.$1) {
                            Navigator.pop(context);
                          }
                          bool b = _selectedDurationIndex.value != element.$1;
                          int i = b ? element.$1 : -1;
                          _selectedDurationIndex.value = i;
                          _selectedDuration1.value = element.$2;
                        },
                        selected: element.$1 == sDIndex,
                        selectedColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(color: ThemeController.selectedTheme == ThemeMode.dark ? Colors.white : Colors.black,),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _initializeData() {
    _selectedDate1.value = widget.sDate ?? 'Today';
    _selectedTime1.value = DateFormat('hh:mm a').format(widget.sTime != null
        ? DateFormat('HH:mm:ss').parse(widget.sTime!)
        : DateTime.now());
    _selectedDurationIndex.value =
        widget.vldTime != null ? _durations.indexOf(widget.vldTime!) : 1;
    _selectedDuration1.value = _durations.elementAt(
        widget.vldTime != null ? _durations.indexOf(widget.vldTime!) : 1);
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
    _initializeData();
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
        title: const Text('Invite Guest'),
      ),
      body: _connectionStatus == null
          ? const Center(child: CircularProgressIndicator()) // Show loader initially
          : _connectionStatus!.contains(ConnectivityResult.none)
          ? checkInternetConnection(initConnectivity)
          : Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: ThemeController.selectedTheme == ThemeMode.dark ? Colors.white : Colors.black,
            ),
            width: double.maxFinite,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Guest Name',
                style: TextStyle(
                  color: ThemeController.selectedTheme == ThemeMode.light ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(
            child: Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.all(10.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(widget.name),
                ),
              ),
            ),
          ),
          SizedBox(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: ThemeController.selectedTheme == ThemeMode.dark ? Colors.white : Colors.black,
                  ),
                  width: double.maxFinite,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Choose Date',style: TextStyle(color: ThemeController.selectedTheme == ThemeMode.light ? Colors.white : Colors.black,),),
                  ),
                ),
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 10.0,
                    ),
                    child: ValueListenableBuilder(
                      valueListenable: _selectedDate1,
                      builder: (context, sDate, child) {
                        return DataCard(
                          label: 'Select Date',
                          icon: Icons.today_rounded,
                          data: sDate,
                          onPressed: _selectDate,
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 10.0,
                    ),
                    child: Row(
                      children: [
                        ValueListenableBuilder(
                          valueListenable: _selectedTime1,
                          builder: (context, sTime, child) {
                            return Expanded(
                              child: DataCard(
                                label: 'Starting Time',
                                icon: Icons.schedule_rounded,
                                data: sTime,
                                onPressed: _selectTime,
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 5.0),
                        ValueListenableBuilder(
                          valueListenable: _selectedDuration1,
                          builder: (context, sDuration, child) {
                            return Expanded(
                              child: DataCard(
                                label: 'Valid for',
                                icon: Icons.schedule_rounded,
                                data: sDuration,
                                onPressed: _selectDuration,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          bottom: 16.0,
          left: 16.0,
          right: 16.0,
        ),
        child: ElevatedButton(
          onPressed: _inviteGuest,
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
          child: const Text('Invite Guest'),
        ),
      ),
    );
  }
}

class DataCard extends StatefulWidget {
  const DataCard({
    super.key,
    required this.label,
    required this.data,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final String data;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  State<DataCard> createState() => _DataCardState();
}

class _DataCardState extends State<DataCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 8.0,
          ),
          child: Text(
            widget.label,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Card(
          child: InkWell(
            onTap: widget.onPressed,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Text(
                    widget.data,
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(widget.icon),
                    onPressed: widget.onPressed,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Passcode Dialog
void displayPassDialog({
  required BuildContext context,
  required String qrImagePath,
  required String passcode,
  required String validDate,
  required String validTime,
  required String validInterval,
}) {
  final repaintBoundaryKey = GlobalKey();
  final media = MediaQuery.of(context);

  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return PasscodeShareDialog(
        repaintBoundaryKey: repaintBoundaryKey,
        media: media,
        qrImagePath: qrImagePath,
        passcode: passcode,
        validDate: validDate,
        validTime: validTime,
        validInterval: validInterval,
      );
    },
  );
}

class PasscodeShareDialog extends StatelessWidget {
  const PasscodeShareDialog({
    super.key,
    required this.repaintBoundaryKey,
    required this.media,
    required this.qrImagePath,
    required this.passcode,
    required this.validDate,
    required this.validTime,
    required this.validInterval,
  });

  final GlobalKey repaintBoundaryKey;
  final MediaQueryData media;
  final String qrImagePath;
  final String passcode;
  final String validDate;
  final String validTime;
  final String validInterval;

  String get _validDateInterval {
    final dt = DateFormat('dd MMM y HH:mm:ss').parse('$validDate $validTime');
    final start = DateFormat('d MMMM y, h:mm a').format(dt);
    final duration = int.parse(validInterval.split(' ').first);
    final end = DateFormat('d MMMM y, h:mm a').format(
      dt.add(Duration(hours: duration)),
    );
    return '$start\nto $end';
  }

  @override
  Widget build(BuildContext context) {
    print('Theme:- ${ThemeController.selectedTheme}');
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 10.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              color: Colors.white,
              icon: const Icon(Icons.close_rounded),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          RepaintBoundary(
            key: repaintBoundaryKey,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: ThemeController.selectedTheme == ThemeMode.dark ? Colors.white : Colors.black,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 10.0,
                      ),
                      child: Text(
                        'Owner has invited you',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: ThemeController.selectedTheme == ThemeMode.light ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 10.0,
                      ),
                      child: Text(
                        'Show this QR code or OTP\nto the guard at gate',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: ThemeController.selectedTheme == ThemeMode.light ? Colors.white : Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        qrImagePath,
                        cacheHeight: 100,
                        cacheWidth: 100,
                        fit: BoxFit.contain,
                        height: 100.0,
                        width: 100.0,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            int? totalBytes =
                                loadingProgress.expectedTotalBytes;
                            int bytesLoaded =
                                loadingProgress.cumulativeBytesLoaded;
                            return Center(
                              child: CircularProgressIndicator(
                                value: totalBytes != null
                                    ? bytesLoaded / totalBytes
                                    : null,
                              ),
                            );
                          }
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.hide_image_outlined,
                                color: Colors.red,
                                size: 30.0,
                              ),
                              Text(
                                'No Preview',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12.0,
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                      ),
                      child: SizedBox(
                        width: 100.0,
                        child: Row(
                          children: [
                            const Expanded(
                              child: Divider(),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                              ),
                              child: Text(
                                'OR',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: ThemeController.selectedTheme == ThemeMode.light ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                            const Expanded(
                              child: Divider(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        const SizedBox(
                          height: 20.0,
                          width: 150.0,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.indigo,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 140.0,
                          child: DecoratedBox(
                            decoration: const BoxDecoration(
                              color: Colors.indigo,
                            ),
                            child: Center(
                              child: Text(
                                passcode,
                                style: const TextStyle(
                                  // color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                      ),
                      child: Text(
                        _validDateInterval,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: ThemeController.selectedTheme == ThemeMode.light ? Colors.white : Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                      ),
                      child: AutoSizeText(
                        "${Constants.societyName}, ${Constants.societyBlock}, ${Constants.societyNumber}, ${Constants.address}",
                        style: TextStyle(
                          fontSize: 14.0,
                          color: ThemeController.selectedTheme == ThemeMode.light ? Colors.white : Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.asset(
                          'assets/images/infraLogo.png',
                          fit: BoxFit.contain,
                          height: 100.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 10.0,
            ),
            child: Text(
              'Share this invite with your guest for hassle-free entry',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            child: ElevatedButton(
              onPressed: () {
                _shareCapturedImage(
                  repaintKey: repaintBoundaryKey,
                  pixelRatio: media.devicePixelRatio,
                  passCode: passcode,
                );
              },
              style: ButtonStyle(
                padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(
                    vertical: 16.0,
                  ),
                ),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              child: const Text(
                'Share',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Share Content
Future<void> _shareCapturedImage({
  required GlobalKey repaintKey,
  required double pixelRatio,
  required String passCode,
}) async {
  try {
    final repaintContext = repaintKey.currentContext;
    if (repaintContext != null) {
      final boundary = repaintContext.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: pixelRatio);
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      if (byteData != null) {
        final pngBytes = byteData.buffer.asUint8List();
        final content = "Hello visitor, "
            "Owner has invited you to "
            "${Constants.societyName}, ${Constants.societyBlock}, ${Constants.societyNumber}. "
            "Your Passcode: $passCode.\n"
            "Please show this passcode to the security "
            "at the gate for hassle free entry.";
        await Share.shareXFiles(
          [
            XFile.fromData(
              pngBytes,
              mimeType: 'image/png',
              name: 'passcode.png',
            ),
          ],
          subject: 'Visitors Passcode',
          text: content,
        );
      }
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}
