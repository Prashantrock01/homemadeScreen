import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../newservices.dart';
import 'gate_pass.dart';
// import 'gate_pass.dart';

class MyServicesScreen extends StatefulWidget {
  final String flatNumber; // Add flat number as a parameter

  MyServicesScreen({required this.flatNumber}); // Update constructor

  @override
  _MyServicesScreenState createState() => _MyServicesScreenState();
}

class _MyServicesScreenState extends State<MyServicesScreen> {
  // List to manage cards
  List<bool> _cardVisibility = [true, true, true, true, true]; // Added a second card

  void _deleteCard(int index) {
    setState(() {
      _cardVisibility[index] = false;
    });
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  void _shareContent(String text) {
    Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Services'),
        // backgroundColor: Colors.yellow[600],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        // decoration: const BoxDecoration(
        //   gradient: LinearGradient(
        //     colors: [Color.fromARGB(255, 247, 223, 147), Color(0xFFFFFFFF)],
        //     begin: Alignment.topCenter,
        //     end: Alignment.bottomCenter,
        //   ),
        // ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [

              // Display cards
              Expanded(
                child: ListView.builder(
                  itemCount: _cardVisibility.length,
                  itemBuilder: (context, index) {
                    if (!_cardVisibility[index]) return const SizedBox.shrink(); // Skip invisible cards

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0), // Adjust bottom padding
                      child: Card(
                        elevation: 5, // Adds shadow to the card
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const CircleAvatar(
                                        backgroundImage: AssetImage('assets/images/maid28.png'), // Replace with your image asset
                                        radius: 40,
                                      ),
                                      const SizedBox(width: 12),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Mena',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius: BorderRadius.circular(12.0), // Adjust the radius as needed
                                                  ),
                                                  child: const SizedBox(
                                                    height: 25,
                                                    width: 60,
                                                    child: Center(
                                                      child: Text(
                                                        'Maid',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                const Expanded(
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.star, color: Colors.amber, size: 16),
                                                      Icon(Icons.star, color: Colors.amber, size: 16),
                                                      Icon(Icons.star, color: Colors.amber, size: 16),
                                                      Icon(Icons.star, color: Colors.amber, size: 16),
                                                      Icon(Icons.star_border, color: Colors.amber, size: 16),
                                                      SizedBox(width: 4),
                                                      Text('(7 flats)', style: TextStyle(fontSize: 12)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Row(
                                              children: [
                                                Text('01:35 PM - 01:58 PM'),
                                                SizedBox(width: 8),
                                                Text('+1 more'),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Icon(Icons.home),
                                                Text(' ${widget.flatNumber}'), // Display the flat number
                                                const SizedBox(width: 8),
                                                const Text('6 more flats'),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextButton.icon(
                                        onPressed: () {
                                          // Navigator.push(context, MaterialPageRoute(builder:  (context) => GatePass()),
                                          // );
                                          Get.to(()=>const GatePass());
                                        },
                                        icon: const Icon(Icons.lock, color: Colors.green),
                                        label: const Text('Gate Pass', style: TextStyle(color: Colors.green)),
                                      ),
                                      TextButton.icon(
                                        onPressed: () => _makePhoneCall('9955562769'), // Replace with the actual phone number
                                        icon: const Icon(Icons.call, color: Colors.blue),
                                        label: const Text('Call', style: TextStyle(color: Colors.blue)),
                                      ),
                                      TextButton.icon(
                                        onPressed: () => _shareContent('Check out Mena, our maid at A-101. She is highly recommended!'),
                                        icon: const Icon(Icons.share, color: Colors.yellow),
                                        label: const Text('Share', style: TextStyle(color: Colors.yellow)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: -2,
                              right: 8,
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.notifications, color: Colors.grey[600]),
                                    onPressed: () {
                                      // Add your bell icon functionality here
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _deleteCard(index),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6FDE89),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  minimumSize: const Size(150, 40), // Adjust the width as needed
                  padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 40.0), // Adjust padding to control width
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Newservices()),
                  );
                },
                child: const Text(
                  '+ Add a New Daily Help',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
