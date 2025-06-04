// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import 'amenities_listing_screen.dart';
//
// class AmenitiesTypeListing extends StatefulWidget {
//   const AmenitiesTypeListing({super.key});
//
//   @override
//   AmenitiesTypeListingState createState() => AmenitiesTypeListingState();
// }
//
// class AmenitiesTypeListingState extends State<AmenitiesTypeListing> {
//   TextEditingController searchController = TextEditingController();
//
//   final Map<String, String> amenitiesImages = {
//     "Party Hall": "assets/home/amenities.png",
//     "Gym": "assets/home/amenities.png",
//     "Pool": "assets/home/amenities.png",
//     "Tennis Court": "assets/home/amenities.png",
//     "Library": "assets/home/amenities.png",
//     "Playground": "assets/home/amenities.png",
//     "Parking Lot": "assets/home/amenities.png",
//     "Conference Room": "assets/home/amenities.png",
//   };
//
//   List<String> allItems = [];
//   List<String> filteredItems = [];
//   List<String> suggestions = [];
//
//   @override
//   void initState() {
//     super.initState();
//     allItems = amenitiesImages.keys.toList();
//     filteredItems = allItems;
//   }
//
//   void filterSearch(String query) {
//     setState(() {
//       filteredItems = allItems
//           .where((item) =>
//           item.toLowerCase().contains(query.toLowerCase().trim()))
//           .toList();
//       suggestions = allItems
//           .where((item) =>
//           item.toLowerCase().startsWith(query.toLowerCase().trim()))
//           .take(5)
//           .toList();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Amenities"),
//       ),
//       body: Column(
//         children: [
//           // Search Bar
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: TextField(
//               controller: searchController,
//               onChanged: (value) => filterSearch(value),
//               decoration: InputDecoration(
//                 hintText: "Search amenities...",
//                 prefixIcon: const Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                   borderSide: const BorderSide(color: Colors.grey),
//                 ),
//               ),
//             ),
//           ),
//           // Suggestions Dropdown
//           if (suggestions.isNotEmpty && searchController.text.isNotEmpty)
//             Container(
//               color: Colors.white,
//               child: ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: suggestions.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text(suggestions[index]),
//                     onTap: () {
//                       searchController.text = suggestions[index];
//                       filterSearch(suggestions[index]);
//                       setState(() {
//                         suggestions.clear();
//                       });
//                     },
//                   );
//                 },
//               ),
//             ),
//           // Filtered List
//           Expanded(
//             child: filteredItems.isEmpty
//                 ? const Center(
//               child: Text(
//                 "No results found",
//                 style: TextStyle(fontSize: 18, color: Colors.grey),
//               ),
//             )
//                 : ListView.builder(
//               itemCount: filteredItems.length,
//               itemBuilder: (context, index) {
//                 String item = filteredItems[index];
//                 return Card(
//                   margin: const EdgeInsets.symmetric(
//                       horizontal: 16.0, vertical: 8.0),
//                   child: ListTile(
//                     title: Text(item),
//                     leading: CircleAvatar(
//                       backgroundImage: AssetImage(
//                         amenitiesImages[item]!,
//                       ),
//                     ),
//                     onTap: () {
//                       Get.to(()=> const AmenitiesListingScreen());
//                     },
//                   ),
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
