// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:biz_infra/CustomWidgets/configurable_widgets.dart';
// import 'package:biz_infra/Screens/owner_tenant_registration/reset_password.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import '../../Network/dio_service_client.dart';
// import '../../Utils/app_styles.dart';
//
// class ForgotPassword extends StatefulWidget {
//   const ForgotPassword({super.key});
//
//   @override
//   State<ForgotPassword> createState() => _ForgotPasswordState();
// }
//
// class _ForgotPasswordState extends State<ForgotPassword> {
//   final _forgotFormKey = GlobalKey<FormState>();
//   final usernameController = TextEditingController();
//   final emailMobileController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return
//       Scaffold(
//         appBar: AppBar(title: const Text("Forgot Password"),
//           elevation: 5,),
//         body: SingleChildScrollView(
//             child:
//             Form(
//               key: _forgotFormKey,
//               child: Column(
//                 children: [
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width,
//                     height: MediaQuery.of(context).size.height/3,
//                     child: Image.asset(
//                       'assets/images/Group 2621@3x.png',
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   const SizedBox(height: 20,),
//                   Padding(
//                     padding: const EdgeInsets.all(15.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         textField(
//                           controller: usernameController,
//                           inputType: TextInputType.text,
//                           validator: (value){
//                             if((value ?? '').trim().isEmpty){
//                               return "Please enter username";
//                             }
//                             return null;
//                           },
//                           fillColor: const Color(0xFFEDEDED),
//                           filled: true,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           counterText: "",
//                           prefixIcon: const Icon(Icons.person),
//                           hintText: "Username",
//                         ),
//
//                         const SizedBox(height: 20,),
//
//                         textField(
//                           controller: emailMobileController,
//                           inputType: TextInputType.emailAddress,
//                           validator: (value){
//                             if((value ?? '').trim().isEmpty){
//                               return "Please enter registered email or registered mobile no";
//                             }
//                             // if (!RegExp(r"^[a-zA-Z\d.a-zA-Z!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z\d]+\.[a-zA-Z]+").hasMatch(value!)) {
//                             //   return "Please enter valid email address";
//                             // }
//                             return null;
//                           },
//                           // fillColor: const Color(0xFFEDEDED),
//                           // filled: true,
//                           // border: OutlineInputBorder(
//                           //   borderRadius: BorderRadius.circular(8),
//                           // ),
//                           prefixIcon: const Icon(Icons.mail),
//                           hintText: "Enter Registered Email / Mobile No",
//                         ),
//
//                         const SizedBox(height: 30,),
//
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(15.0),
//                     child: textButton(
//                       // onPressed: () async{
//                       //   if (_forgotFormKey.currentState!.validate()) {
//                       //     var preResetData =  await dioServiceClient.employeeForgotPassword(badgeNo: usernameController.text, emailId: emailMobileController.text);
//                       //     if(preResetData!.data!.uid!=null) {
//                       //       Get.to(() =>  ResetPassword(uid:preResetData.data!.uid.toString()));
//                       //     }
//                       //     else {
//                       //       snackBarMessenger(preResetData.statusMessage.toString());
//                       //       // Fluttertoast.showToast(
//                       //       //     msg: preResetData.statusMessage.toString(),
//                       //       //     toastLength: Toast.LENGTH_LONG,
//                       //       //     gravity: ToastGravity.BOTTOM,
//                       //       //     timeInSecForIosWeb: 1,
//                       //       //     backgroundColor: Colors.black,
//                       //       //     textColor: Colors.white,
//                       //       //     fontSize: 16.0
//                       //       // );
//                       //       EasyLoading.dismiss();
//                       //     }
//                       //   }
//                       // },
//                         onPressed: () async {
//                           if (_forgotFormKey.currentState!.validate()) {
//                             String input = emailMobileController.text.trim();
//                             String? email;
//                             String? mobile;
//
//                             // Check if the input is an email or mobile number
//                             if (RegExp(r"^[a-zA-Z\d._%+-]+@[a-zA-Z\d.-]+\.[a-zA-Z]{2,}$").hasMatch(input)) {
//                               email = input;
//                             } else if (RegExp(r"^[0-9]{10}$").hasMatch(input)) {
//                               mobile = input;
//                             } else {
//                               snackBarMessenger("Please enter a valid email or 10-digit mobile number");
//                               return;
//                             }
//
//                             var preResetData = await dioServiceClient.employeeForgotPassword(
//                               badgeNo: usernameController.text,
//                               emailId: email,
//                               mobileNo: mobile,
//                             );
//
//                             if (preResetData!.data!.uid != null) {
//                               Get.to(() => ResetPassword(uid: preResetData.data!.uid.toString()));
//                             } else {
//                               snackBarMessenger(preResetData.statusMessage.toString());
//                               EasyLoading.dismiss();
//                             }
//                           }
//                         },
//
//                         widget:const AutoSizeText("Send OTP"),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//           ),
//
//       );
//   }
// }
