import 'package:biz_infra/Screens/services/plumbing_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VipMembershipBottomSheet extends StatelessWidget {
  const VipMembershipBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        clipBehavior: Clip.none, // Allows image to overflow the container
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),

              // Text and Subtext
              const Text(
                'You are missing out on discount of ₹27',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Customers save up to ₹3500 with VIP membership',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30), // Space for the image to overlap

              // Skip Link
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    color: Colors.lightBlue,
                    fontSize: 16,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Add VIP Membership Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Your code for VIP Membership
                    Get.to(
                      () => const PlumbingServices(),
                      transition: Transition.rightToLeft,
                      popGesture: true,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 58, 192, 63),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                  ),
                  child: const Text(
                    'Add VIP Membership',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Positioned Image
          Positioned(
            top: -50, // Moves the image up from the top of the container
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: 60, // Adjust width as needed
                height: 60, // Adjust height as needed
                decoration: BoxDecoration(
                  color: Colors
                      .white, // Replace with your desired background color
                  borderRadius:
                      BorderRadius.circular(50), // Makes the container rounded
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/icon2.png', // Path to your image
                    width:
                        40, // Adjust width as needed (slightly smaller than container width)
                    height:
                        40, // Adjust height as needed (slightly smaller than container height)
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
