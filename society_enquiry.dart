import 'package:auto_size_text/auto_size_text.dart';
import 'package:biz_infra/CustomWidgets/configurable_widgets.dart';
import 'package:biz_infra/Model/SocietyEnquiry/designation_model.dart';
import 'package:biz_infra/Network/dio_service_client.dart';
// import 'package:biz_infra/Screens/owner_tenant_registration/login.dart';
import 'package:biz_infra/company_code.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../CustomWidgets/validations.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';


class SocietyRegistration extends StatefulWidget {
  const SocietyRegistration({super.key});

  @override
  State<SocietyRegistration> createState() => _SocietyRegistrationState();
}

class _SocietyRegistrationState extends State<SocietyRegistration> {
  final _regFormKey = GlobalKey<FormState>();
  CountryCode cCode = CountryCode.fromCountryCode('IN');

  final TextEditingController societyNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController contactNoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final scrollController = ScrollController();
  RxList<dynamic>? designationList = [].obs;
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;


  void fetchDesignation() async {
    DesignationModel? response = await dioServiceClient.designationData();
    if (response?.statuscode == 1) {
      designationList!.value = response?.data?.designation
              ?.map((x) => x.designation.toString())
              .toList() ??
          [];
    }
  }

  void showThankYouDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // backgroundColor: const Color(0xFFf39142),
          title: Column(
            children: [
              const Text("Thank You!!"),
              Image.asset('assets/images/authenticate_bg.gif'),
            ],
          ),
          content: Text(
            message,
          ),
          actions: <Widget>[
            textButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              widget: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchDesignation();

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
      _connectionStatus = result.isNotEmpty ? result : [ConnectivityResult.none];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Society Enquiry'),
      ),
      body: _connectionStatus.contains(ConnectivityResult.none)?
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 50, color: Colors.grey),
            const SizedBox(height: 20),
            const Text("No Internet Connection", style: TextStyle(fontSize: 20, color: Colors.grey)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: initConnectivity,
              child: const Text("Retry"),
            ),
          ],
        ),
      ):

      Form(
        key: _regFormKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 200.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 20.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Want to register your\n'
                            'society with BizInfra?',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: 5.0,
                              top: 10.0,
                            ),
                            child: Text(
                              'Refer your society\nand earn money',
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                          Text(
                            'Many people have earned',
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(
                          right: 10.0,
                        ),
                        child: Image.asset(
                          'assets/images/Group 3257@3x.png',
                          fit: BoxFit.cover,
                          height: 150.0,
                          width: 130.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    textField(
                      controller: societyNameController,
                      hintText: 'Enter Society Name *',
                      labelText: 'Society Name *',
                      textCapitalization: TextCapitalization.words,
                      inputType: TextInputType.text,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                      ],
                      prefixIcon: const Icon(Icons.apartment),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter society name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    textField(
                      controller: usernameController,
                      textCapitalization: TextCapitalization.words,
                      inputType: TextInputType.text,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                      ],
                      hintText: 'Enter your name *',
                      labelText: 'Username *',
                      prefixIcon: const Icon(Icons.person),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Obx(
                      () => dropdownUI(
                        context: context,
                        controller: designationController,
                        hintText: 'Select Designation *',
                        formLabel: 'Select Designation *',
                        prefixIcon: const Icon(Icons.work),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select designation';
                          }
                          return null;
                        },
                        data: designationList?.toList().cast<String>(),
                        //data: societyName.toList().cast<String>(),
                        onChanged: (int? value) {},
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    textField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: contactNoController,
                      hintText: 'Enter Contact Number *',
                      inputType: TextInputType.phone,
                      maxLength: 10,
                      counterText: '',
                      labelText: 'Contact Number *',
                      prefixIcon: CountryCodePicker(
                        initialSelection: cCode.code,
                        onChanged: (value) {
                          setState(() {
                            cCode = value;
                          });
                        },
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        final regex = RegExp(r'^[6-9]\d{9}$');
                        if (value == null || value.isEmpty) {
                          return 'Please enter phone number';
                        } else if (!regex.hasMatch(value)) {
                          return 'Please enter valid phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    textField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: emailController,
                      inputType: TextInputType.emailAddress,
                      hintText: 'Enter Email Address',
                      prefixIcon: const Icon(Icons.email),
                      validator: validateEmail,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    textField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,// do not remove this line. It is used to clear city, district & state as soon as user changes the pincode
                      controller: pinCodeController,
                      hintText: 'Enter Pincode *',
                      inputType: TextInputType.number,
                      labelText: 'Pincode *',
                      maxLength: 6,
                      counterText: '',
                      prefixIcon: const Icon(Icons.onetwothree),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: _showAvailableCitiesFromPincode,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        final regex = RegExp(r'^[^0]\d{5}$');
                        if (value == null || value.isEmpty) {
                          return 'Please enter Pincode';
                        } else if (!regex.hasMatch(value)) {
                          cityController.text = '';
                          districtController.text = '';
                          stateController.text = '';
                          return 'Please enter valid pincode';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    textField(
                      controller: cityController,
                      hintText: 'Enter City *',
                      labelText: 'City *',
                      prefixIcon: const Icon(Icons.location_city),
                      readOnly: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter city name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    textField(
                      controller: districtController,
                      hintText: 'Enter District *',
                      labelText: 'District *',
                      prefixIcon: const Icon(Icons.location_city),
                      readOnly: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter district';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    textField(
                      controller: stateController,
                      hintText: 'Enter State *',
                      labelText: 'State *',
                      prefixIcon: const Icon(Icons.location_city),
                      readOnly: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter state';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    textField(
                      controller: addressController,
                      textCapitalization: TextCapitalization.words,
                      hintText: 'Enter Address *',
                      inputType: TextInputType.multiline,
                      labelText: 'Address *',
                      prefixIcon: const Icon(Icons.location_city),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s,-]'))
                      ],

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    textButton(
                      onPressed: () async {
                        if (_regFormKey.currentState!.validate()) {
                          var societyEnquiryData =
                              await dioServiceClient.createSocietyEnquiry(
                            societyName: societyNameController.text,
                            username: usernameController.text,
                            contactNumber: contactNoController.text,
                            designation: designationController.text,
                            pincode: pinCodeController.text,
                            city: cityController.text,
                            district: districtController.text,
                            state: stateController.text,
                            address: addressController.text,
                            email: emailController.text,
                          );

                          if (societyEnquiryData?.statuscode == 1) {
                            Fluttertoast.showToast(
                              msg: societyEnquiryData!.statusMessage.toString(),
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );

                            Get.off(() => const CompanyCode());
                            showThankYouDialog(
                                "We’ve received your enquiry at Infra Eye! Our team will follow up with you soon. Thank you for letting us assist you on your journey with Infra Eye!");
                          }
                        }
                      },
                      widget: const Text(
                        'Submit',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _selectedCityIndex = -1;

  Future<void> _showAvailableCitiesFromPincode() async {
    final pin = pinCodeController.text;
    if (pin.isNotEmpty && pin.length == 6) {
      final result = await dioServiceClient.fetchCitiesFromPincode(
        pincode: pin,
      );
      final data = result.data?.pincodes;
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Center(
                              child: AutoSizeText(
                                'Pincode',
                                style: TextStyle(
                                  fontFamily: 'Sfpro',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        const Divider(
                          color: Colors.grey,
                          height: 4.0,
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height * 0.4,
                          ),
                          child: Visibility(
                            visible: data != null && data.isNotEmpty,
                            replacement: const Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Text("Please enter valid Pincode"),
                            ),
                            child: Scrollbar(
                              controller: scrollController,
                              thumbVisibility: true,
                              child: ListView.builder(
                                controller: scrollController,
                                itemCount: data!.length,
                                itemBuilder: (context, index) {
                                  final pid = data.elementAt(index);
                    
                                  return RadioListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 5.0,
                                    ),
                                    title: AutoSizeText(
                                      pid.pincodeCity!,
                                      style: const TextStyle(
                                        fontFamily: 'Sfpro',
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                    value: index,
                                    groupValue: _selectedCityIndex,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedCityIndex = index;
                                        cityController.text =
                                            pid.pincodeCity ?? '';
                                        districtController.text =
                                            pid.pincodeDistrict ?? '';
                                        stateController.text =
                                            pid.pincodeState ?? '';
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional.bottomEnd,
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 100,
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    style: ButtonStyle(
                                      shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                    ),
                                    child: const AutoSizeText(
                                      'OK',
                                      style: TextStyle(fontSize: 14.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      );
    }
  }
}
