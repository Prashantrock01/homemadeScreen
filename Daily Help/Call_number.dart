// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class CallNumber extends StatelessWidget {
//   const CallNumber({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         // appBar: AppBar(
//         //   title: Text('Phone Call Example'),
//         // ),
//         body: Center(
//           child: CallButton(),
//         ),
//       ),
//     );
//   }
// }
//
// class CallButton extends StatelessWidget {
//   void _makePhoneCall(String phoneNumber) async {
//     final Uri launchUri = Uri(
//       scheme: 'tel',
//       path: phoneNumber,
//     );
//     await launchUrl(launchUri);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: () => _makePhoneCall('1234567890'), // Replace with your desired number
//       child: Text('Make a Call'),
//     );
//    }



// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class CallNumber extends StatelessWidget {
//  const CallNumber({super.key});
//
//  @override
//  Widget build(BuildContext context) {
//   return MaterialApp(
//    home: Scaffold(
//     body: Center(
//      child: CallButton(),
//     ),
//    ),
//   );
//  }
// }
//
// class CallButton extends StatelessWidget {
//  void _makePhoneCall(String phoneNumber) async {
//   final Uri launchUri = Uri(
//    scheme: 'tel',
//    path: phoneNumber,
//   );
//   await launchUrl(launchUri);
//  }
//
//  @override
//  Widget build(BuildContext context) {
//   return GestureDetector(
//    onTap: () => _makePhoneCall('1234567890'), // Replace with your desired number
//    //child: Image.asset('assets/call_icon.png'),
//   );
//  }
// }
//
// void main() {
//  runApp(const CallNumber());
// }

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CallNumber extends StatelessWidget {
 const CallNumber({super.key});

 @override
 Widget build(BuildContext context) {
  return MaterialApp(
   home: Scaffold(
    body: Center(
     child: CallButton(),
    ),
   ),
  );
 }
}

class CallButton extends StatelessWidget {
 void _makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(
   scheme: 'tel',
   path: phoneNumber,
  );
  if (await canLaunchUrl(launchUri)) {
   await launchUrl(launchUri);
  } else {
   throw 'Could not launch $launchUri';
  }
 }

 @override
 Widget build(BuildContext context) {
  return GestureDetector(
   onTap: () => _makePhoneCall('1234567890'), // Replace with your desired number
   //child: Image.asset('assets/call_icon.png'),
  );
 }
}

void main() {
 runApp(const CallNumber());
}




//
//
// }
//
//
//
//
//
//
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// //
// // class MyServicesScreen extends StatefulWidget {
// //   @override
// //   _MyServicesScreenState createState() => _MyServicesScreenState();
// // }
// //
// // class _MyServicesScreenState extends State<MyServicesScreen> {
// //   // List to manage cards
// //   List<bool> _cardVisibility = [true, true]; // Added a second card
// //
// //   void _deleteCard(int index) {
// //     setState(() {
// //       _cardVisibility[index] = false;
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('My Services'),
// //         backgroundColor: Colors.yellow[600],
// //         leading: IconButton(
// //           icon: Icon(Icons.arrow_back),
// //           onPressed: () {
// //           },
// //         ),
// //       ),
// //       body: Container(
// //         decoration: const BoxDecoration(
// //           gradient: LinearGradient(
// //             colors: [Color.fromARGB(255, 247, 223, 147), Color(0xFFFFFFFF)],
// //             begin: Alignment.topCenter,
// //             end: Alignment.bottomCenter,
// //           ),
// //         ),
// //         child: Padding(
// //           padding: const EdgeInsets.all(16.0),
// //           child: Column(
// //             children: [
// //               // Display cards
// //               Expanded(
// //                 child: ListView.builder(
// //                   itemCount: _cardVisibility.length,
// //                   itemBuilder: (context, index) {
// //                     if (!_cardVisibility[index]) return SizedBox.shrink(); // Skip invisible cards
// //
// //                     return Card(
// //                       elevation: 2, // Adds shadow to the card
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(5.0),
// //                       ),
// //                       child: Stack(
// //                         children: [
// //                           Padding(
// //                             padding: const EdgeInsets.all(8.0),
// //                             child: Column(
// //                               crossAxisAlignment: CrossAxisAlignment.start,
// //                               children: [
// //                                 Row(
// //                                   children: [
// //                                     CircleAvatar(
// //                                       backgroundImage: AssetImage('assets/images/maid28.png'), // Replace with your image asset
// //                                       radius: 40,
// //                                     ),
// //                                     SizedBox(width: 16),
// //                                     Column(
// //                                       crossAxisAlignment: CrossAxisAlignment.start,
// //                                       children: [
// //                                         Text(
// //                                           'Mena',
// //                                           style: TextStyle(
// //                                             fontSize: 16,
// //                                             fontWeight: FontWeight.bold,
// //                                           ),
// //                                         ),
// //                                         Row(
// //                                           children: [
// //                                             Container(
// //                                               decoration: BoxDecoration(
// //                                                 color: Colors.red,
// //                                                 borderRadius: BorderRadius.circular(5.0), // Adjust the radius as needed
// //                                               ),
// //                                               child: SizedBox(
// //                                                 height: 20,
// //                                                 width: 40,
// //                                                 child: Center(
// //                                                   child: Text(
// //                                                     'Maid',
// //                                                     style: TextStyle(
// //                                                       color: Colors.white,
// //                                                       fontWeight: FontWeight.bold,
// //                                                     ),
// //                                                   ),
// //                                                 ),
// //                                               ),
// //                                             ),
// //                                             SizedBox(width: 8),
// //                                             Row(
// //                                               children: [
// //                                                 Icon(Icons.star, color: Colors.amber, size: 16),
// //                                                 Icon(Icons.star, color: Colors.amber, size: 16),
// //                                                 Icon(Icons.star, color: Colors.amber, size: 16),
// //                                                 Icon(Icons.star, color: Colors.amber, size: 16),
// //                                                 Icon(Icons.star_border, color: Colors.amber, size: 16),
// //                                                 SizedBox(width: 4),
// //                                                 Text('(7 flats)', style: TextStyle(fontSize: 12)),
// //                                               ],
// //                                             ),
// //                                           ],
// //                                         ),
// //                                         Row(
// //                                           children: [
// //                                             Text('01:35 PM - 01:58 PM'),
// //                                             SizedBox(width: 8),
// //                                             Text('+1 more'),
// //                                           ],
// //                                         ),
// //                                         Row(
// //                                           children: [
// //                                             Icon(Icons.home),
// //                                             Text(' A-101'),
// //                                             SizedBox(width: 8),
// //                                             Text('6 more flats'),
// //                                           ],
// //                                         ),
// //                                       ],
// //                                     ),
// //                                   ],
// //                                 ),
// //                                 SizedBox(height: 25),
// //                                 Row(
// //                                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                                   children: [
// //                                     TextButton.icon(
// //                                       onPressed: () {},
// //                                       icon: Icon(Icons.lock, color: Colors.white),
// //                                       label: Text('Gate Pass', style: TextStyle(color: Colors.white)),
// //                                     ),
// //                                     TextButton.icon(
// //                                       onPressed: () {},
// //                                       icon: Icon(Icons.call, color: Colors.white),
// //                                       label: Text('Call', style: TextStyle(color: Colors.white)),
// //                                     ),
// //                                     TextButton.icon(
// //                                       onPressed: () {},
// //                                       icon: Icon(Icons.share, color: Colors.white),
// //                                       label: Text('Share', style: TextStyle(color: Colors.white)),
// //                                     ),
// //                                   ],
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                           Positioned(
// //                             top: -5,
// //                             right: 10,
// //                             child: Row(
// //                               children: [
// //                                 IconButton(
// //                                   icon: Icon(Icons.notifications, color: Colors.grey[600]),
// //                                   onPressed: () {
// //                                     // Add your bell icon functionality here
// //                                   },
// //                                 ),
// //                                 IconButton(
// //                                   icon: Icon(Icons.delete, color: Colors.red),
// //                                 //  onPressed: () => _deleteCard(index),
// //                                   onPressed: (){
// //
// //                                   },
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     );
// //                   },
// //                 ),
// //               ),
// //               SizedBox(height: 20),
// //               ElevatedButton(
// //                 style: ElevatedButton.styleFrom(
// //                   backgroundColor: const Color(0xFF6FDE89),
// //                   shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(0),
// //                   ),
// //                   minimumSize: const Size(150, 30), // Adjust the width as needed
// //                   padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 40.0), // Adjust padding to control width
// //                 ),
// //                 onPressed: () {
// //                   Navigator.push(
// //                     context,
// //                     MaterialPageRoute(builder: (context) => MyServicesScreen()),
// //                   );
// //                 },
// //                 child: const Text(
// //                   '+ Add a New Daily Help',
// //                   style: TextStyle(color: Colors.white, fontSize: 18),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
//
//
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../my_services.dart';
//
// class CallNumber extends StatefulWidget {
//   @override
//   _CallNumberState createState() => _CallNumberState();
// }
//
// class _CallNumberState extends State<CallNumber> {
//   List<bool> _cardVisibility = [true, true]; // Added a second card
//
//   void _deleteCard(int index) {
//     setState(() {
//       _cardVisibility[index] = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My Services'),
//         backgroundColor: Colors.yellow[600],
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             // Add your back button functionality here
//           },
//         ),
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color.fromARGB(255, 247, 223, 147), Color(0xFFFFFFFF)],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               // Display cards
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: _cardVisibility.length,
//                   itemBuilder: (context, index) {
//                     if (!_cardVisibility[index]) return SizedBox.shrink(); // Skip invisible cards
//
//                     return Card(
//                       elevation: 2, // Adds shadow to the card
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12.0),
//                       ),
//                       child: Stack(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(12.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   children: [
//                                     CircleAvatar(
//                                       backgroundImage: AssetImage('assets/images/maid28.png'), // Replace with your image asset
//                                       radius: 40,
//                                     ),
//                                     SizedBox(width: 16),
//                                     Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           'Mena',
//                                           style: TextStyle(
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                         Row(
//                                           children: [
//                                             Container(
//                                               decoration: BoxDecoration(
//                                                 color: Colors.red,
//                                                 borderRadius: BorderRadius.circular(12.0), // Adjust the radius as needed
//                                               ),
//                                               child: SizedBox(
//                                                 height: 20,
//                                                 width: 40,
//                                                 child: Center(
//                                                   child: Text(
//                                                     'Maid',
//                                                     style: TextStyle(
//                                                       color: Colors.white,
//                                                       fontWeight: FontWeight.bold,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             SizedBox(width: 10),
//                                             Row(
//                                               children: [
//                                                 Icon(Icons.star, color: Colors.amber, size: 16),
//                                                 Icon(Icons.star, color: Colors.amber, size: 16),
//                                                 Icon(Icons.star, color: Colors.amber, size: 16),
//                                                 Icon(Icons.star, color: Colors.amber, size: 16),
//                                                 Icon(Icons.star_border, color: Colors.amber, size: 16),
//                                                 SizedBox(width: 4),
//                                                 Text('(7 flats)', style: TextStyle(fontSize: 12)),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                         Row(
//                                           children: [
//                                             Text('01:35 PM - 01:58 PM'),
//                                             SizedBox(width: 10),
//                                             Text('+1 more'),
//                                           ],
//                                         ),
//                                         Row(
//                                           children: [
//                                             Icon(Icons.home),
//                                             Text(' A-101'),
//                                             SizedBox(width: 10),
//                                             Text('6 more flats'),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(height: 25),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                   children: [
//                                     Flexible(
//                                       child: TextButton.icon(
//                                         onPressed: () {},
//                                         icon: Icon(Icons.lock, color: Colors.white),
//                                         label: Text('Gate Pass', style: TextStyle(color: Colors.white)),
//                                       ),
//                                     ),
//                                     Flexible(
//                                       child: TextButton.icon(
//                                         onPressed: () {
//                                         },
//                                         icon: Icon(Icons.call, color: Colors.white),
//                                         label: Text('Call', style: TextStyle(color: Colors.white)),
//                                       ),
//                                     ),
//                                     Flexible(
//                                       child: TextButton.icon(
//                                         onPressed: () {},
//                                         icon: Icon(Icons.share, color: Colors.white),
//                                         label: Text('Share', style: TextStyle(color: Colors.white)),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Positioned(
//                             top: -5,
//                             right: 10,
//                             child: Row(
//                               children: [
//                                 IconButton(
//                                   icon: Icon(Icons.notifications, color: Colors.grey[600]),
//                                   onPressed: () {
//                                     // Add your bell icon functionality here
//                                   },
//                                 ),
//                                 IconButton(
//                                   icon: Icon(Icons.delete, color: Colors.red),
//                                   //  onPressed: () => _deleteCard(index),
//                                   onPressed: () {
//                                     // Add your delete functionality here
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF6FDE89),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(0),
//                   ),
//                   minimumSize: const Size(200, 50), // Adjust the width as needed
//                   padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 40.0), // Adjust padding to control width
//                 ),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => MyServicesScreen()),
//                   );
//                 },
//                 child: const Text(
//                   '+ Add a New Daily Help',
//                   style: TextStyle(color: Colors.white, fontSize: 18),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
