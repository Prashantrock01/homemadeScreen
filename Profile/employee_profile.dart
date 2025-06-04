import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:biz_infra/CustomWidgets/configurable_widgets.dart';
import 'package:biz_infra/Utils/app_styles.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../CustomWidgets/image_view.dart';
import '../../Network/dio_service_client.dart';
import '../../Utils/constants.dart';
import '../../company_code.dart';
import '../CustomerCare/customerCare_list.dart';
import '../bottom_navigation.dart';
import '../owner_tenant_registration/change_password.dart';
import 'employee_edit_email.dart';

class EmployeeProfileScreen extends StatefulWidget {
  const EmployeeProfileScreen({super.key});

  @override
  EmployeeProfileScreenState createState() => EmployeeProfileScreenState();
}

class EmployeeProfileScreenState extends State<EmployeeProfileScreen> {
  String? email;
  XFile? pickedFile;
  XFile? _image;
  final ImagePicker _imagePicker = ImagePicker();
  bool hasInternetConnection = true;

  void showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('Are you sure you want to delete your account?'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              var employeeProfileData = await dioServiceClient.employeeDeleteProfile();
              if (employeeProfileData!.statuscode == 1) {
                Get.offAll(() => const CompanyCode());
              }
            },
            child: const Text('Delete Account', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  pickAnImageFromCamera() async {
    pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile!.path);
        //print("UPLOADINGIMAGE");
        //print(_image!.path.toString());
      });
    }
  }

  Future<void> _getImageFromGallery() async {
    final pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = XFile(pickedImage.path);
      });
    }
  }

  checkInternetConnection() async {
    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
    setState(() {
      isConnected = connectivityResult.contains(ConnectivityResult.mobile) || connectivityResult.contains(ConnectivityResult.wifi) || connectivityResult.contains(ConnectivityResult.ethernet);
    });
  }

  @override
  void initState() {
    super.initState();
    checkInternetConnection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          title: const Text('Profile'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Constants.userRole == "Security Supervisor"
                  ? Get.back()
                  : Navigator.pushReplacement<void, void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const BottomNavigation(),
                      ),
                    );
            },
          ),
          actions: [
            PopupMenuButton<String>(
              onSelected: (String value) {
                if (value == 'Customer Care') {
                  Get.to(() => const CustomerCare());
                } else if (value == 'Delete Account') {
                  showDeleteDialog();
                } else if (value == 'Terms & Condition') {
                  launchExternalWebsite(Uri.parse('https://bizinfratech.in/terms-and-conditions'));
                } else if (value == 'Privacy Policy') {
                  launchExternalWebsite(Uri.parse('https://bizinfratech.in/privacy-policy'));
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem(
                  value: 'Customer Care',
                  child: Text('Customer Care'),
                ),
                const PopupMenuItem(
                  value: 'Delete Account',
                  child: Text('Delete Account'),
                ),
                const PopupMenuItem(
                  value: 'Terms & Condition',
                  child: Text('Terms & Condition'),
                ),
                const PopupMenuItem(
                  value: 'Privacy Policy',
                  child: Text('Privacy Policy'),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder(
          future: dioServiceClient.employeeProfile(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: Get.height / 3.5),
                    const Text(
                      'Something went wrong, Try after sometime',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    const Spacer(),
                    buildActionButtons(showChangePassword: false),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            } else if (snapshot.hasData) {
              Constants.userImage = snapshot.data!.data!.profileInfo?.imagename.toString() ?? "";
              return Column(
                children: [
                  Stack(children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.white70,
                      child: hasInternetConnection
                          ? (Constants.userImage != "null" && Constants.userImage.isNotEmpty)
                              ? InkWell(
                                  onTap: () async {
                                    File file = await getFile(Constants.userImage, "${snapshot.data!.data!.profileInfo!.empImagefile}profileImage");
                                    Get.to(() => ImageViewScreen(imageFile: file));
                                  },
                                  child: ClipOval(
                                    child: Image.network(
                                      Constants.userImage.toString(),
                                      fit: BoxFit.cover,
                                      width: 140,
                                      height: 140,
                                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                                          ),
                                        );
                                      },
                                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                        // Fallback in case of network error or invalid URL
                                        return CircleAvatar(
                                          radius: 70,
                                          backgroundColor: Colors.white70,
                                          child: ClipOval(
                                            child: Padding(
                                              padding: const EdgeInsets.all(20.0),
                                              child: Image.asset(
                                                'assets/images/41.png',
                                                fit: BoxFit.cover,
                                                width: 140,
                                                height: 140,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 70,
                                  backgroundColor: Colors.white70,
                                  child: ClipOval(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Image.asset(
                                        'assets/images/41.png',
                                        fit: BoxFit.cover,
                                        width: 140,
                                        height: 140,
                                      ),
                                    ),
                                  ),
                                )
                          : CircleAvatar(
                              radius: 70,
                              backgroundColor: Colors.white70,
                              child: ClipOval(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Image.asset(
                                    'assets/images/41.png',
                                    fit: BoxFit.cover,
                                    width: 140,
                                    height: 140,
                                  ),
                                ),
                              ),
                            ),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Theme.of(context).brightness == Brightness.light ? Colors.grey.shade300 : Colors.grey.shade900,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        ListTile(
                                          leading: const Icon(Icons.camera_alt),
                                          title: const AutoSizeText("Capture a Photo"),
                                          onTap: () async {
                                            // EasyLoading.show();
                                            // await _getImageFromCamera();
                                            await pickAnImageFromCamera();
                                            await dioServiceClient.profileUploadAttachment(fieldName: 'emp_imagefile', empImageName: _image!, module: 'Users');
                                            setState(() {
                                              Constants.userImage = Constants.userImage;
                                            });
                                            // EasyLoading.dismiss();
                                            Get.back();
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.photo),
                                          title: const AutoSizeText("Select from Gallery"),
                                          onTap: () async {
                                            //   EasyLoading.show();
                                            await _getImageFromGallery();
                                            await dioServiceClient.profileUploadAttachment(fieldName: 'emp_imagefile', empImageName: _image!, module: 'Users');
                                            setState(() {
                                              Constants.userImage = Constants.userImage;
                                            });
                                            //   EasyLoading.dismiss();
                                            Get.back();
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            },
                          ),
                        )),
                  ]),
                  const SizedBox(height: 30),

                  // Profile Details Section
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Constants.userRole == "Super Admin" ? keyValue('User Id', Constants.email) : keyValue('User Id', snapshot.data!.data!.profileInfo!.badgeNo.toString()),
                            keyValue('Name', snapshot.data!.data!.profileInfo!.serviceEngineerName.toString()),
                            keyValue('Phone Number', snapshot.data!.data!.profileInfo!.phone.toString()),
                            keyValue(
                              'Email',
                              snapshot.data!.data!.profileInfo!.email.toString(),
                              trailingIcon: InkWell(
                                onTap: () {
                                  Get.to(() => EmployeeEditEmailScreen(email: snapshot.data!.data!.profileInfo!.email.toString()));
                                },
                                child: const Padding(
                                  padding: EdgeInsets.only(right: 20.0),
                                  child: Icon(Icons.edit, size: 20),
                                ),
                              ),
                            ),
                            keyValue('Society Name', snapshot.data!.data!.profileInfo!.empSociety.toString()),
                            keyValue('Block', Constants.userRole == 'Super Admin' ? 'Common Area' : snapshot.data!.data!.profileInfo!.empBlock.toString()),
                            keyValue(
                              'Address',
                              Constants.address,
                            ),
                            keyValue('Aadhar No', snapshot.data!.data!.profileInfo!.aadharNo.toString()),
                            keyValue('I\'am', snapshot.data!.data!.profileInfo!.subServiceManagerRole.toString()),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  buildActionButtons(showChangePassword: true),
                  const SizedBox(height: 12),
                  Center(
                    child: FutureBuilder<PackageInfo>(
                      future: PackageInfo.fromPlatform(),
                      builder: (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
                        if (snapshot.hasData) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Version: ',
                                style: Styles.textBoldLabel,
                              ),
                              Text('${snapshot.data!.version}'),
                            ],
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                  ),
                ],
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }

  /// Builds Action Buttons
  Widget buildActionButtons({required bool showChangePassword}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (showChangePassword)
          Expanded(
            child: textButton(onPressed: () => Get.to(() => const ChangePasswordScreen()), widget: const Text("Change Password")),
          ),
        if (showChangePassword) const SizedBox(width: 8),
        Expanded(child: textButton(widget: const Text("Logout"), onPressed: _showLogoutDialog)),
      ],
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout', textAlign: TextAlign.center),
          content: const Text('Are you sure you want to logout?', textAlign: TextAlign.center),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  onPressed: () async {
                    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                    sharedPreferences.clear();
                    Get.offAll(
                      () => const CompanyCode(),
                      transition: Transition.rightToLeft,
                      popGesture: true,
                    );
                  },
                  child: const Text('Yes', style: TextStyle(color: Colors.blue)),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('No', style: TextStyle(color: Colors.blue)),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  Widget keyValue(String key, String value, {Widget? trailingIcon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: AutoSizeText(
              key,
              minFontSize: 14.0,
              style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
              textAlign: TextAlign.left,
            ),
          ),
          const AutoSizeText(':'), // Separator
          const SizedBox(width: 10),
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Expanded(
                  child: AutoSizeText(
                    value,
                    minFontSize: 14.0,
                    style: const TextStyle(fontSize: 14.0),
                    textAlign: TextAlign.left,
                  ),
                ),
                if (trailingIcon != null) ...[
                  const SizedBox(width: 5), // Optional spacing between text and icon
                  trailingIcon,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
