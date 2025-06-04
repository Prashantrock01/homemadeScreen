// import 'package:flutter/material.dart';
//
// class SelectIssueLocationPage extends StatelessWidget {
//   final List<String> locations = [
//     "A-402",
//     "B-402",
//     "C-317",
//     "Club House",
//     "Common Area",
//     "Gate",
//     "D-113",
//     "Society Office",
//   ];
//
//   SelectIssueLocationPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // backgroundColor: const Color.fromARGB(255, 254, 197, 63),
//         title: SizedBox(
//           height:
//           kToolbarHeight, // Ensures the Stack takes the full height of the AppBar
//           child: Stack(
//             children: [
//               // Positioned(
//               //   left: -10,
//               //   top: 10,
//               //   bottom: 0,
//               //   child: IconButton(
//               //     icon: const Icon(Icons.arrow_back, color: Colors.white),
//               //     onPressed: () {
//               //       Navigator.pop(context);
//               //     },
//               //   ),
//               // ),
//               const Positioned(
//                 left: 25, // Adjust based on your needs
//                 // Adjust based on your needs
//                 top: 10,
//                 bottom: 0,
//                 child: Align(
//                   alignment: Alignment.center,
//                   child: Text(
//                     'Select Issue Location',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 right: 15,
//                 top: 10,
//                 bottom: 0,
//                 child: IconButton(
//                   icon: const Icon(
//                     Icons.search,
//                     color: Colors.white,
//                     size: 22,
//                   ),
//                   onPressed: () {
//                     // Implement search functionality if needed
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//         centerTitle: false,
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Colors.amber[100]!,
//               Colors.amber[200]!,
//               const Color.fromARGB(255, 255, 255, 255)
//             ],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: ListView.builder(
//           itemCount: locations.length,
//           itemBuilder: (context, index) {
//             return Column(
//               children: [
//                 Container(
//                   color: Colors
//                       .white, // Set background color of list item to white
//                   height: 45, // Manually set the height of each list item
//                   child: ListTile(
//                     contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 30), // Reduces gap on left and right
//                     title: Text(
//                       locations[index],
//                       style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 14,
//                           color: Color.fromARGB(
//                               255, 106, 104, 104) // Reduces the font size
//                       ),
//                     ),
//                     onTap: () {
//                       // Implement navigation or action on item tap
//                     },
//                   ),
//                 ),
//                 const Divider(
//                   height: 1,
//                   color: Color.fromARGB(
//                       255, 255, 236, 67), // Set the divider color to yellow
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
