import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';

import '../../Utils/app_styles.dart';


class FaceDetectionScreen extends StatefulWidget {
  const FaceDetectionScreen({super.key});

  @override
  _FaceDetectionScreenState createState() => _FaceDetectionScreenState();
}

class _FaceDetectionScreenState extends State<FaceDetectionScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  late List<Face> _faces;

  Future<void> _pickImage() async {
    _imageFile = await showImagePickerDialog(context);
    _detectFaces(_imageFile!);
  }

  Future<void> _detectFaces(File imageFile) async {
    final File imageFile1 = imageFile;

    final inputImage = InputImage.fromFile(imageFile1);
    //final faceDetector = GoogleMlKit.vision.faceDetector();
    final faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableContours: true,
        enableLandmarks: true,
      ),
    );
   final faces = await faceDetector.processImage(inputImage);

    if (faces.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Face detected!')),
      );
      print('Face detected!');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No face detected.')),
      );
      print('No face detected.');
    }
  }

  @override
  void initState() {
    super.initState();
    _faces = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Face Detection")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pickImage,
              child: Text("Capture Image"),
            ),
            SizedBox(height: 20),
            _imageFile != null ? Image.file(_imageFile!, height: 300) : Text("No image selected"),
            SizedBox(height: 20),
            if (_faces.isNotEmpty) ...[
              Text("Detected faces: ${_faces.length}"),
              for (var face in _faces)
                Text(
                  "Face at: x:${face.boundingBox.left}, y:${face.boundingBox.top}",
                  style: TextStyle(fontSize: 16),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Future<File> showImagePickerDialog(BuildContext context) async {
    File? image;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Choose an option", style: Styles.textBoldLabel),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Capture Image"),
                onTap: () async {
                  image = await takePhoto();

                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Pick from Gallery"),
                onTap: () async {
                  image = await pickImage();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );

    return image!;
  }

  Future<File> pickImage() async {
    final XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    File? selectedDocImage;
    if (pickedFile != null) {
      setState(() {
        selectedDocImage = File(pickedFile.path);
      });
    }
    return selectedDocImage!;
  }

  Future<File?> takePhoto() async {
    final XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    File? imageSelect;
    if (pickedFile != null) {
      setState(() {
        imageSelect = File(pickedFile.path);
      });
    }
    return imageSelect;
  }
}
