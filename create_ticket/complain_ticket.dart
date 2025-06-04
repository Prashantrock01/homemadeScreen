// import 'package:flutter/material.dart';
//  // import 'create_help_desk_ticket.dart';
//
// class Complainsandtickets extends StatefulWidget {
//   const Complainsandtickets({super.key});
//
//   @override
//   _ComplaintsAndTicketPageState createState() =>
//       _ComplaintsAndTicketPageState();
// }
//
// class _ComplaintsAndTicketPageState extends State<Complainsandtickets>
//     with SingleTickerProviderStateMixin {
//   TabController? _tabController;
//   String _selectedStatus = 'All'; // Default value
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // backgroundColor: const Color(0xFFF7C51E),
//         title: const Text(
//           'Complaints and Ticket',
//           style: TextStyle(
//               color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
//         ),
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back,
//             color: Colors.white,
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         bottom: TabBar(
//           labelStyle:
//           const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
//           controller: _tabController,
//           unselectedLabelColor: const Color.fromARGB(255, 255, 255, 255),
//           indicatorColor: Colors.red,
//           tabs: const [
//             Tab(text: 'PERSONAL(0)'),
//             // Tab(
//             //   text: 'COMMUNITY(10)',
//             // ),
//           ],
//         ),
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Color(0xFFF7C51E),
//               Color(0xFFF7C51E),
//               Colors.white,
//               Color(0xFFF6CEFF),
//             ],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(right: 40, top: 10),
//               child: Align(
//                 alignment: Alignment.centerRight,
//                 child: DropdownButton<String>(
//                   value: _selectedStatus,
//                   icon: const Icon(Icons.arrow_drop_down),
//                   iconSize: 24,
//                   elevation: 16,
//                   style: const TextStyle(
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 14.0,
//                   ),
//                   underline: Container(
//                     height: 2,
//                     color: Colors.transparent,
//                   ),
//                   onChanged: (String? newValue) {
//                     setState(() {
//                       _selectedStatus = newValue!;
//                     });
//                   },
//                   items: <String>[
//                     'All',
//                     'Open',
//                     'In-progress',
//                     'Resolved',
//                     'Closed',
//                     'On Hold'
//                   ].map<DropdownMenuItem<String>>((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Text(value),
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 50,
//             ),
//             Stack(
//               alignment: Alignment.center,
//               children: [
//                 SizedBox(
//                   width: 300,
//                   height: 200,
//                   child: Image.asset('assets/images/circle44.png', width: 300),
//                 ),
//                 Positioned(
//                   top: -49,
//                   left: 55,
//                   child: Image.asset(
//                     'assets/images/image1-44.png',
//                     width: 185,
//                     height: 195,
//                   ),
//                 ),
//                 Positioned(
//                   top: 40,
//                   left: 79,
//                   child: Image.asset(
//                     'assets/images/image2-44.png',
//                     width: 185,
//                     height: 195,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 40),
//             const Center(
//               child: Text(
//                 "You've not raised any Tickets!",
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 15),
//             const Center(
//               child: Text(
//                 "Look like you didn't raise a complaint yet.",
//                 style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
//               ),
//             ),
//             const SizedBox(height: 15),
//             const Center(
//               child: Text(
//                 "Awesome sauce!",
//                 style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
//               ),
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Navigator.push(
//           //     context, MaterialPageRoute(builder: (context) => CreateTicketPage()));
//         },
//         backgroundColor: Colors.green,
//         shape: const CircleBorder(),
//         child: const Icon(
//           Icons.add,
//           color: Colors.white,
//           size: 40,
//         ),
//       ),
//     );
//   }
// }
