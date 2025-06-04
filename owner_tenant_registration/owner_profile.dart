import 'package:flutter/material.dart';

class OwnerProfile extends StatefulWidget {
  const OwnerProfile({super.key});

  @override
  State<OwnerProfile> createState() => _OwnerProfileState();
}

class _OwnerProfileState extends State<OwnerProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile'),
      ),
      body: Stack(
        children: [
const CircleAvatar(
  radius: 60,
  backgroundColor: Colors.amber,
),
         Positioned(
           top: 10,
           bottom: 0,
           right: 25,
           child:
           CircleAvatar(
            backgroundColor: Colors.amberAccent,
             child: IconButton(
               color: Colors.black,
               icon: const Icon(Icons.camera_alt_outlined),
               onPressed: () {  },
                 style: const ButtonStyle(
                                  side: WidgetStatePropertyAll(
                                    BorderSide(
                                      color: Colors.black,
                                      width: 3.0,
                                    ),
                                  ),
                                ),
             )

           ),
         )
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';
//
// class OwnerProfile extends StatefulWidget {
//   const OwnerProfile({super.key});
//
//   @override
//   State<OwnerProfile> createState() => _OwnerProfileState();
// }
//
// class _OwnerProfileState extends State<OwnerProfile> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile'),
//       ),
//       body: Center( // Centering the Stack
//         child: Stack(
//           children: [
//           Align(
//           alignment: Alignment.topCenter, // Centers the main circle
//           child:
//             const CircleAvatar(
//               radius: 60,
//               backgroundColor: Colors.amber,
//             ),
//         ),
//             // Positioned(
//             //   bottom: 0,
//             //   right: 20,// Aligns the smaller circle at the bottom of the main circle
//             //   child: CircleAvatar(
//             //     backgroundColor: Colors.amberAccent,
//             //     child: IconButton(
//             //       icon: const Icon(Icons.camera_alt_outlined),
//             //       color: Colors.black,
//             //       onPressed: () {
//             //         // Your code to handle the button press
//             //       },
//             //     ),
//             //   ),
//             // ),
//         Positioned(
//            top: 10,
//            bottom: 0,
//            right: 25,
//            child:
//            CircleAvatar(
//             backgroundColor: Colors.amberAccent,
//              child: IconButton(
//                color: Colors.black,
//                icon: const Icon(Icons.camera_alt_outlined),
//                onPressed: () {  },
//                  style: const ButtonStyle(
//                                   side: WidgetStatePropertyAll(
//                                     BorderSide(
//                                       color: Colors.black,
//                                       width: 3.0,
//                                     ),
//                                   ),
//                                 ),
//              )
//
//            ),
//         )
//         ]
//         ),
//       ),
//     );
//   }
// }


