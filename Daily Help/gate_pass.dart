import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GatePass extends StatefulWidget {
  const GatePass({super.key});

  @override
  _GatePassState createState() => _GatePassState();
}

class _GatePassState extends State<GatePass> {
  List<File> _images = [];
  FlutterSoundRecorder? _recorder;
  bool _isRecording = false;
  String? _recordingFilePath;
  Timer? _timer;
  Duration _recordingDuration = Duration.zero;
  List<String> _selectedItems = [];

  @override
  void initState() {
    super.initState();
    _recorder = FlutterSoundRecorder();
    _openRecorder();
    _loadSelectedItems();  // Load previously selected items from local storage
    _loadRecordingFilePath(); // Load previously saved recording file path
  }

  @override
  void dispose() {
    _recorder?.closeRecorder();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _openRecorder() async {
    await _recorder?.openRecorder();
  }

  Future<void> _startRecording() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.aac';
    setState(() {
      _recordingFilePath = path;
      _isRecording = true;
      _recordingDuration = Duration.zero;
    });
    await _recorder?.startRecorder(toFile: path);

    _startTimer();
  }

  Future<void> _stopRecording() async {
    await _recorder?.stopRecorder();
    setState(() {
      _isRecording = false;
    });
    _timer?.cancel();

    // Save the recording file path to local storage
    if (_recordingFilePath != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('recordingFilePath', _recordingFilePath!);
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordingDuration = _recordingDuration + const Duration(seconds: 1);
      });
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Future<void> _loadSelectedItems() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedItems = prefs.getStringList('selectedItems') ?? [];
    });
  }

  Future<void> _toggleItemSelection(String item) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_selectedItems.contains(item)) {
        _selectedItems.remove(item);
      } else {
        _selectedItems.add(item);
      }
    });
    await prefs.setStringList('selectedItems', _selectedItems);
  }

  Future<void> _loadRecordingFilePath() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _recordingFilePath = prefs.getString('recordingFilePath');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF7C51E), Color(0xFFFFFFFF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20), // Add space from the top
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Gate Pass',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 247, 223, 147),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage('assets/images/maid28.png'),
                        radius: 30,
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Shaha',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 2.0,
                              horizontal: 8.0,
                            ),
                            child: const Text(
                              'Guest',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "I have Given...",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: [
                          _buildTextButton('Cash', Colors.white.withOpacity(0.5)),
                          _buildTextButton('Food', Colors.white.withOpacity(0.5)),
                          _buildTextButton('Clothes', Colors.white.withOpacity(0.5)),
                          _buildTextButton('Parcel', Colors.white.withOpacity(0.5)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextField(
                      maxLines: 5,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Other Optional',
                        hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 35, // Reduced height
                              child: CustomButton(
                                icon: Icons.camera_alt,
                                text: 'Add Photo',
                                width: double.infinity,
                                borderRadius: 4.0,
                                color: const Color(0xFFF7C51E),
                                onPressed: () {
                                  _showImagePickerOptions(context);
                                },
                                textSize: 10.0,
                                height: 2, // Reduced text size
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: SizedBox(
                              height: 35, // Reduced height
                              child: CustomButton(
                                icon: _isRecording ? Icons.stop : Icons.mic,
                                text: _isRecording ? 'Stop Recording' : 'Add Voice',
                                width: double.infinity,
                                borderRadius: 4.0,
                                color: _isRecording ? Colors.red : const Color(0xFFF7C51E),
                                onPressed: _isRecording ? _stopRecording : _startRecording,
                                textSize: 10.0,
                                height: 2, // Reduced text size
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (_recordingFilePath != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            'Recording saved at: $_recordingFilePath',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                if (_isRecording) _buildRecordingIndicator(),
                if (_images.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _images.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Image.file(
                                _images[index],
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                top: 5,
                                right: 5,
                                child: GestureDetector(
                                  onTap: () => _removeImage(index),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextButton(String text, Color color) {
    final isSelected = _selectedItems.contains(text);
    return GestureDetector(
      onTap: () => _toggleItemSelection(text),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF7C51E) : color,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRecordingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.fiber_manual_record, color: Colors.red),
          const SizedBox(width: 8),
          Text(
            _formatDuration(_recordingDuration),
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}

class CustomButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final double width;
  final double borderRadius;
  final Color color;
  final VoidCallback onPressed;
  final double textSize;
  final double height;

  const CustomButton({
    required this.icon,
    required this.text,
    required this.width,
    required this.borderRadius,
    required this.color,
    required this.onPressed,
    required this.textSize,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height * 20, // Adjust the height based on text size
      child: ElevatedButton.icon(
        icon: Icon(icon, size: textSize * 1.8), // Adjust icon size based on text size
        label: Text(
          text,
          style: TextStyle(fontSize: textSize),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

