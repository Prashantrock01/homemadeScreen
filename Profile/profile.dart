import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:biz_infra/company_code.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../CustomWidgets/configurable_widgets.dart';
import '../../CustomWidgets/image_view.dart';
import '../../Network/dio_service_client.dart';
import '../../Utils/app_styles.dart';
import '../../Utils/constants.dart';
import '../CustomerCare/customerCare_list.dart';
import '../bottom_navigation.dart';
import '../owner_tenant_registration/change_password.dart';
import 'edit_email.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  bool isConnected = true;
  XFile? _image;

  @override
  void initState() {
    super.initState();
    checkInternetConnection();
  }

  Future<void> checkInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      isConnected = connectivityResult.contains(ConnectivityResult.mobile) || connectivityResult.contains(ConnectivityResult.wifi) || connectivityResult.contains(ConnectivityResult.ethernet);
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await _imagePicker.pickImage(source: source);
    if (pickedImage != null) {
      _image = pickedImage;
      await dioServiceClient.ownerProfileUploadAttachment(
        fieldName: 'emp_imagefile',
        ownerImageName: _image!,
        module: 'Users',
      );
      setState(() {});
    }
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('Are you sure you want to delete your account?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              dioServiceClient.employeeDeleteProfile();
              Get.offAll(() => const CompanyCode());
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
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
                    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                    sharedPreferences.clear();
                    Get.offAll(() => const CompanyCode(), transition: Transition.rightToLeft);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder(
          future: dioServiceClient.ownerProfile(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              debugPrint("API Error: ${snapshot.error}");
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
            } else if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else {
              Constants.userImage = snapshot.data!.data!.profileInfo?.imagename ?? "";
              final profile = snapshot.data!.data!.profileInfo;

              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          buildProfileImage(),
                          const SizedBox(height: 30),
                          buildProfileDetails(profile),
                        ],
                      ),
                    ),
                  ),
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
                              Text('Version: ',style: Styles.textBoldLabel,),
                              Text('${snapshot.data!.version}'),

                            ],
                          );
                        } else {
                          return SizedBox();
                        }
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  /// Builds the Profile Image with Edit Button
  Widget buildProfileImage() {
    return Stack(
      children: [
        CircleAvatar(
          radius: 70,
          backgroundColor: Colors.white70,
          child: isConnected && Constants.userImage.isNotEmpty
              ? ClipOval(
                  child: InkWell(
                    onTap: () async {
                      File file = await getFile(Constants.userImage, 'Image.png');
                      Get.to(() => ImageViewScreen(imageFile: file));
                    },
                    child: Image.network(
                      Constants.userImage,
                      fit: BoxFit.cover,
                      width: 140,
                      height: 140,
                      loadingBuilder: (context, child, loadingProgress) => loadingProgress == null ? child : const CircularProgressIndicator(),
                      errorBuilder: (_, __, ___) => fallbackProfileImage(),
                    ),
                  ),
                )
              : fallbackProfileImage(),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: buildEditButton(),
        ),
      ],
    );
  }

  /// Fallback Profile Image
  Widget fallbackProfileImage() {
    return CircleAvatar(
      radius: 70,
      backgroundColor: Colors.white70,
      child: ClipOval(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Image.asset('assets/images/41.png', fit: BoxFit.cover, width: 140, height: 140),
        ),
      ),
    );
  }

  /// Edit Button for Profile Image
  Widget buildEditButton() {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light ? Colors.grey.shade300 : Colors.grey.shade900,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: const Icon(Icons.camera_alt),
        onPressed: () => showImagePickerOptions(),
      ),
    );
  }

  void showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const AutoSizeText("Capture a photo"),
              onTap: () => _pickImage(ImageSource.camera).then((_) => Get.back()),
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const AutoSizeText("Select an image"),
              onTap: () => _pickImage(ImageSource.gallery).then((_) => Get.back()),
            ),
          ],
        );
      },
    );
  }

  /// Builds Profile Details
  Widget buildProfileDetails(profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        keyValue('User Id', profile.badgeNo.toString()),
        keyValue('I\'am', profile.owntenantRole.toString()),
        keyValue('I Reside In', "Society: ${Constants.societyName}; Block: ${Constants.societyBlock}; No: ${Constants.societyNumber}"),
        keyValue('Address', Constants.address),
        keyValue('Name', profile.owntenantName.toString()),
        keyValue('Phone', profile.owntenantMobile.toString()),
        keyValue(
          'Email',
          profile.owntenantEmail.toString(),
          trailingIcon: InkWell(
            onTap: () => Get.to(() => EditEmailScreen(email: profile.owntenantEmail.toString())),
            child: const Icon(Icons.edit, size: 20),
          ),
        ),
      ],
    );
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Profile'),
      // leading: IconButton(
      //   icon: const Icon(Icons.arrow_back),
      //   onPressed: () {
      //     Get.offAll(() => const BottomNavigation());
      //   },
      // ),
      actions: [
        PopupMenuButton<String>(
          onSelected: (String value) {
            switch (value) {
              case 'Customer Care':
                Get.to(() => const CustomerCare());
                break;
              case 'Delete Account':
                _showDeleteDialog();
                break;
              case 'Terms & Condition':
                launchExternalWebsite(Uri.parse('https://bizinfratech.in/terms-and-conditions'));
                break;
              case 'Privacy Policy':
                launchExternalWebsite(Uri.parse('https://bizinfratech.in/privacy-policy'));
                break;
            }
          },
          itemBuilder: (context) => [
            buildPopupMenuItem('Customer Care'),
            buildPopupMenuItem('Delete Account'),
            buildPopupMenuItem('Terms & Condition'),
            buildPopupMenuItem('Privacy Policy'),
          ],
        ),
      ],
    );
  }

  PopupMenuItem<String> buildPopupMenuItem(String title) {
    return PopupMenuItem(
      value: title,
      child: Text(title),
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
            flex: 3,
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
