class Endpoints {
  ///Production URL
  //static const String baseUrl = 'https://api.bizinfratech.in/modules/Mobile/';

  ///Quality URL
 // static const String baseUrl = 'https://api.bizinfratech.in/bizinfraeyequality/modules/Mobile/';

  static const String registerDeviceId = "v1/registerDeviceIdWithCRM";
  static const String fetchBaseUrl = 'v1/getCInstanceURL';
  static const String listing = 'v1/listModuleRecords';
  static const String getPicklist ='v1/GetPicklist';
  static const String getRoleWisePicklist = 'v1/getRoleBaseAssignedPicklist';
  static const String uploadAttachment = 'v1/UploadAttachment';
  static const String saveRecord = 'v1/saveRecord';
  static const String getRecordComments = 'v1/getRecordComments';
  static const String registration = 'v1/Registration';
  static const String validateUser = 'v1/CheckOwnerExists';
  static const String ownerRegistration = "v1/OwnerRegistration";
  static const String emailLogin = 'v1/loginNew';
  static const String preLogin = 'v1/PreLogin';
  static const String phoneNumberLogin = 'v1/DoOTPLogin';
  static const String otpVerification ='v1/OTPGeneration';
  static const String getRecordDetail = 'v1/GetRecordDetail';
  static const String count = 'v1/Count';
  static const String noticeFilter = 'v1/FilterNotice';
  static const String verifyOtp ='v1/VerifiedOTP';
  static const String pickListValues ='v1/GetPickListValuesOfField';
  static const String societyEnquiry = 'v1/SocietyRegistration';
  static const String cancelRecord = 'v1/CancelRecords';
  static const String ownerProfile ='v1/GetOwnerProfileInfo';
  static const String employeeProfile ='v1/GetProfileInfo';
  static const String passcodeCreation ='v1/PasscodeGeneration';
  static const String passwordChange ='v1/ChangePassword';
  static const String profileDelete ='v1/DeleteAccount';
  static const String editEmail = 'v1/UpdateOwner';
  static const String editEmployeeEmail = 'v1/UpdateProfile';
  static const String renewPassCode = 'v1/PasscodeRenew';
  static const String forgotPassword = 'v1/PreResetPassword';
  static const String resetPassword = 'v1/ResetPassword';
  static const String deleteRecords = 'v1/deleteRecords';
  static const String pinCodeInfo = 'v1/GetPincodeInfo';
  static const String deleteAttachment = 'v1/DeleteAttachment';
  static const String domesticHelpPasscodeVerification = 'v1/DemostichelpPasscodeVerificaion';
  static const String ratingAndFeedBack = 'v1/RatingAndFeedBack';
  static const String societyName = 'v1/getSocietyList';
  static const String societyBlock = 'v1/FilterBlock';
  static const String societyNumber = 'v1/FilterFlat';
  // static const String announcement = 'v1/getAnnouncement';
  static const String announcement = 'v1/ModuleRecords';
  static const String fetchInOutDetails = 'v1/FetchInOutDetails';
  static const String faceAttendance = 'v1/FaceAttendance';
  static const String fetchAttendanceDetails='v1/FetchAttendanceDetails';
  static const String pollsCreation ='v1/saveRecord';
  static const String addToFlat ='v1/AddToFlat';
  static const String customerCare ='v1/ModuleRecords';
  static const String removeDomesticHelp ='v1/RemoveDomesticHelp';
  static const String like='v1/like';
  static const String getAppVersionName ='v1/getAppVersionName';
  static const String getTimeSlot ='v1/timeslot';
  static const String getInfraEmpProfileInfo ='v1/GetInfraEmpProfileInfo';
  static const String updateInfraEmployee = 'v1/UpdateInfraEmployee';
}
