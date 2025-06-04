import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class DiscussionNewPost extends StatefulWidget {
  const DiscussionNewPost({super.key});

  @override
  State<DiscussionNewPost> createState() => _DiscussionNewPostState();
}

class _DiscussionNewPostState extends State<DiscussionNewPost> {
  // Controller for add discussion
  final _dicussController = TextEditingController();
  // Controller for adding comments
  final _addCommentController = TextEditingController();

  //Value Notifier for images
  final RxList<File> _imagesNotifier = <File>[].obs;

  // Images Scroll Controller
  final _scrollController = ScrollController();

  // Checkboxes
  final ValueNotifier<bool> _allResidents = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _owner = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _residingOwner = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _tenant = ValueNotifier<bool>(false);

  //Default selection for sharing
  String _selectedOptions = "Select";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text(
          'Discussion',
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              ListTile(
                leading: const CircleAvatar(
                  child: Text('P'),
                ),
                title: const Text('Priya'),
                subtitle: const Text(
                  'COMMON AREA Manager Office',
                  style:
                      TextStyle(fontSize: 10, overflow: TextOverflow.visible),
                ),
                contentPadding: const EdgeInsets.all(10.0),
                trailing: TextButton.icon(
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: context,
                      showDragHandle: true,
                      builder: (BuildContext context) {
                        return SizedBox(
                          height: 250,
                          width: 400,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text(
                                    'Select with whom to share',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                _buildCheckboxListTile(
                                    'All Residents', _allResidents),
                                _buildCheckboxListTile('Owner', _owner),
                                _buildCheckboxListTile(
                                    'Residing Owner', _residingOwner),
                                _buildCheckboxListTile('Tenant', _tenant),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    onPressed: () {
                                      _updateSelectedOptions();
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'Done',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  label: Text(
                    _selectedOptions,
                    style: const TextStyle(
                        fontSize: 12, overflow: TextOverflow.clip),
                  ),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  iconAlignment: IconAlignment.end,
                ),
              ),
              //Textfield for discussion
              Container(
                margin: const EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: _dicussController,
                  minLines: 1,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: 'What do you want to talk about?',
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
              // To show uploaded attachemnets of images
              Obx(() {
                return Visibility(
                  visible: _imagesNotifier.isNotEmpty,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.4,
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
                                      borderRadius: BorderRadius.circular(4.0),
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 2.0,
                                      ),
                                    ),
                                    child: Image.file(
                                      _imagesNotifier[index],
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      height:
                                          MediaQuery.of(context).size.height *
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
            ],
          ),
        ),
      ),
      // To adding comments
      bottomNavigationBar: Transform.translate(
        offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
        child: BottomAppBar(
          height: 60,
          elevation: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _addCommentController,
                    decoration: const InputDecoration(
                      hintText: 'Add your comment....',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: _showAlertDialog,
                icon: const Icon(Icons.attachment),
              ),
              IconButton(
                onPressed: () {
                  // Handle send action
                },
                icon: const Icon(
                  Icons.send,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  
  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
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
                  _pickImage(ImageSource.camera);
                },
                label: const Text(
                  'Take a Photo',
                  style: TextStyle(color: Colors.black),
                ),
                icon: const Icon(
                  Icons.camera,
                  color: Colors.amber,
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
                  style: TextStyle(color: Colors.black),
                ),
                icon: const Icon(
                  Icons.photo_library,
                  color: Colors.amber,
                ),
                iconAlignment: IconAlignment.start,
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                label: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.black),
                ),
                icon: const Icon(
                  Icons.cancel,
                  color: Colors.amber,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    XFile? image = await ImagePicker().pickImage(source: source);

    if (image != null) {
      final updatedImages = List<File>.from(_imagesNotifier)
        ..add(File(image.path));
      _imagesNotifier.value = updatedImages;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Image selected from Camera!'),
          backgroundColor: Colors.amber,
        ));
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('No image selected from Camera.'),
          backgroundColor: Colors.amber,
        ));
      });
    }
  }

  Future<void> _pickImages(ImageSource source) async {
    List<XFile>? xImages = await ImagePicker().pickMultiImage();

    if (xImages.isNotEmpty) {
      final updatedImages = List<File>.from(_imagesNotifier)
        ..addAll(xImages.map((xFile) => File(xFile.path)));
      _imagesNotifier.value = updatedImages;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Images selected from Gallery!'),
          backgroundColor: Colors.amber,
        ));
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('No images selected from Gallery.'),
          backgroundColor: Colors.amber,
        ));
      });
    }
  }

  void _removeImage(int index) {
    final updatedImages = List<File>.from(_imagesNotifier);
    final removedImage = updatedImages[index];
    updatedImages.removeAt(index);
    _imagesNotifier.value = updatedImages;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Image removed: ${removedImage.path}'),
      backgroundColor: Colors.amber,
    ));
  }

  // Future<void> _downloadImages(File imageFile) async {
  //   try {
  //     final galleryPath = await GallerySaver.saveImage(imageFile.path);

  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: Text('Image downloaded to $galleryPath'),
  //         backgroundColor: Colors.amber,
  //       ));
  //     });
  //   } catch (e) {
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text('Failed to download image.'),
  //         backgroundColor: Colors.amber,
  //       ));
  //     });
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //   }
  // }

  void _openFullImageDialog(File imageFile) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shadowColor: Colors.blueAccent,
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(40.0)),
          backgroundColor: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InteractiveViewer(child: Image.file(imageFile)),
              // ElevatedButton(
              //   onPressed: () {
              //     _downloadImages(imageFile);
              //   },
              //   child: const Text("Download Image"),
              // ),
            ],
          ),
        );
      },
    );
  }

  void _deselectAll() {
    _allResidents.value = false;
    _owner.value = false;
    _residingOwner.value = false;
    _tenant.value = false;
  }

  void _updateSelectedOptions() {
    String selectedOption = "None Selected";

    if (_allResidents.value) {
      selectedOption = "All Residents";
    } else if (_owner.value) {
      selectedOption = "Owner";
    } else if (_residingOwner.value) {
      selectedOption = "Residing Owner";
    } else if (_tenant.value) {
      selectedOption = "Tenant";
    }

    setState(() {
      _selectedOptions = selectedOption;
    });
  }

  Widget _buildCheckboxListTile(String title, ValueNotifier<bool> notifier) {
    return ValueListenableBuilder(
      valueListenable: notifier,
      builder: (context, checkboxValue, _) {
        return CheckboxListTile(
          title: Text(title),
          activeColor: Colors.amber,
          onChanged: (bool? value) {
            if (value != null && value) {
              _deselectAll();
              notifier.value = true;
            }
          },
          value: checkboxValue,
        );
      },
    );
  }
}
