import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class ResidentInAppMessaging extends StatefulWidget {
  final String residentName;

  const ResidentInAppMessaging({required this.residentName, super.key});

  @override
  State<ResidentInAppMessaging> createState() => _ResidentInAppMessagingState();
}

class _ResidentInAppMessagingState extends State<ResidentInAppMessaging> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final ImagePicker _picker = ImagePicker();

  void _sendMessage({required String text, File? file, Position? location}) {
    if (text.isNotEmpty || file != null || location != null) {
      setState(() {
        _messages.insert(0, {
          'text': text,
          'file': file,
          'location': location,
          'timestamp': DateTime.now(),
          'sent': true,
        });
        _messageController.clear();
      });
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _sendMessage(text: '', file: File(image.path));
    }
  }

  Future<void> _pickVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      _sendMessage(text: '', file: File(video.path));
    }
  }

  // Future<void> _getLocation() async {
  //   Position position = await Geolocator.getCurrentPosition(
  //     desiredAccuracy: LocationAccuracy.high,
  //   );
  //   _sendMessage(text: 'Location shared', location: position);
  // }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 1) {
      return '${timestamp.month}/${timestamp.day}/${timestamp.year}';
    } else if (difference.inHours > 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 1) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.residentName),
        actions: [
          IconButton(
            icon: const Icon(Icons.image),
            onPressed: _pickImage,
          ),
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: _pickVideo,
          ),
          // IconButton(
          //   icon: const Icon(Icons.location_on),
          //   onPressed: _getLocation,
          // ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isSent = message['sent'] as bool;
                  final messageText = message['text'] as String;
                  final file = message['file'] as File?;
                  //final location = message['location'] as Position?;
                  final timestamp = message['timestamp'] as DateTime;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    child: Align(
                      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          if (file != null) ...[
                            if (file.path.endsWith('.jpg') || file.path.endsWith('.png')) ...[
                              Container(
                                margin: const EdgeInsets.only(bottom: 4.0),
                                child: Image.file(
                                  file,
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                            if (file.path.endsWith('.mp4')) ...[
                              Container(
                                margin: const EdgeInsets.only(bottom: 4.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.videocam, color: Colors.grey, size: 40),
                                    const SizedBox(height: 4),
                                    Text('Video: ${file.uri.pathSegments.last}', style: const TextStyle(color: Colors.grey)),
                                  ],
                                ),
                              ),
                            ],
                          ],
                          // if (location != null) ...[
                          //   Container(
                          //     margin: const EdgeInsets.only(bottom: 4.0),
                          //     child: Column(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: [
                          //         const Icon(Icons.location_on, color: Colors.grey, size: 40),
                          //         const SizedBox(height: 4),
                          //         Text('Location: ${location.latitude}, ${location.longitude}'),
                          //       ],
                          //     ),
                          //   ),
                          // ],
                          if (messageText.isNotEmpty) ...[
                            Container(
                              decoration: BoxDecoration(
                                color: isSent ? const Color(0xffF7C51E) : Colors.grey[300],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                              child: Text(
                                messageText,
                                style: TextStyle(
                                  color: isSent ? Colors.white : Colors.black87,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                          ],
                          Text(
                            _formatTimestamp(timestamp),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send, color: Color(0xffF7C51E)),
                    onPressed: () {
                      if (_messageController.text.isNotEmpty) {
                        _sendMessage(text: _messageController.text);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
