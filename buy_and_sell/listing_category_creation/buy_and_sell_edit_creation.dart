// ignore_for_file: invalid_use_of_protected_member

import 'dart:io';

import 'package:biz_infra/CustomWidgets/configurable_widgets.dart';
import 'package:biz_infra/Model/buy_and_sell/buy_and_sell_creation_modal.dart';
import 'package:biz_infra/Model/buy_and_sell/buy_and_sell_details_modal.dart';
import 'package:biz_infra/Model/buy_and_sell/dropdowns/list_category_dropdown_modal.dart';
import 'package:biz_infra/Model/buy_and_sell/dropdowns/type_of_sell_dropdown_modal.dart';
import 'package:biz_infra/Network/dio_service_client.dart';
import 'package:biz_infra/Screens/buy_and_sell/buy_and_sell_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_image_compress/flutter_image_compress.dart';

class BuyAndSellEditCreation extends StatefulWidget {
  const BuyAndSellEditCreation(
      {super.key, required this.buyAndSellId, this.buyAndSellData});

  final String buyAndSellId;
  final BuyAndSellDetailsModal? buyAndSellData;

  @override
  State<BuyAndSellEditCreation> createState() => _BuyAndSellEditCreationState();
}

class _BuyAndSellEditCreationState extends State<BuyAndSellEditCreation> {
  final _formKey = GlobalKey<FormState>();

  final _listController = TextEditingController();
  final _titleController = TextEditingController();
  final _specController = TextEditingController();
  final _purchaseYearController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _typeOfSellController = TextEditingController();
  final _sellingPriceController = TextEditingController();

  final ValueNotifier<bool> saleNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> giveawayNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> negotiableNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<String?> selectedTypeOfSell =
      ValueNotifier<String?>(null);

  final _scrollController = ScrollController();

  final RxList<File> _imagesNotifier = <File>[].obs;

  List<XFile>? imageList = [];

  RxList<dynamic>? listCategory = [].obs;
  RxList<dynamic>? typeOfSell = [].obs;

  List<File?> capturedImages = [];
  List<String> listOfExistigImagesRecord = [];

  @override
  void initState() {
    super.initState();
    fetchData();
    callListCategory();
    callTypeofSell();
  }

  @override
  void dispose() {
    // Dispose the ValueNotifier when the widget is removed from the tree
    saleNotifier.dispose();
    giveawayNotifier.dispose();
    negotiableNotifier.dispose();
    selectedTypeOfSell.dispose();
    super.dispose();
  }

  fetchData() async {
    try {
      if (widget.buyAndSellData != null) {
        EasyLoading.show();
        _listController.text =
            widget.buyAndSellData!.data!.record!.buysellCategory!;
        _titleController.text =
            widget.buyAndSellData!.data!.record!.buysellTitle!;
        _specController.text =
            widget.buyAndSellData!.data!.record!.buysellSpecification!;
        _purchaseYearController.text =
            widget.buyAndSellData!.data!.record!.buysellYear!;
        _purchasePriceController.text =
            widget.buyAndSellData!.data!.record!.buysellPurchasePrice!;
        _typeOfSellController.text =
            widget.buyAndSellData!.data!.record!.buysellSelltype!;

        // Check if the type of sell is 'Giveaway'
        if (_typeOfSellController.text == 'Giveaway') {
          _sellingPriceController.text = ''; // Clear the selling price
        } else {
          _sellingPriceController.text =
              widget.buyAndSellData!.data!.record!.buysellCost!;
        }

        negotiableNotifier.value = widget
                .buyAndSellData!.data!.record!.buysellNegotiate!
                .toLowerCase() ==
            '1';

        List<BuysellUploadpic>? listOfImages =
            widget.buyAndSellData!.data!.record!.buysellUploadpic;
        listOfImages ??= [];
        listOfExistigImagesRecord = [];
        for (int i = 0; i < listOfImages.length; i++) {
          final uri = Uri.parse(listOfImages[i].urlpath.toString());
          final res = await http.get(uri);
          var bytes = res.bodyBytes;
          final temp = await getTemporaryDirectory();
          final path = '${temp.path}/${listOfImages[i].name}';
          if (File(path).existsSync()) {
            File(path).deleteSync();
            // print("ISDELETED${File(path).existsSync().toString()}");
          }
          File(path).writeAsBytesSync(bytes, mode: FileMode.write);
          _imagesNotifier.add(File(path));
          listOfExistigImagesRecord
              .add(listOfImages[i].attachmentsid.toString());
        }
        EasyLoading.dismiss();
      }
    } catch (e) {
      //print(e.toString());
      EasyLoading.dismiss();
    }
  }

  void callListCategory() async {
    ListCategoryDropdownModal? response = await dioServiceClient.getListCategory();
    if (response?.statuscode == 1) {
      listCategory!.value = response?.data?.buysellCategory
              ?.map((x) => x.buysellCategory.toString())
              .toList() ??
          [];
    }
  }

  void callTypeofSell() async {
    TypeofSellDropdownModal? response = await dioServiceClient.getTypeofSell();
    if (response?.statuscode == 1) {
      typeOfSell!.value = response?.data?.buysellSelltype
              ?.map((x) => x.buysellSelltype.toString())
              .toList() ??
          [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Item Details'),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 4.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: TextButton.icon(
                      onPressed: _showAlertDialog,
                      label: const Text('Add Photo'),
                      icon: const Icon(Icons.add_a_photo),
                      iconAlignment: IconAlignment.start,
                    ),
                  ),
                  Obx(() {
                    return Visibility(
                      visible: _imagesNotifier
                          .isNotEmpty, // Show GridView only if there are images
                      child: Container(
                        margin: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7.0),
                          border: Border.all(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                        ),
                        child: Scrollbar(
                          controller: _scrollController,
                          thumbVisibility: true,
                          thickness: 4.0,
                          child: GridView.builder(
                            controller: _scrollController,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 12 / 16,
                              crossAxisCount: 3,
                              mainAxisSpacing: 4.0,
                            ),
                            padding: const EdgeInsets.all(10.0),
                            itemCount: _imagesNotifier.length,
                            itemBuilder: (context, index) {
                              return Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        _openFullImageDialog(
                                            _imagesNotifier[index]);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                          border: Border.all(
                                            color: Colors.grey,
                                            width: 2.0,
                                          ),
                                        ),
                                        child: Image.file(
                                          _imagesNotifier[index],
                                          fit: BoxFit.cover,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.4,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 10,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () {
                                        _removeImage(index);
                                      },
                                      child: const Icon(
                                        Icons.delete_sweep,
                                        color: Color.fromARGB(255, 202, 43, 32),
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
                    );
                  }),
                  const SizedBox(
                    height: 15,
                  ),
                  Obx(
                    () => dropdownUI(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      context: context,
                      controller: _listController,
                      formLabel: 'List Category',
                      labelText: 'List Category *',
                      hintText: 'Please select list category',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select list category';
                        }
                        return null;
                      },
                      data: listCategory!.value.cast(),
                      onChanged: (int? value) {},
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  textField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _titleController,
                    labelText: 'Title *',
                    hintText: 'Enter title',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select whom to share';
                      }
                      return null;
                    },
                    inputType: TextInputType.text,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  textField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _specController,
                    labelText: 'Specification *',
                    hintText: 'Brand, Modal, Size, etc.',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your specifications';
                      }
                      return null;
                    },
                    inputType: TextInputType.text,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  textField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _purchaseYearController,
                    labelText: 'Purchase Year *',
                    hintText: 'Select date',
                    readOnly: true,
                    onTap: () => datePicker(_purchaseYearController),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your specifications';
                      }
                      return null;
                    },
                    suffixIcon: const Icon(Icons.calendar_month),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  textField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _purchasePriceController,
                    labelText: 'Purchase Price *',
                    hintText: 'Enter purchase price',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your purchase price';
                      }
                      return null;
                    },
                    inputType: TextInputType.number,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Obx(
                    () => dropdownUI(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      context: context,
                      controller: _typeOfSellController,
                      formLabel: 'Type of Sell',
                      labelText: 'Type of Sell *',
                      hintText: 'Please select type of sell',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select type of sell';
                        }
                        return null;
                      },
                      data: typeOfSell!.value.cast(),
                      onChanged: (int? value) {
                        // Update the selected value
                        selectedTypeOfSell.value = value != null
                            ? typeOfSell![value].toString()
                            : null;

                        // Clear the selling price if "Giveaway" is selected
                        if (selectedTypeOfSell.value == 'Giveaway') {
                          _sellingPriceController.clear();
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ValueListenableBuilder<String?>(
                    valueListenable: selectedTypeOfSell,
                    builder: (context, value, _) {
                      // Check if 'Giveaway' is selected or in the text controller
                      final isGiveaway = value == 'Giveaway' ||
                          _typeOfSellController.text == 'Giveaway';

                      return isGiveaway
                          ? const SizedBox
                              .shrink() // Hide if 'Giveaway' is selected
                          : textField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: _sellingPriceController,
                              labelText: 'Selling Price',
                              hintText: 'Enter your price',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your selling price';
                                }
                                return null;
                              },
                              inputType: TextInputType.number,
                            );
                    },
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: negotiableNotifier,
                    builder: (context, checkboxValue, _) {
                      return CheckboxListTile(
                        checkboxShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        value: checkboxValue,
                        onChanged: (bool? value) {
                          negotiableNotifier.value =
                              value ?? false; // Update the ValueNotifier
                        },
                        title: const Text('Negotiable'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10.0),
          child: customElevatedButton(
            text: 'Edit Listing',
            fontSize: 20,
            onPressed: () async {
              final scaffoldMessenger = ScaffoldMessenger.of(context);

              if (!_formKey.currentState!.validate()) {
                return; // Stop further execution if form is invalid
              }

              // if (imageList!.isEmpty) {
              //   Get.snackbar(
              //     "No image selected",
              //     "Please capture or upload an employee image to proceed.",
              //     snackPosition: SnackPosition.TOP,
              //     margin:
              //         const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              //     borderRadius: 10,
              //     backgroundColor: Colors.orange,
              //     colorText: Colors.white,
              //   );
              //   return; // Stop further execution if imageList is empty
              // }

              try {
                BuyAndSellCreationModal? res =
                    await dioServiceClient.submitBuyAndSell(
                  buySellCategory: _listController.text,
                  buySellTitle: _titleController.text,
                  buySellSpecification: _specController.text,
                  buySellYear: _purchaseYearController.text,
                  buySellPurchasePrice: _purchasePriceController.text,
                  buySellSellType: _typeOfSellController.text,
                  buySellCost: _sellingPriceController.text,
                  buySellNegotiate: negotiableNotifier.value ? 1 : 0,
                  imageList: imageList,
                  recordId: widget.buyAndSellId,
                  listOfImageRecordToBeDeleted: listOfExistigImagesRecord,
                );

                scaffoldMessenger.showSnackBar(
                  const SnackBar(
                    content: Text('Successfully edited listed item.'),
                  ),
                );

                if (res!.statuscode == 1) {
                  Get.close(2);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const BuyAndSellList(),
                    ),
                  );
                } else {
                  Get.snackbar(
                    "Oops!",
                    res.statusMessage!,
                    snackPosition: SnackPosition.TOP,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 50),
                    borderRadius: 10,
                    backgroundColor: Colors.redAccent,
                    colorText: Colors.white,
                  );
                }
              } catch (e) {
                Get.snackbar(
                  "Oops!! Failed to list item",
                  e.toString(),
                  snackPosition: SnackPosition.TOP,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                  borderRadius: 10,
                  backgroundColor: Colors.redAccent,
                  colorText: Colors.white,
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Future<void> datePicker(TextEditingController con) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      con.text = DateFormat('dd/MM/yyyy').format(pickedDate);
    }
  }

  Future<bool> onWillPop() async {
    return await showModalBottomSheet<bool>(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Leaving Already?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 221, 213, 213),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        const Text(
                          'Are you sure you want to leave?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              onPressed: () {
                                Get.close(3);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const BuyAndSellList(),
                                  ),
                                );
                              }, // Stay on the page
                              child: const Text(
                                'Yes',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                side: const BorderSide(
                                  color: Colors.grey,
                                  width: 0.5,
                                ),
                              ),
                              onPressed: () =>
                                  Navigator.pop(context), // Leave the page
                              child: const Text(
                                'Keep Posting',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ) ??
        false; // Default to false if the bottom sheet is dismissed
  }

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          title: const Text(
            'Add a photo',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  _pickImage();
                },
                label: const Text(
                  'Take a Photo',
                ),
                icon: const Icon(
                  Icons.camera,
                ),
                iconAlignment: IconAlignment.start,
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  _pickImages(ImageSource.gallery);
                },
                label: const Text(
                  'Choose from Gallery',
                ),
                icon: const Icon(
                  Icons.photo_library,
                ),
                iconAlignment: IconAlignment.start,
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                label: const Text(
                  'Cancel',
                ),
                icon: const Icon(
                  Icons.cancel,
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Future<File?> _compressImage(File file) async {
    final dir = await getTemporaryDirectory();
    final targetPath = '${dir.path}/compressed_${file.uri.pathSegments.last}';

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 80, // Adjust quality as needed
    );

    return result != null ? File(result.path) : null;
  }

  Future<void> _pickImage() async {
    XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      File originalFile = File(pickedImage.path);

      // Compress the image
      File? compressedImage = await _compressImage(originalFile);

      if (compressedImage != null &&
          await compressedImage.length() < 3 * 1024 * 1024) {
        // Add the compressed image to the list
        imageList?.add(XFile(compressedImage.path));

        final updatedImages = List<File>.from(_imagesNotifier.value)
          ..add(compressedImage);
        _imagesNotifier.value = updatedImages;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Image selected and compressed successfully.'),
          ));
        });
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Image is too large, please try again.'),
          ));
        });
      }
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('No image selected from Camera.'),
        ));
      });
    }
  }

  Future<void> _pickImages(ImageSource source) async {
    imageList = await ImagePicker().pickMultiImage();

    if (imageList!.isNotEmpty) {
      final updatedImages = List<File>.from(_imagesNotifier)
        ..addAll(imageList!.map((xFile) => File(xFile.path)));
      _imagesNotifier.value = updatedImages;

      // Call ScaffoldMessenger after async operation completes
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Images selected from Gallery!'),
        ));
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('No images selected from Gallery.'),
        ));
      });
    }
  }

  void _openFullImageDialog(File imageFile) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shadowColor: Colors.blueAccent,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InteractiveViewer(child: Image.file(imageFile)),
                  // Add any buttons or additional widgets below the image if needed
                ],
              ),
              // Positioned close button at the top-right
              Positioned(
                top: 10.0,
                right: 10.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _removeImage(int index) {
    // Remove the image directly from the RxList
    final removedImage = _imagesNotifier[index];
    _imagesNotifier.removeAt(index);

    // Update the actual image list to ensure consistency
    imageList = List<XFile>.from(_imagesNotifier);

    // Show snackbar after removing the image
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Image removed: ${removedImage.path}'),
      ),
    );
  }
}
