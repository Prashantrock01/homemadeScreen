import 'package:flutter/material.dart';

class ResidentInAppCalling extends StatefulWidget {
  final String residentName;
  const ResidentInAppCalling({required this.residentName, super.key});

  @override
  State<ResidentInAppCalling> createState() => _ResidentInAppCallingState();
}

class _ResidentInAppCallingState extends State<ResidentInAppCalling> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.residentName),
       backgroundColor: Colors.transparent,
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.phone, size: 100, color: Colors.green),
            const SizedBox(height: 20),
            Text('Calling ${widget.residentName}...',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('End Call'),
            ),
          ],
        ),
      ),
    );
  }
}
