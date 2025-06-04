// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// class SecurityGuardActions extends StatefulWidget {
//   const SecurityGuardActions({super.key});
//
//   @override
//   State<SecurityGuardActions> createState() => _SecurityGuardActionsState();
// }
//
// class _SecurityGuardActionsState extends State<SecurityGuardActions>
//     with SingleTickerProviderStateMixin {
//   late TabController _topTabController;
//
//   @override
//   void initState() {
//     super.initState();
//     _topTabController = TabController(
//       length: 4,
//       vsync: this,
//     );
//   }
//
//   @override
//   void dispose() {
//     _topTabController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.more_vert_rounded),
//             onPressed: () {},
//           ),
//         ],
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(60.0),
//           child: TabBar(
//             controller: _topTabController,
//             indicatorColor: Colors.red,
//             isScrollable: true,
//             tabAlignment: TabAlignment.center,
//             tabs: const [
//               Tab(
//                 icon: Icon(
//                   Icons.pin_outlined,
//                   color: Colors.white,
//                 ),
//                 child: Text(
//                   'Enter Code',
//                   style: TextStyle(
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               Tab(
//                 icon: Icon(
//                   Icons.sync_outlined,
//                   color: Colors.white,
//                 ),
//                 child: Text(
//                   'Freq. Visitors',
//                   style: TextStyle(
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               Tab(
//                 icon: Icon(
//                   Icons.people_outlined,
//                   color: Colors.white,
//                 ),
//                 child: Text(
//                   'Visitors',
//                   style: TextStyle(
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               Tab(
//                 icon: Icon(
//                   Icons.notifications_outlined,
//                   color: Colors.white,
//                 ),
//                 child: Text(
//                   'Notice',
//                   style: TextStyle(
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: TabBarView(
//               controller: _topTabController,
//               physics: const PageScrollPhysics(
//                 parent: NeverScrollableScrollPhysics(),
//               ),
//               children: const [
//                 EnterCodeView(),
//                 FrequentVisitorsView(),
//                 VisitorsView(),
//                 SizedBox.shrink(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class EnterCodeView extends StatefulWidget {
//   const EnterCodeView({super.key});
//
//   @override
//   State<EnterCodeView> createState() => _EnterCodeViewState();
// }
//
// class _EnterCodeViewState extends State<EnterCodeView> {
//   final _controller = ValueNotifier(TextEditingController());
//
//   @override
//   void dispose() {
//     _controller.value.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox.expand(
//       child: Column(
//         children: [
//           ValueListenableBuilder(
//             valueListenable: _controller,
//             builder: (context, code, child) {
//               return Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: TextField(
//                   controller: code,
//                   decoration: const InputDecoration(
//                     border: UnderlineInputBorder(
//                       borderSide: BorderSide.none,
//                     ),
//                     hintText: 'Enter Code',
//                   ),
//                   enabled: false,
//                   inputFormatters: [
//                     LengthLimitingTextInputFormatter(6),
//                   ],
//                   readOnly: true,
//                   style: const TextStyle(
//                     color: Colors.black,
//                     fontSize: 30.0,
//                     letterSpacing: 5.0,
//                   ),
//                   textAlign: TextAlign.center,
//                   textAlignVertical: TextAlignVertical.center,
//                 ),
//               );
//             },
//           ),
//           Expanded(
//             child: GridView.count(
//               childAspectRatio: 1.5,
//               crossAxisCount: 3,
//               crossAxisSpacing: 10.0,
//               mainAxisSpacing: 10.0,
//               padding: const EdgeInsets.only(
//                 left: 20.0,
//                 right: 20.0,
//                 top: 20.0,
//               ),
//               physics: const ScrollPhysics(
//                 parent: NeverScrollableScrollPhysics(),
//               ),
//               shrinkWrap: true,
//               children: List<int>.generate(12, (index) {
//                 return index + 1;
//               }).map((number) {
//                 if (number == 10) {
//                   return IconButton(
//                     icon: const Icon(
//                       Icons.cameraswitch_outlined,
//                       size: 30.0,
//                     ),
//                     onPressed: () {},
//                     style: const ButtonStyle(
//                       side: WidgetStatePropertyAll(BorderSide()),
//                     ),
//                   );
//                 } else if (number == 11) {
//                   return IconButton(
//                     icon: const Text(
//                       '0',
//                       style: TextStyle(
//                         fontSize: 30.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     onPressed: () {
//                       if (_controller.value.text.length < 6) {
//                         _controller.value.text += '0';
//                       }
//                     },
//                     style: const ButtonStyle(
//                       side: WidgetStatePropertyAll(BorderSide()),
//                     ),
//                   );
//                 } else if (number == 12) {
//                   return GestureDetector(
//                     onLongPress: () {
//                       if (_controller.value.text.isNotEmpty) {
//                         _controller.value.clear();
//                       }
//                     },
//                     child: IconButton(
//                       icon: const Icon(Icons.backspace_outlined),
//                       onPressed: () {
//                         var code = _controller.value.text;
//                         if (code.isNotEmpty) {
//                           _controller.value.text = code.substring(
//                             0,
//                             code.length - 1,
//                           );
//                         }
//                       },
//                       style: const ButtonStyle(
//                         side: WidgetStatePropertyAll(BorderSide()),
//                       ),
//                     ),
//                   );
//                 }
//
//                 return IconButton(
//                   icon: Text(
//                     number.toString(),
//                     style: const TextStyle(
//                       fontSize: 30.0,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   onPressed: () {
//                     if (_controller.value.text.length < 6) {
//                       _controller.value.text += number.toString();
//                     }
//                   },
//                   style: const ButtonStyle(
//                     side: WidgetStatePropertyAll(BorderSide()),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),
//           Row(
//             children: [
//               Flexible(
//                 fit: FlexFit.tight,
//                 child: InkWell(
//                   onTap: _enterPhoneNumberOrOtp,
//                   child: const Tab(
//                     icon: Icon(Icons.person_outline),
//                     child: Text('Guest'),
//                   ),
//                 ),
//               ),
//               Flexible(
//                 fit: FlexFit.tight,
//                 child: InkWell(
//                   onTap: () {},
//                   child: const Tab(
//                     icon: Icon(Icons.local_shipping_outlined),
//                     child: Text('Delivery'),
//                   ),
//                 ),
//               ),
//               Flexible(
//                 fit: FlexFit.tight,
//                 child: InkWell(
//                   onTap: () {},
//                   child: const Tab(
//                     icon: Icon(Icons.local_taxi_outlined),
//                     child: Text('Cab'),
//                   ),
//                 ),
//               ),
//               Flexible(
//                 fit: FlexFit.tight,
//                 child: InkWell(
//                   onTap: () {},
//                   child: const Tab(
//                     icon: Icon(Icons.add_circle_outline),
//                     child: Text('More'),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const DecoratedBox(
//             decoration: BoxDecoration(
//               color: Colors.green,
//             ),
//             child: Padding(
//               padding: EdgeInsets.all(10.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox.square(
//                     dimension: 40.0,
//                     child: DecoratedBox(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Center(
//                         child: Icon(
//                           Icons.foundation_rounded,
//                           size: 30.0,
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 10.0),
//                   SizedBox(
//                     child: Text.rich(
//                       TextSpan(
//                         children: [
//                           TextSpan(
//                             style: TextStyle(
//                               fontSize: 16.0,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             text: 'Main Gate, Ajay Rathi',
//                           ),
//                           TextSpan(
//                             text: ' - ',
//                           ),
//                           TextSpan(
//                             text: 'Security',
//                           ),
//                         ],
//                       ),
//                       style: TextStyle(
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _enterPhoneNumberOrOtp() {
//     final phoneNumberController = TextEditingController();
//
//     showDialog(
//       builder: (context) {
//         return Dialog.fullscreen(
//           backgroundColor: const Color.fromARGB(100, 0, 0, 0),
//           child: Container(
//             alignment: Alignment.center,
//             padding: const EdgeInsets.symmetric(
//               horizontal: 20.0,
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Card(
//                   child: Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const ListTile(
//                           leading: Icon(
//                             Icons.phone_android,
//                             size: 30.0,
//                           ),
//                           title: Text(
//                             'Enter Phone Number',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(10.0),
//                           child: TextField(
//                             autofocus: true,
//                             controller: phoneNumberController,
//                             decoration: const InputDecoration(
//                               hintText: 'Eg. 1234567890',
//                             ),
//                             inputFormatters: [
//                               FilteringTextInputFormatter.digitsOnly,
//                               LengthLimitingTextInputFormatter(10),
//                             ],
//                             keyboardType: TextInputType.phone,
//                             onSubmitted: (value) {
//                               if (phoneNumberController.text.isNotEmpty &&
//                                   (value.length == 10)) {
//                                 Navigator.pop(context);
//                                 _enterVisitorsName();
//                               }
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 10.0),
//                 Card(
//                   child: InkWell(
//                     onTap: () {},
//                     child: const Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: ListTile(
//                         leading: Icon(
//                           Icons.numbers_rounded,
//                           size: 30.0,
//                         ),
//                         subtitle: Text(
//                           'If yes, use the code to make quick entry',
//                           style: TextStyle(
//                             fontSize: 12.0,
//                           ),
//                         ),
//                         title: Text(
//                           'Is 6-digit OTP available with Guest',
//                           style: TextStyle(
//                             fontSize: 14.0,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//       context: context,
//     );
//   }
//
//   void _enterVisitorsName() {
//     final nameController = TextEditingController();
//
//     showDialog(
//       builder: (context) {
//         return Dialog.fullscreen(
//           backgroundColor: const Color.fromARGB(100, 0, 0, 0),
//           child: Container(
//             alignment: Alignment.center,
//             padding: const EdgeInsets.symmetric(
//               horizontal: 20.0,
//             ),
//             child: Card(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const ListTile(
//                     leading: Icon(Icons.account_circle_outlined),
//                     title: Text(
//                       'Visitor Name',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: TextField(
//                       autofocus: true,
//                       controller: nameController,
//                       decoration: const InputDecoration(
//                         hintText: 'Eg. John Doe',
//                       ),
//                     ),
//                   ),
//                   ClipRRect(
//                     borderRadius: const BorderRadius.only(
//                       bottomLeft: Radius.circular(12.0),
//                       bottomRight: Radius.circular(12.0),
//                     ),
//                     child: InkWell(
//                       onTap: () {
//                         if (nameController.text.isNotEmpty) {
//                           Navigator.pop(context);
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) {
//                                 return const SelectBuilding();
//                               },
//                             ),
//                           );
//                         }
//                       },
//                       child: Container(
//                         decoration: const BoxDecoration(
//                           color: Colors.green,
//                         ),
//                         padding: const EdgeInsets.all(10.0),
//                         child: const Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Expanded(
//                               child: Center(
//                                 child: Text(
//                                   'Submit',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Icon(
//                               Icons.arrow_forward_rounded,
//                               color: Colors.white,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//       context: context,
//     );
//   }
// }
//
// class SelectBuilding extends StatefulWidget {
//   const SelectBuilding({super.key});
//
//   @override
//   State<SelectBuilding> createState() => _SelectBuildingState();
// }
//
// class _SelectBuildingState extends State<SelectBuilding> {
//   final _building = <String>[
//     'A',
//     'B',
//     'C',
//     'D',
//     'E',
//     'F',
//     'G',
//     'H',
//     'J',
//     'K',
//     'L',
//     'M',
//     'N',
//     'P',
//     'Q',
//     'R',
//     'S',
//     'COMMON AREA',
//     'Security',
//     'Clubhouse',
//   ];
//   final _flat = <String>['Facility Manager', 'Office Manager'];
//   final _selectedBuilding = ValueNotifier<int>(-1);
//   final _selectedFlat = ValueNotifier<int>(-1);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: ValueListenableBuilder(
//           valueListenable: _selectedBuilding,
//           builder: (context, index, child) {
//             return Text((index != -1) ? 'Add Flat' : 'Select Building');
//           },
//         ),
//       ),
//       body: SizedBox.expand(
//         child: Material(
//           child: ValueListenableBuilder(
//             valueListenable: _selectedBuilding,
//             builder: (context, selectedBuilding, child) {
//               return Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: GridView.builder(
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     childAspectRatio: 16 / 10,
//                     crossAxisCount: 3,
//                   ),
//                   itemBuilder: (context, index) {
//                     return GridTile(
//                       child: Card(
//                         color: selectedBuilding == index
//                             ? Colors.green.shade300
//                             : Colors.amber.shade100,
//                         child: InkWell(
//                           onTap: () {
//                             _selectedBuilding.value =
//                                 selectedBuilding != index ? index : -1;
//                             if (_selectedBuilding.value != -1) {
//                               _addVisitorApproval();
//                             }
//                           },
//                           child: Center(
//                             child: Text(
//                               _building.elementAt(index),
//                               style: const TextStyle(
//                                 fontSize: 16.0,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               textAlign: TextAlign.center,
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                   itemCount: _building.length,
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _addVisitorApproval() {
//     showModalBottomSheet(
//       builder: (context) {
//         return SizedBox(
//           height: MediaQuery.of(context).size.height * 0.3,
//           width: double.maxFinite,
//           child: ValueListenableBuilder(
//             valueListenable: _selectedFlat,
//             builder: (context, selectedFlat, child) {
//               return Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 10.0,
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             _building.elementAt(_selectedBuilding.value),
//                             style: const TextStyle(
//                               fontSize: 20.0,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           TextButton.icon(
//                             icon: const Icon(Icons.chevron_right),
//                             iconAlignment: IconAlignment.end,
//                             label: const Text('Continue'),
//                             onPressed: () {
//                               if (_selectedBuilding.value != -1 &&
//                                   _selectedFlat.value != -1) {
//                                 Navigator.pop(context);
//                                 Navigator.pop(context);
//                                 showDialog(
//                                   builder: (context) {
//                                     return AlertDialog(
//                                       actions: [
//                                         TextButton(
//                                           onPressed: () {
//                                             Navigator.pop(context);
//                                           },
//                                           child: const Text('OK'),
//                                         ),
//                                       ],
//                                       content: const SizedBox(
//                                         child: AbsorbPointer(
//                                           child: ExpansionTile(
//                                             initiallyExpanded: true,
//                                             leading: Icon(
//                                               Icons.verified_rounded,
//                                               color: Colors.green,
//                                               size: 30.0,
//                                             ),
//                                             shape: Border(),
//                                             showTrailingIcon: false,
//                                             subtitle: Text(
//                                                 'Entrance allowed for visitor'),
//                                             title: Text('Status Confirmed'),
//                                             children: [
//                                               SizedBox(
//                                                 height: 100.0,
//                                                 child: Center(
//                                                   child: Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .center,
//                                                     mainAxisSize:
//                                                         MainAxisSize.min,
//                                                     children: [
//                                                       Icon(
//                                                         Icons
//                                                             .transfer_within_a_station,
//                                                         color: Colors.amber,
//                                                         size: 40.0,
//                                                       ),
//                                                       Icon(
//                                                         Icons.fence,
//                                                         color: Colors.grey,
//                                                         size: 40.0,
//                                                       ),
//                                                       Icon(
//                                                         Icons.cottage,
//                                                         color: Colors.brown,
//                                                         size: 40.0,
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                       title: const Text('Entry Approval'),
//                                     );
//                                   },
//                                   context: context,
//                                 );
//                               }
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                     const Divider(),
//                     Expanded(
//                       child: GridView.builder(
//                         gridDelegate:
//                             const SliverGridDelegateWithFixedCrossAxisCount(
//                           childAspectRatio: 16 / 10,
//                           crossAxisCount: 3,
//                         ),
//                         itemBuilder: (context, index) {
//                           return GridTile(
//                             child: Card(
//                               color: selectedFlat == index
//                                   ? Colors.green.shade300
//                                   : Colors.amber.shade100,
//                               child: InkWell(
//                                 onTap: () {
//                                   _selectedFlat.value =
//                                       selectedFlat != index ? index : -1;
//                                 },
//                                 child: Center(
//                                   child: Text(
//                                     _flat.elementAt(index),
//                                     style: const TextStyle(
//                                       fontSize: 16.0,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                         itemCount: _flat.length,
//                         shrinkWrap: true,
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         );
//       },
//       context: context,
//       isDismissible: false,
//       showDragHandle: true,
//     );
//   }
// }
//
// class FrequentVisitorsView extends StatefulWidget {
//   const FrequentVisitorsView({super.key});
//
//   @override
//   State<FrequentVisitorsView> createState() => _FrequentVisitorsViewState();
// }
//
// class _FrequentVisitorsViewState extends State<FrequentVisitorsView> {
//   late final TextEditingController _searchController;
//
//   final _visitors = <Map<String, String>>[
//     {'name': 'Ramesh Kumar', 'in_or_out': 'in'},
//     {'name': 'Suresh Patel', 'in_or_out': 'out'},
//     {'name': 'Amit Sharma', 'in_or_out': 'in'},
//     {'name': 'John Doe', 'in_or_out': 'out'},
//     {'name': 'Jane Smith', 'in_or_out': 'in'},
//     {'name': 'Alice Johnson', 'in_or_out': 'out'},
//     {'name': 'Bob Brown', 'in_or_out': 'in'},
//     {'name': 'Charlie White', 'in_or_out': 'out'},
//     {'name': 'David Wilson', 'in_or_out': 'in'},
//     {'name': 'Eve Davis', 'in_or_out': 'out'},
//   ];
//
//   final _filteredVisitors = ValueNotifier<List<Map<String, String>>>([{}]);
//
//   void _filterVisitors(String value) {
//     if (value.isEmpty) {
//       _filteredVisitors.value = _visitors;
//     } else {
//       _filteredVisitors.value = _visitors.where((v) {
//         return v['name']!.toLowerCase().contains(value);
//       }).toList();
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _searchController = TextEditingController();
//     _filteredVisitors.value = _visitors;
//   }
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox.expand(
//       child: Column(
//         children: [
//           SizedBox(
//             child: DecoratedBox(
//               decoration: BoxDecoration(
//                 color: Colors.amber.shade200,
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 20.0,
//                   vertical: 10.0,
//                 ),
//                 child: TextField(
//                   controller: _searchController,
//                   decoration: InputDecoration(
//                     border: const UnderlineInputBorder(
//                       borderSide: BorderSide.none,
//                     ),
//                     hintStyle: const TextStyle(
//                       color: Colors.white,
//                     ),
//                     hintText: 'Search',
//                     suffixIcon: IconButton(
//                       icon: const Icon(
//                         Icons.search_rounded,
//                         color: Colors.white,
//                       ),
//                       onPressed: () {
//                         final searchQuery = _searchController.text;
//                         _filterVisitors(searchQuery);
//                       },
//                     ),
//                   ),
//                   onChanged: (value) {
//                     if (value.isEmpty) {
//                       _filterVisitors('');
//                     }
//                   },
//                   textAlignVertical: TextAlignVertical.center,
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: ValueListenableBuilder(
//               valueListenable: _filteredVisitors,
//               builder: (context, filterVisitors, child) {
//                 return ListView.separated(
//                   itemBuilder: (context, index) {
//                     final fv = filterVisitors.elementAt(index);
//
//                     return ListTile(
//                       leading: DecoratedBox(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10.0),
//                           color: Colors.lightBlue.shade100,
//                         ),
//                         child: const Padding(
//                           padding: EdgeInsets.all(8.0),
//                           child: Icon(Icons.person),
//                         ),
//                       ),
//                       subtitle: const Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text(
//                             'Laundry',
//                             style: TextStyle(
//                               color: Colors.grey,
//                               fontSize: 12.0,
//                             ),
//                           ),
//                           Text(
//                             'KA11AD2222',
//                             style: TextStyle(
//                               color: Colors.grey,
//                               fontSize: 12.0,
//                             ),
//                           ),
//                         ],
//                       ),
//                       title: Text(
//                         fv.containsKey('name') ? fv['name']! : '----',
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       trailing: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           IconButton(
//                             icon: const Icon(Icons.call_rounded),
//                             onPressed: () {},
//                           ),
//                           const SizedBox(width: 5.0),
//                           DecoratedBox(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10.0),
//                               color: fv['in_or_out']! == 'in'
//                                   ? Colors.green
//                                   : Colors.red,
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 8.0,
//                                 vertical: 4.0,
//                               ),
//                               child: Text(
//                                 fv['in_or_out']!.toUpperCase(),
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 14.0,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                   itemCount: filterVisitors.length,
//                   padding: const EdgeInsets.all(8.0),
//                   separatorBuilder: (context, index) {
//                     return const Divider(
//                       color: Colors.yellow,
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class VisitorsView extends StatefulWidget {
//   const VisitorsView({super.key});
//
//   @override
//   State<VisitorsView> createState() => _VisitorsViewState();
// }
//
// class _VisitorsViewState extends State<VisitorsView>
//     with SingleTickerProviderStateMixin {
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox.expand(
//       child: DefaultTabController(
//         length: 2,
//         child: Column(
//           children: [
//             DecoratedBox(
//               decoration: BoxDecoration(
//                 color: Colors.amber.shade200,
//               ),
//               child: const TabBar(
//                 indicatorColor: Colors.red,
//                 tabs: [
//                   Tab(
//                     child: Text.rich(
//                       TextSpan(
//                         children: [
//                           TextSpan(
//                             style: TextStyle(
//                               color: Colors.white,
//                             ),
//                             text: 'Inside ',
//                           ),
//                           TextSpan(
//                             style: TextStyle(
//                               color: Colors.white,
//                             ),
//                             text: '(10)',
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Tab(
//                     child: Text.rich(
//                       TextSpan(
//                         children: [
//                           TextSpan(
//                             style: TextStyle(
//                               color: Colors.white,
//                             ),
//                             text: 'Waiting ',
//                           ),
//                           TextSpan(
//                             style: TextStyle(
//                               color: Colors.white,
//                             ),
//                             text: '(10)',
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: TabBarView(
//                 children: [
//                   ListView.separated(
//                     itemBuilder: (context, index) {
//                       return ListTile(
//                         leading: DecoratedBox(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10.0),
//                             color: Colors.lightBlue.shade100,
//                           ),
//                           child: const Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: Icon(Icons.person),
//                           ),
//                         ),
//                         subtitle: const Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Text(
//                               'Amazon',
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 12.0,
//                               ),
//                             ),
//                             Text(
//                               'Common Area',
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 12.0,
//                               ),
//                             ),
//                             Text(
//                               'Manager',
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 12.0,
//                               ),
//                             ),
//                           ],
//                         ),
//                         title: const Text(
//                           'Yash',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         trailing: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             IconButton(
//                               icon: const Icon(Icons.close_rounded),
//                               onPressed: () {},
//                               style: ButtonStyle(
//                                 shape: WidgetStatePropertyAll(
//                                   RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8.0),
//                                     side: const BorderSide(
//                                       color: Colors.red,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 5.0),
//                             IconButton(
//                               icon: const Icon(
//                                 Icons.inventory_2_outlined,
//                                 color: Colors.white,
//                               ),
//                               onPressed: () {},
//                               style: ButtonStyle(
//                                 backgroundColor: const WidgetStatePropertyAll(
//                                   Colors.green,
//                                 ),
//                                 shape: WidgetStatePropertyAll(
//                                   RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8.0),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                     itemCount: 10,
//                     padding: const EdgeInsets.all(10.0),
//                     separatorBuilder: (context, index) {
//                       return const Divider(
//                         color: Colors.yellow,
//                       );
//                     },
//                   ),
//                   ListView.separated(
//                     itemBuilder: (context, index) {
//                       return ListTile(
//                         leading: DecoratedBox(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10.0),
//                             color: Colors.lightBlue.shade100,
//                           ),
//                           child: const Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: Icon(Icons.person),
//                           ),
//                         ),
//                         subtitle: const Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Text(
//                               'Flipkart',
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 12.0,
//                               ),
//                             ),
//                             Text(
//                               'Common Area',
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 12.0,
//                               ),
//                             ),
//                             Text(
//                               'Manager',
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 12.0,
//                               ),
//                             ),
//                           ],
//                         ),
//                         title: const Text(
//                           'Raju',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         trailing: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             IconButton(
//                               icon: const Icon(Icons.close_rounded),
//                               onPressed: () {},
//                               style: ButtonStyle(
//                                 shape: WidgetStatePropertyAll(
//                                   RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8.0),
//                                     side: const BorderSide(
//                                       color: Colors.red,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 5.0),
//                             IconButton(
//                               icon: const Icon(
//                                 Icons.inventory_2_outlined,
//                                 color: Colors.white,
//                               ),
//                               onPressed: () {},
//                               style: ButtonStyle(
//                                 backgroundColor: const WidgetStatePropertyAll(
//                                   Colors.green,
//                                 ),
//                                 shape: WidgetStatePropertyAll(
//                                   RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8.0),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                     itemCount: 10,
//                     padding: const EdgeInsets.all(10.0),
//                     separatorBuilder: (context, index) {
//                       return const Divider(
//                         color: Colors.yellow,
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
