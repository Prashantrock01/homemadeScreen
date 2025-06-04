import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:biz_infra/CustomWidgets/configurable_widgets.dart';
import 'package:biz_infra/CustomWidgets/image_view.dart';
import 'package:biz_infra/Network/dio_service_client.dart';
import 'package:biz_infra/Services/LocationServices.dart';
import 'package:biz_infra/Utils/app_styles.dart';
import 'package:biz_infra/Utils/common_widget.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http show get;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class VendorRegistration extends StatefulWidget {
  final bool updateMode;
  final String? recordId;

  const VendorRegistration({super.key, this.updateMode = false, this.recordId});

  @override
  State<VendorRegistration> createState() => _VendorRegistrationState();
}

class _VendorRegistrationState extends State<VendorRegistration> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  CountryCode cCode = CountryCode.fromCountryCode('IN');
  int _selectedCityIndex = -1;
  final scrollController = ScrollController();
  final _picker = ImagePicker();
  List<XFile> attachments = [];
  List<String> delAttachIds = [];
  bool? useCurrentLocation = false;

  final _vendorName = TextEditingController();
  final _vendorMobNo = TextEditingController();
  final _vendorEmail = TextEditingController();
  final _pincode = TextEditingController();
  final _city = TextEditingController();
  final _district = TextEditingController();
  final _state = TextEditingController();
  final _address = TextEditingController();
  final _typeOfServices = TextEditingController();
  final _idProof = TextEditingController();

  void _disposeFields() {
    _vendorName.dispose();
    _vendorMobNo.dispose();
    _vendorEmail.dispose();
    _pincode.dispose();
    _city.dispose();
    _district.dispose();
    _state.dispose();
    _address.dispose();
    _typeOfServices.dispose();
    _idProof.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (!widget.updateMode) {
      cCode = CountryCode.fromCountryCode('IN');
    }
    _initializeFieldsIfUpdate();
  }

  @override
  void dispose() {
    _disposeFields();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.updateMode ? 'Edit Vendor Details' : 'Vendor Registration',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(12),
          children: [
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _vendorName,
              decoration: defaultInputDecoration(hintText: 'Enter Vendor Name', prefixIcon: Icons.store, labelText: 'Vendor Name'),
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter vendor name';
                }
                return null;
              },
            ),
            SizedBox(height: 8),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _vendorEmail,
              decoration: defaultInputDecoration(hintText: 'Enter Email Id', prefixIcon: Icons.email, labelText: 'Email Id'),
              keyboardType: TextInputType.emailAddress,
              validator: validateEmail,
            ),
            SizedBox(height: 8),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _vendorMobNo,
              maxLength: 10,
              decoration: defaultInputDecoration(
                  hintText: 'Enter Mobile Number',
                  counterText: '',
                  prefix: CountryCodePicker(
                    initialSelection: cCode.code,
                    onChanged: (value) {
                      setState(() {
                        cCode = value;
                      });
                    },
                  ),
                  labelText: 'Mobile Number'),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (value) {
                final regex = RegExp(r'^[6-9]\d{9}$');
                if (value == null || value.isEmpty) {
                  return 'Please enter mobile number';
                } else if (!regex.hasMatch(value)) {
                  return 'Please enter valid mobile number';
                }
                return null;
              },
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: _typeOfServices,
              textCapitalization: TextCapitalization.words,
              decoration: defaultInputDecoration(hintText: 'Enter Type Of Services', prefixIcon: Icons.design_services, labelText: 'Type Of Services'),
              keyboardType: TextInputType.multiline,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s,-]'))],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter type of services';
                }
                return null;
              },
            ),
            CheckboxListTile(
              value: useCurrentLocation,
              contentPadding: EdgeInsets.zero,
              onChanged: (c) {
                useCurrentLocation = c;

                setState(() {});
                if (useCurrentLocation == true) {
                  getCurrentLocationByAddress();
                } else {
                  clearAllAddField();
                }
              },
              title: Text('Use current Location?', style: Styles.hintText),
            ),
            SizedBox(height: 8),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              // do not remove this line. It is used to clear city, district & state as soon as user changes the pincode
              controller: _pincode,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: defaultInputDecoration(
                hintText: 'Enter PinCode',
                prefixIcon: Icons.onetwothree,
                labelText: 'PinCode',
                counterText: '',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _showAvailableCitiesFromPincode,
                ),
              ),
              onFieldSubmitted: (value) => _showAvailableCitiesFromPincode(),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (value) {
                final regex = RegExp(r'^[^0]\d{5}$');
                if (value == null || value.isEmpty) {
                  return 'Please enter PinCode';
                } else if (!regex.hasMatch(value)) {
                  clearAllAddField();
                  return 'Please enter valid PinCode';
                }
                return null;
              },
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _city,
                    decoration: defaultInputDecoration(hintText: 'Enter City', prefixIcon: Icons.location_city, labelText: 'City'),
                    readOnly: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter city name';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _district,
                    decoration: defaultInputDecoration(hintText: 'Enter District', prefixIcon: Icons.location_city, labelText: 'District'),
                    readOnly: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter district';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: _state,
              decoration: defaultInputDecoration(hintText: 'Enter State', prefixIcon: Icons.location_city, labelText: 'State'),
              readOnly: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter state';
                }
                return null;
              },
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: _address,
              textCapitalization: TextCapitalization.words,
              decoration: defaultInputDecoration(hintText: 'Enter Address', prefixIcon: Icons.location_city, labelText: 'Address'),
              maxLines: 3,
              keyboardType: TextInputType.streetAddress,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s,-]'))],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter address';
                }
                return null;
              },
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: _idProof,
              decoration: defaultInputDecoration(hintText: 'Enter Id Proof', prefixIcon: Icons.location_city, labelText: 'Id Proof'),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z,-\s]')),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter id proof';
                }
                return null;
              },
            ),
            SizedBox(height: 8),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Upload Id Proof *',
                      style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(5.0),
                      onTap: _showUploadFromSourceDialog,
                      child: const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.attachment),
                            SizedBox(width: 2),
                            Text(
                              'Upload',
                              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Visibility(
                        visible: attachments.isNotEmpty,
                        replacement: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('No Attachment'),
                        ),
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 8 / 9,
                            crossAxisCount: 3,
                            crossAxisSpacing: 3.0,
                            mainAxisSpacing: 3.0,
                          ),
                          shrinkWrap: true,
                          primary: false,
                          itemCount: attachments.length,
                          itemBuilder: (context, index) {
                            final img = attachments.elementAt(index);

                            return Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(
                                        () => ImageViewScreen(
                                          imageFile: File(img.path),
                                        ),
                                        popGesture: true,
                                        transition: Transition.rightToLeft,
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4.0),
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 2.0,
                                        ),
                                      ),
                                      child: Image.file(
                                        File(img.path),
                                        fit: BoxFit.cover,
                                        width: media.size.width * 0.4,
                                        height: media.size.height * 0.4,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () => _removeAt(index),
                                    child: const Icon(
                                      Icons.remove_circle_outline_rounded,
                                      color: Colors.red,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            textButton(
              onPressed: _onFormSubmit,
              widget: Text(
                widget.updateMode ? 'Update' : 'Submit',
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? validateEmail(String? value) {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (value == null || value.isEmpty) {
      return null;
    } else if (!regex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  Future<void> _showAvailableCitiesFromPincode() async {
    final pin = _pincode.text;
    if (pin.isNotEmpty && pin.length == 6) {
      final result = await dioServiceClient.fetchCitiesFromPincode(pincode: pin);
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
                                        _city.text = pid.pincodeCity ?? '';
                                        _district.text = pid.pincodeDistrict ?? '';
                                        _state.text = pid.pincodeState ?? '';
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
                                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
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

  void _showUploadFromSourceDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          contentPadding: const EdgeInsets.all(16.0),
          title: const Text('Select Source'),
          children: [
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                _pickFromCamera();
              },
              padding: const EdgeInsets.all(10.0),
              child: const Text('Camera'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                _pickMultipleFromGallery();
              },
              padding: const EdgeInsets.all(10.0),
              child: const Text('Gallery'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
              },
              padding: const EdgeInsets.all(10.0),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickFromCamera() async {
    final pickedImage = await _picker.pickImage(
      imageQuality: 25,
      source: ImageSource.camera,
    );
    if (pickedImage != null) {
      setState(() {
        attachments.add(pickedImage);
      });
    }
  }

  Future<void> _pickMultipleFromGallery() async {
    final pickedImages = await _picker.pickMultiImage(imageQuality: 25);
    if (pickedImages.isNotEmpty) {
      setState(() {
        attachments.addAll(pickedImages);
      });
    }
  }

  void _removeAt(int index) {
    setState(() {
      attachments.removeAt(index);
    });
  }

  Future<void> _onFormSubmit() async {
    final id = widget.recordId;
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      if (attachments.isEmpty) {
        snackBarMessenger(
          'Please Upload Id Proof',
          duration: 2,
        );
      } else {
        final result = await dioServiceClient.saveVendorDetails(
          vendorName: _vendorName.text,
          mobile: '${cCode.dialCode}${_vendorMobNo.text}',
          email: _vendorEmail.text,
          pincode: _pincode.text,
          city: _city.text,
          district: _district.text,
          state: _state.text,
          address: _address.text,
          servicesTypes: _typeOfServices.text,
          idProof: _idProof.text,
          uplImages: attachments,
          recordId: id,
          imagesToBeDeleted: delAttachIds,
        );
        if (result && mounted) {
          Navigator.pop(context);
        }
      }
    }
  }

  Future<void> _initializeFieldsIfUpdate() async {
    final id = widget.recordId;
    if (widget.updateMode && (id != null && id.isNotEmpty)) {
      EasyLoading.show(status: 'Fetching Data');
      final result = await dioServiceClient.getVendorsDetails(vendorId: id);
      final data = result.data;
      if (data != null) {
        final record = data.record;
        if (record != null) {
          _vendorName.text = record.vendorname.toString();
          final regex = RegExp(r'^(\+\d+)?(\d{10})$');
          final phone = regex.matchAsPrefix(record.phone.toString());
          if (phone != null) {
            _vendorMobNo.text = phone.group(2).toString();
            cCode = CountryCode.fromDialCode(phone.group(1) ?? '+91');
          }
          _vendorEmail.text = record.email.toString();
          _pincode.text = record.postalcode.toString();
          _city.text = record.city.toString();
          _district.text = record.district.toString();
          _state.text = record.state.toString();
          _address.text = record.address.toString();
          _typeOfServices.text = record.typeOfServices.toString();
          _idProof.text = record.idproof.toString();
          final pics = record.uploadidproof;
          if (pics != null && pics.isNotEmpty) {
            final tmpDir = await getTemporaryDirectory();
            for (final pic in pics) {
              final resp = await http.get(Uri.parse(pic.urlpath.toString()));
              if (File([tmpDir.path, pic.name].join('/')).existsSync()) {
                File([tmpDir.path, pic.name].join('/')).deleteSync();
              }
              final picFile = XFile.fromData(
                resp.bodyBytes,
                length: resp.contentLength,
                mimeType: 'image/*',
                name: pic.name,
                path: [tmpDir.path, pic.name].join('/'),
              );
              Uint8List bytes = await picFile.readAsBytes();
              File(picFile.path).writeAsBytesSync(
                bytes,
                mode: FileMode.write,
              );
              attachments.add(picFile);
              delAttachIds.add(pic.attachmentsid.toString());
            }
            setState(() {});
          }
        }
      }
      EasyLoading.dismiss();
    }
  }

  getCurrentLocationByAddress() async {
    try {
      Position position = await LocationServices().getCurrentLocation();
      Placemark? address = await LocationServices().getAddressFromCoordinates(position);
      if (address != null) {
        _pincode.text = address.postalCode!;
        _city.text = address.locality!;
        _district.text = address.subAdministrativeArea!;
        _state.text = address.administrativeArea!;
        _address.text = formatAddress(address);
      }
      print("📍 Address: ${address}");
    } catch (e) {
      setState(() {
        print("Error: $e");
      });
    }
  }

  clearAllAddField() {
    _pincode.clear();
    _city.clear();
    _district.clear();
    _state.clear();
    _address.clear();
  }

  String formatAddress(Placemark place) {
    return [
      if (place.subLocality != null && place.subLocality!.isNotEmpty) place.subLocality,
      if (place.locality != null && place.locality!.isNotEmpty) place.locality,
      if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) place.administrativeArea,
      if (place.postalCode != null && place.postalCode!.isNotEmpty) place.postalCode,
      if (place.country != null && place.country!.isNotEmpty) place.country,
    ].join(", ");
  }
}
