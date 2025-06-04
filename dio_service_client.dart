  import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:biz_infra/CustomWidgets/configurable_widgets.dart';
import 'package:biz_infra/Model/Amenities/my_booking_listing_model.dart';
import 'package:biz_infra/Model/DomesticHelp/domestic_help_society_model.dart';
import 'package:biz_infra/Model/DomesticHelp/gatePassHistoryListModel.dart';
import 'package:biz_infra/Model/SocietyEnquiry/pincode_info_model.dart';
import 'package:biz_infra/Model/WaterTank/water_tank_list_model.dart';
import 'package:biz_infra/Model/adv_notice_board/adv_notice_board_count_modal.dart';
import 'package:biz_infra/Model/adv_notice_board/adv_notice_board_creation_modal.dart';
import 'package:biz_infra/Model/adv_notice_board/adv_notice_board_delete_modal.dart';
import 'package:biz_infra/Model/adv_notice_board/adv_notice_board_details_modal.dart';
import 'package:biz_infra/Model/adv_notice_board/adv_notice_board_listing_modal.dart';
import 'package:biz_infra/Model/adv_notice_board/dropdowns/adv_notice_share_dropdown_modal.dart';
import 'package:biz_infra/Model/adv_notice_board/dropdowns/adv_notice_type_dropdown_modal.dart';
import 'package:biz_infra/Model/announcement_modal.dart';
import 'package:biz_infra/Model/buy_and_sell/buy_and_sell_creation_modal.dart';
import 'package:biz_infra/Model/buy_and_sell/buy_and_sell_details_modal.dart';
import 'package:biz_infra/Model/buy_and_sell/buy_and_sell_listing_modal.dart';
import 'package:biz_infra/Model/buy_and_sell/buy_and_sell_sold_modal.dart';
import 'package:biz_infra/Model/buy_and_sell/chats/buy_and_sell_comments_creation_modal.dart';
import 'package:biz_infra/Model/buy_and_sell/chats/buy_and_sell_comments_listing.dart';
import 'package:biz_infra/Model/buy_and_sell/dropdowns/list_category_dropdown_modal.dart';
import 'package:biz_infra/Model/buy_and_sell/dropdowns/type_of_sell_dropdown_modal.dart';
import 'package:biz_infra/Model/employee_registration/dropdowns/employee_block_dropdown_modal.dart';
import 'package:biz_infra/Model/employee_registration/dropdowns/employee_role_dropdown_modal.dart';
import 'package:biz_infra/Model/employee_registration/dropdowns/employee_role_userwise_dropdown_modal.dart';
import 'package:biz_infra/Model/employee_registration/dropdowns/employee_society_dropdown_modal.dart';
import 'package:biz_infra/Model/employee_registration/employee_registration_details_modal.dart';
import 'package:biz_infra/Model/employee_registration/employee_registration_list_modal.dart';
import 'package:biz_infra/Model/employee_registration/employee_registration_modal.dart';
import 'package:biz_infra/Model/Login/email_login_model.dart';
import 'package:biz_infra/Model/notice_board/dropdowns/notice_share_dropdown_modal.dart';
import 'package:biz_infra/Model/notice_board/dropdowns/notice_type_dropdown_modal.dart';
import 'package:biz_infra/Model/notice_board/notice_board_count_modal.dart';
import 'package:biz_infra/Model/notice_board/notice_board_creation_modal.dart';
import 'package:biz_infra/Model/notice_board/notice_board_delete_modal.dart';
import 'package:biz_infra/Model/notice_board/notice_board_details_modal.dart';
import 'package:biz_infra/Model/notice_board/notice_board_filter_modal.dart';
import 'package:biz_infra/Model/notice_board/notice_board_listing_modal.dart';
import 'package:biz_infra/Model/pre_approval/guest_approval_list_model.dart';
import 'package:biz_infra/Model/pre_approval/guest_invitation_model.dart';
import 'package:biz_infra/Model/pre_approval/passcode_generation_model.dart';
import 'package:biz_infra/Model/society_designation_model.dart';
import 'package:biz_infra/Model/supervisor_approval/da_delivery_block_model.dart';
import 'package:biz_infra/Model/supervisor_approval/da_delivery_company_model.dart';
import 'package:biz_infra/Model/supervisor_approval/da_delivery_society_no_model.dart';
import 'package:biz_infra/Model/supervisor_approval/ga_guest_block_model.dart';
import 'package:biz_infra/Model/supervisor_approval/guest_approval_creation_model.dart';
import 'package:biz_infra/Model/supervisor_approval/ga_guest_society_no_model.dart';
import 'package:biz_infra/Model/vendors/vendor_details_model.dart';
import 'package:biz_infra/Model/vendors/vendors_listing_model.dart';
import 'package:biz_infra/Network/dio_service_exception.dart';
import 'package:biz_infra/Screens/bottom_navigation.dart';
import 'package:biz_infra/Screens/help_desk/help_desk_details_screen.dart';
import 'package:biz_infra/Screens/owner_tenant_registration/login.dart';
import 'package:biz_infra/Screens/security_guard/guard_home_screen.dart';
import 'package:biz_infra/Utils/app_string.dart';
import 'package:biz_infra/Utils/constants.dart';
import 'package:biz_infra/Utils/debugger.dart';
import 'package:biz_infra/company_code.dart';
import 'package:dio/dio.dart' as fd show FormData;
import 'package:dio/dio.dart';
import 'package:dio/src/multipart_file.dart' as multip;
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_compress/video_compress.dart';
import '../CustomWidgets/CustomLoaders/custom_loader_manager.dart';
import '../Model/Amenities/amenities_available_slot_model.dart';
import '../Model/Amenities/amenities_details_model.dart';
import '../Model/Amenities/amenities_listing_model.dart';
import '../Model/Amenities/amenities_booking_save_record_model.dart';
import '../Model/Amenities/amenities_payment_qr_code_model.dart';
import '../Model/Amenities/booking_cancel_model.dart';
import '../Model/Attendance/AttendaceDetailModel.dart';
import '../Model/Attendance/AttendanceListModel.dart';
import '../Model/Attendance/FaceDetectionModel.dart';
import '../Model/Attendance/ServiceUserDetailModel.dart';
import '../Model/CallGuard/call_guard_listing.dart';
import '../Model/CallGuard/guard_creation.dart';
import '../Model/CustomerCare/customerCare_list_modal.dart';
import '../Model/DomesticHelp/AddToFlatModel.dart';
import '../Model/DomesticHelp/DeleteDomesticModel.dart';
import '../Model/DomesticHelp/DomesticBlockModel.dart';
import '../Model/DomesticHelp/DomesticDocumentModel.dart';
import '../Model/DomesticHelp/DomesticHelpTypeModel.dart';
import '../Model/DomesticHelp/FilterDomesticHelpModel.dart';
import '../Model/DomesticHelp/GatePassCountModel.dart';
import '../Model/DomesticHelp/GatePassPickListModel.dart';
import '../Model/DomesticHelp/PasscodeVerifyModel.dart';
import '../Model/DomesticHelp/RemoveDomHelpServiceModel.dart';
import '../Model/DomesticHelp/domestic_help_detail_model.dart';
import '../Model/DomesticHelp/domestic_help_list.dart';
import '../Model/DomesticHelp/save_domestic_help_model.dart';
import '../Model/DomesticHelp/time_slot_model.dart';
import '../Model/EmergencyDirectory/emergency_directory_save_record_model.dart';
import '../Model/EmergencyDirectory/emergency_directory_listing_model.dart';
import '../Model/HelpDesk/comments/edit_message_model.dart';
import '../Model/HelpDesk/comments/messge_listing_model.dart';
import '../Model/HelpDesk/comments/reply_message_model.dart';
import '../Model/HelpDesk/comments/send_message_model.dart';
import '../Model/HelpDesk/helpDesk_category_model.dart';
import '../Model/HelpDesk/helpDesk_create_model.dart';
import '../Model/HelpDesk/helpDesk_pinLocation_model.dart';
import '../Model/HelpDesk/help_desk_count_model.dart';
import '../Model/HelpDesk/help_desk_details_model.dart';
import '../Model/HelpDesk/help_desk_listing_model.dart';
import '../Model/HelpDesk/help_desk_role_based_assigned_list_model.dart';

// import '../Model/Login/phone_login_model.dart';
import '../Model/InfraEmpProfileModel.dart';
import '../Model/Login/phone_login_model.dart';
import '../Model/Login/pre_login_phone_model.dart';
import '../Model/Maintenance/PaymentDueListModel.dart';
import '../Model/Maintenance/PaymentUploadImageModel.dart';
import '../Model/Maintenance/QRPaymentModel.dart';
import '../Model/Polls/DetailsPollsModel.dart';
import '../Model/Polls/PollsCountStatusModel.dart';
import '../Model/Polls/PollsListingModel.dart';
import '../Model/Polls/polls_creation_model.dart';
import '../Model/ResidentDirectory/resident_directory_listing.dart';
import '../Model/ResidentDirectory/selected_resident_directory_model.dart';
import '../Model/SocietyEnquiry/designation_model.dart';
import '../Model/SocietyEnquiry/society_enquiry_model.dart';
import '../Model/UpdateAppModel.dart';
import '../Model/WaterTank/AllowInOutModel.dart';
import '../Model/WaterTank/DateWiseAllowInModel.dart';
import '../Model/WaterTank/water_tak_cancel_model.dart';
import '../Model/WaterTank/water_tank_details_model.dart';
import '../Model/WaterTank/water_tank_model.dart';
import '../Model/WaterTank/water_tank_passcode_model.dart';
import '../Model/changePassword_model.dart';
import '../Model/fetch_base_url_model.dart';
import '../Model/otp_verification_model.dart';
import '../Model/ownerLogin&Registration/ForgotPasswordModel.dart';
import '../Model/ownerLogin&Registration/ResetPasswordModel.dart';
import '../Model/ownerLogin&Registration/delete_profile_model.dart';
import '../Model/ownerLogin&Registration/edit_email_model.dart';
import '../Model/ownerLogin&Registration/validate_user_model.dart';
import '../Model/ownerProfileModel.dart';
import '../Model/owner_tenant_model.dart';
import '../Model/pre_approval/visitor_detail_model.dart';
import '../Model/profile/employee_change_password_model.dart';
import '../Model/profile/employee_delete_profile_model.dart';
import '../Model/profile/employee_edit_email_model.dart';
import '../Model/profile/employee_forgot_password_model.dart';
import '../Model/profile/employee_profile_model.dart';
import '../Model/profile/employee_reset_password_model.dart';
import '../Model/registration_model.dart';
import '../Model/society_block_model.dart';
import '../Model/society_name_model.dart';
import '../Model/society_number_model.dart';
import '../Model/verify_otp_model.dart';
import '../Screens/Call Guard/message_guard.dart';
import '../Screens/vendor_regd/InfraEmp/infra_emp_dashboard.dart';
import 'authorization_interceptor.dart';
import 'end_points.dart';
import 'logger_interceptor.dart';

DioServiceClient dioServiceClient = DioServiceClient();
SharedPreferences? sharedPreferences;
CustomLoaderManager customLoaderManager = CustomLoaderManager();

class DioServiceClient {
  static const timeout = 50000;

  ///Production URL
// String baseUrl = 'https://api.bizinfratech.in/bizinfraeyeprod/modules/Mobile/';
// String defaultBaseUrl = 'https://api.bizinfratech.in/bizinfraeyeprod/modules/Mobile/';

  ///Quality URL
  String baseUrl = 'https://api.bizinfratech.in/bizinfraeyequality/modules/Mobile/';
  String defaultBaseUrl = 'https://api.bizinfratech.in/bizinfraeyequality/modules/Mobile/';

  DioServiceClient._internal(this.baseUrl) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(milliseconds: timeout),
        receiveTimeout: const Duration(milliseconds: timeout),
        sendTimeout: const Duration(milliseconds: timeout),
      ),
    )..interceptors.addAll([
        AuthorizationInterceptor(),
        LoggerInterceptor(),
      ]);
  }

  static final DioServiceClient _instance = DioServiceClient._internal('https://api.bizinfratech.in/bizinfraeyequality/modules/Mobile/');

  factory DioServiceClient() => _instance;

  Dio get dio => _dio;

  void updateBaseUrl(String baseUrl) {
    baseUrl = baseUrl;
    _dio.options.baseUrl = baseUrl;
    Constants.baseUrl = baseUrl;
  }

  late final Dio _dio;

  Future<FetchBaseUrlModel?> getBaseUrl({required String code}) async {
    try {
      EasyLoading.show();
      final response = await _dio.post(
        Endpoints.fetchBaseUrl,
        data: {'cCode': code},
      );
      sharedPreferences = await SharedPreferences.getInstance();
      if (response.statusCode == 200) {
        FetchBaseUrlModel? fetchUrlData = FetchBaseUrlModel.fromJson(response.data);
        return fetchUrlData;
      } else {
        throw Exception("Failed to fetch base URL: ${response.statusCode}");
      }
    } on DioException catch (err) {
      // EasyLoading.dismiss();
      //  final errorMessage = err.toString();
      //  throw errorMessage;
      throw Exception("Network error: ${err.message}");
    } catch (e) {
      // EasyLoading.dismiss();
      // throw e.toString();
      throw Exception("Unexpected error: $e");
    } finally {
      EasyLoading.dismiss();
    }
    //return null;
  }

  Future<DesignationModel?> designationData() async {
    try {
      EasyLoading.show();
      final response = await _dio.post(
        Endpoints.pickListValues,
        data: {
          'field': 'designation',
        },
      );
      return DesignationModel.fromJson(response.data);
    } on DioException catch (e) {
      EasyLoading.dismiss();
      throw DioServiceException.fromDioException(e);
    } catch (e) {
      EasyLoading.dismiss();
      throw e.toString();
    } finally {
      EasyLoading.dismiss();
    }
  }

  ///Login user
  Future<EmailLoginModel> getEmailLogin({required BuildContext context, required String employeeId, required String password}) async {
    EasyLoading.show();
    try {
      final response = await _dio.post(
        Endpoints.emailLogin,
        queryParameters: {'email_or_username': employeeId, 'password': password},
      );
      var loginData = EmailLoginModel.fromJson(response.data);

      sharedPreferences = await SharedPreferences.getInstance();
      if (loginData.statuscode == 1) {
        // Constants.baseUrl = dioServiceClient.baseUrl;
        Constants.userRole = loginData.data!.userRole ?? '';
        Constants.accessToken = loginData.data!.accessToken ?? '';
        Constants.userUniqueId = loginData.data!.useruniqeid ?? '';
        Constants.userName = loginData.data!.profileInfo!.serviceEngineerName ?? loginData.data!.profileInfo!.owntenantName ?? '';
        Constants.assignedUserId = loginData.data!.assignUserId ?? '';
        Constants.email = loginData.data!.profileInfo!.email ?? loginData.data!.profileInfo!.owntenantEmail ?? '';
        Constants.userImage = loginData.data!.imagename ?? '';
        Constants.address = loginData.data!.address ?? '';
        Constants.qrcodeId = loginData.data!.qrcodeid ?? '';

        Constants.societyName = loginData.data!.profileInfo!.societyName ?? loginData.data!.profileInfo!.empSociety ?? '';
        Constants.societyBlock = loginData.data!.profileInfo!.blockName ?? loginData.data!.profileInfo!.empBlock ?? '';
        Constants.societyNumber = loginData.data!.profileInfo!.societyNo ?? '';
        Constants.userBadgeNo = loginData.data!.profileInfo!.badgeNo ?? '';
        Constants.qrcodeId = loginData.data!.qrcodeid ?? '';
        sharedPreferences?.setString('baseUrl', Constants.baseUrl);
        sharedPreferences?.setString("TOKEN", Constants.accessToken);
        sharedPreferences?.setString("USERUNIQUEID", Constants.userUniqueId);
        sharedPreferences?.setString("USERNAME", Constants.userName);
        sharedPreferences?.setString("USERROLE", Constants.userRole);
        sharedPreferences?.setString("ASSIGNEDUSERID", Constants.assignedUserId);
        sharedPreferences?.setString("EMAIL", Constants.email);
        sharedPreferences?.setString("USERIMAGE", Constants.userImage);
        sharedPreferences?.setString("SOCIETYNAME", Constants.societyName);
        sharedPreferences?.setString("SOCIETYBLOCK", Constants.societyBlock);
        sharedPreferences?.setString("SOCIETYNUMBER", Constants.societyNumber);
        sharedPreferences?.setString("BADGENO", Constants.userBadgeNo);
        sharedPreferences?.setString("ADDRESS", Constants.address);
        sharedPreferences?.setString("QR_CODE_ID", Constants.qrcodeId);

        if (loginData.data!.userRole == Constants.securitySupervisor) {
          registerDeviceId();
          Get.offAll(() => const GuardHomeScreen());
        } else if (loginData.data!.userRole == Constants.marketing) {
          registerDeviceId();
          Get.offAll(() => const InfraEmpDashboard());
        } else {
          registerDeviceId();
          Get.offAll(() => const BottomNavigation());
        }
      } else {
        if (loginData.statusMessage == "You are Not Registered") {
          snackBarMessenger(
            loginData.statusMessage.toString(),
          );
        } else if (loginData.statusMessage!.contains('Invalid Credentials')) {
          snackBarMessenger(loginData.statusMessage.toString());
        } else if (loginData.statusMessage!.contains('User Verification is Pending')) {
          snackBarMessenger(loginData.statusMessage.toString());
        }
        EasyLoading.dismiss();
      }
      return loginData;
    } on DioException catch (err) {
      Fluttertoast.showToast(
          msg: err.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);

      EasyLoading.dismiss();
      final errorMessage = err.toString();
      throw errorMessage;
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
      log('Error while getting data is $e');
      throw e.toString();
    } finally {
      EasyLoading.dismiss();
    }
  }

  ///Pre Login - to generate OTP/fetch UID
  Future<PreLoginPhoneModel?> generatePreLoginOtp({required String mobile}) async {
    fd.FormData preLoginData = fd.FormData.fromMap({
      'mobile_number': mobile,
    });

    try {
      EasyLoading.show();
      final response = await _dio.post(Endpoints.preLogin, data: preLoginData);
      var preLoginPhoneResponse = PreLoginPhoneModel.fromJson(response.data);

      if (preLoginPhoneResponse.statuscode == 1) {
        return preLoginPhoneResponse; // Return successful response
      } else {
        // Throw an exception if the user is not registered
        if (preLoginPhoneResponse.statusMessage == "You are Not Registered") {
          throw Exception("You are Not registered");
        } else if (preLoginPhoneResponse.statusMessage == "Failed to send OTP") {
          throw Exception("Failed to send OTP. Please try again.");
        }
      }
    } catch (e) {
      snackBarMessenger(e.toString()); // Show error message in UI
      return null; // Return null in case of failure
    } finally {
      EasyLoading.dismiss();
    }
    return null;
  }

  Future<PhoneNoLoginModel> getPhoneNoLogin({required BuildContext context, required String trackingUrl, required String fetchedOtp}) async {
    EasyLoading.show();
    try {
      fd.FormData otpFormData = fd.FormData.fromMap({
        'tracking_url': trackingUrl,
        'otp': fetchedOtp,
      });

      final response = await _dio.post(
        Endpoints.phoneNumberLogin,
        data: otpFormData,
        // data: {'mobile_number': mobileNumber, 'otp': fetchedOtp},
        // options: Options(
        //   headers: {'Cookie': cookie},
        // ),
      );
      var phoneNoLoginData = PhoneNoLoginModel.fromJson(response.data);

      sharedPreferences = await SharedPreferences.getInstance();
      if (phoneNoLoginData.statuscode == 1) {
        //print("printing dioservice client");
        // Constants.baseUrl = dioServiceClient.baseUrl;
        Constants.userRole = phoneNoLoginData.data!.userRole ?? '';
        Constants.accessToken = phoneNoLoginData.data!.accessToken ?? '';
        Constants.userUniqueId = phoneNoLoginData.data!.useruniqeid ?? '';
        Constants.userName = phoneNoLoginData.data!.profileInfo!.serviceEngineerName ?? phoneNoLoginData.data!.profileInfo!.owntenantName ?? '';
        Constants.assignedUserId = phoneNoLoginData.data!.assignUserId ?? '';
        Constants.email = phoneNoLoginData.data!.profileInfo!.email ?? phoneNoLoginData.data!.profileInfo!.owntenantEmail ?? '';
        Constants.userImage = phoneNoLoginData.data!.imagename ?? '';
        Constants.address = phoneNoLoginData.data!.address ?? '';

        Constants.societyName = phoneNoLoginData.data!.profileInfo!.societyName ?? phoneNoLoginData.data!.profileInfo!.empSociety ?? '';
        Constants.societyBlock = phoneNoLoginData.data!.profileInfo!.blockName ?? phoneNoLoginData.data!.profileInfo!.empBlock ?? '';
        Constants.societyNumber = phoneNoLoginData.data!.profileInfo!.societyNo ?? '';
        Constants.userBadgeNo = phoneNoLoginData.data!.profileInfo!.badgeNo ?? '';
        Constants.qrcodeId = phoneNoLoginData.data!.qrcodeid ?? '';
        sharedPreferences?.setString('baseUrl', Constants.baseUrl);
        sharedPreferences?.setString("TOKEN", Constants.accessToken);
        sharedPreferences?.setString("USERUNIQUEID", Constants.userUniqueId);
        sharedPreferences?.setString("USERNAME", Constants.userName);
        sharedPreferences?.setString("USERROLE", Constants.userRole);
        sharedPreferences?.setString("ASSIGNEDUSERID", Constants.assignedUserId);
        sharedPreferences?.setString("EMAIL", Constants.email);
        sharedPreferences?.setString("USERIMAGE", Constants.userImage);
        sharedPreferences?.setString("SOCIETYNAME", Constants.societyName);
        sharedPreferences?.setString("SOCIETYBLOCK", Constants.societyBlock);
        sharedPreferences?.setString("SOCIETYNUMBER", Constants.societyNumber);
        sharedPreferences?.setString("BADGENO", Constants.userBadgeNo);
        sharedPreferences?.setString("ADDRESS", Constants.address);
        sharedPreferences?.setString("QR_CODE_ID", Constants.qrcodeId);

        if (phoneNoLoginData.data!.userRole == Constants.securitySupervisor) {
          registerDeviceId();
          Get.offAll(() => const GuardHomeScreen());
        } else {
          registerDeviceId();
          Get.offAll(() => const BottomNavigation());
        }
      } else {
        if (phoneNoLoginData.statusMessage == "You are Not Registered") {
          snackBarMessenger(
            phoneNoLoginData.statusMessage.toString(),
          );
        } else if (phoneNoLoginData.statusMessage!.contains('Invalid OTP')) {
          snackBarMessenger(phoneNoLoginData.statusMessage.toString());
        } else if (phoneNoLoginData.statusMessage!.contains('User Verification is Pending')) {
          snackBarMessenger(phoneNoLoginData.statusMessage.toString());
        }
        EasyLoading.dismiss();
      }
      return phoneNoLoginData;
    } on DioException catch (err) {
      Fluttertoast.showToast(
          msg: err.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);

      EasyLoading.dismiss();
      final errorMessage = err.toString();
      throw errorMessage;
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(), toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
      log('Error while getting data is $e');
      throw e.toString();
    } finally {
      EasyLoading.dismiss();
    }
  }

  /// Register Device ID
  registerDeviceId() async {
    try {
      String? deviceId = await FirebaseMessaging.instance.getToken();
      final response = await _dio.post(
        Endpoints.registerDeviceId,
        data: {'useruniqueid': Constants.userUniqueId, 'access_token': Constants.accessToken, 'deviceId': deviceId, 'userid': Constants.userUniqueId},
      );
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        // EasyLoading.showSuccess("Device registered successfully");
        // Optionally store the deviceId locally
        // await SharedPreferences.getInstance().then(
        //       (prefs) => prefs.setString('device_id', deviceId),
        // );
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      final errorMessage = err.toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
  }

  /// Otp generation
  Future<OtpVerificationModel?> generateOtp({
    required String module,
    required String email,
    required String name,
    required String mobile,
  }) async {
    fd.FormData otpFormData = fd.FormData.fromMap({
      'module': module,
      'owntenant_email': email,
      'owntenant_name': name,
      'owntenant_mobile': mobile,
    });

    try {
      EasyLoading.show();
      final response = await _dio.post(Endpoints.otpVerification, data: otpFormData);

      if (response.statusCode == 200) {
        return OtpVerificationModel.fromJson(response.data);
      } else {
        Get.snackbar('Oops!', 'Failed to send OTP');
      }
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar('Oops!', e.toString());
    } finally {
      EasyLoading.dismiss();
    }
    return null;
  }

  //verify otp
  Future<VerifyOtpModel?> verifyOtp({
    required String otp,
    required String uid,
  }) async {
    fd.FormData verifyOtpFormData = fd.FormData.fromMap({
      'uid': uid,
      'otp': otp,
    });

    try {
      EasyLoading.show();
      final response = await _dio.post(
        Endpoints.verifyOtp,
        data: verifyOtpFormData,
      );

      if (response.statusCode == 200) {
        return VerifyOtpModel.fromJson(response.data);
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      EasyLoading.dismiss();
    }
    return null;
  }

  Future<ValidateUserModel?> validatingExistingUser({
    required String? ownerTenantMobile,
    required String? ownerTenantEmail,
  }) async {
    fd.FormData verifyUserExistence = fd.FormData.fromMap({
      'owntenant_mobile': ownerTenantMobile,
      'owntenant_email': ownerTenantEmail,
    });
    try {
      EasyLoading.show();
      final response = await _dio.post(
        Endpoints.validateUser,
        data: verifyUserExistence,
      );

      if (response.statusCode == 200) {
        return ValidateUserModel.fromJson(response.data);
      }
    } on DioException catch (err) {
      final errorMessage = err.toString();
      throw errorMessage;
    } catch (e) {
      throw Exception(e);
    } finally {
      EasyLoading.dismiss();
    }
    return null;
  }

// Owner Tenant registration
  Future<OwnerTenantRegistrationModel?> ownerTenantRegistration(
      {required String? ownerTenantName,
      required String? ownerTenantMobile,
      required String? ownerTenantEmail,
      String? ownerTenantPassword,
      String? societyName,
      String? societyBlock,
      String? societyNumber,
      String? role,
      String? residingType}) async {
    fd.FormData ownerTenantFormData = fd.FormData.fromMap({
      'owntenant_name': ownerTenantName,
      'owntenant_mobile': ownerTenantMobile,
      'owntenant_email': ownerTenantEmail,
      // 'owntenant_password': ownerTenantPassword,
      'related_society': societyName,
      'related_block': societyBlock,
      'related_flat': societyNumber,
      'owntenant_role': role,
      'owntenant_type_residing': residingType,
    });
    try {
      EasyLoading.show();
      final response = await _dio.post(
        Endpoints.ownerRegistration,
        data: ownerTenantFormData,
      );

      if (response.statusCode == 200) {
        return OwnerTenantRegistrationModel.fromJson(response.data);
      }
    } on DioException catch (err) {
      final errorMessage = err.toString();
      throw errorMessage;
    } catch (e) {
      throw Exception(e);
    } finally {
      EasyLoading.dismiss();
    }
    return null;
  }

  Future<SocietyNameModel?> societyName() async {
    try {
      EasyLoading.show();
      final response = await _dio.post(
        Endpoints.societyName,
        queryParameters: {
          'module': 'Accounts',
        },
      );
      return SocietyNameModel.fromJson(response.data);
    } on DioException catch (e) {
      EasyLoading.dismiss();
      throw DioServiceException.fromDioException(e);
    } catch (e) {
      EasyLoading.dismiss();
      throw e.toString();
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<SocietyBlockModel?> societyBlock(String dependentFieldVal) async {
    try {
      EasyLoading.show();

      final response = await _dio.post(
        Endpoints.societyBlock,
        queryParameters: {
          'module': 'SocBlocks',
          'filter_field': 'society_name',
          'filter_value': dependentFieldVal,
        },
      );

      return SocietyBlockModel.fromJson(response.data);
    } on DioException catch (e) {
      EasyLoading.dismiss();

      throw DioServiceException.fromDioException(e);
    } catch (e) {
      EasyLoading.dismiss();

      throw e.toString();
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<SocietyNumberModel?> societyNumber(String societyName, String societyBlock) async {
    try {
      EasyLoading.show();

      final response = await _dio.post(Endpoints.societyNumber, queryParameters: {
        'module': 'Plat',
        'society_id': societyName,
        'block_id': societyBlock,
      });

      return SocietyNumberModel.fromJson(response.data);
    } on DioException catch (e) {
      EasyLoading.dismiss();

      throw DioServiceException.fromDioException(e);
    } catch (e) {
      EasyLoading.dismiss();

      throw e.toString();
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<OwnerProfileModel?> ownerProfile() async {
    try {
      EasyLoading.show();
      final response = await _dio.post(
        Endpoints.ownerProfile,
        queryParameters: {
          'access_token': Constants.accessToken,
          'useruniqueid': Constants.userUniqueId,
        },
      );

      if (response.statusCode == 200) {
        if (response.data['statuscode'] == 1) {
          return OwnerProfileModel.fromJson(response.data);
        } else {
          throw Exception(response.data['statusMessage']);
        }
      }
    } on DioException catch (e) {
      EasyLoading.dismiss();
      final errorMessage = e.toString();
      throw errorMessage;
    } catch (e) {
      EasyLoading.dismiss();
      throw e.toString();
    } finally {
      EasyLoading.dismiss();
    }
    return null;
  }

  Future<ChangePasswordModel?> changePassword({required String newPassword, required String confirmPassword}) async {
    try {
      EasyLoading.show();

      final response = await _dio.post(
        Endpoints.passwordChange,
        queryParameters: {'access_token': Constants.accessToken, 'useruniqueid': Constants.userUniqueId, 'newPassword': newPassword, 'confirmPassword': confirmPassword},
      );

      return ChangePasswordModel.fromJson(response.data);
    } on DioException catch (e) {
      EasyLoading.dismiss();

      throw DioServiceException.fromDioException(e);
    } catch (e) {
      EasyLoading.dismiss();

      throw e.toString();
    } finally {
      EasyLoading.dismiss();
    }
  }

  // Future<DeleteProfileModel?> deleteProfile(Future? future, ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar, {required String? userName}) async {
  //   try {
  //     EasyLoading.show();
  //
  //     final response = await _dio.post(
  //       Endpoints.profileDelete,
  //       queryParameters: {
  //         'access_token': Constants.accessToken,
  //         'useruniqueid': Constants.userUniqueId,
  //         'user_name': Constants.userBadgeNo,
  //       },
  //     );
  //
  //     return DeleteProfileModel.fromJson(response.data);
  //   } on DioException catch (e) {
  //     EasyLoading.dismiss();
  //
  //     throw DioServiceException.fromDioException(e);
  //   } catch (e) {
  //     EasyLoading.dismiss();
  //
  //     throw e.toString();
  //   } finally {
  //     EasyLoading.dismiss();
  //   }
  // }

  Future<DeleteProfileModel?> deleteProfile() async {
    try {
      EasyLoading.show();

      final response = await _dio.post(
        Endpoints.profileDelete,
        queryParameters: {
          'access_token': Constants.accessToken,
          'useruniqueid': Constants.userUniqueId,
          'user_name': Constants.userBadgeNo,
        },
      );

      return DeleteProfileModel.fromJson(response.data);
    } on DioException catch (e) {
      EasyLoading.dismiss();

      throw DioServiceException.fromDioException(e);
    } catch (e) {
      EasyLoading.dismiss();

      throw e.toString();
    } finally {
      EasyLoading.dismiss();
    }
  }

  //Update owner email
  Future<EditEmailModel?> emailEdit({required String? updatedEmail}) async {
    try {
      EasyLoading.show();
      final response = await _dio.post(
        Constants.userRole == Constants.marketing ? Endpoints.updateInfraEmployee : Endpoints.editEmail,
        queryParameters: {
          'access_token': Constants.accessToken,
          'useruniqueid': Constants.userUniqueId,
          'email': updatedEmail,
        },
      );

      if (response.statusCode == 200) {
        return EditEmailModel.fromJson(response.data);
      }
    } on DioException catch (e) {
      EasyLoading.dismiss();
      final errorMessage = e.toString();
      throw errorMessage;
    } catch (e) {
      EasyLoading.dismiss();
      throw e.toString();
    } finally {
      EasyLoading.dismiss();
    }
    return null;
  }

  // Update Employee Email
  Future<EmployeeEditEmailModel?> employeeEmailEdit({required String? updatedEmail}) async {
    try {
      EasyLoading.show();
      final response = await _dio.post(
        Endpoints.editEmployeeEmail,
        queryParameters: {
          'access_token': Constants.accessToken,
          'useruniqueid': Constants.userUniqueId,
          'email': updatedEmail,
        },
      );

      if (response.statusCode == 200) {
        return EmployeeEditEmailModel.fromJson(response.data);
      }
    } on DioException catch (e) {
      EasyLoading.dismiss();
      final errorMessage = e.toString();
      throw errorMessage;
    } catch (e) {
      EasyLoading.dismiss();
      throw e.toString();
    } finally {
      EasyLoading.dismiss();
    }
    return null;
  }

  Future<ForgotPasswordModel?> forgotPassword({/*required String badgeNo,*/ String? emailId, String? mobileNo}) async {
//badge_no, owntenant_name keys
    fd.FormData preResetData = fd.FormData.fromMap({
      // 'badgeNo': badgeNo,
      'email': emailId,
      'mobile': mobileNo,
    });
    try {
      EasyLoading.show();
      final response = await _dio.post(
        Endpoints.forgotPassword,
        data: preResetData,
      );
      return ForgotPasswordModel.fromJson(response.data);
    } on DioException catch (e) {
      EasyLoading.dismiss();
      throw DioServiceException.fromDioException(e);
    } catch (e) {
      EasyLoading.dismiss();
      throw e.toString();
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<ResetPasswordModel> resetPassword(String uid, String otp, String password, String confirmPassword) async {
    try {
      EasyLoading.show();

      final response = await _dio.post(
        Endpoints.resetPassword,
        data: {'uid': uid, 'otp': otp, 'newPassword': password, 'repeatnewPassword': confirmPassword},
        // queryParameters: {
        //   'access_token': Constants.accessToken,
        //   'useruniqueid': Constants.userUniqueId,
        //   'newPassword': 'admin@123',
        //   'repeatnewPassword': 'admin@123',
        // },
      );

      return ResetPasswordModel.fromJson(response.data);
    } on DioException catch (e) {
      EasyLoading.dismiss();

      throw DioServiceException.fromDioException(e);
    } catch (e) {
      EasyLoading.dismiss();

      throw e.toString();
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<RegistrationModel?> employeeRegister(
      {required String employeeId,
      required String employeeName,
      required String setPassword,
      required String confirmPassword,
      required String employeePhoneNo,
      required String employeeAadhaarNo,
      required String employeeRole,
      required Map<String, List<File>> employeeUserImage}) async {
    try {
      final response = await _dio.post(Endpoints.registration, queryParameters: {
        'access_token': Constants.accessToken,
        'useruniqueid': Constants.userUniqueId,
        'badge_no': employeeId,
        'service_engineer_name': employeeName,
        'user_password': setPassword,
        'confirm_password': confirmPassword,
        'phone': employeePhoneNo,
        'aadhar_no': employeeAadhaarNo,
        'sub_service_manager_role': employeeRole,
        'emp_imagefile': employeeUserImage,
      });
      if (response.statusCode == 200) {
        if (response.data['statuscode'] == 0) {
          final statusMessage = response.data['statusMessage'];

          // Check for specific error messages
          if (statusMessage.contains('Mobile number already registered')) {
            Get.snackbar('Oops!!', statusMessage);
          } else if (statusMessage.contains('Email already registered')) {
            Get.snackbar('Oops!!', statusMessage);
          }
          return null;
        }
        RegistrationModel registrationModel = RegistrationModel.fromJson(response.data);
        return registrationModel;
      } else {
        Fluttertoast.showToast(
          msg: 'Fetching Registration failed',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        throw Exception('Fetching Registration failed');
      }
    } on DioException catch (e) {
      throw DioServiceException.fromDioException(e);
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      throw Exception(e);
    }
    //return data;
  }

  Future<EmployeeForgotPasswordModel?> employeeForgotPassword({required String badgeNo, String? emailId, String? mobileNo}) async {
//badge_no, owntenant_name keys
    fd.FormData preResetData = fd.FormData.fromMap({'badgeNo': badgeNo, 'email': emailId, 'mobile': mobileNo});
    try {
      EasyLoading.show();
      final response = await _dio.post(
        Endpoints.forgotPassword,
        data: preResetData,
      );
      return EmployeeForgotPasswordModel.fromJson(response.data);
    } on DioException catch (e) {
      EasyLoading.dismiss();
      throw DioServiceException.fromDioException(e);
    } catch (e) {
      EasyLoading.dismiss();
      throw e.toString();
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<EmployeeResetPasswordModel> employeeResetPassword(String uid, String otp, String password, String confirmPassword) async {
    try {
      EasyLoading.show();

      final response = await _dio.post(
        Endpoints.resetPassword,
        data: {'uid': uid, 'otp': otp, 'newPassword': password, 'repeatnewPassword': confirmPassword},
        queryParameters: {
          'access_token': Constants.accessToken,
          'useruniqueid': Constants.userUniqueId,
          'newPassword': 'admin@123',
          'repeatnewPassword': 'admin@123',
        },
      );

      return EmployeeResetPasswordModel.fromJson(response.data);
    } on DioException catch (e) {
      EasyLoading.dismiss();

      throw DioServiceException.fromDioException(e);
    } catch (e) {
      EasyLoading.dismiss();

      throw e.toString();
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<EmployeeProfileModel?> employeeProfile() async {
    try {
      EasyLoading.show();
      final response = await _dio.post(
        Endpoints.employeeProfile,
        queryParameters: {
          'access_token': Constants.accessToken,
          'useruniqueid': Constants.userUniqueId,
          // 'owntenant_email':'shreedhev98@gmail.com',
        },
      );

      if (response.statusCode == 200) {
        return EmployeeProfileModel.fromJson(response.data);
      } else if (response.statusCode == 200 && response.statusCode == 0) {
        snackBarMessenger(response.statusMessage.toString());
      }
    } on DioException catch (e) {
      EasyLoading.dismiss();
      final errorMessage = e.toString();
      throw errorMessage;
    } catch (e) {
      EasyLoading.dismiss();
      throw e.toString();
    } finally {
      EasyLoading.dismiss();
    }
    return null;
  }

  Future<EmployeeChangePasswordModel?> employeeChangePassword({required String newPassword, required String confirmPassword}) async {
    try {
      EasyLoading.show();

      final response = await _dio.post(
        Endpoints.passwordChange,
        queryParameters: {'access_token': Constants.accessToken, 'useruniqueid': Constants.userUniqueId, 'newPassword': newPassword, 'confirmPassword': confirmPassword},
      );

      return EmployeeChangePasswordModel.fromJson(response.data);
    } on DioException catch (e) {
      EasyLoading.dismiss();

      throw DioServiceException.fromDioException(e);
    } catch (e) {
      EasyLoading.dismiss();

      throw e.toString();
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<EmployeeDeleteProfileModel?> employeeDeleteProfile() async {
    print("Delete Account");
    print(Constants.userBadgeNo);
    try {
      EasyLoading.show();
      final response = await _dio.post(
        Endpoints.profileDelete,
        queryParameters: {
          'access_token': Constants.accessToken,
          'useruniqueid': Constants.userUniqueId,
          'user_name': Constants.userBadgeNo,
        },
      );
      if (response.statusCode == 200) {
        return EmployeeDeleteProfileModel.fromJson(response.data);
      } else {
        Get.snackbar("Error!", response.statusMessage.toString());
        debugger.printLogs('Error while delete account -> ${response.statusMessage ?? ''}');
        if (response.statusMessage == 'Already Profile Delete Is requested') {
          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          sharedPreferences.clear();
          Get.offAll(const LoginScreen());
        }
      }
    } on DioException catch (e) {
      EasyLoading.dismiss();

      throw DioServiceException.fromDioException(e);
    } catch (e) {
      EasyLoading.dismiss();

      throw e.toString();
    } finally {
      EasyLoading.dismiss();
    }
    return null;
  }

  // To fetch approved guest list
  Future<GuestApprovalListModel> fetchApprovedGuest({
    required int page,
    bool? searchParams,
  }) async {
    late final GuestApprovalListModel data;
    try {
      final response = await _dio.post(
        Endpoints.listing,
        data: fd.FormData.fromMap({
          'access_token': Constants.accessToken,
          'module': Constants.visitorsModule,
          'page': page.toString(),
          'useruniqueid': Constants.userUniqueId,
          if (searchParams == true) 'search_params': '[["visitor_in", "e", "1"]]' else 'search_params': '[["visitor_in", "e", "0"]]'
        }),
      );
      if (response.statusCode == 200 && response.data['statuscode'] == 1) {
        data = GuestApprovalListModel.fromJson(response.data);
      } else {
        Fluttertoast.showToast(
          msg: 'Fetching approved guest failed',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        throw Exception('Fetching approved guest failed');
      }
    } on DioException catch (e) {
      throw DioServiceException.fromDioException(e);
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      throw Exception(e);
    }
    return data;
  }

  // To add and approve a single guest
  Future<GuestInvitationModel> addInviteGuest({
    required String name,
    required String mobile,
    required String date,
    required String time,
    required String validity,
    String? recordId,
  }) async {
    late final GuestInvitationModel data;
    EasyLoading.show();
    try {
      final response = await _dio.post(
        Endpoints.saveRecord,
        data: fd.FormData.fromMap({
          'access_token': Constants.accessToken,
          'module': Constants.visitorsModule,
          'useruniqueid': Constants.userUniqueId,
          'values': {
            'assigned_user_id': Constants.userUniqueId,
            'todays_date': date,
            'visitor_mobile': mobile,
            'visitor_name': name,
            'visitor_startingtime': time,
            'visitor_valid': validity,
          },
          'record': recordId
        }),
      );
      if (response.statusCode == 200 && response.data['statuscode'] == 1) {
        data = GuestInvitationModel.fromJson(response.data);
        Fluttertoast.showToast(
          msg: 'Guest Invitation Created',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Invitation Failed',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        throw Exception('Invitation Failed');
      }
    } on DioException catch (e) {
      throw DioServiceException.fromDioException(e);
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      throw Exception(e);
    } finally {
      EasyLoading.dismiss();
    }
    return data;
  }

  // Notice Type Dropdown
  Future<NoticeTypeDropdownModal?> getNoticeType() async {
    try {
      EasyLoading.show(status: 'Loading...');

      final response = await _dio.post(
        Endpoints.getPicklist,
        queryParameters: {
          'access_token': Constants.accessToken,
          'useruniqueid': Constants.userUniqueId,
          'module': Constants.noticeModule,
          'field': 'notice_type',
        },
      );

      EasyLoading.dismiss();

      return NoticeTypeDropdownModal.fromJson(response.data);
    } on DioException catch (e) {
      EasyLoading.dismiss();

      throw DioServiceException.fromDioException(e);
    } catch (e) {
      EasyLoading.dismiss();

      throw e.toString();
    }
  }

  // Notice Share Dropdown
  Future<NoticeShareDropdownModal?> getNoticeShare() async {
    try {
      EasyLoading.show(status: 'Loading...');

      final response = await _dio.post(
        Endpoints.getPicklist,
        queryParameters: {
          'access_token': Constants.accessToken,
          'useruniqueid': Constants.userUniqueId,
          'module': Constants.noticeModule,
          'field': 'notice_share',
        },
      );

      EasyLoading.dismiss();

      return NoticeShareDropdownModal.fromJson(response.data);
    } on DioException catch (e) {
      EasyLoading.dismiss();

      throw DioServiceException.fromDioException(e);
    } catch (e) {
      EasyLoading.dismiss();

      throw e.toString();
    }
  }

  // Notice Board Upload Attachment
  Future<void> uploadAttachmentForNoticeBoard({required String? recordId, required String imageName}) async {
    fd.FormData formData = fd.FormData.fromMap({
      'access_token': Constants.accessToken,
      'useruniqueid': Constants.userUniqueId,
      'module': Constants.noticeModule,
      'recordId': recordId,
      'fieldName': 'notice_attachment',
      'notice_attachment': await multip.MultipartFile.fromFile(
        imageName,
      ),
    });

    try {
      await _dio.post(
        Endpoints.uploadAttachment,
        data: formData,
      );
    } on DioException catch (e) {
      EasyLoading.dismiss();

      throw DioServiceException.fromDioException(e);
    } catch (e) {
      EasyLoading.dismiss();

      throw e.toString();
    }
  }

  // // Notice Board Advertisement Upload Attachment
  // Future<void> uploadAdvAttachmentForNoticeBoard({required String? advRecordId, required String advImageName}) async {
  //   fd.FormData formData = fd.FormData.fromMap({
  //     'access_token': Constants.accessToken,
  //     'useruniqueid': Constants.userUniqueId,
  //     'module': Constants.noticeModule,
  //     'recordId': advRecordId,
  //     'fieldName': 'notice_advertisement',
  //     'notice_advertisement': await multip.MultipartFile.fromFile(
  //       advImageName,
  //     ),
  //   });

  //   try {
  //     await _dio.post(
  //       Endpoints.attachment,
  //       data: formData,
  //     );
  //   } on DioException catch (e) {
  //     EasyLoading.dismiss();

  //     throw DioServiceException.fromDioException(e);
  //   } catch (e) {
  //     EasyLoading.dismiss();

  //     throw e.toString();
  //   }
  // }

  // Notice Board Creation
  Future<NoticeBoardCreationModal?> submitNotice({
    required String noticeType,
    required String noticeSub,
    required String noticeDescription,
    required String noticeShare,
    List<XFile>? imageList,
  }) async {
    try {
      EasyLoading.show();

      final response = await _dio.post(
        Endpoints.saveRecord,
        queryParameters: {
          'access_token': Constants.accessToken,
          'useruniqueid': Constants.userUniqueId,
          'module': Constants.noticeModule,
          'values': {
            'notice_type': noticeType,
            'notice_sub': noticeSub,
            'notice_description': noticeDescription,
            'notice_share': noticeShare,
            'assigned_user_id': Constants.userUniqueId,
          },
        },
      );

      var responseData = NoticeBoardCreationModal.fromJson(response.data);

      if (response.statusCode == 200 && response.data['statuscode'] == 1) {
        log('Invited one guest');

        for (int i = 0; i < imageList!.length; i++) {
          await uploadAttachmentForNoticeBoard(recordId: responseData.data!.id, imageName: imageList[i].path);
        }
      }
      EasyLoading.dismiss();

      return NoticeBoardCreationModal.fromJson(response.data);
    } on DioException catch (e) {
      EasyLoading.dismiss();

      throw DioServiceException.fromDioException(e);
    } catch (e) {
      EasyLoading.dismiss();

      throw e.toString();
    }
  }

  // Notice Board Listing
  Future<NoticeBoardListingModal?> getNoticeList({required int page, required String filter}) async {
    try {
      final response = await _dio.post(
        Endpoints.listing,
        queryParameters: {'access_token': Constants.accessToken, 'useruniqueid': Constants.userUniqueId, 'module': Constants.noticeModule, 'page': page, 'search_params': filter},
      );
      return NoticeBoardListingModal.fromJson(response.data);
    } on DioException catch (e) {
      throw DioServiceException.fromDioException(e);
    } catch (e) {
      throw e.toString();
    }
  }

  // Notice Board Delete
  Future<NoticeBoardDeleteModal?> getNoticeDelete({required String record}) async {
    EasyLoading.show();

    try {
      final response = await _dio.post(
        Endpoints.deleteRecords,
        data: fd.FormData.fromMap({
          'access_token': Constants.accessToken,
          'useruniqueid': Constants.userUniqueId,
          'module': Constants.noticeModule,
          'record': record,
        }),
      );
      EasyLoading.dismiss();

      return NoticeBoardDeleteModal.fromJson(response.data);
    } on DioException catch (e) {
      EasyLoading.dismiss();

      throw DioServiceException.fromDioException(e);
    } catch (e) {
      EasyLoading.dismiss();

      throw e.toString();
    }
  }

  // Notice Board Details
  Future<NoticeBoardDetailsModal?> getNoticeDetails({required String? recordId}) async {
    try {
      final response = await _dio.post(
        Endpoints.getRecordDetail,
        queryParameters: {
          'module': Constants.noticeModule,
          'access_token': Constants.accessToken,
          'record': recordId,
          'useruniqueid': Constants.userUniqueId,
        },
      );

      return NoticeBoardDetailsModal.fromJson(response.data);
    } on DioException catch (e) {
      throw DioServiceException.fromDioException(e);
    } catch (e) {
      throw e.toString();
    }
  }

  // Notice Board Count
  Future<NoticeBoardCountModal?> getNoticeCount() async {
    try {
      final response = await _dio.post(
        Endpoints.count,
        queryParameters: {
          'access_token': Constants.accessToken,
          'useruniqueid': Constants.userUniqueId,
          'module': Constants.noticeModule,
        },
      );

      return NoticeBoardCountModal.fromJson(response.data);
    } on DioException catch (e) {
      throw DioServiceException.fromDioException(e);
    } catch (e) {
      throw e.toString();
    }
  }

  // Notice Board Filter
  Future<NoticeBoardFilterModal> getNoticeFilter({required String? noticeType}) async {
    try {
      final response = await _dio.post(
        Endpoints.noticeFilter,
        queryParameters: {'access_token': Constants.accessToken, 'useruniqueid': Constants.userUniqueId, 'module': Constants.noticeModule, 'notice_type': noticeType},
      );

      return NoticeBoardFilterModal.fromJson(response.data);
    } on DioException catch (e) {
      throw DioServiceException.fromDioException(e);
    } catch (e) {
      throw e.toString();
    }
  }

  // Adv Notice Type Dropdown
  Future<AdvNoticeTypeDropdownModal?> getAdvNoticeType() async {
    try {
      EasyLoading.show(status: 'Loading...');

      final response = await _dio.post(
        Endpoints.getPicklist,
        queryParameters: {
          'access_token': Constants.accessToken,
          'useruniqueid': Constants.userUniqueId,
          'module': Constants.advNoticeModule,
          'field': 'advnotice_type',
        },
      );

      EasyLoading.dismiss();

      return AdvNoticeTypeDropdownModal.fromJson(response.data);
    } on DioException catch (e) {
      EasyLoading.dismiss();

      throw DioServiceException.fromDioException(e);
    } catch (e) {
      EasyLoading.dismiss();

      throw e.toString();
    }
  }

  // Adv Notice Share Dropdown
  Future<AdvNoticeShareDropdownModal?> getAdvNoticeShare() async {
    try {
      EasyLoading.show(status: 'Loading...');

      final response = await _dio.post(
        Endpoints.getPicklist,
        queryParameters: {
          'access_token': Constants.accessToken,
          'useruniqueid': Constants.userUniqueId,
          'module': Constants.advNoticeModule,
          'field': 'advnotice_share',
        },
      );

      EasyLoading.dismiss();

      return AdvNoticeShareDropdownModal.fromJson(response.data);
    } on DioException catch (e) {
      EasyLoading.dismiss();

      throw DioServiceException.fromDioException(e);
    } catch (e) {
      EasyLoading.dismiss();

      throw e.toString();
    }
  }

  // Adv Upload Attachment
  Future<void> uploadAdvAttachment({required String? recordId, required String imageName}) async {
    fd.FormData formData = fd.FormData.fromMap({
      'access_token': Constants.accessToken,
      'useruniqueid': Constants.userUniqueId,
      'module': Constants.advNoticeModule,
      'recordId': recordId,
      'fieldName': 'advnotice_imageurl',
      'advnotice_imageurl': await multip.MultipartFile.fromFile(
        imageName,
      ),
    });

    try {
      await _dio.post(
        Endpoints.uploadAttachment,
        data: formData,
      );
    } on DioException catch (e) {
      EasyLoading.dismiss();

      throw DioServiceException.fromDioException(e);
    } catch (e) {
      EasyLoading.dismiss();

      throw e.toString();
    }
  }

  // Adv Notice Board Creation
  Future<AdvNoticeBoardCreationModal?> submitAdvNotice({
    required String? posterStartDate,
    required String? posterEndDate,
    required String advNoticeType,
    required String advNoticeSub,
    required String advNoticeDescription,
    String? advNoticeShare,
    XFile? image,
  }) async {
    try {
      EasyLoading.show();

      final response = await _dio.post(
        Endpoints.saveRecord,
        queryParameters: {
          'access_token': Constants.accessToken,
          'useruniqueid': Constants.userUniqueId,
          'module': Constants.advNoticeModule,
          'values': {
            'posterstart_date': posterStartDate,
            'posterend_date': posterEndDate,
            'advnotice_type': advNoticeType,
            'advnotice_sub': advNoticeSub,
            'adv_description': advNoticeDescription,
            'advnotice_share': advNoticeShare,
            'assigned_user_id': Constants.userUniqueId,
          },
        },
      );

      var responseData = AdvNoticeBoardCreationModal.fromJson(response.data);

      if (response.statusCode == 200 && response.data['statuscode'] == 1) {
        log('Invited one guest');

        await uploadAdvAttachment(recordId: responseData.data!.id, imageName: image!.path);
      }

      EasyLoading.dismiss();

      return AdvNoticeBoardCreationModal.fromJson(response.data);
    } on DioException catch (e) {
      EasyLoading.dismiss();

      throw DioServiceException.fromDioException(e);
    } catch (e) {
      EasyLoading.dismiss();

      throw e.toString();
    }
  }

  // Adv Notice Board Listing
  Future<AdvNoticeBoardListingModal?> getAdvNoticeList({required int page, required String filter}) async {
    try {
      final response = await _dio.post(
        Endpoints.listing,
        queryParameters: {'access_token': Constants.accessToken, 'useruniqueid': Constants.userUniqueId, 'module': Constants.advNoticeModule, 'page': page, 'search_params': filter},
      );
      return AdvNoticeBoardListingModal.fromJson(response.data);
    } on DioException catch (e) {
      throw DioServiceException.fromDioException(e);
    } catch (e) {
      throw e.toString();
    }
  }

  // Adv Notice Board Delete
  Future<AdvNoticeBoardDeleteModal?> getAdvNoticeDelete({required String record}) async {
    EasyLoading.show();

    try {
      final response = await _dio.post(
        Endpoints.deleteRecords,
        data: fd.FormData.fromMap({
          'access_token': Constants.accessToken,
          'useruniqueid': Constants.userUniqueId,
          'module': Constants.advNoticeModule,
          'record': record,
        }),
      );
      EasyLoading.dismiss();

      return AdvNoticeBoardDeleteModal.fromJson(response.data);
    } on DioException catch (e) {
      EasyLoading.dismiss();

      throw DioServiceException.fromDioException(e);
    } catch (e) {
      EasyLoading.dismiss();

      throw e.toString();
    }
  }

  // Adv Notice Board Details
  Future<AdvNoticeBoardDetailsModal?> getAdvNoticeDetails({required String? recordId}) async {
    try {
      final response = await _dio.post(
        Endpoints.getRecordDetail,
        queryParameters: {
          'module': Constants.advNoticeModule,
          'access_token': Constants.accessToken,
          'record': recordId,
          'useruniqueid': Constants.userUniqueId,
        },
      );

      return AdvNoticeBoardDetailsModal.fromJson(response.data);
    } on DioException catch (e) {
      throw DioServiceException.fromDioException(e);
    } catch (e) {
      throw e.toString();
    }
  }

  // Adv Notice Board Count
  Future<AdvNoticeBoardCountModal?> getAdvNoticeCount() async {
    try {
      final response = await _dio.post(
        Endpoints.count,
        queryParameters: {
          'access_token': Constants.accessToken,
          'useruniqueid': Constants.userUniqueId,
          'module': Constants.advNoticeModule,
        },
      );

      return AdvNoticeBoardCountModal.fromJson(response.data);
    } on DioException catch (e) {
      throw DioServiceException.fromDioException(e);
    } catch (e) {
      throw e.toString();
    }
  }

  // Advertisement
  Future<AnnouncementModal?> getAnnouncement() async {
    try {
      final response = await _dio.post(
        Endpoints.announcement,
        queryParameters: {
          // 'access_token': Constants.accessToken,
          // 'useruniqueid': Constants.userUniqueId,
          'module': Constants.announcements,
        },
      );
      return AnnouncementModal.fromJson(response.data);
    } on DioException catch (e) {
      throw DioServiceException.fromDioException(e);
    } catch (e) {
      throw e.toString();
    }
  }

  // Employee Role Dropdown
  Future<EmployeeRoleDropdownModal?> getEmployeeRole() async {
    try {
      EasyLoading.show(status: 'Loading...');

      final response = await _dio.post(
        Endpoints.getPicklist,
        queryParameters: {
          'access_token': Constants.accessToken,
          'useruniqueid': Constants.userUniqueId,
          'module': Constants.employeeRegModule,
          'field': 'sub_service_manager_role',
        },
      );

      EasyLoading.dismiss();

      return EmployeeRoleDropdownModal.fromJson(response.data);
    } on DioException catch (e) {
      EasyLoading.dismiss();

      throw DioServiceException.fromDioException(e);
    } catch (e) {
      EasyLoading.dismiss();

      throw e.toString();
    }
  }

  Future<EmployeeRoleUserwiseDropdownModal?> getEmployeeRoleUserwise() async {
    try {
      EasyLoading.show(status: 'Loading...');

      final response = await _dio.post(
        Endpoints.getRoleWisePicklist,
        queryParameters: {'access_token': Constants.accessToken, 'useruniqueid': Constants.userUniqueId, 'field': 'sub_service_manager_role', 'fieldvalue': Constants.userRole},
      );

      EasyLoading.dismiss();

      return EmployeeRoleUserwiseDropdownModal.fromJson(response.data);
    } on DioException catch (e) {
      EasyLoading.dismiss();

      throw DioServiceException.fromDioException(e);
    } catch (e) {
      EasyLoading.dismiss();

      throw e.toString();
    }
  }

  // Employee Society Dropdown
  Future<EmployeeSocietyDropdownModal?> getEmployeeSociety() async {
    try {
      EasyLoading.show(status: 'Loading...');

      final response = await _dio.post(
        Endpoints.getPicklist,
        queryParameters: {
          'access_token': Constants.accessToken,
          'useruniqueid': Constants.userUniqueId,
          'module': Constants.employeeRegModule,
          'field': 'emp_society',
        },
      );

      EasyLoading.dismiss();

      return EmployeeSocietyDropdownModal.fromJson(response.data);
    } on DioException catch (e) {
      EasyLoading.dismiss();

      throw DioServiceException.fromDioException(e);
    } catch (e) {
      EasyLoading.dismiss();

      throw e.toString();
    }
  }

  // Employee Block Dropdown
  Future<EmployeeBlockDropdownModal?> getEmployeeBlock() async {
    try {
      EasyLoading.show(status: 'Loading...');

      final response = await _dio.post(
        Endpoints.getPicklist,
        queryParameters: {
          'access_token': Constants.accessToken,
          'useruniqueid': Constants.userUniqueId,
          'module': Constants.employeeRegModule,
          'field': 'emp_block',
        },
      );

      EasyLoading.dismiss();

      return EmployeeBlockDropdownModal.fromJson(response.data);
    } on DioException catch (e) {
      EasyLoading.dismiss();

      throw DioServiceException.fromDioException(e);
    } catch (e) {
      EasyLoading.dismiss();

      throw e.toString();
    }
  }

  // Employee Aadhar Upload Attachment
  Future<void> uploadAadharAttachmentEmployeeRegistration({required String? recordId, required String imageName}) async {
    fd.FormData formData = fd.FormData.fromMap({
      'access_token': Constants.accessToken,
      'useruniqueid': Constants.userUniqueId,
      'module': Constants.employeeRegModule,
      'recordId': recordId,
      'fieldName': 'emp_adharpic',
      'emp_adharpic': await multip.MultipartFile.fromFile(
        imageName,
      ),
    });

    try {
      await _dio.post(
        Endpoints.uploadAttachment,
        data: formData,
      );
    } on DioException catch (e) {
      EasyLoading.dismiss();

      throw DioServiceException.fromDioException(e);
    } catch (e) {
      EasyLoading.dismiss();

      throw e.toString();
    }
  }

  // Employee Profile Upload Attachment
  Future<void> uploadProfileAttachmentEmployeeRegistration({required String? recordId, required String imageName}) async {
    fd.FormData formData = fd.FormData.fromMap({
      'access_token': Constants.accessToken,
      'useruniqueid': Constants.userUniqueId,
      'module': Constants.employeeRegModule,
      'recordId': recordId,
      'fieldName': 'emp_imagefile',
      'emp_imagefile': await multip.MultipartFile.fromFile(
        imageName,
      ),
    });

    try {
      await _dio.post(
        Endpoints.uploadAttachment,
        data: formData,
      );
    } on DioException catch (e) {
      EasyLoading.dismiss();

      throw DioServiceException.fromDioException(e);
    } catch (e) {
      EasyLoading.dismiss();

      throw e.toString();
    }
  }

  // Employee Registration
  Future<EmployeeRegistrationModal?> submitEmployee({
    // required String badgeNo,
    required String serviceEngineerName,
    required String phone,
    required String aadharNo,
    required String subServiceManagerRole,
    String? email,
    required String empSociety,
    required String empBlock,
    required String empStartTime,
    required String empEndTime,
    required String empWeakOff,
    List<XFile>? imageList,
    XFile? image,
  }) async {
    fd.FormData employeeRegistrationFormData = fd.FormData.fromMap({
      'access_token': Constants.accessToken,
      'useruniqueid': Constants.userUniqueId,
      'service_engineer_name': serviceEngineerName,
      'phone': phone,
      'aadhar_no': aadharNo,
      'sub_service_manager_role': subServiceManagerRole,
      'email': email,
      'emp_society': empSociety,
      'emp_block': empBlock,
      'emp_starttime': empStartTime,
      'emp_endtime': empEndTime,
      'emp_weakoff': empWeakOff,
    });
    try {
      EasyLoading.show();

      final response = await _dio.post(
        Endpoints.registration,
        data: employeeRegistrationFormData,
      );

      var responseData = EmployeeRegistrationModal.fromJson(response.data);

      if (response.statusCode == 200 && response.data['statuscode'] == 1) {
        log('Invited one guest');

        for (int i = 0; i < imageList!.length; i++) {
          await uploadAadharAttachmentEmployeeRegistration(recordId: responseData.data!.record!.serviceEngineerId, imageName: imageList[i].path);
        }

        await uploadProfileAttachmentEmployeeRegistration(recordId: responseData.data!.record!.serviceEngineerId, imageName: image!.path);
      }

      EasyLoading.dismiss();

      return EmployeeRegistrationModal.fromJson(response.data);
    } on DioException catch (e) {
      EasyLoading.dismiss();

      throw DioServiceException.fromDioException(e);
    } catch (e) {
      EasyLoading.dismiss();

      throw e.toString();
    } finally {
      EasyLoading.dismiss();
    }
  }

  // Employee Registration List
  Future<EmployeeRegistrationListModel?> getEmployeeRegistrationList({required int page}) async {
    try {
      final response = await _dio.post(
        Endpoints.listing,
        queryParameters: {'access_token': Constants.accessToken, 'useruniqueid': Constants.userUniqueId, 'module': Constants.employeeRegModule, 'page': page},
      );
      return EmployeeRegistrationListModel.fromJson(response.data);
    } on DioException catch (e) {
      throw DioServiceException.fromDioException(e);
    } catch (e) {
      throw e.toString();
    }
  }

  // Employee Registration Details
  Future<EmployeeRegistrationDetailsModal?> getEmployeeRegistrationDetails({required String? recordId}) async {
    try {
      final response = await _dio.post(
        Endpoints.getRecordDetail,
        queryParameters: {
          'access_token': Constants.accessToken,
          'useruniqueid': Constants.userUniqueId,
          'module': Constants.employeeRegModule,
          'record': recordId,
        },
      );

      return EmployeeRegistrationDetailsModal.fromJson(response.data);
    } on DioException catch (e) {
      throw DioServiceException.fromDioException(e);
    } catch (e) {
      throw e.toString();
    }
  }

  // List Category Dropdown
  Future<ListCategoryDropdownModal?> getListCategory() async {
    try {
      EasyLoading.show(status: 'Loading...');

      final response = await _dio.post(
        Endpoints.getPicklist,
        queryParameters: {
          'access_token': Constants.accessToken,
          'useruniqueid': Constants.userUniqueId,
          'module': Constants.buyAndSellModule,
          'field': 'buysell_category',
        },
      );

      EasyLoading.dismiss();

      return ListCategoryDropdownModal.fromJson(response.data);
    } on DioException catch (e) {
      EasyLoading.dismiss();

      throw DioServiceException.fromDioException(e);
    } catch (e) {
      EasyLoading.dismiss();

      throw e.toString();
    }
  }

  // Type of Sell Dropdown
  Future<TypeofSellDropdownModal?> getTypeofSell() async {
    try {
      EasyLoading.show(status: 'Loading...');

      final response = await _dio.post(
        Endpoints.getPicklist,
        queryParameters: {
          'access_token': Constants.accessToken,
          'useruniqueid': Constants.userUniqueId,
          'module': Constants.buyAndSellModule,
          'field': 'buysell_selltype',
        },
      );

      EasyLoading.dismiss();

      return TypeofSellDropdownModal.fromJson(response.data);
    } on DioException catch (e) {
      EasyLoading.dismiss();

      throw DioServiceException.fromDioException(e);
    } catch (e) {
      EasyLoading.dismiss();

      throw e.toString();
    }
  }

  // Buy and Sell Upload Attachment
  Future<void> uploadAttachmentBuyAndSellItem({required String? recordId, required String imageName}) async {
    fd.FormData formData = fd.FormData.fromMap({
      'access_token': Constants.accessToken,
      'useruniqueid': Constants.userUniqueId,
      'module': Constants.buyAndSellModule,
      'recordId': recordId,
      'fieldName': 'buysell_uploadpic',
      'buysell_uploadpic': await multip.MultipartFile.fromFile(
        imageName,
      ),
    });

    try {
      await _dio.post(
        Endpoints.uploadAttachment,
        data: formData,
      );
    } on DioException catch (e) {
      EasyLoading.dismiss();

      throw DioServiceException.fromDioException(e);
    } catch (e) {
      EasyLoading.dismiss();

      throw e.toString();
    }
  }

  // Buy and Sell Creation
  Future<BuyAndSellCreationModal?> submitBuyAndSell(
      {required String buySellCategory,
      required String buySellTitle,
      required String buySellSpecification,
      required String buySellYear,
      required String buySellPurchasePrice,
      required String buySellSellType,
      String? buySellCost,
      required int buySellNegotiate,
      required List<XFile>? imageList,
      String? recordId,
      List<String>? listOfImageRecordToBeDeleted}) async {
    try {
      EasyLoading.show();

      final response = await _dio.post(
        Endpoints.saveRecord,
        queryParameters: {
          'access_token': Constants.accessToken,
          'useruniqueid': Constants.userUniqueId,
          'module': Constants.buyAndSellModule,
          'values': {
            'buysell_category': buySellCategory,
            'buysell_title': buySellTitle,
            'buysell_specification': buySellSpecification,
            'buysell_year': buySellYear,
            'buysell_purchase_price': buySellPurchasePrice,
            'buysell_selltype': buySellSellType,
            'buysell_cost': buySellCost,
            'buysell_negotiate': buySellNegotiate,
            'assigned_user_id': Constants.userUniqueId,
          },
          'record': recordId
        },
      );

      var responseData = BuyAndSellCreationModal.fromJson(response.data);

      if (response.statusCode == 200 && response.data['statuscode'] == 1) {
        log('Invited one guest');

        await deleteAttachment(listOfImages: listOfImageRecordToBeDeleted, recordId: recordId, module: Constants.buyAndSellModule);

        for (int i = 0; i < imageList!.length; i++) {
          await uploadAttachmentBuyAndSellItem(recordId: responseData.data!.id, imageName: imageList[i].path);
        }
      }
      EasyLoading.dismiss();

      return BuyAndSellCreationModal.fromJson(response.data);
    } on DioException catch (e) {
      EasyLoading.dismiss();

      throw DioServiceException.fromDioException(e);
    } catch (e) {
      EasyLoading.dismiss();

      throw e.toString();
    }
  }

  // Buy And Sell List
  Future<BuyAndSellListingModal?> getBuyAndSellList({required int page, required String filter}) async {
    try {
      final response = await _dio.post(
        Endpoints.listing,
        queryParameters: {'access_token': Constants.accessToken, 'useruniqueid': Constants.userUniqueId, 'module': Constants.buyAndSellModule, 'page': page, 'search_params': filter},
      );
      return BuyAndSellListingModal.fromJson(response.data);
    } on DioException catch (e) {
      throw DioServiceException.fromDioException(e);
    } catch (e) {
      throw e.toString();
    }
  }

  // Buy And Sell Details
  Future<BuyAndSellDetailsModal?> getBuyAndSellDetails({required String? recordId}) async {
    try {
      final response = await _dio.post(
        Endpoints.getRecordDetail,
        queryParameters: {
          'access_token': Constants.accessToken,
          'useruniqueid': Constants.userUniqueId,
          'module': Constants.buyAndSellModule,
          'record': recordId,
        },
      );

      return BuyAndSellDetailsModal.fromJson(response.data);
    } on DioException catch (e) {
      throw DioServiceException.fromDioException(e);
    } catch (e) {
      throw e.toString();
    }
  }

  // Buy And Sell Comments Creation
  Future<BuyAndSellCommentsCreationModal?> commentBuyAndSell({
    required String commentContent,
    required String relatedTo,
  }) async {
    try {
      final response = await _dio.post(
        Endpoints.saveRecord,
        queryParameters: {
          'access_token': Constants.accessToken,
          'module': 'ModComments',
          'useruniqueid': Constants.userUniqueId,
          'values': {
            'commentcontent': commentContent,
            'related_to': relatedTo,
            'assigned_user_id': Constants.userUniqueId,
          },
        },
      );

      if (response.statusCode == 200 && response.data['statuscode'] == 1) {
        // Assuming you have a `fromJson` method in `BuyAndSellCommentsCreationModal` class
        return BuyAndSellCommentsCreationModal.fromJson(response.data);
      } else {
        throw Exception('Failed to create comment: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw DioServiceException.fromDioException(e);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Buy And Sell Comments List
  Future<BuyAndSellCommentsListing?> getBuyAndSellCommentsList({required String? recordId}) async {
    try {
      final response = await _dio.post(
        Endpoints.getRecordComments,
        queryParameters: {'record': recordId, 'access_token': Constants.accessToken, 'useruniqueid': Constants.userUniqueId},
      );
      return BuyAndSellCommentsListing.fromJson(response.data);
    } on DioException catch (e) {
      throw DioServiceException.fromDioException(e);
    } catch (e) {
      throw e.toString();
    }
  }

  //Buy And Sell Sold
  Future<BuyAndSellSoldModal?> getBuyAndSellSold({
    required int buySellSold,
    String? recordId,
  }) async {
    try {
      final response = await _dio.post(
        Endpoints.saveRecord,
        queryParameters: {
          'access_token': Constants.accessToken,
          'useruniqueid': Constants.userUniqueId,
          'module': Constants.buyAndSellModule,
          'values': {
            'buysell_issold': buySellSold,
          },
          'record': recordId
        },
      );

      if (response.statusCode == 200 && response.data['statuscode'] == 1) {
        // Assuming you have a `fromJson` method in `BuyAndSellCommentsCreationModal` class
        return BuyAndSellSoldModal.fromJson(response.data);
      } else {
        throw Exception('Failed to create comment: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw DioServiceException.fromDioException(e);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //Water Tank Listing
  Future<WaterTankListModel?> getWaterTankList(bool checkAccessToken, {required int page}) async {
    try {
      final response = await _dio.post(
        Endpoints.listing,
        data: {'access_token': Constants.accessToken, 'module': 'WaterTank', 'useruniqueid': Constants.userUniqueId, 'page': page},
      );
      if (response.statusCode == 200) {
        if (response.statusMessage.toString().contains("Invalid Access Token")) {
          if (checkAccessToken) {
            //EasyLoading.show();
            Fluttertoast.showToast(
                msg: pleaseLoginAgainText,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0);
            sharedPreferences = await SharedPreferences.getInstance();
            await sharedPreferences!.clear();
            Get.offAll(const CompanyCode());
          }
        }
        WaterTankListModel? waterTankListModel = WaterTankListModel.fromJson(response.data);
        return waterTankListModel;
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      final errorMessage = err.toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
    return null;
  }

  //Water Tank Details
  Future<WaterTankDetailModel?> getWaterTankDetails({required String recordId}) async {
    try {
      //EasyLoading.show();
      final response = await _dio.post(
        Endpoints.getRecordDetail,
        data: {'access_token': Constants.accessToken, 'module': 'WaterTank', 'useruniqueid': Constants.userUniqueId, 'record': recordId},
      );
      if (response.statusCode == 200) {
        if (response.data['statuscode'] == 0) {
          final statusMessage = response.data['statusMessage'];
          if (statusMessage.contains('Permission to perform the operation is denied for id')) {
            Get.snackbar('Oops!!', statusMessage);
            Get.close(1);
          } else if (statusMessage.contains('Invalid Access Token')) {
            // Get.snackbar('Oops!!', statusMessage);
            Get.offAll(() => const CompanyCode());
          } else if (statusMessage.contains('userUniqueId is Empty')) {
            // Get.snackbar('Oops!!', statusMessage);
            Get.offAll(() => const CompanyCode());
          }

          return null;
        }
        WaterTankDetailModel? waterTankDetailModel = WaterTankDetailModel.fromJson(response.data);
        return waterTankDetailModel;
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      final errorMessage = err.toString();
      throw errorMessage;
    } catch (e) {
      EasyLoading.dismiss();
      throw e.toString();
    } finally {
      EasyLoading.dismiss();
    }
    return null;
  }

//Water Tank Save Record
  Future<WaterTankModel?> waterTankSaveRecord(
      {required String waterSupplierName,
      required String waterTankCapacityName,
      //required String vehicleNumber,
      required String contactNumber,
      required String startDate,
      required String endDate,
      required List<File?> ownerImage,
      required RxList<XFile?> mediaList,
      String? recordId,
      List<String>? listOfImageRecordToBeDeleted}) async {
    try {
      EasyLoading.show();
      Map<String, dynamic>? waterTankSaveRecordValues = {
        'wtsuplier_name': waterSupplierName,
        'wtcapacity': waterTankCapacityName,
        //'wtvehicle_number': "KA24M8080",
        'wtcontact_number': contactNumber,
        'wtchoose_date': startDate,
        'wtend_date': endDate,
        'assigned_user_id': Constants.assignedUserId,
      };
      // waterTankSaveRecordValues.addIf(true, 'assigned_user_id', Constants.assignedUserId);
      final response = await _dio.post(
        Endpoints.saveRecord,
        queryParameters: {
          'access_token': Constants.accessToken,
          'useruniqueid': Constants.userUniqueId,
          'module': 'WaterTank',
          'values': waterTankSaveRecordValues,
          'record': recordId,
        },
      );

      if (response.statusCode == 200) {
        WaterTankModel? waterTankSaveRecord = WaterTankModel.fromJson(response.data);
        String uploadAttachmentId = waterTankSaveRecord.data!.id.toString();
        String waterTankId = uploadAttachmentId.split('x').last;
        await deleteAttachment(listOfImages: listOfImageRecordToBeDeleted, recordId: recordId, module: 'WaterTank');
        for (File? img in ownerImage) {
          if (img != null) {
            await waterTankUploadImage(
              recordId: uploadAttachmentId,
              fieldName: 'wttake_photo',
              imageName: img,
              recordIDForRedirecting: uploadAttachmentId,
              moduleName: 'WaterTank',
            );
          }
        }

        for (XFile? img in mediaList) {
          if (img != null) {
            await waterTankUploadImage(
              recordId: uploadAttachmentId,
              fieldName: 'Wt_uploadatachment',
              moduleName: 'WaterTank',
              imageName: File(img.path),
              recordIDForRedirecting: uploadAttachmentId,
            );
          }
        }

        var waterTankPasscodeData = await waterTankPasscode(waterTankId: waterTankId, waterTankName: waterSupplierName, contactNumber: contactNumber);
        waterTankSaveRecord.waterTankPasscodeModelData = waterTankPasscodeData;
        return waterTankSaveRecord;
      } else {
        throw Exception('Failed to save water tank record: ${response.statusCode}');
      }
    } on DioException catch (err) {
      // Handle Dio-specific exceptions
      final errorMessage = err.message;
      EasyLoading.dismiss();
      throw Exception(errorMessage);
    } catch (e) {
      // Handle any other exceptions
      EasyLoading.dismiss();
      throw Exception('An unexpected error occurred: $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  compressImage(String imagePath, int maxSizeInBytes) async {
    int fileSize = File(imagePath).lengthSync();
    int quality = 100;

    debugger.printLogs("fghgkkjk");
    debugger.printLogs(fileSize);

    var imageResult = await FlutterImageCompress.compressWithFile(
      imagePath,
      quality: quality,
    );
    quality = 90;
    while (imageResult!.length > maxSizeInBytes) {
      imageResult = await FlutterImageCompress.compressWithFile(
        imagePath,
        quality: quality,
      );
      quality -= 10;
    }
    debugger.printLogs('Current Image Size');
    debugger.printLogs(imageResult.length);
    File(imagePath).writeAsBytesSync(imageResult);
  }

  // Future<void> compressVideo(String videoPath, int maxSizeInBytes) async {
  //   try {
  //     final tempDir = await getTemporaryDirectory();
  //     String outputPath = '${tempDir.path}/compressed_video.mp4';
  //     final outputFile = File(outputPath);
  //
  //     // Ensure the directory exists
  //     if (!await outputFile.parent.exists()) {
  //       await outputFile.parent.create(recursive: true);
  //     }
  //
  //     // FFmpeg command to compress the video
  //     String command = '-i $videoPath -vcodec libx264 -crf 28 -preset fast -y $outputPath';
  //
  //     print("Compressing file......");
  //
  //     final session = await FFmpegKit.execute(command);
  //     final returnCode = await session.getReturnCode();
  //
  //     // Check for success
  //     if (ReturnCode.isSuccess(returnCode)) {
  //       int fileSize = await outputFile.length();
  //       print('Compressed video size: $fileSize bytes');
  //
  //       // If the file is still too large, decrease CRF and retry
  //       while (fileSize > maxSizeInBytes) {
  //         command = '-i $videoPath -vcodec libx264 -crf 30 -preset fast -y $outputPath';
  //         await FFmpegKit.execute(command);
  //         fileSize = await outputFile.length();
  //         if (fileSize <= maxSizeInBytes) break;
  //       }
  //
  //       print("Compression successful. Final size: $fileSize bytes");
  //
  //       // Optionally replace the original video with the compressed version
  //       File(videoPath).writeAsBytesSync(await outputFile.readAsBytes());
  //     } else {
  //       throw Exception("FFmpeg failed to compress the video. Error code: $returnCode");
  //     }
  //   } catch (e) {
  //     print("Error during video compression: $e");
  //   }
  // }
  Future<String?> compressVideo(String filePath) async {
    try {
      // Initialize VideoCompress
      await VideoCompress.setLogLevel(0);

      // Compress the video
      MediaInfo? compressedVideo = await VideoCompress.compressVideo(
        filePath,
        quality: VideoQuality.LowQuality, // You can adjust the quality level
        deleteOrigin: false, // Set to true if you want to delete the original file
      );

      // Return the compressed video file path
      return compressedVideo?.path;
    } catch (e) {
      // Handle any errors
      print('Error compressing video: $e');
      return null;
    }
  }

  Future<void> compressVideoWithFFmpeg(String inputPath) async {
    final tempDir = await getTemporaryDirectory();
    String outputPath = '${tempDir.path}/compressed_video.mp4';
    String command = '-i $inputPath -vf scale=720:-1 -b:v 800k -c:v libx264 -preset ultrafast -c:a aac -b:a 128k -y $outputPath';

    try {
      print("Compressing video using FFmpeg...");
      final session = await FFmpegKit.execute(command);

      final returnCode = await session.getReturnCode();
      if (ReturnCode.isSuccess(returnCode)) {
        print("Video compressed successfully: $outputPath");
      } else {
        print("FFmpeg compression failed: ${await session.getLogsAsString()}");
      }
    } catch (e) {
      print("Error during FFmpeg compression: $e");
    }
  }

  Future<void> waterTankUploadImage({
    required String? recordId,
    required String? fieldName,
    required File? imageName,
    required String? moduleName,
    String? recordIDForRedirecting,
  }) async {
    if (imageName == null) {
      throw Exception('Image file is null');
    }

    // Check if the image size exceeds 3 MB
    int fileSize = await imageName.length();
    const int maxSizeInBytes = 3 * 1024 * 1024; // 3 MB in bytes
    if (fileSize > maxSizeInBytes) {
      await compressImage(imageName.path, maxSizeInBytes);
    }

    fd.FormData waterTankFormData = fd.FormData.fromMap({
      fieldName.toString(): await multip.MultipartFile.fromFile(
        imageName.path,
      ),
      'access_token': Constants.accessToken,
      'useruniqueid': Constants.userUniqueId,
      'module': moduleName,
      'fieldName': fieldName,
      'recordId': recordId,
    });

    try {
      final response = await _dio.post(Endpoints.uploadAttachment, data: waterTankFormData);
      debugger.printLogs(response);
      //Get.snackbar('Result', response.toString());
    } on DioException catch (err) {
      final errorMessage = err.message;
      // Get.snackbar('Dio Exception', errorMessage.toString());
      throw Exception('Failed to upload image: $errorMessage');
    } catch (e) {
      //  Get.snackbar('Catch Error', e.toString());
      throw Exception('An unexpected error occurred while uploading the image: $e');
    }
  }

  Future<void> deleteAttachment({
    required List<String>? listOfImages,
    required String? recordId,
    required String module,
  }) async {
    try {
      print("Printing listing of images fetched in water tank");
      print(listOfImages.toString());
      if (listOfImages == null || listOfImages.isEmpty) return;
      await _dio.post(Endpoints.deleteAttachment, data: {
        'access_token': Constants.accessToken,
        'useruniqueid': Constants.userUniqueId,
        'module': module,
        'attachmentsid': listOfImages,
        'record': recordId,
      });
    } on DioException catch (err) {
      final errorMessage = err.toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
  }

  //Water Tank Cancel
  Future<WaterTankCancelModel?> cancelWaterTank({required String record}) async {
    try {
      EasyLoading.show();
      final response = await _dio.post(
        Endpoints.cancelRecord,
        data: {'access_token': Constants.accessToken, 'useruniqueid': Constants.userUniqueId, 'module': 'WaterTank', 'record': record},
      );
      if (response.statusCode == 200) {
        WaterTankCancelModel? waterTankCancelModel = WaterTankCancelModel.fromJson(response.data);
        return waterTankCancelModel;
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      final errorMessage = err.toString();
      EasyLoading.dismiss();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    } finally {
      EasyLoading.dismiss();
    }
    return null;
  }

  //Water Tank new and Renew Passcode
  Future<WaterTankPasscodeModel?> waterTankPasscode({required String waterTankId, required String waterTankName, required String contactNumber}) async {
    try {
      final response = await _dio.post(
        Endpoints.renewPassCode,
        data: {'module': 'WaterTank', 'watertankid': waterTankId, 'wtsuplier_name': waterTankName, 'wtcontact_number': contactNumber},
      );
      if (response.statusCode == 200) {
        WaterTankPasscodeModel? waterTankRenewModel = WaterTankPasscodeModel.fromJson(response.data);
        return waterTankRenewModel;
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      final errorMessage = err.toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
    return null;
  }

  // fetch society registration dropdown values
  Future<SocietyDesignationModel> fetchDesignationValues() async {
    late final SocietyDesignationModel data;
    EasyLoading.show();
    try {
      final response = await _dio.post(
        Endpoints.getPicklist,
        data: fd.FormData.fromMap({
          'access_token': Constants.accessToken,
          'field': 'designation',
          'module': Constants.societyRegistrationModule,
          'useruniqueid': Constants.userUniqueId,
        }),
      );
      if (response.statusCode == 200 && response.data['statuscode'] == 1) {
        data = SocietyDesignationModel.fromJson(response.data);
      } else {
        throw Exception('Failed to respond');
      }
    } on DioException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Unexpected error occured');
    } finally {
      EasyLoading.dismiss();
    }
    return data;
  }

  Future<SocietyEnquiryModel?> createSocietyEnquiry(
      {required String societyName,
      required String username,
      required String contactNumber,
      required String email,
      required String designation,
      required String pincode,
      required String city,
      required String district,
      required String state,
      required String address}) async {
    EasyLoading.show();
    try {
      final response = await _dio.post(
        Endpoints.societyEnquiry,
        data: fd.FormData.fromMap({
          'societyname': societyName,
          'username': username,
          'contactnumber': contactNumber,
          'designation': designation,
          'pincode': pincode,
          'city': city,
          'district': district,
          'state': state,
          'address': address,
          'email': email,
        }),
      );
      if (response.statusCode == 200) {
        SocietyEnquiryModel societyEnquiry = SocietyEnquiryModel.fromJson(response.data);
        return societyEnquiry;
      } else {
        Fluttertoast.showToast(
          msg: 'Failed to register society',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        throw Exception('Failed to register society');
      }
    } on DioException catch (e) {
      throw DioServiceException.fromDioException(e);
    } catch (e) {
      throw Exception(e);
    } finally {
      EasyLoading.dismiss();
    }
  }

  // To generate passcode for visitor
  Future<PasscodeGenerationModel> generateVisitorPasscode({
    required String visitorId,
    required String visitorName,
    required String visitorMobile,
  }) async {
    late final PasscodeGenerationModel data;
    try {
      final response = await _dio.post(
        Endpoints.passcodeCreation,
        data: fd.FormData.fromMap({
          'module': 'Visitor',
          'visitors_id': visitorId,
          'visitor_mobile': visitorMobile,
          'visitor_name': visitorName,
        }),
      );
      if (response.statusCode == 200 && response.data['statuscode'] == 1) {
        data = PasscodeGenerationModel.fromJson(response.data);
        Fluttertoast.showToast(
          msg: 'Passcode created for Guest',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Failed to generate passcode',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        throw Exception('Failed to generate passcode');
      }
    } on DioException catch (e) {
      throw DioServiceException.fromDioException(e);
    } catch (e) {
      throw Exception(e);
    }
    return data;
  }

  //Call Guard Listing
  Future<CallGuardListingModel?> getCallGuardList({required int page}) async {
    try {
      final response = await _dio.post(
        Endpoints.listing,
        data: {'access_token': Constants.accessToken, 'module': 'GuardDir', 'useruniqueid': Constants.userUniqueId, 'page': page},
      );
      if (response.statusCode == 200) {
        CallGuardListingModel? callGuardListing = CallGuardListingModel.fromJson(response.data);
        return callGuardListing;
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      final errorMessage = err.toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
    return null;
  }

  //Call Guard Creation
  Future<GuardCreationModel?> guardSaveRecord({
    required String guardName,
    required String guardMobileNumber,
    // required List<File?> image,
  }) async {
    try {
      EasyLoading.show();
      Map<String, dynamic>? guardSaveRecordValues = {
        'guarddir_name': guardName,
        'guarddir_mobile': guardMobileNumber,
        'assigned_user_id': Constants.assignedUserId,
      };
      final response = await _dio.post(
        Endpoints.saveRecord,
        queryParameters: {
          'access_token': Constants.accessToken,
          'useruniqueid': Constants.userUniqueId,
          'module': 'GuardDir',
          'values': guardSaveRecordValues,
        },
      );

      if (response.statusCode == 200) {
        GuardCreationModel? guardSaveCreationData = GuardCreationModel.fromJson(response.data);
        //String uploadAttachmentId = guardSaveCreationData.data!.id.toString();

        // Upload images if any exist
        // for (File? img in image) {
        //   if (img != null) {
        //     await callGuardUploadImage(
        //       recordId: uploadAttachmentId,
        //       fieldName: 'imagename',
        //       imageName: img,
        //       recordIDForRedirecting: uploadAttachmentId,
        //     );
        //   }
        // }
        return guardSaveCreationData;
      } else {
        // Handle unexpected response status
        throw Exception('Failed to save guard record: ${response.statusCode}');
      }
    } on DioException catch (err) {
      // Handle Dio-specific exceptions
      final errorMessage = err.message; // Use error.message for better context
      EasyLoading.dismiss();
      throw Exception(errorMessage);
    } catch (e) {
      // Handle any other exceptions
      EasyLoading.dismiss();
      throw Exception('An unexpected error occurred: $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  // Upload Image of Call Guard
  Future<void> callGuardUploadImage({
    required String? recordId,
    required String? fieldName,
    required File? imageName,
    String? recordIDForRedirecting,
  }) async {
    if (imageName == null) {
      throw Exception('Image file is null');
    }

    fd.FormData waterTankFormData = fd.FormData.fromMap({
      'guarddir_img': await multip.MultipartFile.fromFile(
        imageName.path,
      ),
      'access_token': Constants.accessToken,
      'useruniqueid': Constants.userUniqueId,
      'module': 'GuardDir',
      'fieldName': 'guarddir_img',
      'recordId': recordId,
    });

    try {
      final response = await _dio.post(Endpoints.uploadAttachment, data: waterTankFormData);
      debugger.printLogs(response);
    } on DioException catch (err) {
      final errorMessage = err.message;
      throw Exception('Failed to upload image: $errorMessage');
    } catch (e) {
      throw Exception('An unexpected error occurred while uploading the image: $e');
    }
  }

//Resident Directory Listing - one
  Future<ResidentDirectoryModel?> getResidentDirectory() async {
    try {
      final response = await _dio.post(
        Endpoints.getPicklist,
        data: {'access_token': Constants.accessToken, 'module': 'Resident', 'useruniqueid': Constants.userUniqueId, 'field': 'select_block'},
      );
      if (response.statusCode == 200) {
        ResidentDirectoryModel? residentDirectory = ResidentDirectoryModel.fromJson(response.data);
        return residentDirectory;
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      final errorMessage = err.toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
    return null;
  }

  Future<SelectedResidentModel?> getSelectedResidentDirectory({required String selectBlock, int? page}) async {
    try {
      // EasyLoading.show();
      final response = await _dio.post(
        Endpoints.listing,
        data: {
          'access_token': Constants.accessToken, 'useruniqueid': Constants.userUniqueId, 'module': 'Resident',
          'select_block': selectBlock,
          'page': page,
          // 'search_params': '[["select_block", "e", "$selectBlock"]]',
        },
      );
      if (response.statusCode == 200) {
        SelectedResidentModel? selectedResident = SelectedResidentModel.fromJson(response.data);
        return selectedResident;
      }
    } on DioException catch (err) {
      // EasyLoading.dismiss();
      final errorMessage = err.toString();
      // EasyLoading.dismiss();
      throw errorMessage;
    } catch (e) {
      // EasyLoading.dismiss();
      throw e.toString();
    }
    // finally {
    //   EasyLoading.dismiss();
    // }
    return null;
  }

  Future<EmergencyDirectoryListingModel?> getEmergencyDirectoryList(bool checkAccessToken, {required int page}) async {
    try {
      final response = await _dio.post(
        Endpoints.listing,
        data: {'access_token': Constants.accessToken, 'module': 'EmergencyDir', 'useruniqueid': Constants.userUniqueId},
      );
      if (response.statusCode == 200) {
        EmergencyDirectoryListingModel? emergencyNumberListing = EmergencyDirectoryListingModel.fromJson(response.data);
        return emergencyNumberListing;
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      final errorMessage = err.toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
    return null;
  }

  Future<EmergencyDirectorySaveRecordModel?> saveEmergencyDirectory({required String emergencyDirectoryName, required String emergencyDirectoryNumber}) async {
    try {
      EasyLoading.show();
      Map<String, dynamic>? emergencyDirectorySaveRecordValues = {
        'emergencydir_name': emergencyDirectoryName,
        'emergencydir_mobile': emergencyDirectoryNumber,
        'assigned_user_id': Constants.assignedUserId,
      };
      final response = await _dio.post(
        Endpoints.saveRecord,
        queryParameters: {
          'access_token': Constants.accessToken,
          'useruniqueid': Constants.userUniqueId,
          'module': 'EmergencyDir',
          'values': emergencyDirectorySaveRecordValues,
          // 'record': recordId,
        },
      );

      if (response.statusCode == 200) {
        if (response.data['statuscode'] == 0) {
          final statusMessage = response.data['statusMessage'];
          if (statusMessage.contains('This mobile number is already registered in EmergencyDir. It must be unique.')) {
            Get.snackbar('Oops!!', statusMessage);
          }
          return null;
        }

        EmergencyDirectorySaveRecordModel residentDirectorySaveRecordModel = EmergencyDirectorySaveRecordModel.fromJson(response.data);
        return residentDirectorySaveRecordModel;
      } else {
        throw Exception('Failed to save emergency directory record: ${response.statusCode}');
      }
    } on DioException catch (err) {
      // Handle Dio-specific exceptions
      final errorMessage = err.message;
      EasyLoading.dismiss();
      throw Exception(errorMessage);
    } catch (e) {
      // Handle any other exceptions
      EasyLoading.dismiss();
      throw Exception('An unexpected error occurred: $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  // To cancel the guest invitation
  Future<Map<String, dynamic>> cancelGuestInvite({required String id}) async {
    late final Map<String, dynamic> jsonBody;
    EasyLoading.show();
    try {
      final response = await _dio.post(
        Endpoints.deleteRecords,
        data: fd.FormData.fromMap({
          'access_token': Constants.accessToken,
          'module': Constants.visitorsModule,
          'record': id,
          'useruniqueid': Constants.userUniqueId,
        }),
      );
      if (response.statusCode == 200 && response.data['statuscode'] == 1) {
        jsonBody = response.data;
        Fluttertoast.showToast(
          msg: response.data['statusMessage'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        throw Exception(response.data['statusMessage']);
      }
    } on DioException catch (e) {
      throw DioServiceException.fromDioException(e);
    } catch (e) {
      throw Exception(e);
    } finally {
      EasyLoading.dismiss();
    }
    return jsonBody;
  }

  // To search city from pincode
  Future<PincodeInfoModel> fetchCitiesFromPincode({
    required String pincode,
  }) async {
    late final PincodeInfoModel data;
    EasyLoading.show(status: 'Searching');
    try {
      final response = await _dio.post(
        Endpoints.pinCodeInfo,
        data: fd.FormData.fromMap({
          'pincode': pincode,
        }),
      );
      if (response.statusCode == 200 && response.data['statuscode'] == 1) {
        data = PincodeInfoModel.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch pincode');
      }
    } on DioException catch (e) {
      throw DioServiceException.fromDioException(e);
    } catch (e) {
      throw Exception(e);
    } finally {
      EasyLoading.dismiss();
    }
    return data;
  }

  // Get Attendance List
  Future<AttendanceListModel?> getAttendanceList(int page) async {
    try {
      final response = await _dio.post(
        Endpoints.listing,
        data: {
          'access_token': Constants.accessToken,
          'module': 'ServiceEngineer',
          'useruniqueid': Constants.userUniqueId,
          'page': page,
          'search_params': '[["approval_status", "e", "Accepted"]]',
        },
      );
      if (response.statusCode == 200) {
        AttendanceListModel? attendanceListModel = AttendanceListModel.fromJson(response.data);
        return attendanceListModel;
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      final errorMessage = err.toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
    return null;
  }

  //Get Service User Details
  Future<ServiceUserDetailModel?> getServiceUserDetailApi({String? recordId}) async {
    try {
      final response = await _dio.post(
        Endpoints.getRecordDetail,
        data: {
          'access_token': Constants.accessToken,
          'module': 'ServiceEngineer',
          'useruniqueid': Constants.userUniqueId,
          'record': recordId,
        },
      );
      if (response.statusCode == 200) {
        ServiceUserDetailModel? serviceUserDetail = ServiceUserDetailModel.fromJson(response.data);
        return serviceUserDetail;
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      final errorMessage = err.toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
    return null;
  }

  Future<HelpDeskCategoryModel?> category({required dependentValue}) async {
    try {
      EasyLoading.show();
      final response = await _dio.post(
        Endpoints.pickListValues,
        queryParameters: {'access_token': Constants.accessToken, 'useruniqueid': Constants.userUniqueId, 'field': 'tic_category', 'dependentFieldVal': dependentValue},
      );
      if (response.statusCode == 200) {
        return HelpDeskCategoryModel.fromJson(response.data);
      }
    } on DioException catch (e) {
      EasyLoading.dismiss();
      final errorMessage = e.toString();
      throw errorMessage;
    } catch (e) {
      EasyLoading.dismiss();
      throw e.toString();
    } finally {
      EasyLoading.dismiss();
    }
    return null;
  }

  Future<HelpDeskPinLocationModel?> pinLocation() async {
    try {
      EasyLoading.show();
      final response = await _dio.post(
        Endpoints.getPicklist,
        queryParameters: {
          'access_token': Constants.accessToken,
          'useruniqueid': Constants.userUniqueId,
          'module': 'HelpDesk',
          'field': 'tic_pin_location',
        },
      );
      if (response.statusCode == 200) {
        return HelpDeskPinLocationModel.fromJson(response.data);
      }
    } on DioException catch (e) {
      EasyLoading.dismiss();
      final errorMessage = e.toString();
      throw errorMessage;
    } catch (e) {
      EasyLoading.dismiss();
      throw e.toString();
    } finally {
      EasyLoading.dismiss();
    }
    return null;
  }

  Future<HelpDeskRoleBasedAssignedListModel?> getTicketType() async {
    try {
      EasyLoading.show();
      final response = await _dio.post(
        Endpoints.getRoleWisePicklist,
        queryParameters: {
          'access_token': Constants.accessToken,
          'useruniqueid': Constants.userUniqueId,
          'module': 'HelpDesk',
          'field': 'tic_type',
          'fieldvalue': Constants.userRole,
        },
      );
      if (response.statusCode == 200) {
        return HelpDeskRoleBasedAssignedListModel.fromJson(response.data);
      }
    } on DioException catch (e) {
      EasyLoading.dismiss();
      final errorMessage = e.toString();
      throw errorMessage;
    } catch (e) {
      EasyLoading.dismiss();
      throw e.toString();
    } finally {
      EasyLoading.dismiss();
    }
    return null;
  }

  Future<void> uploadAttachmentForHelpDesk({required String imageName, required String recordId}) async {
    fd.FormData formData = fd.FormData.fromMap({
      'access_token': Constants.accessToken,
      'useruniqueid': Constants.userUniqueId,
      //'module': Constants.noticeModule,
      'module': 'HelpDesk',
      'recordId': recordId,
      'fieldName': 'tic_uploadimage',
      'tic_uploadimage': await multip.MultipartFile.fromFile(
        imageName,
      ),
    });

    try {
      await _dio.post(
        Endpoints.uploadAttachment,
        data: formData,
      );
    } on DioException catch (e) {
      EasyLoading.dismiss();

      throw DioServiceException.fromDioException(e);
    } catch (e) {
      EasyLoading.dismiss();

      throw e.toString();
    }
  }

  Future<HelpDeskCreateModel?> helpDeskSaveRecord(
      {required String tic_type,
      required String tic_category,
      required String tic_pin_location,
      required String tic_description,
      required String tic_isemergency,
      required RxList<XFile> voiceRecordingList,
      required RxList<XFile> imageList
      //required String tic_isemergency,
      }) async {
    Map<String, dynamic>? helpDeskSaveRecordValues = {
      'tic_type': tic_type,
      'tic_category': tic_category,
      'tic_pin_location': tic_pin_location,
      'tic_description': tic_description,
      'tic_isemergency': tic_isemergency,
      // 'assigned_user_id': Constants.assignedUserId,
    };
    try {
      EasyLoading.show();
      final response = await _dio.post(
        Endpoints.saveRecord,
        data: {
          'access_token': Constants.accessToken,
          'useruniqueid': Constants.userUniqueId,
          'module': 'HelpDesk',
          'values': helpDeskSaveRecordValues,
        },
      );
      if (response.statusCode == 200) {
        HelpDeskCreateModel helpDeskCreateModel = HelpDeskCreateModel.fromJson(response.data);
        var recordId = helpDeskCreateModel.data!.id.toString();

        //upload voice recording
        for (XFile file in voiceRecordingList) {
          await uploadAttachment(recordId: recordId, fieldName: "tic_voicerecord", imageName: File(file.path), module: 'HelpDesk');
        }
        for (XFile file in imageList) {
          await uploadAttachment(recordId: recordId, fieldName: "tic_uploadimage", imageName: File(file.path), module: 'HelpDesk');
        }
        //upload imagelist

        return helpDeskCreateModel;
      }
    } on DioException catch (e) {
      EasyLoading.dismiss();
      final errorMessage = e.toString();
      throw errorMessage;
    } catch (e) {
      EasyLoading.dismiss();
      throw e.toString();
    } finally {
      EasyLoading.dismiss();
    }
    return null;
  }

  //Create Domestic
  Future<SaveDomesticHelpModel?> createDomesticHelpApi({Map? request, String? recordID}) async {
    try {
      final response = await _dio.post(
        Endpoints.saveRecord,
        data: {
          'access_token': Constants.accessToken,
          'module': 'DomesticHelp',
          'useruniqueid': Constants.userUniqueId,
          'values': request,
          if (recordID != null) 'record': recordID,
        },
      );
      if (response.statusCode == 200) {
        EasyLoading.dismiss();

        return SaveDomesticHelpModel.fromJson(response.data);
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      final errorMessage = err.toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
    // return null;
  }

  // Domestic Board Upload Attachment
  Future<void> uploadAttachmentDomesticDocHelp({required String? recordId, required String imageName}) async {
    fd.FormData formData = fd.FormData.fromMap({
      'access_token': Constants.accessToken,
      'useruniqueid': Constants.userUniqueId,
      'module': 'DomesticHelp',
      'recordId': recordId,
      'fieldName': 'domhelp_doc_upload',
      'domhelp_doc_upload': await multip.MultipartFile.fromFile(
        imageName,
      ),
    });

    try {
      final response = await _dio.post(Endpoints.uploadAttachment, data: formData);
      if (response.statusCode == 200) {
        log("Response ${response.statusMessage}");
      }
    } on DioException catch (e) {
      EasyLoading.dismiss();

      throw DioServiceException.fromDioException(e);
    } catch (e) {
      EasyLoading.dismiss();

      throw e.toString();
    }
  }

  // Domestic Board Upload Attachment
  Future<void> uploadAttachmentDomesticProfileHelp({required String? recordId, required String imageName}) async {
    fd.FormData formData = fd.FormData.fromMap({
      'access_token': Constants.accessToken,
      'useruniqueid': Constants.userUniqueId,
      'module': 'DomesticHelp',
      'recordId': recordId,
      'fieldName': 'domhelp_pic',
      'domhelp_pic': await multip.MultipartFile.fromFile(
        imageName,
      ),
    });

    try {
      final response = await _dio.post(Endpoints.uploadAttachment, data: formData);
      if (response.statusCode == 200) {
        log("Response ${response.statusMessage}");
      }
    } on DioException catch (e) {
      EasyLoading.dismiss();

      throw DioServiceException.fromDioException(e);
    } catch (e) {
      EasyLoading.dismiss();

      throw e.toString();
    }
  }

  //getTimeSlot
  Future<TimeSlotModel?> getTimeSlotApi() async {
    try {
      final response = await _dio.post(
        Endpoints.getPicklist,
        data: {
          'access_token': Constants.accessToken,
          'module': 'DomesticHelp',
          'useruniqueid': Constants.userUniqueId,
          'field': 'domhelp_timeslot',
        },
      );
      if (response.statusCode == 200) {
        TimeSlotModel? timeSlotModel = TimeSlotModel.fromJson(response.data);
        return timeSlotModel;
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      final errorMessage = err.toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
    return null;
  }

  //get Domestic help List
  Future<DomesticListModel?> getDomesticHelpListApi({int? page, String? searchParam, bool? isMyService = false}) async {
    try {
      final response = await _dio.post(
        Endpoints.listing,
        data: {
          'access_token': Constants.accessToken /*'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyaWQiOiIxIn0.3mmsYCxRshKckI3j3liPNDnfwXkcbwbWL_rv7S-XC0U'*/,
          'module': 'DomesticHelp',
          'useruniqueid': Constants.userUniqueId /*'1'*/,
          'page': page,
          'view_type': isMyService == true ? 'my_services' : 'all_services'
          // if (searchParam != null && searchParam.isNotEmpty) 'search_params': searchParam
        },
      );
      if (response.statusCode == 200) {
        DomesticListModel? domesticListModel = DomesticListModel.fromJson(response.data);
        return domesticListModel;
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      final errorMessage = err.toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
    return null;
  }

  //get Domestic Detail
  Future<DomesticDetailModel?> getDomesticHelpDetailApi({String? recordId}) async {
    try {
      final response = await _dio.post(
        Endpoints.getRecordDetail,
        data: {
          'access_token': Constants.accessToken,
          'module': 'DomesticHelp',
          'useruniqueid': Constants.userUniqueId,
          'record': recordId,
        },
      );
      if (response.statusCode == 200) {
        DomesticDetailModel? domesticDetail = DomesticDetailModel.fromJson(response.data);
        return domesticDetail;
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      final errorMessage = err.toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
    return null;
  }

  //get Domestic Help Type Data
  Future<DomesticHelpTypeModel?> getDomesticHelpTypeApi() async {
    try {
      final response = await _dio.post(
        Endpoints.getPicklist,
        data: {
          'access_token': Constants.accessToken,
          'module': 'DomesticHelp',
          'useruniqueid': Constants.userUniqueId,
          'field': 'domhelp_type',
        },
      );
      if (response.statusCode == 200) {
        DomesticHelpTypeModel? timeSlotModel = DomesticHelpTypeModel.fromJson(response.data);
        return timeSlotModel;
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      final errorMessage = err.toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
    return null;
  }

  //get Domestic Help Society Data
  Future<DomesticSocietyModel?> getDomesticHelpSocietyApi() async {
    try {
      final response = await _dio.post(
        Endpoints.getPicklist,
        data: {
          'access_token': Constants.accessToken,
          'module': 'DomesticHelp',
          'useruniqueid': Constants.userUniqueId,
          'field': 'domhelp_society',
        },
      );
      if (response.statusCode == 200) {
        DomesticSocietyModel? societyModel = DomesticSocietyModel.fromJson(response.data);
        return societyModel;
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      final errorMessage = err.toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
    return null;
  }

  Future<DomesticBlockModel?> getDomesticHelpBlockApi() async {
    try {
      final response = await _dio.post(
        Endpoints.getPicklist,
        data: {
          'access_token': Constants.accessToken,
          'module': 'DomesticHelp',
          'useruniqueid': Constants.userUniqueId,
          'field': 'domhelp_block',
        },
      );
      if (response.statusCode == 200) {
        DomesticBlockModel? blockModel = DomesticBlockModel.fromJson(response.data);
        return blockModel;
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      final errorMessage = err.toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
    return null;
  }

  Future<DomesticDocumentModel?> getDomesticHelpDocApi() async {
    try {
      final response = await _dio.post(
        Endpoints.getPicklist,
        data: {
          'access_token': Constants.accessToken,
          'module': 'DomesticHelp',
          'useruniqueid': Constants.userUniqueId,
          'field': 'domhelp_doc_type',
        },
      );
      if (response.statusCode == 200) {
        DomesticDocumentModel? documentModel = DomesticDocumentModel.fromJson(response.data);
        return documentModel;
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      final errorMessage = err.toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
    return null;
  }

  Future<DeleteDomesticModel?> deleteDomesticHelpApi({String? recordId}) async {
    try {
      final response = await _dio.post(
        Endpoints.deleteRecords,
        data: {
          'access_token': Constants.accessToken,
          'module': 'DomesticHelp',
          'useruniqueid': Constants.userUniqueId,
          'record': recordId,
        },
      );
      if (response.statusCode == 200) {
        DeleteDomesticModel? documentModel = DeleteDomesticModel.fromJson(response.data);
        return documentModel;
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      final errorMessage = err.toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
    return null;
  }

  Future<RemoveDomHelpServiceModel?> removeDomHelpServiceApi({String? recordId}) async {
    try {
      final response = await _dio.post(
        Endpoints.removeDomesticHelp,
        data: {
          'access_token': Constants.accessToken,
          'useruniqueid': Constants.userUniqueId,
          'domestichelpid': recordId,
        },
      );
      if (response.statusCode == 200) {
        RemoveDomHelpServiceModel? documentModel = RemoveDomHelpServiceModel.fromJson(response.data);
        return documentModel;
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      final errorMessage = err.toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
    return null;
  }

  ///Pass code verify By Security supervisor
  Future<PasscodeVerifyModel?> passcodeVerifyApi({String? passcode}) async {
    try {
      final response = await _dio.post(
        Endpoints.domesticHelpPasscodeVerification,
        data: {
          "passcode": passcode,
        },
      );
      if (response.statusCode == 200) {
        PasscodeVerifyModel? passcodeModel = PasscodeVerifyModel.fromJson(response.data);
        return passcodeModel;
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      final errorMessage = err.toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
    return null;
  }

  // Domestic Board Filter
  Future<FilterDomesticHelpModel> getDomesticFilter({required String? domesticType, int? page = 1}) async {
    try {
      final response = await _dio.post(
        Endpoints.listing,
        queryParameters: {
          'access_token': Constants.accessToken,
          'useruniqueid': Constants.userUniqueId,
          'module': Constants.domesticHelp,
          'page': page,
          "search_params": '[["domhelp_type","e","$domesticType"]]',
        },
      );

      return FilterDomesticHelpModel.fromJson(response.data);
    } on DioException catch (e) {
      throw DioServiceException.fromDioException(e);
    } catch (e) {
      throw e.toString();
    }
  }

  /// Help Desk Listing
  Future<HelpDeskListModel?> getHelpDeskList({required int page, required String filter}) async {
    try {
      final response = await _dio.post(
        Endpoints.listing,
        data: {'access_token': Constants.accessToken, 'module': 'HelpDesk', 'useruniqueid': Constants.userUniqueId, 'search_params': filter, 'page': page},
      );
      if (response.statusCode == 200) {
        final statusMessage = response.data['statusMessage'];
        if (statusMessage.contains('Invalid Access Token')) {
          // Get.snackbar('Oops!!', statusMessage);
          Get.offAll(() => const CompanyCode());
        } else if (statusMessage.contains('userUniqueId is Empty')) {
          // Get.snackbar('Oops!!', statusMessage);
          Get.offAll(() => const CompanyCode());
        }
        HelpDeskListModel? helpDeskListModel = HelpDeskListModel.fromJson(response.data);
        return helpDeskListModel;
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      final errorMessage = err.toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
    return null;
  }

  Future<HelpDeskCountModel?> getCountList({String? ticketType, required module}) async {
    try {
      final response = await _dio.post(
        Endpoints.count,
        data: {'access_token': Constants.accessToken, 'useruniqueid': Constants.userUniqueId, 'module': module, 'tic_type': ticketType},
      );
      if (response.statusCode == 200) {
        final statusMessage = response.data['statusMessage'];
        if (statusMessage.contains('Invalid Access Token')) {
          //Get.snackbar('Oops!!', statusMessage);
          Get.offAll(() => const CompanyCode());
        } else if (statusMessage.contains('userUniqueId is Empty')) {
          //Get.snackbar('Oops!!', statusMessage);
          Get.offAll(() => const CompanyCode());
        }
        HelpDeskCountModel? countData = HelpDeskCountModel.fromJson(response.data);
        return countData;
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      final errorMessage = err.toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
    return null;
  }

  updateHelpDeskTicketStatus({required String recordId, required String updateTicketStatus, bool needToSkip = false}) async {
    if (needToSkip) return;
    EasyLoading.show();
    try {
      await _dio.post(
        Endpoints.saveRecord,
        data: {
          'access_token': Constants.accessToken,
          'useruniqueid': Constants.userUniqueId,
          'module': 'HelpDesk',
          'values': {"ticketstatus": updateTicketStatus},
          'record': recordId,
        },
      );
    } finally {
      EasyLoading.dismiss();
    }
  }

  updateHelpDeskTicketRating({required String recordId, required int rating}) async {
    EasyLoading.show();
    try {
      await _dio.post(
        Endpoints.ratingAndFeedBack,
        data: {
          'access_token': Constants.accessToken,
          'useruniqueid': Constants.userUniqueId,
          'module': 'HelpDesk',
          'rating': rating,
          'record': recordId,
        },
      );
    } finally {
      EasyLoading.dismiss();
    }
  }

  /// Help Desk Details
  Future<HelpDeskDetailsModel?> getHelpDeskDetails({required String recordId}) async {
    try {
      // EasyLoading.show();
      final response = await _dio.post(
        Endpoints.getRecordDetail,
        data: {'access_token': Constants.accessToken, 'module': 'HelpDesk', 'useruniqueid': Constants.userUniqueId, 'record': recordId},
      );
      if (response.statusCode == 200) {
        if (response.data['statuscode'] == 0) {
          final statusMessage = response.data['statusMessage'];
          if (statusMessage.contains('Permission to perform the operation is denied for id')) {
            Get.snackbar('Oops!!', statusMessage);
            Get.close(1);
          } else if (statusMessage.contains('Invalid Access Token')) {
            // Get.snackbar('Oops!!', statusMessage);
            Get.offAll(() => const CompanyCode());
          } else if (statusMessage.contains('userUniqueId is Empty')) {
            // Get.snackbar('Oops!!', statusMessage);
            Get.offAll(() => const CompanyCode());
          }

          return null;
        }
        HelpDeskDetailsModel? helpDeskDetailsModel = HelpDeskDetailsModel.fromJson(response.data);
        return helpDeskDetailsModel;
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      final errorMessage = err.toString();
      throw errorMessage;
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.dismiss();
      throw e.toString();
    } finally {
      EasyLoading.dismiss();
    }
    return null;
  }

  Future<MessageListModel?> getMessageLists({required String record}) async {
    try {
      final response = await _dio.post(
        Endpoints.getRecordComments,
        data: {'access_token': Constants.accessToken, 'useruniqueid': Constants.userUniqueId, 'record': record},
      );
      if (response.statusCode == 200) {
        MessageListModel? messageList = MessageListModel.fromJson(response.data);
        return messageList;
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      final errorMessage = err.toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
    return null;
  }

  Future<SendMessageModel?> sendMessage(
      {required BuildContext context, required String commentContent, required String relatedTo, required RxList<XFile> listOfFiles, required Function onChange}) async {
    try {
      EasyLoading.show();
      Map<String, dynamic>? helpDeskMessageSaveRecordValues = {
        'commentcontent': commentContent,
        'related_to': relatedTo,
        'assigned_user_id': Constants.assignedUserId,
      };
      final response = await _dio.post(
        Endpoints.saveRecord,
        queryParameters: {
          'access_token': Constants.accessToken,
          'useruniqueid': Constants.userUniqueId,
          'module': 'ModComments',
          'values': helpDeskMessageSaveRecordValues,
        },
      );

      if (response.statusCode == 200) {
        SendMessageModel? sendMessageData = SendMessageModel.fromJson(response.data);
        print("status success");

        String id = sendMessageData.data!.id.toString();
        print(id.toString());
        for (int k = 0; k < listOfFiles.length; k++) {
          File currentFile = File(listOfFiles[k].path);
          await waterTankUploadImage(
            recordId: id,
            fieldName: 'filename',
            imageName: currentFile,
            moduleName: 'ModComments',
          );
        }
        Get.close(1);
        EasyLoading.dismiss();
        Get.to(() => HelpDeskTicketDetailsScreen(
              recordId: relatedTo.toString(),
              onAnyChanges: onChange,
            ));

        return sendMessageData;
      }

      // if (response.statusCode == 200) {
      //
      //  if(response.data['statuscode'] == 1){
      //    print("mnbmfef");
      //   // Get.off(()=> HelpDeskTicketDetailsScreen(recordId: relatedTo,));
      //    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HelpDeskTicketDetailsScreen(recordId: relatedTo,)));
      //
      //  }
      //
      //   // HelpDeskMessageModel helpDeskMessageData = HelpDeskMessageModel.fromJson(response.data);
      //   // return helpDeskMessageData;
      // }
      else {
        EasyLoading.dismiss();
        throw Exception('Failed to save help desk record: ${response.statusCode}');
      }
    } on DioException catch (err) {
      // Handle Dio-specific exceptions
      final errorMessage = err.message;
      EasyLoading.dismiss();
      throw Exception(errorMessage);
    } catch (e) {
      // Handle any other exceptions
      EasyLoading.dismiss();
      throw Exception('An unexpected error occurred: $e');
    } finally {
      EasyLoading.dismiss();
    }
    //return null;
  }

  Future<SendMessageModel?> sendMessageCallGuard(
      {required BuildContext context, required String commentContent, required String relatedTo, required RxList<XFile> listOfFiles, required String guardName}) async {
    try {
      EasyLoading.show();
      Map<String, dynamic>? helpDeskMessageSaveRecordValues = {
        'commentcontent': commentContent,
        'related_to': relatedTo,
        'assigned_user_id': Constants.assignedUserId,
      };
      final response = await _dio.post(
        Endpoints.saveRecord,
        queryParameters: {
          'access_token': Constants.accessToken,
          'useruniqueid': Constants.userUniqueId,
          'module': 'ModComments',
          'values': helpDeskMessageSaveRecordValues,
        },
      );

      if (response.statusCode == 200) {
        SendMessageModel? sendMessageData = SendMessageModel.fromJson(response.data);
        String id = sendMessageData.data!.id.toString();
        for (int k = 0; k < listOfFiles.length; k++) {
          File currentFile = File(listOfFiles[k].path);
          await uploadAttachment(
            recordId: id,
            fieldName: 'imagename',
            imageName: currentFile,
            module: 'ModComments',
          );
        }
        Get.close(1);
        EasyLoading.dismiss();
        Get.to(() => MessageGuard(
              recordID: relatedTo.toString(),
              name: guardName,
            ));
      }

      // if (response.statusCode == 200) {
      //
      //  if(response.data['statuscode'] == 1){
      //    print("mnbmfef");
      //   // Get.off(()=> HelpDeskTicketDetailsScreen(recordId: relatedTo,));
      //    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HelpDeskTicketDetailsScreen(recordId: relatedTo,)));
      //
      //  }
      //
      //   // HelpDeskMessageModel helpDeskMessageData = HelpDeskMessageModel.fromJson(response.data);
      //   // return helpDeskMessageData;
      // }
      else {
        EasyLoading.dismiss();
        throw Exception('Failed to save help desk record: ${response.statusCode}');
      }
    } on DioException catch (err) {
      // Handle Dio-specific exceptions
      final errorMessage = err.message;
      EasyLoading.dismiss();
      throw Exception(errorMessage);
    } catch (e) {
      // Handle any other exceptions
      EasyLoading.dismiss();
      throw Exception('An unexpected error occurred: $e');
    } finally {
      EasyLoading.dismiss();
    }
    return null;
  }

  Future<ReplyMessageModel?> replyMessageGuard({required Map<String, dynamic>? values, required File? imagePath, required String recordID, required String name}) async {
    try {
      final response = await _dio.post(
        Endpoints.saveRecord,
        data: {'access_token': Constants.accessToken, 'module': 'ModComments', 'useruniqueid': Constants.userUniqueId, 'values': values},
      );
      debugger.printLogs(response.statusCode.toString());
      if (response.statusCode == 200) {
        ReplyMessageModel? replyMessageData = ReplyMessageModel.fromJson(response.data);
        debugger.printLogs(replyMessageData.toJson().toString());
        String id = replyMessageData.data!.id.toString();
        if (imagePath != null) {
          await uploadAttachment(recordId: id, fieldName: 'imagename', imageName: imagePath, module: 'ModComments');
        } else {
          Get.close(1);
          Get.to(() => MessageGuard(
                recordID: recordID.toString(),
                name: name,
              ));
          // Get.offAll(BottomNavigation());
        }
        Get.close(1);
        Get.to(() => MessageGuard(recordID: recordID.toString(), name: name));
        // Get.close(-1);
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      final errorMessage = err.toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
    return null;
  }

  Future<EditMessageModel?> editMessagesCallGuard(
      {required Map<String, dynamic>? values, required String? model, required String? record, required List<File?> imagePath, required String? recordID, required String name}) async {
    try {
      final response = await _dio.post(
        Endpoints.saveRecord,
        data: {'access_token': Constants.accessToken, 'module': 'ModComments', 'useruniqueid': Constants.userUniqueId, 'values': values, 'record': record},
      );
      debugger.printLogs(response.statusCode.toString());
      if (response.statusCode == 200) {
        EditMessageModel? editMessagesData = EditMessageModel.fromJson(response.data);
        String id = editMessagesData.data!.id.toString();
        for (int k = 0; k < imagePath.length; k++) {
          if (imagePath[k] != null) {
            uploadAttachment(recordId: id, fieldName: 'imagename', imageName: imagePath[k], module: 'ModComments');
          }
        }

        {
          Get.close(1);
          debugger.printLogs("Image is Null");
          //Get.to(() => DiscussionBlogDetailView(recordID: recordID.toString()));
          Get.to(() => MessageGuard(
                recordID: recordID.toString(),
                name: name,
              ));
          //Get.offAll(BottomNavigation());
        }
        Get.close(1);
        Get.to(() => MessageGuard(
              recordID: recordID.toString(),
              name: name,
            ));
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      final errorMessage = err.toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
    return null;
  }

  //Upload Attachment message
  Future<void> uploadAttachment({required String? recordId, required String? fieldName, required File? imageName, required String module}) async {
    fd.FormData formData = fd.FormData.fromMap({
      fieldName.toString(): await multip.MultipartFile.fromFile(
        imageName!.path,
      ),
      'access_token': Constants.accessToken,
      'useruniqueid': Constants.userUniqueId,
      'module': module,
      'fieldName': fieldName,
      'recordId': recordId,
    });

    try {
      final response = await _dio.post(Endpoints.uploadAttachment, data: formData);
      debugger.printLogs(response);
    } on DioException catch (err) {
      final errorMessage = err.toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
  }

  // to save and create guest approval
  Future<bool> saveGuestApproval({
    required Map<String, dynamic> guestDetails,
    required List<int> imageBytes,
  }) async {
    late final bool success;
    EasyLoading.show();
    try {
      final response = await _dio.post(
        Endpoints.saveRecord,
        data: fd.FormData.fromMap({
          'access_token': Constants.accessToken,
          'module': Constants.guestApprovalModule,
          'useruniqueid': Constants.userUniqueId,
          'values': {
            'assigned_user_id': Constants.assignedUserId,
            ...guestDetails,
          },
        }),
      );
      if (response.statusCode == 200 && response.data['statuscode'] == 1) {
        final result = GuestApprovalCreationModel.fromJson(response.data);
        final data = result.data;
        if (data != null && imageBytes.isNotEmpty) {
          await uploadAttachmentForGuestApproval(
            imageBytes: imageBytes,
            recordId: data.id.toString(),
          );
        }
        success = true;
        Fluttertoast.showToast(
          msg: result.statusMessage.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        success = false;
        Fluttertoast.showToast(
          msg: response.data['statusMessage'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        // throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw DioServiceException.fromDioException(e);
    } catch (e) {
      throw Exception(e);
    } finally {
      EasyLoading.dismiss();
    }
    return success;
  }

  // to upload attachment to guest approval during creation
  Future<void> uploadAttachmentForGuestApproval({
    required List<int> imageBytes,
    required String recordId,
  }) async {
    try {
      final response = await _dio.post(
        Endpoints.uploadAttachment,
        data: fd.FormData.fromMap({
          'access_token': Constants.accessToken,
          'fieldName': 'guest_take_photo',
          'guest_take_photo': multip.MultipartFile.fromBytes(
            imageBytes,
            filename: 'guest_${recordId.split('x').last}.png',
          ),
          'module': Constants.guestApprovalModule,
          'recordId': recordId,
          'useruniqueid': Constants.userUniqueId,
        }),
      );
      if (response.statusCode == 200 && response.data['statuscode'] != 1) {
        Fluttertoast.showToast(
          msg: response.statusMessage.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw DioServiceException.fromDioException(e);
    } catch (e) {
      throw Exception(e);
    }
  }

  // to get the picklist of block for guest approval
  Future<GAGuestBlockModel> getGABlockPickList() async {
    late final GAGuestBlockModel data;
    try {
      final response = await _dio.post(
        Endpoints.getPicklist,
        data: fd.FormData.fromMap({
          'access_token': Constants.accessToken,
          'field': 'block',
          'module': Constants.guestApprovalModule,
          'useruniqueid': Constants.userUniqueId,
        }),
      );
      if (response.statusCode == 200 && response.data['statuscode'] == 1) {
        data = GAGuestBlockModel.fromJson(response.data);
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw DioServiceException.fromDioException(e);
    } catch (e) {
      throw Exception(e);
    }
    return data;
  }

  // to get the picklist of society no for guest approval
  Future<GAGuestSocietyNoModel> getGASocietyNoPickList() async {
    late final GAGuestSocietyNoModel data;
    try {
      final response = await _dio.post(
        Endpoints.getPicklist,
        data: fd.FormData.fromMap({
          'access_token': Constants.accessToken,
          'field': 'society_no',
          'module': Constants.guestApprovalModule,
          'useruniqueid': Constants.userUniqueId,
        }),
      );
      if (response.statusCode == 200 && response.data['statuscode'] == 1) {
        data = GAGuestSocietyNoModel.fromJson(response.data);
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw DioServiceException.fromDioException(e);
    } catch (e) {
      throw Exception(e);
    }
    return data;
  }

  // to get the picklist of delivery company for delivery approval
  Future<DADeliveryCompanyModel> getDADeliveryCompanyPickList() async {
    late final DADeliveryCompanyModel data;
    try {
      final response = await _dio.post(
        Endpoints.getPicklist,
        data: fd.FormData.fromMap({
          'access_token': Constants.accessToken,
          'field': 'deliver_company',
          'module': Constants.deliveryApprovalModule,
          'useruniqueid': Constants.userUniqueId,
        }),
      );
      if (response.statusCode == 200 && response.data['statuscode'] == 1) {
        data = DADeliveryCompanyModel.fromJson(response.data);
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw DioServiceException.fromDioException(e);
    } catch (e) {
      throw Exception(e);
    }
    return data;
  }

  // to get the picklist of block for delivery approval
  Future<DADeliveryBlockModel> getDABlockPickList() async {
    late final DADeliveryBlockModel data;
    try {
      final response = await _dio.post(
        Endpoints.getPicklist,
        data: fd.FormData.fromMap({
          'access_token': Constants.accessToken,
          'field': 'deliver_block',
          'module': Constants.deliveryApprovalModule,
          'useruniqueid': Constants.userUniqueId,
        }),
      );
      if (response.statusCode == 200 && response.data['statuscode'] == 1) {
        data = DADeliveryBlockModel.fromJson(response.data);
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw DioServiceException.fromDioException(e);
    } catch (e) {
      throw Exception(e);
    }
    return data;
  }

  // to get the picklist of society no for delivery approval
  Future<DADeliverySocietyNoModel> getDASocietyNoPickList() async {
    late final DADeliverySocietyNoModel data;
    try {
      final response = await _dio.post(
        Endpoints.getPicklist,
        data: fd.FormData.fromMap({
          'access_token': Constants.accessToken,
          'field': 'deliver_society',
          'module': Constants.deliveryApprovalModule,
          'useruniqueid': Constants.userUniqueId,
        }),
      );
      if (response.statusCode == 200 && response.data['statuscode'] == 1) {
        data = DADeliverySocietyNoModel.fromJson(response.data);
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw DioServiceException.fromDioException(e);
    } catch (e) {
      throw Exception(e);
    }
    return data;
  }

  // to save and create delivery approval
  Future<bool> saveDeliveryApproval({
    required Map<String, dynamic> deliveryDetails,
    required List<int> imageBytes,
  }) async {
    late final bool success;
    EasyLoading.show();
    try {
      final response = await _dio.post(
        Endpoints.saveRecord,
        data: fd.FormData.fromMap({
          'access_token': Constants.accessToken,
          'module': Constants.deliveryApprovalModule,
          'useruniqueid': Constants.userUniqueId,
          'values': {
            'assigned_user_id': Constants.assignedUserId,
            ...deliveryDetails,
          },
        }),
      );
      if (response.statusCode == 200 && response.data['statuscode'] == 1) {
        final result = GuestApprovalCreationModel.fromJson(response.data);
        final data = result.data;
        if (data != null && imageBytes.isNotEmpty) {
          await uploadAttachmentForDeliveryApproval(
            imageBytes: imageBytes,
            recordId: data.id.toString(),
          );
        }
        success = true;
        Fluttertoast.showToast(
          msg: result.statusMessage.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        success = false;
        Fluttertoast.showToast(
          msg: response.data['statusMessage'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        // throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw DioServiceException.fromDioException(e);
    } catch (e) {
      throw Exception(e);
    } finally {
      EasyLoading.dismiss();
    }
    return success;
  }

  // to upload attachment to delivery approval during creation
  Future<void> uploadAttachmentForDeliveryApproval({
    required List<int> imageBytes,
    required String recordId,
  }) async {
    try {
      final response = await _dio.post(
        Endpoints.uploadAttachment,
        data: fd.FormData.fromMap({
          'access_token': Constants.accessToken,
          'fieldName': 'gatepass_attachment',
          'gatepass_attachment': multip.MultipartFile.fromBytes(
            imageBytes,
            filename: 'guest_${recordId.split('x').last}.png',
          ),
          'module': Constants.deliveryApprovalModule,
          'recordId': recordId,
          'useruniqueid': Constants.userUniqueId,
        }),
      );
      if (response.statusCode == 200 && response.data['statuscode'] != 1) {
        Fluttertoast.showToast(
          msg: response.statusMessage.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw DioServiceException.fromDioException(e);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<CustomerCareListModel?> getCustomer({required int page}) async {
    try {
      final response = await _dio.post(
        Endpoints.customerCare,
        queryParameters: {'access_token': Constants.accessToken, 'useruniqueid': Constants.userUniqueId, 'module': Constants.customerCare, 'page': page},
      );
      return CustomerCareListModel.fromJson(response.data);
    } on DioException catch (e) {
      throw DioServiceException.fromDioException(e);
    } catch (e) {
      throw e.toString();
    }
  }

  //Allow In Out Api

  Future<AllowInOutModel> allowInOutApi({String? valueRecordId, String? recordID, String? moduleId}) async {
    try {
      Map res = {
        "inout_day": DateFormat('EEEE').format(DateTime.now()),
        "inout_date": DateFormat('dd/MM/yyyy').format(DateTime.now()), //"9/12/2024",
        "inout_attendance_status": "Present",
        ((recordID != null && recordID.isNotEmpty) ? "inout_allow_out_time" : "inout_allow_in_time"): DateFormat('hh:mm:ss a').format(DateTime.now()),
        moduleId: valueRecordId,
        "assigned_user_id": Constants.assignedUserId,
      };

      final response = await _dio.post(
        Endpoints.saveRecord,
        data: fd.FormData.fromMap({
          'access_token': Constants.accessToken,
          'values': jsonEncode(res),
          'module': Constants.inout,
          'useruniqueid': Constants.userUniqueId,
          if (recordID != null && recordID.isNotEmpty) 'record': recordID,
        }),
      );
      if (response.statusCode == 200 && response.data['statuscode'] == 1) {
        return AllowInOutModel.fromJson(response.data);
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw DioServiceException.fromDioException(e);
    } catch (e) {
      throw Exception(e);
    }
  }

  //Upload Attachment message
  Future<PaymentUploadImageModel?> allowInImgForWaterTank({required String? recordId, required File? imageName}) async {
    fd.FormData formData = fd.FormData.fromMap({
      'access_token': Constants.accessToken,
      'useruniqueid': Constants.userUniqueId,
      'module': Constants.inout,
      'fieldName': 'inout_image',
      'recordId': recordId,
      'inout_image': await multip.MultipartFile.fromFile(
        imageName!.path,
      ),
    });

    try {
      final response = await _dio.post(Endpoints.uploadAttachment, data: formData);
      debugger.printLogs(response);
      if (response.statusCode == 200) {
        PaymentUploadImageModel? paymentDueImg = PaymentUploadImageModel.fromJson(response.data);
        return paymentDueImg;
      }
    } on DioException catch (err) {
      final errorMessage = err.toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
    return null;
  }

  Future<AllowInOutModel> allowInOutVisitorApi({Map? value, String? recordID, String? moduleId}) async {
    try {
      final response = await _dio.post(
        Endpoints.saveRecord,
        data: fd.FormData.fromMap({
          'access_token': Constants.accessToken,
          'values': jsonEncode(value),
          'module': Constants.visitorsModule,
          'useruniqueid': Constants.userUniqueId,
          'record': recordID,
        }),
      );
      if (response.statusCode == 200 && response.data['statuscode'] == 1) {
        return AllowInOutModel.fromJson(response.data);
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw DioServiceException.fromDioException(e);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<DateWiseAllowInModel> getDateWiseAllowInOutApi({String? selectedDate, String? recordID, String? moduleName}) async {
    try {
      final response = await _dio.post(
        Endpoints.fetchInOutDetails,
        data: fd.FormData.fromMap({
          "access_token": Constants.accessToken,
          "useruniqueid": Constants.assignedUserId,
          "recordid": recordID,
          "module": moduleName,
          "selected_date": selectedDate,
        }),
      );
      if (response.statusCode == 200 && response.data['statuscode'] == 1) {
        return DateWiseAllowInModel.fromJson(response.data);
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw DioServiceException.fromDioException(e);
    } catch (e) {
      throw Exception(e);
    }
  }

  //get Visitor Detail
  Future<VisitorDetailModel?> getVisitorDetailApi({String? recordId}) async {
    try {
      final response = await _dio.post(
        Endpoints.getRecordDetail,
        data: {
          'access_token': Constants.accessToken,
          'module': Constants.visitorsModule,
          'useruniqueid': Constants.userUniqueId,
          'record': recordId,
        },
      );
      if (response.statusCode == 200) {
        VisitorDetailModel? visitorDetail = VisitorDetailModel.fromJson(response.data);
        return visitorDetail;
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      final errorMessage = err.toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
    return null;
  }

  //get Domestic Detail
  Future<SaveDomesticHelpModel?> addToFlatApi({String? recordId, Map? res}) async {
    try {
      final response = await _dio.post(
        Endpoints.saveRecord,
        data: {
          'access_token': Constants.accessToken,
          'useruniqueid': Constants.userUniqueId,
          'module': Constants.domesticHelp,
          'values': jsonEncode(res),
          'record': recordId,
        },
      );
      if (response.statusCode == 200) {
        SaveDomesticHelpModel? addToFlatResponse = SaveDomesticHelpModel.fromJson(response.data);
        return addToFlatResponse;
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      final errorMessage = err.toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
    return null;
  }

  //Upload Attachment of employee image
  Future<void> profileUploadAttachment({required String? fieldName, required XFile empImageName, required String module}) async {
    // Check if the image size exceeds 3 MB
    int fileSize = await empImageName.length();
    const int maxSizeInBytes = 2 * 1024 * 1024; // 3 MB in bytes
    if (fileSize > maxSizeInBytes) {
      await compressImage(empImageName.path, maxSizeInBytes);
    }
    fd.FormData formData = fd.FormData.fromMap({
      'emp_imagefile': await multip.MultipartFile.fromFile(
        empImageName.path,
      ),
      'access_token': Constants.accessToken,
      'useruniqueid': Constants.userUniqueId,
      'module': 'Users',
      'fieldName': 'emp_imagefile',
    });

    try {
      final response = await _dio.post(Endpoints.uploadAttachment, data: formData);
      debugger.printLogs(response);
    } on DioException catch (err) {
      final errorMessage = err.toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
  }

  //Upload Attachment of owner image
  Future<void> ownerProfileUploadAttachment({required String? fieldName, required XFile ownerImageName, required String module}) async {
    int fileSize = await ownerImageName.length();
    const int maxSizeInBytes = 2 * 1024 * 1024; // 3 MB in bytes
    if (fileSize > maxSizeInBytes) {
      await compressImage(ownerImageName.path, maxSizeInBytes);
    }
    fd.FormData formData = fd.FormData.fromMap({
      'imagename': await multip.MultipartFile.fromFile(
        ownerImageName.path,
      ),
      'access_token': Constants.accessToken,
      'useruniqueid': Constants.userUniqueId,
      'module': 'Users',
      'fieldName': 'imagename',
    });

    try {
      final response = await _dio.post(Endpoints.uploadAttachment, data: formData);

      debugger.printLogs(response);
    } on DioException catch (err) {
      final errorMessage = err.toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
  }

  //get Domestic Detail
  Future<PaymentDueListModel?> paymentDueListApi({String? paidValue, int? page = 1}) async {
    try {
      final response = await _dio.post(
        Endpoints.listing,
        data: {
          'access_token': Constants.accessToken,
          'useruniqueid': Constants.userUniqueId,
          'module': Constants.paymentDetail,
          'page': page,
          'search_params': '[["payment_status","e","$paidValue"]]',
        },
      );
      if (response.statusCode == 200) {
        PaymentDueListModel? paymentDueList = PaymentDueListModel.fromJson(response.data);
        return paymentDueList;
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      final errorMessage = err.toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
    return null;
  }

  //Upload Attachment message
  Future<PaymentUploadImageModel?> paymentRecieptUploadAttachment({required String? recordId, required File? imageName}) async {
    fd.FormData formData = fd.FormData.fromMap({
      'access_token': Constants.accessToken,
      'useruniqueid': Constants.userUniqueId,
      'module': Constants.paymentDetail,
      'fieldName': 'pay_uploadpic',
      'recordId': recordId,
      'pay_uploadpic': await multip.MultipartFile.fromFile(
        imageName!.path,
      ),
    });

    try {
      final response = await _dio.post(Endpoints.uploadAttachment, data: formData);
      debugger.printLogs(response);
      if (response.statusCode == 200) {
        PaymentUploadImageModel? paymentDueImg = PaymentUploadImageModel.fromJson(response.data);
        return paymentDueImg;
      }
    } on DioException catch (err) {
      final errorMessage = err.toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
    return null;
  }

  Future<FaceDetectionModel?> faceAttendanceApi({required String? serviceEngineerId, required File capturedImage, required String empMatchImg}) async {
    var imageFile = await multip.MultipartFile.fromFile(
      capturedImage.path,
    );
    fd.FormData formData = fd.FormData.fromMap({
      'access_token': Constants.accessToken,
      'useruniqueid': Constants.userUniqueId,
      'serviceengineerid': serviceEngineerId,
      'doc_url': empMatchImg,
      'captured_image': imageFile,
    });

    try {
      final response = await _dio.post(Endpoints.faceAttendance, data: formData, options: Options(headers: {'_operation': 'process'}));
      if (response.statusCode == 200) {
        FaceDetectionModel res = FaceDetectionModel.fromJson(response.data);
        return res;
      }
    } on DioException catch (e) {
      EasyLoading.dismiss();

      throw DioServiceException.fromDioException(e);
    } catch (e) {
      EasyLoading.dismiss();

      throw e.toString();
    }
    return null;
  }

  Future<AllowInOutModel> signInAttendanceApi({Map? value, String? recordID}) async {
    try {
      final response = await _dio.post(
        Endpoints.saveRecord,
        data: fd.FormData.fromMap({
          'access_token': Constants.accessToken,
          'values': jsonEncode(value),
          'module': Constants.attendance,
          'useruniqueid': Constants.userUniqueId,
          if (recordID != null && recordID.isNotEmpty) 'record': recordID,
        }),
      );
      if (response.statusCode == 200 && response.data['statuscode'] == 1) {
        return AllowInOutModel.fromJson(response.data);
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw DioServiceException.fromDioException(e);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<AllowInOutModel> domesticHelpRatingApi({String? rating, String? recordID}) async {
    try {
      final response = await _dio.post(
        Endpoints.ratingAndFeedBack,
        data: fd.FormData.fromMap({'access_token': Constants.accessToken, 'module': Constants.domesticHelp, 'useruniqueid': Constants.userUniqueId, 'record': recordID, 'rating': rating}),
      );
      if (response.statusCode == 200 && response.data['statuscode'] == 1) {
        return AllowInOutModel.fromJson(response.data);
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw DioServiceException.fromDioException(e);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<AllowInOutModel> domesticHelpGatePassApi({Map? value, String? recordId}) async {
    try {
      final response = await _dio.post(
        Endpoints.saveRecord,
        data: fd.FormData.fromMap({
          'access_token': Constants.accessToken,
          'module': Constants.gatePass,
          'useruniqueid': Constants.userUniqueId,
          'values': jsonEncode(value),
          if (recordId != null && recordId.isNotEmpty) 'record': recordId
        }),
      );
      if (response.statusCode == 200 && response.data['statuscode'] == 1) {
        // if (capturedImageList != null && capturedImageList.isNotEmpty) {
        //   capturedImageList.map((e) async {
        //  await   uploadAttachmentForGatPass(capturedImageList: e, recordId: recordId!);
        //   });
        // }
        return AllowInOutModel.fromJson(response.data);
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw DioServiceException.fromDioException(e);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<FaceDetectionModel?> uploadAttachmentForGatPass({required File capturedImageList, required String recordId}) async {
    List imageFile = [];
    log("-------upload gate pass image");
    fd.FormData formData = fd.FormData.fromMap({
      'access_token': Constants.accessToken,
      'useruniqueid': Constants.userUniqueId,
      'module': Constants.gatePass,
      'recordId': recordId,
      'fieldName': 'gatepass_attachment',
      'gatepass_attachment': await multip.MultipartFile.fromFile(capturedImageList.path),
    });

    try {
      final response = await _dio.post(Endpoints.uploadAttachment, data: formData);
      if (response.statusCode == 200) {
        FaceDetectionModel res = FaceDetectionModel.fromJson(response.data);
        return res;
      }
    } on DioException catch (e) {
      EasyLoading.dismiss();

      throw DioServiceException.fromDioException(e);
    } catch (e) {
      EasyLoading.dismiss();

      throw e.toString();
    }
    return null;
  }

  Future<AttendanceDetailModel> getDateWiseSignInOutApi({String? selectedDate, String? recordID, String? moduleName}) async {
    try {
      final response = await _dio.post(
        Endpoints.fetchAttendanceDetails,
        data: fd.FormData.fromMap({
          "access_token": Constants.accessToken,
          "useruniqueid": Constants.assignedUserId,
          "recordid": recordID,
          "selected_date": selectedDate,
        }),
      );
      if (response.statusCode == 200 && response.data['statuscode'] == 1) {
        return AttendanceDetailModel.fromJson(response.data);
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw DioServiceException.fromDioException(e);
    } catch (e) {
      throw Exception(e);
    }
  }

  //get Domestic Detail
  Future<GatePassHistoryModel?> gatePassListApi({String? page, String? isVerify = '0', String? recordId}) async {
    try {
      final response = await _dio.post(
        Endpoints.listing,
        data: {
          'access_token': Constants.accessToken,
          'useruniqueid': Constants.userUniqueId,
          'module': Constants.gatePass,
          'page': page,
          'domestichelpid': recordId,
          if (Constants.userRole == Constants.securitySupervisor) 'search_params': '[["gatepass_isverify", "e", $isVerify]]'
        },
      );
      if (response.statusCode == 200) {
        GatePassHistoryModel? gatePassList = GatePassHistoryModel.fromJson(response.data);
        return gatePassList;
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      final errorMessage = err.toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
    return null;
  }

  //get getPass Detail
  Future<GatePassCountModel?> unVerifyGatePassListApi({String? recordId, String? isVerify = '0'}) async {
    try {
      final response = await _dio.post(
        Endpoints.count,
        data: {
          'access_token': Constants.accessToken,
          'useruniqueid': Constants.userUniqueId,
          'module': Constants.gatePass,
          'domestichelpid': recordId,
        },
      );
      if (response.statusCode == 200) {
        GatePassCountModel? gatePassList = GatePassCountModel.fromJson(response.data);
        return gatePassList;
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      final errorMessage = err.toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
    return null;
  }

  //Get Getpass Pick List
  Future<GatePassPickListModel?> gatePassPickListApi() async {
    EasyLoading.show(status: 'Loading..');
    try {
      final response = await _dio.post(
        Endpoints.getPicklist,
        data: {
          'access_token': Constants.accessToken,
          'useruniqueid': Constants.userUniqueId,
          'module': Constants.gatePass,
          'field': 'gatepass_havegiven',
        },
      );
      if (response.statusCode == 200) {
        GatePassPickListModel? gatePassList = GatePassPickListModel.fromJson(response.data);
        return gatePassList;
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      final errorMessage = err.toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    } finally {
      EasyLoading.dismiss();
    }
    return null;
  }

  Future<void> PollsImage({required String? recordId, required String imageName}) async {
    fd.FormData formData = fd.FormData.fromMap({
      'access_token': Constants.accessToken,
      'useruniqueid': Constants.userUniqueId,
      'module': Constants.poll,
      'recordId': recordId,
      'fieldName': 'poll_uploadpic',
      'poll_uploadpic': await multip.MultipartFile.fromFile(
        imageName,
      ),
    });

    try {
      await _dio.post(
        Endpoints.uploadAttachment,
        data: formData,
      );
    } on DioException catch (e) {
      EasyLoading.dismiss();

      throw DioServiceException.fromDioException(e);
    } catch (e) {
      EasyLoading.dismiss();

      throw e.toString();
    }
  }

  Future<PollsCreationModel?> createPass(
      {required String poll_topic,
      required String poll_description,
      required String poll_type,
      required String pollstart_date,
      required String pollend_date,
      String? recordId,
      List<XFile>? imageList,
      List<String>? listOfImageRecordToBeDelated}) async {
    try {
      EasyLoading.show();

      final response = await _dio.post(
        Endpoints.pollsCreation,
        queryParameters: {
          'access_token': Constants.accessToken,
          'useruniqueid': Constants.userUniqueId,
          'module': Constants.poll,
          'values': {
            'poll_topic': poll_topic,
            'poll_description': poll_description,
            'poll_type': poll_type,
            'assigned_user_id': Constants.userUniqueId,
            'pollstart_date': pollstart_date,
            'pollend_date': pollend_date,
          },
          'record': recordId
        },
      );

      var responseData = PollsCreationModel.fromJson(response.data);

      if (response.statusCode == 200 && response.data['statuscode'] == 1) {
        log('Invited one guest');

        if (imageList != null && imageList.isNotEmpty) {
          for (var image in imageList) {
            await PollsImage(
              recordId: responseData.data!.id,
              imageName: image.path,
            );
          }
        } else {
          log('Image list is null or empty');
        }
      }

      // if (response.statusCode == 200 && response.data['statuscode'] == 1) {
      //   log('Invited one guest');
      //
      //   await deleteAttachment(listOfImages: listOfImageRecordToBeDelated,
      //       recordId: recordId, module: Constants.poll);
      //
      //   for (int i = 0; i < imageList!.length; i++) {
      //     await PollsImage(recordId: responseData.data!.id, imageName: imageList[i].path);
      //   }
      // }

      EasyLoading.dismiss();

      return PollsCreationModel.fromJson(response.data);
    } on DioException catch (e) {
      EasyLoading.dismiss();

      throw DioServiceException.fromDioException(e);
    } catch (e, stacktrace) {
      print('Stack trace:');
      print(stacktrace);
      EasyLoading.dismiss();

      throw e.toString();
    }
  }

  Future<PollsListingModel?> pollsList({required int page}) async {
    try {
      final response = await _dio.post(
        Endpoints.listing,
        queryParameters: {
          'access_token': Constants.accessToken,
          'useruniqueid': Constants.userUniqueId,
          'module': 'Poll',
        },
      );
      if (response.statusCode == 200) {
        return PollsListingModel.fromJson(response.data);
      }
    } on DioException catch (e) {
      throw DioServiceException.fromDioException(e);
    } catch (e) {
      throw e.toString();
    }
    return null;
  }

  Future<DetailsPollsModel?> pollDetails({required String recordId}) async {
    try {
      final response = await _dio.post(
        Endpoints.getRecordDetail,
        queryParameters: {
          'module': 'Poll',
          'access_token': Constants.accessToken,
          'record': recordId,
          'useruniqueid': Constants.userUniqueId,
        },
      );

      return DetailsPollsModel.fromJson(response.data);
    } on DioException catch (e) {
      throw DioServiceException.fromDioException(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<PollsCountStatusModel?> pollsLike({required String? pollId}) async {
    try {
      final response = await _dio.post(
        Endpoints.like,
        queryParameters: {'user_id': Constants.userUniqueId, 'poll_id': pollId},
      );

      return PollsCountStatusModel.fromJson(response.data);
    } on DioException catch (e) {
      throw DioServiceException.fromDioException(e);
    } catch (e) {
      throw e.toString();
    }
  }

  //Amenities Listing
  Future<AmenitiesListingModel?> getAmenitiesList(bool checkAccessToken, {required int page}) async {
    try {
      final response = await _dio.post(
        Endpoints.listing,
        data: {'access_token': Constants.accessToken, 'module': 'Amenities', 'useruniqueid': Constants.userUniqueId, 'page': page},
      );
      if (response.statusCode == 200) {
        if (response.statusMessage.toString().contains("Invalid Access Token")) {
          if (checkAccessToken) {
            EasyLoading.show();
            Fluttertoast.showToast(
                msg: pleaseLoginAgainText,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0);
            sharedPreferences = await SharedPreferences.getInstance();
            await sharedPreferences!.clear();
            Get.offAll(const LoginScreen());
          }
        }
        AmenitiesListingModel? amenitiesListModel = AmenitiesListingModel.fromJson(response.data);
        return amenitiesListModel;
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      final errorMessage = err.toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
    return null;
  }

  Future<AmenitiesAvailableSlotModel?> getAmenitiesSlot(bool checkAccessToken, {required String amenitiesId, required String date}) async {
    try {
      final response = await _dio.post(
        Endpoints.getTimeSlot,
        data: {'access_token': Constants.accessToken, 'useruniqueid': Constants.userUniqueId, 'action': 'getAvailableSlots', 'amenitiesid': amenitiesId, 'date': date},
      );
      if (response.statusCode == 200) {
        if (response.statusMessage.toString().contains("Invalid Access Token")) {
          if (checkAccessToken) {
            EasyLoading.show();
            Fluttertoast.showToast(
                msg: pleaseLoginAgainText,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0);
            sharedPreferences = await SharedPreferences.getInstance();
            await sharedPreferences!.clear();
            Get.offAll(const LoginScreen());
          }
        }
        AmenitiesAvailableSlotModel? amenitiesSlotList = AmenitiesAvailableSlotModel.fromJson(response.data);
        return amenitiesSlotList;
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      final errorMessage = err.toString();
      throw errorMessage;
    } catch (e, stacktrace) {
      print("Printing catch statements");
      print(stacktrace.toString());
      throw e.toString();
    }
    return null;
  }

  Future<AmenitiesDetailsModel?> getAmenitiesDetails({required String recordId}) async {
    try {
      //EasyLoading.show();
      final response = await _dio.post(
        Endpoints.getRecordDetail,
        data: {'access_token': Constants.accessToken, 'module': 'Amenities', 'useruniqueid': Constants.userUniqueId, 'record': recordId},
      );
      if (response.statusCode == 200) {
        if (response.data['statuscode'] == 0) {
          final statusMessage = response.data['statusMessage'];
          if (statusMessage.contains('Permission to perform the operation is denied for id')) {
            Get.snackbar('Oops!!', statusMessage);
            Get.close(1);
          } else if (statusMessage.contains('Invalid Access Token')) {
            // Get.snackbar('Oops!!', statusMessage);
            Get.offAll(() => const CompanyCode());
          }
          return null;
        }
        AmenitiesDetailsModel? amenitiesDetailModel = AmenitiesDetailsModel.fromJson(response.data);
        return amenitiesDetailModel;
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      final errorMessage = err.toString();
      throw errorMessage;
    } catch (e) {
      EasyLoading.dismiss();
      throw e.toString();
    } finally {
      EasyLoading.dismiss();
    }
    return null;
  }

  Future<MyBookingListModel?> getMyBookingList(bool checkAccessToken, {required int page}) async {
    try {
      final response = await _dio.post(
        Endpoints.getTimeSlot,
        data: {'access_token': Constants.accessToken, 'useruniqueid': Constants.userUniqueId, 'action': 'getMyBookings', 'page': page},
      );
      if (response.statusCode == 200) {
        if (response.statusMessage.toString().contains("Invalid Access Token")) {
          if (checkAccessToken) {
            EasyLoading.show();
            Fluttertoast.showToast(
                msg: pleaseLoginAgainText,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0);
            sharedPreferences = await SharedPreferences.getInstance();
            await sharedPreferences!.clear();
            Get.offAll(const LoginScreen());
          }
        }
        MyBookingListModel? myBookingListModel = MyBookingListModel.fromJson(response.data);
        return myBookingListModel;
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      final errorMessage = err.toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
    return null;
  }

  Future<AmenitiesBookingSaveRecordModel?> amenitiesSaveRecord({
    String? bookingOption,
    required String bookingDate,
    required String bookingTimeSlot,
    String? bookingComments,
    required String amenitiesId,
    String? recordId,
    String? bookingAmount,
    String? bookingStatus,
  }) async {
    try {
      EasyLoading.show();
      Map<String, dynamic>? amenitiesBookingRecordValues = {
        'booking_status': bookingStatus,
        'booking_option': bookingOption,
        'booking_date': bookingDate,
        'booking_timeslot': bookingTimeSlot,
        'booking_comments': bookingComments,
        'amenitiesid': amenitiesId,
        'assigned_user_id': Constants.assignedUserId,
        'booking_amount': bookingAmount
      };
      final response = await _dio.post(
        Endpoints.saveRecord,
        queryParameters: {
          'access_token': Constants.accessToken,
          'useruniqueid': Constants.userUniqueId,
          'module': 'Booking',
          'values': amenitiesBookingRecordValues,
          'record': recordId,
        },
      );

      if (response.statusCode == 200) {
        AmenitiesBookingSaveRecordModel? amenitiesSaveRecord = AmenitiesBookingSaveRecordModel.fromJson(response.data);
        return amenitiesSaveRecord;
      } else {
        throw Exception('Failed to amenities record: ${response.statusCode}');
      }
    } on DioException catch (err) {
      // Handle Dio-specific exceptions
      final errorMessage = err.message;
      EasyLoading.dismiss();
      throw Exception(errorMessage);
    } catch (e) {
      // Handle any other exceptions
      EasyLoading.dismiss();
      throw Exception('An unexpected error occurred: $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<BookingCancelModel?> getCancelMyBooking(bool checkAccessToken, {required String? getRecordId}) async {
    try {
      final response = await _dio.post(
        Endpoints.getTimeSlot,
        data: {'access_token': Constants.accessToken, 'useruniqueid': Constants.userUniqueId, 'action': 'cancelBooking', 'bookingid': getRecordId},
      );
      if (response.statusCode == 200) {
        if (response.statusMessage.toString().contains("Invalid Access Token")) {
          if (checkAccessToken) {
            EasyLoading.show();
            Fluttertoast.showToast(
                msg: pleaseLoginAgainText,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0);
            sharedPreferences = await SharedPreferences.getInstance();
            await sharedPreferences!.clear();
            Get.offAll(const LoginScreen());
          }
        }
        BookingCancelModel? bookingCancelModel = BookingCancelModel.fromJson(response.data);
        return bookingCancelModel;
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      final errorMessage = err.toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
    return null;
  }

  Future<AmenitiesPaymentQRCodeModel?> getAmenitiesPaymentQRCode(bool checkAccessToken, {required String? recordId}) async {
    try {
      final response = await _dio.post(
        Endpoints.getRecordDetail,
        data: {'access_token': Constants.accessToken, 'useruniqueid': Constants.userUniqueId, 'module': 'QRCode', 'record': recordId},
      );
      if (response.statusCode == 200) {
        if (response.statusMessage.toString().contains("Invalid Access Token")) {
          if (checkAccessToken) {
            EasyLoading.show();
            Fluttertoast.showToast(
                msg: pleaseLoginAgainText,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0);
            sharedPreferences = await SharedPreferences.getInstance();
            await sharedPreferences!.clear();
            Get.offAll(const LoginScreen());
          }
        }
        AmenitiesPaymentQRCodeModel? amenitiesPaymentQRCode = AmenitiesPaymentQRCodeModel.fromJson(response.data);
        return amenitiesPaymentQRCode;
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      final errorMessage = err.toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
    return null;
  }

  // To fetch all vendors
  Future<VendorsListingModel> getVendorsListing({
    required int page,
  }) async {
    late final VendorsListingModel data;
    try {
      final response = await _dio.post(
        Endpoints.listing,
        data: fd.FormData.fromMap({
          'access_token': Constants.accessToken,
          'module': Constants.vendorsModule,
          'page': page.toString(),
          'useruniqueid': Constants.userUniqueId,
        }),
      );
      if (response.statusCode == 200 && response.data['statuscode'] == 1) {
        data = VendorsListingModel.fromJson(response.data);
      } else {
        Fluttertoast.showToast(
          msg: 'Fetching vendors failed',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        throw Exception('Fetching vendors failed');
      }
    } on DioException catch (e) {
      throw DioServiceException.fromDioException(e);
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      throw Exception(e);
    }
    return data;
  }

  // To fetch vendor details
  Future<VendorDetailsModel> getVendorsDetails({
    required String vendorId,
  }) async {
    late final VendorDetailsModel data;
    try {
      final response = await _dio.post(
        Endpoints.getRecordDetail,
        data: fd.FormData.fromMap({
          'access_token': Constants.accessToken,
          'module': Constants.vendorsModule,
          'record': vendorId,
          'useruniqueid': Constants.userUniqueId,
        }),
      );
      if (response.statusCode == 200 && response.data['statuscode'] == 1) {
        data = VendorDetailsModel.fromJson(response.data);
      } else {
        Fluttertoast.showToast(
          msg: 'Fetching vendor details failed',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        throw Exception('Fetching vendor details failed');
      }
    } on DioException catch (e) {
      throw DioServiceException.fromDioException(e);
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      throw Exception(e);
    }
    return data;
  }

  // To save vendor details
  Future<bool> saveVendorDetails({
    required String vendorName,
    required String mobile,
    required String email,
    required String pincode,
    required String city,
    required String district,
    required String state,
    required String address,
    required String servicesTypes,
    required String idProof,
    required List<XFile> uplImages,
    String? recordId,
    List<String>? imagesToBeDeleted,
  }) async {
    late final bool data;
    EasyLoading.show();
    try {
      final response = await _dio.post(
        Endpoints.saveRecord,
        data: fd.FormData.fromMap({
          'access_token': Constants.accessToken,
          'module': Constants.vendorsModule,
          'useruniqueid': Constants.userUniqueId,
          'values': {
            'vendorname': vendorName,
            'phone': mobile,
            'email': email,
            'postalcode': pincode,
            'city': city,
            'district': district,
            'state': state,
            'address': address,
            'type_of_services': servicesTypes,
            'idproof': idProof,
            'uploadidproof': '${uplImages.length} images',
            'assigned_user_id': Constants.assignedUserId,
          },
          'record': recordId
        }),
      );
      if (response.statusCode == 200 && response.data['statuscode'] == 1) {
        data = response.data['statuscode'] == 1;
        if (recordId != null && recordId.isNotEmpty) {
          if (imagesToBeDeleted != null && imagesToBeDeleted.isNotEmpty) {
            await deleteAttachment(
              listOfImages: imagesToBeDeleted,
              recordId: recordId,
              module: Constants.vendorsModule,
            );
          }
        }
        for (XFile image in uplImages) {
          await uploadAttachmentForVendorReg(
            fileImage: File(image.path),
            recordId: response.data['data']['id'],
          );
        }
        Fluttertoast.showToast(
          msg: (recordId == null) ? 'Vendor Registered' : 'Vendor Details Updated',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        data = response.data['statuscode'] == 1;
        Fluttertoast.showToast(
          msg: (recordId == null) ? 'Failed to create vendor' : 'Failed to update vendor',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } on DioException catch (e) {
      throw DioServiceException.fromDioException(e);
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      EasyLoading.dismiss();
    }
    return data;
  }

  // Upload attachment for vendor registration
  Future<void> uploadAttachmentForVendorReg({
    required File fileImage,
    required String recordId,
  }) async {
    try {
      final response = await _dio.post(
        Endpoints.uploadAttachment,
        data: fd.FormData.fromMap({
          'access_token': Constants.accessToken,
          'fieldName': 'uploadidproof',
          'module': Constants.vendorsModule,
          'recordId': recordId,
          'uploadidproof': multip.MultipartFile.fromFileSync(fileImage.path),
          'useruniqueid': Constants.userUniqueId,
        }),
      );
      if (response.statusCode == 200 && response.data['statuscode'] == 1) {
        debugPrint(response.data.toString());
      } else {
        throw Exception('Failed to upload');
      }
    } on DioException catch (e) {
      final msg = DioServiceException.fromDioException(e);
      debugPrint(msg.errorMessage);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //get Domestic Detail
  Future<QRPaymentModel?> paymentQrDetailApi() async {
    try {
      final response = await _dio.post(
        Endpoints.getRecordDetail,
        data: {
          'access_token': Constants.accessToken,
          'useruniqueid': Constants.userUniqueId,
          'module': Constants.qRCode,
          'record': Constants.qrcodeId,
        },
      );
      if (response.statusCode == 200) {
        QRPaymentModel? paymentQRModel = QRPaymentModel.fromJson(response.data);
        return paymentQRModel;
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      final errorMessage = err.toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
    return null;
  }

  Future<AddToFlatModel?> addToFlatDataUpdateApi(String? helperID) async {
    try {
      final response = await _dio.post(
        Endpoints.addToFlat,
        data: {
          'access_token': Constants.accessToken,
          'useruniqueid': Constants.userUniqueId,
          'helper_id': helperID,
        },
      );
      if (response.statusCode == 200) {
        AddToFlatModel? addToFlatModel = AddToFlatModel.fromJson(response.data);
        return addToFlatModel;
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      final errorMessage = err.toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
    return null;
  }

  Future<UpdateAppModel?> appUpdateApi(String? currentVersion) async {
    try {
      final response = await _dio.post(
        Endpoints.getAppVersionName,
        data: {
          'currentAppVersion': currentVersion,
        },
      );
      if (response.statusCode == 200) {
        UpdateAppModel? updateApp = UpdateAppModel.fromJson(response.data);
        return updateApp;
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      final errorMessage = err.toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
    return null;
  }

  Future<InfraEmpProfileModel?> infraEmpProfileApi() async {
    try {
      EasyLoading.show();
      final response = await _dio.post(
        Endpoints.getInfraEmpProfileInfo,
        queryParameters: {
          'access_token': Constants.accessToken,
          'useruniqueid': Constants.userUniqueId,
        },
      );

      if (response.statusCode == 200) {
        if (response.data['statuscode'] == 1) {
          return InfraEmpProfileModel.fromJson(response.data);
        } else {
          throw Exception(response.data['statusMessage']);
        }
      }
    } on DioException catch (e) {
      EasyLoading.dismiss();
      final errorMessage = e.toString();
      throw errorMessage;
    } catch (e) {
      EasyLoading.dismiss();
      throw e.toString();
    } finally {
      EasyLoading.dismiss();
    }
    return null;
  }
}
