// import 'package:flutter/material.dart';
//
// // import 'package:get/get.dart';
// // import '../../Utils/constants.dart';
// // import 'create_guard.dart';
// import '../bottom_navigation.dart';
// import '../coming_soon.dart';
// import 'guard_directory_listing.dart';
// import 'outside_call_guard.dart';
//
// class CallGuardListing extends StatefulWidget {
//   const CallGuardListing({super.key});
//
//   @override
//   State<CallGuardListing> createState() => CallGuardListingState();
// }
//
// class CallGuardListingState extends State<CallGuardListing> {
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: PreferredSize(
//           preferredSize: const Size.fromHeight(kToolbarHeight),
//           child: ComingSoon(
//             appBarText: 'Guards Directory',
//             leading: true,
//             onLeadingIconPressed: () {
//               Navigator.pushReplacement<void, void>(
//                 context,
//                 MaterialPageRoute<void>(
//                   builder: (BuildContext context) => const BottomNavigation(),
//                 ),
//               );
//             },
//           ),
//         ),
//         body: const Column(
//           children: [
//             TabBar(
//               indicatorSize: TabBarIndicatorSize.tab,
//               tabs: [
//                 Padding(
//                   padding: EdgeInsets.all(15.0),
//                   child: Text("Inside"),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.all(15.0),
//                   child: Text("Outside"),
//                 ),
//               ],
//             ),
//             Expanded(
//               child: TabBarView(
//                 children: [
//                   InsideCallGuard(),
//                   OutsideCallGuard(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
