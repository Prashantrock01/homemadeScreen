// import 'package:biz_infra/Screens/amenities/amenities_booking_payment.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../CustomWidgets/configurable_widgets.dart';
//
// class SocietyBooking extends StatefulWidget {
//   const SocietyBooking({super.key});
//
//   @override
//   State<SocietyBooking> createState() => _SocietyBookingState();
// }
//
// class _SocietyBookingState extends State<SocietyBooking> {
//   final GlobalKey _globalKey = GlobalKey();
//   int _selectedValue = -1;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text("Society Booking"),
//             const Spacer(),
//             InkWell(
//                 onTap: (){
//
//                 },
//                 child: IconButton(
//                   onPressed: (){},
//                     icon: const Icon(Icons.download))),
//             const SizedBox(width: 5,),
//             IconButton(
//               onPressed:(){},
//               //_captureAndSharePdf,
//                 icon: const Icon(Icons.share)),
//           ],
//         ),
//       ),
//       body: RepaintBoundary(
//         key: _globalKey,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             // The main scrollable content
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.all(15.0),
//                   child: Column(
//                     children: [
//                       bookingDetails(name: "Party Hall", cost: "10,000.00"),
//                       const SizedBox(height: 10),
//                       const Divider(),
//                       const SizedBox(height: 10),
//                       bookingDetails(name: "CGST @9% ON Party Hall", cost: "900.00"),
//                       const SizedBox(height: 10),
//                       const Divider(),
//                       const SizedBox(height: 10),
//                       bookingDetails(name: "SGST @9% ON Party Hall", cost: "900.00"),
//                       const SizedBox(height: 10),
//                       const Divider(),
//                       const SizedBox(height: 10),
//                       bookingDetails(name: "Total CGST", cost: "900.00"),
//                       const SizedBox(height: 10),
//                       const Divider(),
//                       const SizedBox(height: 10),
//                       bookingDetails(name: "Total SGST", cost: "900.00"),
//                       const SizedBox(height: 10),
//                       const Divider(),
//                       const SizedBox(height: 10),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//
//             const Divider(),
//
//             Padding(
//               padding: const EdgeInsets.only(bottom: 20.0),
//               child: Padding(
//                 padding: const EdgeInsets.all(15.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     textButton(
//                       onPressed: () {},
//                       widget: const Text(
//                         "Already Paid",
//                         style: TextStyle(
//                             fontFamily: 'Poppins',
//                             fontWeight: FontWeight.w600,
//                             fontSize: 16),
//                       ),
//                     ),
//                     textButton(
//                       onPressed: () {
//                         showModalBottomSheet<void>(
//                           context: context,
//                           builder: (BuildContext context) {
//                             return StatefulBuilder(
//                               builder: (BuildContext context, StateSetter setState) {
//                                 return Padding(
//                                   padding: const EdgeInsets.all(15.0),
//                                   child: SizedBox(
//                                     height: MediaQuery.of(context).size.height/4.5,
//                                     child: Column(
//                                       children: [
//                                         Row(
//                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             const Text("Amount to Pay", style: TextStyle(fontWeight: FontWeight.w600),),
//                                             InkWell(
//                                               onTap: () {
//                                                 Get.close(0);
//                                               },
//                                               child: const Icon(Icons.close),
//                                             ),
//                                           ],
//                                         ),
//
//                                         RadioListTile(
//                                           title: const Text('Total Amount ₹.11,800'),
//                                           value: 1,
//                                           groupValue:
//                                           _selectedValue,
//                                           onChanged: (value) {
//                                             setState(() {
//                                               _selectedValue = value!;
//                                             });
//                                           },
//                                         ),
//
//                                         const Divider(),
//
//                                         // RadioListTile(
//                                         //   title: const Text('Other Amount'),
//                                         //   value: 2,
//                                         //   groupValue:
//                                         //   _selectedValue,
//                                         //   onChanged: (value) {
//                                         //     setState(() {
//                                         //       _selectedValue = value!;
//                                         //     });
//                                         //   },
//                                         // ),
//
//                                         const SizedBox(height: 30),
//
//                                         textButton(
//                                             onPressed: (){
//                                                 showDialog(
//                                                   context: context,
//                                                   builder: (BuildContext context) {
//                                                     return const PaymentStatus();
//                                                   },
//                                                 );
//                                             },
//                                             widget: const Text("Continue", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),))
//
//
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               },
//                             );
//                           },
//                         );
//                       },
//                       widget: const Text(
//                         "Pay ₹.11,800",
//                         style: TextStyle(
//                             fontFamily: 'Poppins',
//                             fontWeight: FontWeight.w600,
//                             fontSize: 16),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget bookingDetails({String? name, String? cost}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(name.toString()),
//         Text(cost.toString()),
//       ],
//     );
//   }
// }
