import 'dart:developer';
import 'package:biz_infra/Network/dio_service_client.dart';
import 'package:biz_infra/Screens/security_guard/guard_scan_screen.dart';
import 'package:biz_infra/Themes/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Utils/app_images.dart';
import '../../Utils/app_styles.dart';
import '../../Utils/constants.dart';
import '../DomesticHelp/domestic_help_profile_screen.dart';
import '../WaterTank/water_tank_details.dart';
import '../registration/employee_registration/employee_registration_list.dart';
import '../supervisor_approval/supervisor_guest_approval.dart';
import 'guard_patrolling.dart';

class GuardEnterScreen extends StatefulWidget {
  final void Function(int, String)? onCallBck;

  const GuardEnterScreen({super.key, this.onCallBck});

  @override
  State<GuardEnterScreen> createState() => _GuardEnterScreenState();
}

class _GuardEnterScreenState extends State<GuardEnterScreen> {
  final ThemeController _themeController = Get.find<ThemeController>();

  List<String> enteredCode = [];

  Future<void> _onKeyPressed(String value) async {
    if (value == 'back' && enteredCode.isNotEmpty) {
      enteredCode.removeLast();
    } else if (value == 'QR') {
      log("message");
      Get.to(() => GuardQRCodeScanner(
            onCallBck: (p0, s) {
              widget.onCallBck!(p0, s);
              setState(() {});
            },
          ));
    } else if (value != 'back' && value != 'QR' && enteredCode.length < 6) {
      enteredCode.add(value);
      if (enteredCode.length == 6) {
        await Future.delayed(const Duration(milliseconds: 100)).then((v) async {
          await dioServiceClient.passcodeVerifyApi(passcode: enteredCode.join()).then((e) {
            log(e!.data!.moduleName.toString());
            if (e.statuscode == 1 && e.data != null && e.data!.moduleName == Constants.domesticHelp) {
              Get.to(() => DomesticHelpProfileScreen(), arguments: {'recordId': e.data!.domesticHelpId, 'isAllowInOut': true});
            } else if (e.statuscode == 1 && e.data != null && e.data!.moduleName == Constants.waterTank) {
              Get.to(() => WaterTankDetails(waterTankId: e.data!.watertankid!, isAllowInOut: true));
            } else if (e.statuscode == 1 && e.data != null && e.data!.moduleName == Constants.visitorsModule) {
              Get.back();
              widget.onCallBck!(Constants.appBarNameList.indexOf('Visitor'), e.data!.visitorId.toString());
            } else {
              Get.back();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(e.statusMessage.toString())),
              );
            }
            enteredCode.clear();
          }).catchError((e) {
            log("Error $e");
          });
        });
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(6, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: index < enteredCode.length
                          ? Text(enteredCode[index], style: Styles.textLargeBoldLabel)
                          : Container(
                              height: 2,
                              width: 20,
                              color: _themeController.currentTheme.value == ThemeMode.dark ? Colors.white : Colors.black38,
                            ),
                    );
                  }),
                ),
              ),
              // Keypad
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < 3; i++)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (j) {
                        int number = i * 3 + j + 1;
                        return _keypadButton(number.toString());
                      }),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _keypadButton('QR', icon: Icons.document_scanner_outlined),
                      _keypadButton('0'),
                      _keypadButton('back', icon: Icons.backspace),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Wrap(
            spacing: 8,
            children: [
              homeCardWidget(
                label: 'Employees',
                image: icEmployee,
                onCall: () {
                  Get.to(() => const EmployeeRegistrationList());
                },
              ),
              homeCardWidget(
                label: 'Guest Approval',
                image: icGuestsApproval,
                onCall: () {
                  Get.to(() => const SupervisorGuestApproval());
                },
              ),
              homeCardWidget(
                label: 'Patrolling',
                image: icPatrolling,
                onCall: () {
                  Get.to(() => GuardPatrolling());
                },
              ),
            ],
          )
        ],
      );
    });
  }

  Widget _keypadButton(String label, {IconData? icon}) {
    return GestureDetector(
      onTap: () => _onKeyPressed(label),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 60,
          alignment: Alignment.center,
          width: 60,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: 0.6,
                color: _themeController.currentTheme.value == ThemeMode.dark ? Colors.white : Colors.black38,
              )),
          child: icon != null ? Icon(icon) : Text(label, style: Styles.textLargeBoldLabel),
        ),
      ),
    );
  }

  Widget homeCardWidget({required String? image, required String? label, required Function onCall}) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 56) / 4,
      child: IconButton(
        onPressed: () {
          onCall();
        },
        icon: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 55,
              height: 60,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 228, 221, 221),
                shape: BoxShape.rectangle, // Makes the container rounded
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Center(
                child: Image.asset(image!, height: 36),
              ),
            ),
            const SizedBox(height: 4.0),
            Text(label!, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
