import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceRecorder extends StatefulWidget {
  const VoiceRecorder({super.key});

  @override
  VoiceRecorderState createState() => VoiceRecorderState();
}

class VoiceRecorderState extends State<VoiceRecorder> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  bool _isRecording = false;
  String? _currentFilePath;
  Timer? _timer;
  int _recordDuration = 0;
  Directory? _recordingDirectory;
  List<FileSystemEntity> _recordings = [];

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
    _loadRecordings();
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    _player.closePlayer();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _initializeRecorder() async {
    await _recorder.openRecorder();
    await Permission.microphone.request();

    // Set up the directory for recordings
    final dir = await getApplicationDocumentsDirectory();
    _recordingDirectory = Directory('${dir.path}/Recordings');
    if (!(await _recordingDirectory!.exists())) {
      await _recordingDirectory!.create();
    }
  }

  Future<void> _loadRecordings() async {
    if (_recordingDirectory != null) {
      setState(() {
        _recordings = _recordingDirectory!.listSync();
      });
    }
  }


  Future<void> _startRecording() async {
    final fileName = 'recording_${DateTime.now().millisecondsSinceEpoch}.aac';
    _currentFilePath = '${_recordingDirectory!.path}/$fileName';

    await _recorder.startRecorder(
      toFile: _currentFilePath,
      // codec: Codec.aacADTS,
    );
    setState(() {
      _isRecording = true;
      _recordDuration = 0;
    });

    _startTimer();
  }

  Future<void> _stopRecording() async {
    await _recorder.stopRecorder();
    _timer?.cancel();
    setState(() => _isRecording = false);
    _loadRecordings();  // Reload recordings to show the new file
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() => _recordDuration++);
    });
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> _playRecording(String filePath) async {
    await _player.openPlayer();
    await _player.startPlayer(
      fromURI: filePath,
      whenFinished: () => setState(() {}),
    );
  }

  Future<void> _deleteRecording(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
      _loadRecordings();  // Reload recordings after deletion
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Voice Recorder")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Recording controls
            Text(
              _isRecording
                  ? 'Recording... ${_formatDuration(_recordDuration)}'
                  : 'Press to Start Recording',
              style: const TextStyle(fontSize: 18, color: Colors.black),
            ),
            ElevatedButton(
              onPressed: _isRecording ? _stopRecording : _startRecording,
              child: Text(_isRecording ? "Stop Recording" : "Start Recording"),
            ),
            const SizedBox(height: 20),
           // Expanded(child: ListView)

            // List of recordings
            Expanded(
              child: ListView.builder(
                itemCount: _recordings.length,
                itemBuilder: (context, index) {
                  final file = _recordings[index];
                  return ListTile(
                    title: Text(file.path.split('/').last),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.play_arrow),
                          onPressed: () => _playRecording(file.path),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteRecording(file.path),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
